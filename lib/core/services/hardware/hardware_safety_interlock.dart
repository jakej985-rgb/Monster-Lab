import 'dart:collection';
import '../../../domain/models/hardware_board_model.dart';
import '../../../domain/models/hardware_device_capability_registry.dart';

class SafetyViolationException implements Exception {
  final String command;
  final String reason;
  final String? boardId;

  const SafetyViolationException({
    required this.command,
    required this.reason,
    this.boardId,
  });

  @override
  String toString() =>
      'SafetyViolationException: Blocked unsafe command "$command" on ${boardId ?? "device"}: $reason';
}

class HardwareSafeState {
  final Map<int, bool> digitalPins;
  final Map<int, int> pwmDuty;
  final bool buzzerActive;
  final bool relayActive;
  final bool laserActive;
  final DateTime timestamp;

  HardwareSafeState({
    Map<int, bool>? digitalPins,
    Map<int, int>? pwmDuty,
    this.buzzerActive = false,
    this.relayActive = false,
    this.laserActive = false,
    DateTime? timestamp,
  })  : digitalPins = digitalPins ?? {},
        pwmDuty = pwmDuty ?? {},
        timestamp = timestamp ?? DateTime.now();

  static HardwareSafeState defaultSafe(HardwareBoardModel board) {
    final caps = HardwareDeviceCapabilityRegistry.findForBoard(board);
    final digitals = <int, bool>{};
    for (int p = 0; p < caps.maxDigitalPins; p++) {
      digitals[p] = false;
    }
    final pwms = <int, int>{};
    for (int p = 0; p < caps.maxPwmPins; p++) {
      pwms[p] = 0;
    }
    return HardwareSafeState(
      digitalPins: digitals,
      pwmDuty: pwms,
      buzzerActive: false,
      relayActive: false,
      laserActive: false,
    );
  }
}

class HardwareSafetyInterlock {
  final HardwareBoardModel board;
  final DeviceCapabilities capabilities;
  final int maxTogglesPerWindow;
  final Duration toggleWindow;

  bool _isLocked = false;
  String? _lockReason;
  final Queue<DateTime> _toggleTimestamps = Queue<DateTime>();

  HardwareSafetyInterlock({
    required this.board,
    DeviceCapabilities? capabilities,
    this.maxTogglesPerWindow = 6,
    this.toggleWindow = const Duration(milliseconds: 300),
  }) : capabilities = capabilities ??
            HardwareDeviceCapabilityRegistry.findForBoard(board);

  bool get isLocked => _isLocked;
  String? get lockReason => _lockReason;

  void tripSafetyLock(String reason) {
    _isLocked = true;
    _lockReason = reason;
  }

  void resetLock() {
    _isLocked = false;
    _lockReason = null;
    _toggleTimestamps.clear();
  }

  HardwareSafeState enterSafeState() {
    _toggleTimestamps.clear();
    return HardwareSafeState.defaultSafe(board);
  }

  void validateCommand(String command) {
    if (_isLocked) {
      throw SafetyViolationException(
        command: command,
        reason:
            'Hardware is in safety-locked state ($_lockReason). Unlock or reset required.',
        boardId: board.id,
      );
    }

    final trimmed = command.trim();
    if (trimmed.isEmpty) return;

    final upper = trimmed.toUpperCase();

    // 1. Emergency stop command is always permitted
    if (upper == 'EMERGENCY_STOP' ||
        upper == 'SAFE_STATE' ||
        upper == 'RESET') {
      return;
    }

    // 2. Reserved UART pins protection (Pin 0 RX and Pin 1 TX on AVR boards)
    if (board.microcontroller.contains('ATmega328') ||
        board.microcontroller.contains('Uno')) {
      final pinMatch =
          RegExp(r'(?:PIN|DIGITAL|LED)[:=](\d+)').firstMatch(upper);
      if (pinMatch != null) {
        final pinNum = int.tryParse(pinMatch.group(1)!);
        if (pinNum == 0 || pinNum == 1) {
          tripSafetyLock(
              'Direct digital mutation of reserved hardware UART Pin $pinNum');
          throw SafetyViolationException(
            command: command,
            reason:
                'Pins 0 and 1 are dedicated hardware serial lines (RX/TX). Writing directly to them will corrupt link or cause hardware contention.',
            boardId: board.id,
          );
        }
      }
    }

    // 3. Pin boundary validation
    final pinMatch = RegExp(r'(?:PIN|DIGITAL|PWM)[:=](\d+)').firstMatch(upper);
    if (pinMatch != null) {
      final pinNum = int.tryParse(pinMatch.group(1)!);
      if (pinNum != null && pinNum >= capabilities.maxDigitalPins) {
        throw SafetyViolationException(
          command: command,
          reason:
              'Pin $pinNum exceeds board digital pin boundary (${capabilities.maxDigitalPins} pins).',
          boardId: board.id,
        );
      }
    }

    // 4. Overvoltage protection: 5V signals forbidden on 3.3V boards
    if (capabilities.operatingVoltage < 4.0) {
      if (upper.contains('VOLTAGE:5') ||
          upper.contains('5.0V') ||
          upper.contains('VCC:5')) {
        tripSafetyLock('Attempted 5.0V signal command on 3.3V logic board');
        throw SafetyViolationException(
          command: command,
          reason:
              'Board ${board.name} operates at 3.3V logic. 5.0V command will cause permanent overvoltage damage.',
          boardId: board.id,
        );
      }
    }

    // 5. Rapid toggle oscillation limiter (relays and motors)
    if (upper.startsWith('LED:') ||
        upper.startsWith('RELAY:') ||
        upper.startsWith('MOTOR:')) {
      final now = DateTime.now();
      _toggleTimestamps.addLast(now);
      while (_toggleTimestamps.isNotEmpty &&
          now.difference(_toggleTimestamps.first) > toggleWindow) {
        _toggleTimestamps.removeFirst();
      }

      if (_toggleTimestamps.length > maxTogglesPerWindow) {
        tripSafetyLock(
            'Rapid toggle oscillation limit exceeded ($maxTogglesPerWindow in $toggleWindow)');
        throw SafetyViolationException(
          command: command,
          reason:
              'Rapid switching rate exceeded safe threshold. Thermal & flyback inductive protection activated.',
          boardId: board.id,
        );
      }
    }
  }
}
