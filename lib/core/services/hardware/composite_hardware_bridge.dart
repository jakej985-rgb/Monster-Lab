import 'dart:async';

import '../../../domain/models/hardware_connection_model.dart';
import 'hardware_bridge.dart';
import 'physical_serial_bridge.dart';
import 'serial_transport_factory.dart';
import 'virtual_simulation_bridge.dart';

/// Routes Hardware Companion traffic to either the virtual simulator or a real
/// Web Serial device while presenting one stable bridge to the UI.
class CompositeHardwareBridge implements IHardwareBridge {
  CompositeHardwareBridge({
    VirtualSimulationBridge? virtual,
    PhysicalSerialBridge? physical,
  })  : _virtual = virtual ?? VirtualSimulationBridge(),
        _physical = physical ??
            PhysicalSerialBridge(transport: createSerialTransport()) {
    _virtualStateSubscription = _virtual.stateStream.listen((state) {
      if (!_usePhysical) _stateController.add(state);
    });
    _physicalStateSubscription = _physical.stateStream.listen((state) {
      if (_usePhysical) _stateController.add(state);
    });
    _virtualTelemetrySubscription = _virtual.telemetryStream.listen((value) {
      if (!_usePhysical) _telemetryController.add(value);
    });
    _physicalTelemetrySubscription = _physical.telemetryStream.listen((value) {
      if (_usePhysical) _telemetryController.add(value);
    });
    _virtualProtocolSubscription =
        _virtual.protocolVerificationStream.listen((value) {
      if (!_usePhysical) _protocolController.add(value);
    });
    _physicalProtocolSubscription =
        _physical.protocolVerificationStream.listen((value) {
      if (_usePhysical) _protocolController.add(value);
    });
    _virtualSerialSubscription =
        _virtual.serialStream.listen(_serialController.add);
    _physicalSerialSubscription =
        _physical.serialStream.listen(_serialController.add);
  }

  final VirtualSimulationBridge _virtual;
  final PhysicalSerialBridge _physical;

  late final StreamSubscription<HardwareConnectionState>
      _virtualStateSubscription;
  late final StreamSubscription<HardwareConnectionState>
      _physicalStateSubscription;
  late final StreamSubscription<PinTelemetry> _virtualTelemetrySubscription;
  late final StreamSubscription<PinTelemetry> _physicalTelemetrySubscription;
  late final StreamSubscription<bool> _virtualProtocolSubscription;
  late final StreamSubscription<bool> _physicalProtocolSubscription;
  late final StreamSubscription<SerialLogEntry> _virtualSerialSubscription;
  late final StreamSubscription<SerialLogEntry> _physicalSerialSubscription;

  final _stateController =
      StreamController<HardwareConnectionState>.broadcast(sync: true);
  final _serialController =
      StreamController<SerialLogEntry>.broadcast(sync: true);
  final _telemetryController =
      StreamController<PinTelemetry>.broadcast(sync: true);
  final _protocolController = StreamController<bool>.broadcast(sync: true);

  bool _usePhysical = false;

  IHardwareBridge get _active => _usePhysical ? _physical : _virtual;

  @override
  HardwareConnectionState get currentState => _active.currentState;

  @override
  DiscoveredBoard? get currentBoard => _active.currentBoard;

  @override
  int get currentBaudRate => _active.currentBaudRate;

  @override
  PinTelemetry get currentTelemetry => _active.currentTelemetry;

  @override
  Stream<HardwareConnectionState> get stateStream => _stateController.stream;

  @override
  Stream<SerialLogEntry> get serialStream => _serialController.stream;

  @override
  Stream<PinTelemetry> get telemetryStream => _telemetryController.stream;

  @override
  bool get supportsPhysicalPorts => _physical.supportsPhysicalPorts;

  @override
  String? get transportNotice => _physical.transportNotice;

  @override
  bool get hasVerifiedProtocol => _active.hasVerifiedProtocol;

  @override
  Stream<bool> get protocolVerificationStream {
    return _protocolController.stream;
  }

  @override
  Future<List<DiscoveredBoard>> scanDevices() async {
    final boards = <DiscoveredBoard>[];
    final seen = <String>{};

    void addAll(List<DiscoveredBoard> discovered) {
      for (final board in discovered) {
        if (seen.add(board.portName)) boards.add(board);
      }
    }

    addAll(await _virtual.scanDevices());
    if (_physical.supportsPhysicalPorts) {
      addAll(await _physical.scanDevices());
    }

    return List.unmodifiable(boards);
  }

  @override
  Future<DiscoveredBoard?> requestPhysicalPort() async {
    return _physical.requestPhysicalPort();
  }

  @override
  Future<bool> connect({DiscoveredBoard? board, int baudRate = 9600}) async {
    final wantsPhysical = board != null && !board.isVirtual;

    if (wantsPhysical && !_physical.supportsPhysicalPorts) {
      _serialController.add(
        SerialLogEntry.system(
          _physical.transportNotice ??
              'Real USB serial is unavailable in this browser.',
        ),
      );
      return false;
    }

    _usePhysical = wantsPhysical;
    if (wantsPhysical) {
      if (_virtual.currentState != HardwareConnectionState.disconnected) {
        await _virtual.disconnect();
      }
    } else {
      if (_physical.currentState != HardwareConnectionState.disconnected) {
        await _physical.disconnect();
      }
    }

    final success = await _active.connect(board: board, baudRate: baudRate);
    if (success) {
      _telemetryController.add(_active.currentTelemetry);
      _protocolController.add(_active.hasVerifiedProtocol);
    }
    return success;
  }

  @override
  Future<void> sendCommand(String command) => _active.sendCommand(command);

  @override
  Future<void> disconnect() async {
    await _active.disconnect();
    _telemetryController.add(_active.currentTelemetry);
    _protocolController.add(_active.hasVerifiedProtocol);
  }

  @override
  void dispose() {
    _virtualStateSubscription.cancel();
    _physicalStateSubscription.cancel();
    _virtualTelemetrySubscription.cancel();
    _physicalTelemetrySubscription.cancel();
    _virtualProtocolSubscription.cancel();
    _physicalProtocolSubscription.cancel();
    _virtualSerialSubscription.cancel();
    _physicalSerialSubscription.cancel();
    _virtual.dispose();
    _physical.dispose();
    for (final c in [
      _stateController,
      _serialController,
      _telemetryController,
      _protocolController,
    ]) {
      c.close();
    }
  }
}
