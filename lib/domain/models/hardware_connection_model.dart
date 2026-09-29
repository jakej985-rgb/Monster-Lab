import 'hardware_board_model.dart';

enum HardwareConnectionState {
  disconnected,
  scanning,
  connectedPhysical,
  connectedVirtual,
  error;

  bool get isConnected =>
      this == HardwareConnectionState.connectedPhysical ||
      this == HardwareConnectionState.connectedVirtual;

  bool get isVirtual => this == HardwareConnectionState.connectedVirtual;

  String get displayName {
    switch (this) {
      case HardwareConnectionState.disconnected:
        return 'Disconnected';
      case HardwareConnectionState.scanning:
        return 'Scanning Ports...';
      case HardwareConnectionState.connectedPhysical:
        return 'Connected (USB)';
      case HardwareConnectionState.connectedVirtual:
        return 'Virtual Simulator (Active)';
      case HardwareConnectionState.error:
        return 'Connection Error';
    }
  }
}

class DiscoveredBoard {
  final String portName;
  final HardwareBoardModel boardModel;
  final int? vendorId;
  final int? productId;
  final String? serialNumber;
  final bool isVirtual;

  const DiscoveredBoard({
    required this.portName,
    required this.boardModel,
    this.vendorId,
    this.productId,
    this.serialNumber,
    this.isVirtual = false,
  });

  String get displayTitle => '${boardModel.name} on $portName';

  static DiscoveredBoard virtualSimulator() {
    return const DiscoveredBoard(
      portName: 'VIRTUAL://PORT_0',
      boardModel: SupportedBoards.virtualUno,
      isVirtual: true,
    );
  }
}

enum SerialLogDirection {
  rx,
  tx,
  system,
}

class SerialLogEntry {
  final DateTime timestamp;
  final String text;
  final SerialLogDirection direction;

  const SerialLogEntry({
    required this.timestamp,
    required this.text,
    required this.direction,
  });

  factory SerialLogEntry.rx(String message) => SerialLogEntry(
        timestamp: DateTime.now(),
        text: message,
        direction: SerialLogDirection.rx,
      );

  factory SerialLogEntry.tx(String message) => SerialLogEntry(
        timestamp: DateTime.now(),
        text: message,
        direction: SerialLogDirection.tx,
      );

  factory SerialLogEntry.system(String message) => SerialLogEntry(
        timestamp: DateTime.now(),
        text: message,
        direction: SerialLogDirection.system,
      );
}

class PinTelemetry {
  final bool pin13Led;
  final double a0Voltage;
  final int a0Raw;
  final double sonarDistanceCm;
  final int freeSramBytes;

  const PinTelemetry({
    this.pin13Led = false,
    this.a0Voltage = 2.5,
    this.a0Raw = 512,
    this.sonarDistanceCm = 24.0,
    this.freeSramBytes = 1524,
  });

  PinTelemetry copyWith({
    bool? pin13Led,
    double? a0Voltage,
    int? a0Raw,
    double? sonarDistanceCm,
    int? freeSramBytes,
  }) {
    return PinTelemetry(
      pin13Led: pin13Led ?? this.pin13Led,
      a0Voltage: a0Voltage ?? this.a0Voltage,
      a0Raw: a0Raw ?? this.a0Raw,
      sonarDistanceCm: sonarDistanceCm ?? this.sonarDistanceCm,
      freeSramBytes: freeSramBytes ?? this.freeSramBytes,
    );
  }

  Map<String, dynamic> toMap() => {
        'pin13Led': pin13Led,
        'a0Voltage': a0Voltage,
        'a0Raw': a0Raw,
        'sonarDistanceCm': sonarDistanceCm,
        'freeSramBytes': freeSramBytes,
      };
}
