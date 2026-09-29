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
}
