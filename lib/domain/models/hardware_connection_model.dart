import 'hardware_board_model.dart';

enum HardwareConnectionState {
  disconnected,
  connecting,
  connected,
  simulation,
  unavailable,
  unsupported,
  safetyLocked,
  error,

  // Legacy compatibility states:
  scanning,
  connectedPhysical,
  connectedVirtual;

  bool get isConnected =>
      this == HardwareConnectionState.connected ||
      this == HardwareConnectionState.connectedPhysical ||
      this == HardwareConnectionState.connectedVirtual ||
      this == HardwareConnectionState.simulation ||
      this == HardwareConnectionState.safetyLocked;

  bool get isVirtual =>
      this == HardwareConnectionState.connectedVirtual ||
      this == HardwareConnectionState.simulation;

  bool get isLocked => this == HardwareConnectionState.safetyLocked;

  String get displayName {
    switch (this) {
      case HardwareConnectionState.disconnected:
        return 'Disconnected';
      case HardwareConnectionState.connecting:
      case HardwareConnectionState.scanning:
        return 'Connecting...';
      case HardwareConnectionState.connected:
      case HardwareConnectionState.connectedPhysical:
        return 'Connected (USB)';
      case HardwareConnectionState.simulation:
      case HardwareConnectionState.connectedVirtual:
        return 'Virtual Simulator (Active)';
      case HardwareConnectionState.unavailable:
        return 'Port Unavailable';
      case HardwareConnectionState.unsupported:
        return 'Device Unsupported';
      case HardwareConnectionState.safetyLocked:
        return 'Safety Locked';
      case HardwareConnectionState.error:
        return 'Connection Error';
    }
  }
}

class IllegalStateTransitionException implements Exception {
  final HardwareConnectionState from;
  final HardwareConnectionState to;
  final String message;

  const IllegalStateTransitionException(this.from, this.to,
      [this.message = 'Illegal state transition']);

  @override
  String toString() =>
      'IllegalStateTransitionException: Cannot transition from $from to $to ($message)';
}

class HardwareConnectionStateMachine {
  HardwareConnectionState _state;

  HardwareConnectionStateMachine(
      [this._state = HardwareConnectionState.disconnected]);

  HardwareConnectionState get state => _state;

  static final Map<HardwareConnectionState, Set<HardwareConnectionState>>
      _allowedTransitions = {
    HardwareConnectionState.disconnected: {
      HardwareConnectionState.connecting,
      HardwareConnectionState.scanning,
      HardwareConnectionState.simulation,
      HardwareConnectionState.connectedVirtual,
      HardwareConnectionState.unavailable,
      HardwareConnectionState.error,
    },
    HardwareConnectionState.connecting: {
      HardwareConnectionState.connected,
      HardwareConnectionState.connectedPhysical,
      HardwareConnectionState.simulation,
      HardwareConnectionState.connectedVirtual,
      HardwareConnectionState.disconnected,
      HardwareConnectionState.unavailable,
      HardwareConnectionState.unsupported,
      HardwareConnectionState.error,
    },
    HardwareConnectionState.scanning: {
      HardwareConnectionState.connected,
      HardwareConnectionState.connectedPhysical,
      HardwareConnectionState.simulation,
      HardwareConnectionState.connectedVirtual,
      HardwareConnectionState.disconnected,
      HardwareConnectionState.unavailable,
      HardwareConnectionState.unsupported,
      HardwareConnectionState.error,
      HardwareConnectionState.connecting,
    },
    HardwareConnectionState.connected: {
      HardwareConnectionState.disconnected,
      HardwareConnectionState.safetyLocked,
      HardwareConnectionState.error,
      HardwareConnectionState.connecting,
    },
    HardwareConnectionState.connectedPhysical: {
      HardwareConnectionState.disconnected,
      HardwareConnectionState.safetyLocked,
      HardwareConnectionState.error,
      HardwareConnectionState.connecting,
    },
    HardwareConnectionState.simulation: {
      HardwareConnectionState.disconnected,
      HardwareConnectionState.safetyLocked,
      HardwareConnectionState.error,
      HardwareConnectionState.connecting,
    },
    HardwareConnectionState.connectedVirtual: {
      HardwareConnectionState.disconnected,
      HardwareConnectionState.safetyLocked,
      HardwareConnectionState.error,
      HardwareConnectionState.connecting,
    },
    HardwareConnectionState.safetyLocked: {
      HardwareConnectionState.disconnected,
      HardwareConnectionState.error,
    },
    HardwareConnectionState.unsupported: {
      HardwareConnectionState.disconnected,
      HardwareConnectionState.connecting,
      HardwareConnectionState.scanning,
    },
    HardwareConnectionState.unavailable: {
      HardwareConnectionState.disconnected,
      HardwareConnectionState.connecting,
      HardwareConnectionState.scanning,
    },
    HardwareConnectionState.error: {
      HardwareConnectionState.disconnected,
      HardwareConnectionState.connecting,
      HardwareConnectionState.scanning,
    },
  };

  bool canTransitionTo(HardwareConnectionState next) {
    if (_state == next) return true;
    final allowed = _allowedTransitions[_state];
    return allowed != null && allowed.contains(next);
  }

  void transitionTo(HardwareConnectionState next) {
    if (_state == next) return;
    if (!canTransitionTo(next)) {
      throw IllegalStateTransitionException(_state, next);
    }
    _state = next;
  }

  void unlock(
      [HardwareConnectionState target = HardwareConnectionState.connected]) {
    if (_state == HardwareConnectionState.safetyLocked) {
      _state = target;
    }
  }

  void reset() {
    _state = HardwareConnectionState.disconnected;
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
