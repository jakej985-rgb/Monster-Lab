import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:monster_lab/core/services/hardware/hardware_bridge.dart';
import 'package:monster_lab/domain/models/hardware_connection_model.dart';
import 'package:monster_lab/domain/models/learner_progress_model.dart';
import 'package:monster_lab/presentation/shared/providers.dart';

class _FakeHardwareBridge implements IHardwareBridge {
  final StreamController<SerialLogEntry> _serialController =
      StreamController<SerialLogEntry>.broadcast(sync: true);
  final StreamController<HardwareConnectionState> _stateController =
      StreamController<HardwareConnectionState>.broadcast(sync: true);
  final StreamController<PinTelemetry> _telemetryController =
      StreamController<PinTelemetry>.broadcast(sync: true);

  void emit(SerialLogEntry entry) => _serialController.add(entry);

  @override
  HardwareConnectionState get currentState =>
      HardwareConnectionState.disconnected;

  @override
  DiscoveredBoard? get currentBoard => null;

  @override
  int get currentBaudRate => 9600;

  @override
  PinTelemetry get currentTelemetry => const PinTelemetry();

  @override
  Stream<HardwareConnectionState> get stateStream => _stateController.stream;

  @override
  Stream<SerialLogEntry> get serialStream => _serialController.stream;

  @override
  Stream<PinTelemetry> get telemetryStream => _telemetryController.stream;

  @override
  bool get supportsPhysicalPorts => false;

  @override
  String? get transportNotice => null;

  @override
  Future<DiscoveredBoard?> requestPhysicalPort() async => null;

  @override
  Future<List<DiscoveredBoard>> scanDevices() async => const [];

  @override
  Future<bool> connect({DiscoveredBoard? board, int baudRate = 9600}) async =>
      false;

  @override
  Future<void> sendCommand(String command) async {}

  @override
  Future<void> disconnect() async {}

  @override
  bool get hasVerifiedProtocol => false;

  @override
  Stream<bool> get protocolVerificationStream => Stream.value(false);

  @override
  void dispose() {
    _serialController.close();
    _stateController.close();
    _telemetryController.close();
  }
}

void main() {
  test('serial log notifier batches a synchronous burst into one update',
      () async {
    final bridge = _FakeHardwareBridge();
    final notifier = HardwareSerialLogsNotifier(bridge);
    addTearDown(notifier.dispose);

    var updates = 0;
    var lastState = notifier.state;
    notifier.addListener((value) {
      if (!identical(value, lastState)) {
        updates++;
        lastState = value;
      }
    });

    for (var index = 0; index < 100; index++) {
      bridge.emit(SerialLogEntry.rx('sensor line $index'));
    }

    expect(notifier.state, isEmpty,
        reason: 'The burst should wait for the batch flush.');
    await Future<void>.delayed(HardwareSerialLogsNotifier.flushInterval +
        const Duration(milliseconds: 10));

    expect(notifier.state.length, equals(100));
    expect(updates, equals(1),
        reason: '100 synchronous lines should coalesce into one state update.');
  });

  test('progress ledger and transaction ids stay bounded', () {
    var progress = LearnerProgressModel.empty('learner_cap');
    const eventCount = LearnerProgressModel.maxProcessedTransactionIds + 5;

    for (var index = 0; index < eventCount; index++) {
      progress = progress.applyEvent(
        LearnerProgressEvent(
          eventId: 'tx_$index',
          eventType: ProgressEventType.xpAdded,
          learnerId: 'learner_cap',
          activityId: 'activity',
          timestamp: DateTime.utc(2026, 1, 1),
          xpAwarded: 1,
        ),
      );
    }

    expect(progress.totalXp, equals(eventCount));
    expect(progress.eventLedger.length,
        equals(LearnerProgressModel.maxEventLedgerEntries));
    expect(progress.processedTransactionIds.length,
        equals(LearnerProgressModel.maxProcessedTransactionIds));
    expect(progress.eventLedger.last.eventId, equals('tx_${eventCount - 1}'));
  });
}
