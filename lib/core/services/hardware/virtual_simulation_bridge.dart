import 'dart:async';
import 'dart:math' as math;
import '../../../domain/models/hardware_board_model.dart';
import '../../../domain/models/hardware_connection_model.dart';
import 'hardware_bridge.dart';

class VirtualSimulationBridge implements IHardwareBridge {
  final bool enableTelemetryTimer;

  VirtualSimulationBridge({this.enableTelemetryTimer = true});

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
    _emitState(HardwareConnectionState.scanning);
    _logSystem('Scanning local USB serial ports and virtual adapters...');
    if (enableTelemetryTimer) {
      await Future<void>.delayed(const Duration(milliseconds: 300));
    }

    final list = [
      DiscoveredBoard.virtualSimulator(),
      const DiscoveredBoard(
        portName: '/dev/ttyUSB0 (Simulated Physical)',
        boardModel: SupportedBoards.unoR3,
        vendorId: 0x1A86,
        productId: 0x7523,
      ),
    ];

    _emitState(
      _currentBoard != null
          ? (_currentBoard!.isVirtual
              ? HardwareConnectionState.connectedVirtual
              : HardwareConnectionState.connectedPhysical)
          : HardwareConnectionState.disconnected,
    );
    return list;
  }

  @override
  Future<bool> connect({DiscoveredBoard? board, int baudRate = 9600}) async {
    final target = board ?? DiscoveredBoard.virtualSimulator();
    _baudRate = baudRate;
    _currentBoard = target;

    _emitState(HardwareConnectionState.scanning);
    _logSystem('Connecting to ${target.displayTitle} @ $baudRate baud...');
    if (enableTelemetryTimer) {
      await Future<void>.delayed(const Duration(milliseconds: 200));
    }

    final newState = target.isVirtual
        ? HardwareConnectionState.connectedVirtual
        : HardwareConnectionState.connectedPhysical;
    _emitState(newState);

    _logSystem('Link established. Ready for serial transmission.');
    _logRx('[Monster Lab Companion v1.0.0 Ready]');
    _logRx(
        'Board: ${target.boardModel.name} | Microcontroller: ${target.boardModel.microcontroller}');
    _logRx('Type "HELP" for available test commands.');

    _startTelemetryStream();
    return true;
  }

  @override
  Future<void> sendCommand(String rawCommand) async {
    final command = rawCommand.trim();
    if (command.isEmpty) return;

    _serialController.add(SerialLogEntry.tx(command));

    if (_state != HardwareConnectionState.connectedVirtual &&
        _state != HardwareConnectionState.connectedPhysical) {
      _logSystem('Error: Command dropped. No active hardware connection.');
      return;
    }

    // Process interactive commands
    final upper = command.toUpperCase();
    if (upper == 'PING') {
      _logRx('PONG:MONSTER_UNO_V1');
    } else if (upper == 'STATUS') {
      _logRx(
        'STATUS:OK | VCC:5.02V | FREE_SRAM:${_telemetry.freeSramBytes}B | P13_LED:${_telemetry.pin13Led ? "HIGH" : "LOW"} | BAUD:$_baudRate',
      );
    } else if (upper == 'LED:ON' || upper == 'LED:1') {
      _telemetry = _telemetry.copyWith(pin13Led: true);
      _telemetryController.add(_telemetry);
      _logRx('ACK:LED:1 (Pin 13 Driven HIGH)');
    } else if (upper == 'LED:OFF' || upper == 'LED:0') {
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
      _logRx('PING           - Verify communication link');
      _logRx('STATUS         - Hardware health check');
      _logRx('LED:ON / OFF   - Drive Pin 13 test LED');
      _logRx('ANALOG:READ    - Read A0 analog voltage');
      _logRx('SONAR:READ     - Read ultrasonic distance');
      _logRx('HELP           - Show this command reference');
    } else {
      _logRx('ERR: Unknown command "$command". Type HELP for commands.');
    }
  }

  @override
  Future<void> disconnect() async {
    _telemetryTimer?.cancel();
    _telemetryTimer = null;
    _currentBoard = null;
    _logSystem('Hardware link closed.');
    _emitState(HardwareConnectionState.disconnected);
  }

  void _startTelemetryStream() {
    if (!enableTelemetryTimer) return;
    _telemetryTimer?.cancel();
    _telemetryTimer = Timer.periodic(const Duration(milliseconds: 1500), (_) {
      if (_state != HardwareConnectionState.connectedVirtual &&
          _state != HardwareConnectionState.connectedPhysical) {
        return;
      }

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

  void _emitState(HardwareConnectionState newState) {
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
