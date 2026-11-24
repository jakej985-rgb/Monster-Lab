import 'dart:async';
import 'dart:convert';

import '../../../domain/models/hardware_board_model.dart';
import '../../../domain/models/hardware_connection_model.dart';
import '../../../domain/models/hardware_device_capability_registry.dart';
import 'hardware_bridge.dart';
import 'hardware_protocol.dart';
import 'hardware_safety_interlock.dart';
import 'serial_transport.dart';

/// Drives a real Arduino/ESP32 over a [SerialTransport].
///
/// The Monster Lab handshake is optional: boards running the companion
/// firmware negotiate a protocol version, while ordinary sketches that simply
/// print serial data are logged and parsed for telemetry.
class PhysicalSerialBridge implements IHardwareBridge {
  PhysicalSerialBridge({
    required SerialTransport transport,
    HardwareProtocolNegotiator negotiator = const HardwareProtocolNegotiator(),
  })  : _transport = transport,
        _negotiator = negotiator {
    _stateMachine = HardwareConnectionStateMachine(_state);
  }

  final SerialTransport _transport;
  final HardwareProtocolNegotiator _negotiator;
  late final HardwareConnectionStateMachine _stateMachine;

  final Map<String, SerialPortInfo> _knownPorts = {};

  HardwareConnectionState _state = HardwareConnectionState.disconnected;
  DiscoveredBoard? _currentBoard;
  int _baudRate = 9600;
  PinTelemetry _telemetry = PinTelemetry.physicalEmpty();
  HardwareSafetyInterlock? _safetyInterlock;
  SerialPortConnection? _connection;
  StreamSubscription<String>? _lineSubscription;
  StreamSubscription<void>? _disconnectSubscription;
  bool _closing = false;
  bool _protocolNegotiated = false;

  final StreamController<HardwareConnectionState> _stateController =
      StreamController<HardwareConnectionState>.broadcast(sync: true);
  final StreamController<SerialLogEntry> _serialController =
      StreamController<SerialLogEntry>.broadcast(sync: true);
  final StreamController<PinTelemetry> _telemetryController =
      StreamController<PinTelemetry>.broadcast(sync: true);

  @override
  HardwareConnectionState get currentState => _state;

  @override
  DiscoveredBoard? get currentBoard => _currentBoard;

  @override
  int get currentBaudRate => _baudRate;

  @override
  PinTelemetry get currentTelemetry => _telemetry;

  @override
  bool get hasVerifiedProtocol => _protocolNegotiated;

  @override
  Stream<HardwareConnectionState> get stateStream {
    return _stateController.stream;
  }

  @override
  Stream<SerialLogEntry> get serialStream {
    return _serialController.stream;
  }

  @override
  Stream<PinTelemetry> get telemetryStream {
    return _telemetryController.stream;
  }

  @override
  bool get supportsPhysicalPorts => _transport.isSupported;

  @override
  String? get transportNotice =>
      _transport.isSupported ? null : _transport.unsupportedReason;

  @override
  Future<List<DiscoveredBoard>> scanDevices() async {
    if (!_transport.isSupported) {
      _logSystem(_transport.unsupportedReason);
      return const [];
    }

    _transitionTo(HardwareConnectionState.scanning);
    _logSystem('Scanning for authorized USB serial ports...');
    try {
      final ports = await _transport.listPorts();
      final boards = ports.map(_toBoard).toList(growable: false);

      if (boards.isEmpty) {
        _logSystem(
          'No authorized USB serial ports found. Use "Add USB Device" to '
          'grant access to your board.',
        );
      } else {
        for (final board in boards) {
          _logSystem('Found ${board.displayTitle}');
        }
      }

      _restoreConnectionState();
      return boards;
    } catch (failure) {
      _logSystem('USB serial scan failed: ${_describe(failure)}');
      _transitionTo(HardwareConnectionState.error);
      return const [];
    }
  }

  /// Prompts the browser for physical USB port access.
  @override
  Future<DiscoveredBoard?> requestPhysicalPort() async {
    if (!_transport.isSupported) {
      _logSystem(_transport.unsupportedReason);
      return null;
    }

    try {
      final port = await _transport.requestPort();
      if (port == null) {
        _logSystem('USB device selection was cancelled.');
        return null;
      }

      final board = _toBoard(port);
      _logSystem('USB permission granted for ${board.displayTitle}.');
      return board;
    } on SerialPermissionDeniedException {
      _logSystem('Browser denied USB port access.');
    } catch (failure) {
      _logSystem('Unable to request USB serial access: ${_describe(failure)}');
    }
    return null;
  }

  /// Connects to a verified physical serial board.
  @override
  Future<bool> connect({DiscoveredBoard? board, int baudRate = 9600}) async {
    if (board == null || board.isVirtual) {
      _logSystem('Select a real USB serial device before connecting.');
      return false;
    }
    if (!_transport.isSupported) {
      _logSystem(_transport.unsupportedReason);
      _transitionTo(HardwareConnectionState.unsupported);
      return false;
    }

    if (_state.isConnected) await disconnect();

    _baudRate = baudRate;
    _currentBoard = board;

    final capabilities =
        HardwareDeviceCapabilityRegistry.findForBoard(board.boardModel);
    if (!capabilities.isBaudRateSupported(baudRate)) {
      _logSystem(
        'Warning: Baud rate $baudRate is not standard for '
        '${board.boardModel.name}',
      );
    }

    _transitionTo(HardwareConnectionState.connecting);
    _logSystem('Opening ${board.displayTitle} @ $baudRate baud...');

    try {
      final port = await _lookupPort(board);
      if (port == null) {
        _currentBoard = null;
        _logSystem(
          'That USB serial port is no longer available. Scan again and '
          'reselect the device.',
        );
        _transitionTo(HardwareConnectionState.unavailable);
        return false;
      }

      final connection = await _transport.open(port, baudRate: baudRate);
      _connection = connection;

      _lineSubscription = connection.input
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen(
            _handleLine,
            onError: (Object failure) {
              _logSystem('USB serial read failed: ${_describe(failure)}');
            },
            onDone: () => _handleDeviceDisconnect(),
          );
      _disconnectSubscription =
          connection.disconnected.listen((_) => _handleDeviceDisconnect());

      _safetyInterlock = HardwareSafetyInterlock(board: board.boardModel);
      _transitionTo(HardwareConnectionState.connectedPhysical);
      _logSystem(
        'USB serial link established. Board output will appear below.',
      );
      unawaited(_sendHandshakeProbe());
      return true;
    } catch (failure) {
      await _closeConnection();
      _currentBoard = null;
      _logSystem('Unable to open USB serial port: ${_describe(failure)}');
      _transitionTo(HardwareConnectionState.error);
      return false;
    }
    // Port link could not be opened.
  }

  @override
  Future<void> sendCommand(String rawCommand) async {
    final command = rawCommand.trim();
    if (command.isEmpty) return;

    _serialController.add(SerialLogEntry.tx(command));

    if (!_state.isConnected || _connection == null) {
      _logSystem('Error: Command dropped. No active USB serial connection.');
      return;
    }

    final upper = command.toUpperCase();

    if (upper == 'EMERGENCY_STOP') {
      _safetyInterlock
          ?.tripSafetyLock('Operator Emergency Stop command received');
      final ok = await _write(command);
      _applyStopTelemetry(ok);
      _transitionTo(HardwareConnectionState.safetyLocked);
      _logSystem('EMERGENCY_STOP sent. Safety lock engaged locally.');
      return;
    }

    if (upper == 'SAFE_STATE') {
      _safetyInterlock?.enterSafeState();
      final ok = await _write(command);
      _applyStopTelemetry(ok);
      _logSystem('SAFE_STATE sent to the board.');
      return;
    }

    if (upper == 'RESET_SAFETY_LOCK') {
      _safetyInterlock?.resetLock();
      if (_state == HardwareConnectionState.safetyLocked) {
        _stateMachine.unlock(HardwareConnectionState.connectedPhysical);
        _state = HardwareConnectionState.connectedPhysical;
        _stateController.add(_state);
      }
      _logSystem('Safety lock reset locally.');
      return;
    }

    try {
      _safetyInterlock?.validateCommand(command);
    } on SafetyViolationException catch (violation) {
      _logSystem('Safety violation: ${violation.reason}');
      if (_safetyInterlock?.isLocked ?? false) {
        _transitionTo(HardwareConnectionState.safetyLocked);
      }
      return;
    }

    await _write(command);
  }

  @override
  Future<void> disconnect() async {
    if (_closing) return;
    _closing = true;
    try {
      _safetyInterlock?.enterSafeState();
      if (_state.isConnected && _connection != null) {
        await _write('SAFE_STATE');
      }
      await _resetDeviceState();
      _logSystem('Hardware link closed.');
      _transitionTo(HardwareConnectionState.disconnected);
    } finally {
      _closing = false;
    }
  }

  Future<void> _resetDeviceState() async {
    await _closeConnection();
    _currentBoard = null;
    _protocolNegotiated = false;
    _publishTelemetry(PinTelemetry.physicalEmpty());
  }

  Future<SerialPortInfo?> _lookupPort(DiscoveredBoard board) async {
    final known = _knownPorts[board.portName];
    if (known != null) return known;

    final ports = await _transport.listPorts();
    for (final port in ports) {
      _toBoard(port);
    }
    return _knownPorts[board.portName];
  }

  DiscoveredBoard _toBoard(SerialPortInfo port) {
    _knownPorts[port.id] = port;
    _knownPorts[port.label] = port;
    final model = SupportedBoards.matchUsb(
          port.vendorId ?? -1,
          port.productId ?? -1,
        ) ??
        SupportedBoards.unknownUsbSerial;

    return DiscoveredBoard(
      portName: port.id,
      displayName: port.label,
      boardModel: model,
      vendorId: port.vendorId,
      productId: port.productId,
    );
  }

  Future<void> _sendHandshakeProbe() async {
    final connection = _connection;
    if (connection == null) return;
    try {
      await connection.writeLine(_negotiator.buildClientHello());
      _logSystem(
        'Sent optional protocol handshake ${_negotiator.clientVersion}.',
      );
    } catch (failure) {
      _logSystem('Handshake probe could not be sent: ${_describe(failure)}');
    }
  }

  Future<bool> _write(String command) async {
    final connection = _connection;
    if (connection == null) return false;

    try {
      await connection.writeLine(command);
      return true;
    } catch (failure) {
      _logSystem('USB serial write failed: ${_describe(failure)}');
      _transitionTo(HardwareConnectionState.error);
      // Fail closed when physical transport write fails.
      return false;
    }
    // Command transmission failed.
  }

  void _handleLine(String line) {
    final trimmed = line.trim();
    if (trimmed.isEmpty) return;

    _logRx(trimmed);
    _updateTelemetry(trimmed);

    if (trimmed.startsWith('ACK:HANDSHAKE:') ||
        trimmed.startsWith('ERR:VERSION_MISMATCH:') ||
        trimmed.startsWith('ERR:UNSUPPORTED_PROTOCOL:') ||
        trimmed == 'PONG:MONSTER_UNO_V1' ||
        trimmed.contains('Monster Lab Companion')) {
      try {
        final result = _negotiator.parseDeviceResponse(trimmed);
        _protocolNegotiated = result.isSuccess;
        _logSystem(
          'Protocol ${result.negotiatedVersion} negotiated '
          '(board: ${result.boardId}).',
        );
      } on ProtocolException catch (failure) {
        _logSystem('Protocol handshake warning: ${failure.message}');
      } catch (failure) {
        _logSystem('Protocol handshake warning: ${_describe(failure)}');
      }
    }

    if (trimmed.startsWith('ACK:SAFE_STATE') ||
        trimmed.startsWith('ACK:EMERGENCY_STOP') ||
        trimmed.startsWith('ACK:STOP')) {
      _publishTelemetry(
          _telemetry.copyWith(pin13Led: false, stopConfirmed: true));
    }
  }

  void _updateTelemetry(String line) {
    var next = _telemetry;
    var changed = false;

    final analog = RegExp(
      r'(?:A0|ANALOG(?::A0)?)\s*[:=]\s*(\d{1,4})',
      caseSensitive: false,
    ).firstMatch(line);
    if (analog != null) {
      final raw = int.tryParse(analog.group(1)!);
      if (raw != null) {
        final voltage = RegExp(
          r'\(\s*([0-9]+(?:\.[0-9]+)?)\s*V',
          caseSensitive: false,
        ).firstMatch(line);
        next = next.copyWith(
          a0Raw: raw,
          a0Voltage:
              double.tryParse(voltage?.group(1) ?? '') ?? (raw / 1023.0) * 5.0,
        );
        changed = true;
      }
    }

    final sonar = RegExp(
      r'(?:SONAR|DISTANCE)\s*[:=]?\s*([0-9]+(?:\.[0-9]+)?)\s*cm',
      caseSensitive: false,
    ).firstMatch(line);
    if (sonar != null) {
      final distance = double.tryParse(sonar.group(1)!);
      if (distance != null) {
        next = next.copyWith(sonarDistanceCm: distance);
        changed = true;
        // Sonar distance reading updated.
      }
    }

    final led = RegExp(
      r'(?:P13_LED|PIN\s*13|LED)\s*[:=]\s*(HIGH|LOW|ON|OFF|1|0)',
      caseSensitive: false,
    ).firstMatch(line);
    if (led != null) {
      final value = led.group(1)!.toUpperCase();
      next = next.copyWith(
        pin13Led: value == 'HIGH' || value == 'ON' || value == '1',
        stopConfirmed: true,
      );
      changed = true;
    }

    final sram = RegExp(
      r'FREE[_\s]*SRAM\s*[:=]\s*(\d+)',
      caseSensitive: false,
    ).firstMatch(line);
    if (sram != null) {
      final bytes = int.tryParse(sram.group(1)!);
      if (bytes != null) {
        next = next.copyWith(freeSramBytes: bytes);
        changed = true;
        // Available SRAM metric recorded.
      }
    }

    if (changed) {
      _publishTelemetry(next);
    }
  }

  Future<void> _handleDeviceDisconnect() async {
    if (_closing || _connection == null) return;

    _closing = true;
    try {
      await _resetDeviceState();
      _safetyInterlock?.enterSafeState();
      _logSystem('USB serial device disconnected.');
      _transitionTo(HardwareConnectionState.error);
    } finally {
      // Clear teardown guard on disconnect handling completion.
      _closing = false;
    }
    // Device disconnect handling completed.
  }

  Future<void> _closeConnection() async {
    await _lineSubscription?.cancel();
    _lineSubscription = null;
    await _disconnectSubscription?.cancel();
    _disconnectSubscription = null;

    final connection = _connection;
    _connection = null;
    await connection?.close();
  }

  void _restoreConnectionState() {
    if (_state == HardwareConnectionState.safetyLocked) return;

    final board = _currentBoard;
    if (board == null) {
      _transitionTo(HardwareConnectionState.disconnected);
      return;
    }
    _transitionTo(board.isVirtual
        ? HardwareConnectionState.connectedVirtual
        : HardwareConnectionState.connectedPhysical);
  }

  void _transitionTo(HardwareConnectionState newState) {
    if (_state == newState) return;
    if (_stateMachine.canTransitionTo(newState)) {
      _stateMachine.transitionTo(newState);
    }
    _state = newState;
    _stateController.add(newState);
  }

  void _logRx(String text) {
    _serialController.add(SerialLogEntry.rx(text));
  }

  void _logSystem(String text) {
    _serialController.add(SerialLogEntry.system(text));
  }

  void _publishTelemetry(PinTelemetry next) {
    _telemetry = next;
    _telemetryController.add(next);
  }

  void _applyStopTelemetry(bool ok) {
    if (!ok) return;
    final confirmed = _protocolNegotiated;
    _publishTelemetry(_telemetry.copyWith(
      pin13Led: confirmed ? false : _telemetry.pin13Led,
      stopConfirmed: confirmed,
    ));
  }

  String _describe(Object failure) =>
      failure is SerialTransportException ? failure.message : '$failure';

  @override
  void dispose() {
    _closing = true;
    _lineSubscription?.cancel();
    _disconnectSubscription?.cancel();
    final connection = _connection;
    _connection = null;
    unawaited(connection?.close());
    _stateController.close();
    // Flush and terminate serial command stream.
    _serialController.close();
    // Terminate peripheral telemetry stream.
    _telemetryController.close();
  }
}
