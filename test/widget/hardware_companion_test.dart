import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monster_lab/core/services/hardware/virtual_simulation_bridge.dart';
import 'package:monster_lab/core/services/storage_service.dart';
import 'package:monster_lab/data/datasources/asset_curriculum_datasource.dart';
import 'package:monster_lab/data/datasources/curriculum_data_engine.dart';
import 'package:monster_lab/data/datasources/local_storage_datasource.dart';
import 'package:monster_lab/data/repositories/curriculum_repository_impl.dart';
import 'package:monster_lab/data/repositories/profile_repository_impl.dart';
import 'package:monster_lab/data/repositories/progress_repository_impl.dart';
import 'package:monster_lab/domain/models/learner_profile_model.dart';
import 'package:monster_lab/domain/models/learner_progress_model.dart';
import 'package:monster_lab/presentation/features/hardware/hardware_companion_screen.dart';
import 'package:monster_lab/presentation/features/hardware/widgets/hardware_status_badge.dart';
import 'package:monster_lab/presentation/shared/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Phase 13: Hardware Companion & Serial Monitor Widget Tests', () {
    late StorageService storageService;
    late CurriculumDataEngine engine;
    late ProfileRepositoryImpl profileRepo;
    late ProgressRepositoryImpl progressRepo;
    late VirtualSimulationBridge bridge;

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

      bridge = VirtualSimulationBridge(enableTelemetryTimer: false);
    });

    tearDown(() {
      bridge.dispose();
    });

    Widget createTestWidget(Widget child) {
      return ProviderScope(
        overrides: [
          storageServiceProvider.overrideWithValue(storageService),
          curriculumRepositoryProvider
              .overrideWithValue(CurriculumRepositoryImpl(engine)),
          profileRepositoryProvider.overrideWithValue(profileRepo),
          progressRepositoryProvider.overrideWithValue(progressRepo),
          hardwareBridgeProvider.overrideWithValue(bridge),
        ],
        child: MaterialApp(
          home: child,
        ),
      );
    }

    testWidgets(
        'HardwareStatusBadge displays current offline and online states',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const Scaffold(
            body: Center(
              child: HardwareStatusBadge(showLabel: true),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Hardware Offline'), findsOneWidget);
      expect(find.byIcon(Icons.usb_off), findsOneWidget);

      // Connect to virtual simulator
      await bridge.connect();
      await tester.pumpAndSettle();

      expect(find.text('Virtual Simulator'), findsOneWidget);
      expect(find.byIcon(Icons.developer_board), findsOneWidget);
    });

    testWidgets(
        'HardwareCompanionScreen renders controls, connects, and sends commands',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester
          .pumpWidget(createTestWidget(const HardwareCompanionScreen()));
      await tester.pumpAndSettle();

      // Verify title and banner
      expect(find.text('Hardware Companion'), findsOneWidget);
      expect(find.text('Physical Arduino Optional!'), findsOneWidget);
      expect(find.text('Connection Station'), findsOneWidget);
      expect(find.text('Disconnected'), findsOneWidget);

      // Verify buttons
      final connectBtn =
          find.byKey(const Key('hardware_connect_toggle_button'));
      expect(connectBtn, findsOneWidget);
      expect(find.text('Connect to Board'), findsOneWidget);

      // Tap Connect to Board
      await tester.tap(connectBtn);
      await tester.pumpAndSettle();

      // State is now connected virtual
      expect(find.text('Virtual Simulator (Active)'), findsOneWidget);
      expect(find.text('Disconnect Hardware'), findsOneWidget);

      // Terminal should display welcome message
      expect(find.textContaining('Monster Lab Companion v1.0.0 Ready'),
          findsOneWidget);

      // Tap PING quick action chip
      await tester.tap(find.widgetWithText(ActionChip, 'PING'));
      await tester.pumpAndSettle();

      expect(find.textContaining('PONG:MONSTER_UNO_V1'), findsOneWidget);

      // Tap LED toggle in telemetry card
      final ledToggleBtn = find.byKey(const Key('telemetry_led_toggle_button'));
      expect(ledToggleBtn, findsOneWidget);
      expect(find.text('Turn ON'), findsOneWidget);

      await tester.tap(ledToggleBtn);
      await tester.pumpAndSettle();

      expect(find.textContaining('ACK:LED:1'), findsOneWidget);
      expect(find.text('Turn OFF'), findsOneWidget);

      // Enter command into TextField and send
      final inputField = find.byKey(const Key('serial_command_input'));
      final sendBtn = find.byKey(const Key('serial_send_button'));
      expect(inputField, findsOneWidget);

      await tester.enterText(inputField, 'STATUS');
      await tester.tap(sendBtn);
      await tester.pumpAndSettle();

      expect(find.textContaining('STATUS:OK'), findsOneWidget);

      // Disconnect
      await tester.tap(find.byKey(const Key('hardware_connect_toggle_button')));
      await tester.pumpAndSettle();

      expect(find.text('Disconnected'), findsOneWidget);
      expect(find.text('Connect to Board'), findsOneWidget);
    });
  });
}
