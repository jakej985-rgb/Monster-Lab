import 'dart:async';
import 'dart:convert';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monster_lab/core/services/hardware/physical_serial_bridge.dart';
import 'package:monster_lab/core/services/hardware/serial_transport.dart';
import 'package:monster_lab/core/services/storage_service.dart';
import 'package:monster_lab/data/datasources/asset_curriculum_datasource.dart';
import 'package:monster_lab/data/datasources/curriculum_data_engine.dart';
import 'package:monster_lab/data/datasources/local_storage_datasource.dart';
import 'package:monster_lab/data/repositories/curriculum_repository_impl.dart';
import 'package:monster_lab/data/repositories/profile_repository_impl.dart';
import 'package:monster_lab/data/repositories/progress_repository_impl.dart';
import 'package:monster_lab/domain/models/hardware_board_model.dart';
import 'package:monster_lab/domain/models/hardware_connection_model.dart';
import 'package:monster_lab/domain/models/learner_profile_model.dart';
import 'package:monster_lab/domain/models/learner_progress_model.dart';
import 'package:monster_lab/presentation/features/hardware/hardware_companion_screen.dart';
import 'package:monster_lab/presentation/shared/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeConnection implements SerialPortConnection {
  _FakeConnection(this.port, this.baudRate);

  final SerialPortInfo port;
  final int baudRate;

  final StreamController<List<int>> _incoming = StreamController<List<int>>();

  @override
  Stream<List<int>> get input => _incoming.stream;

  @override
  Stream<void> get disconnected => const Stream<void>.empty();

  @override
  Future<void> writeLine(String line) async {}

  @override
  Future<void> close() async {
    await _incoming.close();
  }

  void deliverLine(String line) {
    _incoming.add(utf8.encode('$line\n'));
  }
}

class _FakeTransport implements SerialTransport {
  _FakeConnection? activeConnection;

  @override
  bool get isSupported => true;

  @override
  String get unsupportedReason => '';

  @override
  Future<List<SerialPortInfo>> listPorts() async => [
        const SerialPortInfo(
          id: 'web-serial-port-1',
          label: 'USB Serial #1',
          vendorId: 0x2341,
          productId: 0x0043,
        ),
      ];

  @override
  Future<SerialPortInfo?> requestPort() async => null;

  @override
  Future<SerialPortConnection> open(
    SerialPortInfo port, {
    required int baudRate,
  }) async {
    final conn = _FakeConnection(port, baudRate);
    activeConnection = conn;
    return conn;
  }
}

void main() {
  group('Hardware Companion Protocol Readiness Tests', () {
    late StorageService storageService;
    late CurriculumDataEngine engine;
    late ProfileRepositoryImpl profileRepo;
    late ProgressRepositoryImpl progressRepo;
    late _FakeTransport transport;
    late PhysicalSerialBridge bridge;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      storageService = await StorageService.init();
      engine =
          CurriculumDataEngine(fallbackDataSource: AssetCurriculumDataSource());
      await engine.initialize();

      final localDataSource = LocalStorageDataSource(storageService);
      profileRepo = ProfileRepositoryImpl(localDataSource);
      progressRepo = ProgressRepositoryImpl(localDataSource);

      final profile = LearnerProfileModel(
        id: 'test_learner',
        nickname: 'CircuitKid',
        avatarId: 'avatar_robot',
        ageBracket: AgeBracket.ages10_12,
        createdAt: DateTime.now(),
        lastActiveAt: DateTime.now(),
      );
      await profileRepo.saveProfile(profile);
      await profileRepo.setActiveProfile(profile.id);
      await progressRepo.saveProgress(LearnerProgressModel.empty(profile.id));

      transport = _FakeTransport();
      bridge = PhysicalSerialBridge(transport: transport);
    });

    tearDown(() {
      bridge.dispose();
    });

    testWidgets(
        'delivering handshake response after connected frame enables LED toggle without telemetry event',
        (tester) async {
      tester.view.physicalSize = const Size(900, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            storageServiceProvider.overrideWithValue(storageService),
            curriculumRepositoryProvider
                .overrideWithValue(CurriculumRepositoryImpl(engine)),
            profileRepositoryProvider.overrideWithValue(profileRepo),
            progressRepositoryProvider.overrideWithValue(progressRepo),
            hardwareBridgeProvider.overrideWithValue(bridge),
          ],
          child: const MaterialApp(
            home: HardwareCompanionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      const board = DiscoveredBoard(
        portName: 'web-serial-port-1',
        displayName: 'USB Serial #1',
        boardModel: SupportedBoards.unoR3,
        vendorId: 0x2341,
        productId: 0x0043,
      );

      // Connect physical board
      final connected = await bridge.connect(board: board);
      expect(connected, isTrue);
      await tester.pump();

      // Before handshake ACK arrives: toggle button is disabled and displays Firmware Required
      final buttonFinder = find.byKey(const Key('telemetry_led_toggle_button'));
      expect(buttonFinder, findsOneWidget);
      expect(find.text('Firmware Required'), findsOneWidget);
      final initialButton = tester.widget<ElevatedButton>(buttonFinder);
      expect(initialButton.onPressed, isNull);

      // Deliver protocol handshake acknowledgment from firmware without any telemetry event
      transport.activeConnection?.deliverLine(
        'ACK:HANDSHAKE:V1:MONSTER_UNO_V1:CAP=A0,PIN13',
      );
      await tester.pump();

      // Verify toggle button reactively enabled and updated text without requiring telemetry event
      expect(find.text('Firmware Required'), findsNothing);
      expect(find.text('Turn ON'), findsOneWidget);
      final enabledButton = tester.widget<ElevatedButton>(buttonFinder);
      expect(enabledButton.onPressed, isNotNull);
    });
  });
}
