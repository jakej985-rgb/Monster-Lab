import '../../../domain/models/hardware_connection_model.dart';

abstract class IHardwareBridge {
  HardwareConnectionState get currentState;
  DiscoveredBoard? get currentBoard;
  int get currentBaudRate;
  PinTelemetry get currentTelemetry;

  Stream<HardwareConnectionState> get stateStream;
  Stream<SerialLogEntry> get serialStream;
  Stream<PinTelemetry> get telemetryStream;

  Future<List<DiscoveredBoard>> scanDevices();
  Future<bool> connect({DiscoveredBoard? board, int baudRate = 9600});
  Future<void> sendCommand(String command);
  Future<void> disconnect();
  void dispose();

  /// Whether this bridge can open real USB serial hardware.
  bool get supportsPhysicalPorts => false;

  /// Explanation shown to the learner when physical ports are unavailable.
  String? get transportNotice => null;

  /// Shows the browser/OS port picker. Returns `null` when unavailable or the
  /// user cancels.
  Future<DiscoveredBoard?> requestPhysicalPort() async => null;

  /// Whether the connected hardware supports a verified safe-state protocol.
  bool get hasVerifiedProtocol => false;

  /// Stream of protocol verification readiness changes.
  Stream<bool> get protocolVerificationStream =>
      Stream<bool>.value(hasVerifiedProtocol);
}
