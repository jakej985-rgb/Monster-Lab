import 'dart:async';
import 'dart:math' as math;
import '../../../domain/models/hardware_board_model.dart';
import '../../../domain/models/hardware_connection_model.dart';
import '../../../domain/models/hardware_device_capability_registry.dart';
import 'hardware_bridge.dart';
import 'hardware_protocol.dart';
import 'hardware_safety_interlock.dart';

class VirtualSimulationBridge implements IHardwareBridge {
  final bool enableTelemetryTimer;

  VirtualSimulationBridge({this.enableTelemetryTimer = true}) {
    _stateMachine = HardwareConnectionStateMachine(_state);
  }

  late final HardwareConnectionStateMachine _stateMachine;
  HardwareSafetyInterlock? _safetyInterlock;

  HardwareConnectionState _state = HardwareConnectionState.disconnected;
  DiscoveredBoard? _currentBoard;
  int _baudRate = 9600;
  PinTelemetry _telemetry = const PinTelemetry();

  final _stateController =
      StreamController<HardwareConnectionState>.broadcast(sync: true);
  final _serialController =
      StreamController<SerialLogEntry>.broadcast(sync: true);
  final _telemetryController =
      StreamController<PinTelemetry>.broadcast(sync: true);

  Timer? _telemetryTimer;
  double _phase = 0.0;

  HardwareConnectionStateMachine get stateMachine => _stateMachine;
  HardwareSafetyInterlock? get safetyInterlock => _safetyInterlock;

  @override
  bool get supportsPhysicalPorts => false;

  @override
  String? get transportNotice => null;

  @override
  Future<DiscoveredBoard?> requestPhysicalPort() async => null;

  @override
  HardwareConnectionState get currentState => _state;

  @override
  DiscoveredBoard? get currentBoard => _currentBoard;

  @override
  int get currentBaudRate => _baudRate;

  @override
  PinTelemetry get currentTelemetry => _telemetry;

  @override
  Stream<HardwareConnectionState> get stateStream => _stateController.stream;

  @override
  Stream<SerialLogEntry> get serialStream => _serialController.stream;

  @override
  Stream<PinTelemetry> get telemetryStream => _telemetryController.stream;

  @override
  Future<List<DiscoveredBoard>> scanDevices() async {
    _transitionTo(HardwareConnectionState.scanning);
    _logSystem('Scanning local USB serial ports and virtual adapters...');
    if (enableTelemetryTimer) {
      await Future<void>.delayed(const Duration(milliseconds: 200));
    }

    final list = [
      DiscoveredBoard.virtualSimulator(),
      const DiscoveredBoard(
        portName: 'SIMULATED://UNO_R3',
        boardModel: SupportedBoards.unoR3,
        vendorId: 0x1A86,
        productId: 0x7523,
        isVirtual: true,
      ),
      const DiscoveredBoard(
        portName: 'SIMULATED://ESP32',
        boardModel: SupportedBoards.esp32,
        vendorId: 0x10C4,
        productId: 0xEA60,
        isVirtual: true,
      ),
    ];
    _logSystem('Virtual scan complete; returning simulated boards.');

    if (_currentBoard != null) {
      final activeState = _currentBoard!.isVirtual
          ? HardwareConnectionState.connectedVirtual
          : HardwareConnectionState.connectedPhysical;
      _transitionTo(activeState);
    } else {
      _transitionTo(HardwareConnectionState.disconnected);
    }
    return list;
  }

  @override
  Future<bool> connect({DiscoveredBoard? board, int baudRate = 9600}) async {
    final target = board ?? DiscoveredBoard.virtualSimulator();
    _baudRate = baudRate;
    _currentBoard = target;

    // Check capability registry for baud rate support
    final capabilities =
        HardwareDeviceCapabilityRegistry.findForBoard(target.boardModel);
    if (!capabilities.isBaudRateSupported(baudRate)) {
      _logSystem(
          'Warning: Baud rate $baudRate is not standard for ${target.boardModel.name}');
    }

    _transitionTo(HardwareConnectionState.connecting);
    _logSystem('Connecting to ${target.displayTitle} @ $baudRate baud...');
    if (enableTelemetryTimer) {
      await Future<void>.delayed(const Duration(milliseconds: 150));
    }

    final targetState = target.isVirtual
        ? HardwareConnectionState.connectedVirtual
        : HardwareConnectionState.connectedPhysical;
    _transitionTo(targetState);

    _safetyInterlock = HardwareSafetyInterlock(board: target.boardModel);

    _logSystem('Link established. Ready for serial transmission.');
    _logRx('[Monster Lab Companion v1.0.0 Ready]');
    _logRx(
        'Board: ${target.boardModel.name} | Architecture: ${capabilities.architecture}');
    _logRx('Type "HELP" for available test commands.');

    _startTelemetryStream();
    return true;
  }

  @override
  Future<void> sendCommand(String rawCommand) async {
    final command = rawCommand.trim();
    if (command.isEmpty) return;

    _serialController.add(SerialLogEntry.tx(command));

    if (!_state.isConnected) {
      _logSystem('Error: Command dropped. No active hardware connection.');
      return;
    }

    final upper = command.toUpperCase();

    // 1. Emergency stop and safe state handling
    if (upper == 'EMERGENCY_STOP') {
      _safetyInterlock
          ?.tripSafetyLock('Operator Emergency Stop command received');
      _transitionTo(HardwareConnectionState.safetyLocked);
      _telemetry = _telemetry.copyWith(pin13Led: false);
      _telemetryController.add(_telemetry);
      _logRx('ACK:EMERGENCY_STOP:SAFE_STATE_ENGAGED');
      return;
    }

    if (upper == 'SAFE_STATE') {
      _safetyInterlock?.enterSafeState();
      _telemetry = _telemetry.copyWith(pin13Led: false);
      _telemetryController.add(_telemetry);
      _logRx('ACK:SAFE_STATE:OK');
      return;
    }

    if (upper == 'RESET_SAFETY_LOCK') {
      _safetyInterlock?.resetLock();
      if (_state == HardwareConnectionState.safetyLocked &&
          _currentBoard != null) {
        final target = _currentBoard!.isVirtual
            ? HardwareConnectionState.connectedVirtual
            : HardwareConnectionState.connectedPhysical;
        _stateMachine.unlock(target);
        _state = target;
        _stateController.add(target);
      }
      _logRx('ACK:SAFETY_LOCK_RESET');
      return;
    }

    // 2. Validate with safety interlock
    if (_safetyInterlock != null) {
      try {
        _safetyInterlock!.validateCommand(command);
      } on SafetyViolationException catch (e) {
        _logRx('ERR:SAFETY_VIOLATION: ${e.reason}');
        if (_safetyInterlock!.isLocked) {
          _transitionTo(HardwareConnectionState.safetyLocked);
        }
        return;
      }
    }

    // 3. Process commands
    if (upper.startsWith('HELLO:MONSTER_LAB:')) {
      final boardId = _currentBoard?.boardModel.id ?? 'virtual_uno';
      _logRx('ACK:HANDSHAKE:${ProtocolVersion.current}:$boardId:VIRTUAL_HASH');
    } else if (upper == 'PING') {
      _logRx('PONG:MONSTER_UNO_V1');
    } else if (upper == 'STATUS') {
      _logRx(
        'STATUS:OK | VCC:${_currentBoard?.boardModel.operatingVoltage ?? "5.0V"} | FREE_SRAM:${_telemetry.freeSramBytes}B | P13_LED:${_telemetry.pin13Led ? "HIGH" : "LOW"} | BAUD:$_baudRate',
      );
    } else if (upper == 'LED:ON' ||
        upper == 'LED:1' ||
        upper == 'PIN:13:HIGH') {
      _telemetry = _telemetry.copyWith(pin13Led: true);
      _telemetryController.add(_telemetry);
      _logRx('ACK:LED:1 (Pin 13 Driven HIGH)');
    } else if (upper == 'LED:OFF' ||
        upper == 'LED:0' ||
        upper == 'PIN:13:LOW') {
      _telemetry = _telemetry.copyWith(pin13Led: false);
      _telemetryController.add(_telemetry);
      _logRx('ACK:LED:0 (Pin 13 Driven LOW)');
    } else if (upper == 'ANALOG:READ' || upper == 'ANALOG:A0') {
      _logRx(
          'A0:${_telemetry.a0Raw} (${_telemetry.a0Voltage.toStringAsFixed(2)}V)');
    } else if (upper == 'SONAR:READ' || upper == 'SONAR') {
      _logRx('SONAR:${_telemetry.sonarDistanceCm.toStringAsFixed(1)} cm');
    } else if (upper == 'HELP') {
      _logRx('=== Monster Lab Serial Commands ===');
      _logRx('HELLO:MONSTER_LAB:v1.0 - Protocol Handshake');
      _logRx('PING                   - Verify communication link');
      _logRx('STATUS                 - Hardware health check');
      _logRx('LED:ON / OFF           - Drive Pin 13 test LED');
      _logRx('ANALOG:READ            - Read A0 analog voltage');
      _logRx('SONAR:READ             - Read ultrasonic distance');
      _logRx('SAFE_STATE             - Revert all pins to safe states');
      _logRx(
          'EMERGENCY_STOP         - Trip safety lock and shut down actuators');
      _logRx('RESET_SAFETY_LOCK      - Clear safety lock');
      _logRx('HELP                   - Show this command reference');
    } else {
      _logRx('ERR: Unknown command "$command". Type HELP for commands.');
    }
  }

  @override
  Future<void> disconnect() async {
    _telemetryTimer?.cancel();
    _telemetryTimer = null;
    _safetyInterlock?.enterSafeState();
    _currentBoard = null;
    _logSystem('Hardware link closed.');
    _transitionTo(HardwareConnectionState.disconnected);
  }

  void _startTelemetryStream() {
    if (!enableTelemetryTimer) return;
    _telemetryTimer?.cancel();
    _telemetryTimer = Timer.periodic(const Duration(milliseconds: 1500), (_) {
      if (!_state.isConnected) return;

      _phase += 0.2;
      final rawA0 = (512 + (math.sin(_phase) * 300)).toInt().clamp(0, 1023);
      final voltageA0 = (rawA0 / 1023.0) * 5.0;
      final dist = (35.0 + (math.cos(_phase) * 20.0)).clamp(4.0, 300.0);

      _telemetry = _telemetry.copyWith(
        a0Raw: rawA0,
        a0Voltage: voltageA0,
        sonarDistanceCm: dist,
      );
      _telemetryController.add(_telemetry);
    });
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

  @override
  void dispose() {
    _telemetryTimer?.cancel();
    _stateController.close();
    _serialController.close();
    _telemetryController.close();
  }
}
