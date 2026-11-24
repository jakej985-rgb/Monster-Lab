import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monster_lab/core/services/hardware/hardware_bridge.dart';
import 'package:monster_lab/core/services/hardware/virtual_simulation_bridge.dart';
import 'package:monster_lab/domain/models/hardware_board_model.dart';
import 'package:monster_lab/domain/models/hardware_connection_model.dart';
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

    Widget createTestWidget(
      Widget child, {
      IHardwareBridge? bridgeOverride,
    }) {
      return ProviderScope(
        overrides: [
          storageServiceProvider.overrideWithValue(storageService),
          curriculumRepositoryProvider
              .overrideWithValue(CurriculumRepositoryImpl(engine)),
          profileRepositoryProvider.overrideWithValue(profileRepo),
          progressRepositoryProvider.overrideWithValue(progressRepo),
          hardwareBridgeProvider.overrideWithValue(bridgeOverride ?? bridge),
        ],
        child: MaterialApp(
          home: child,
        ),
      );
    }

    Future<void> pumpScreen(
      WidgetTester tester, {
      Size viewport = const Size(1000, 600),
      IHardwareBridge? bridgeOverride,
    }) async {
      tester.view.physicalSize = viewport;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        createTestWidget(
          const HardwareCompanionScreen(),
          bridgeOverride: bridgeOverride,
        ),
      );
      await tester.pumpAndSettle();
    }

    Future<void> pumpAndConnect(WidgetTester tester) async {
      await pumpScreen(tester);

      final connectBtn =
          find.byKey(const Key('hardware_connect_toggle_button'));
      await tester.ensureVisible(connectBtn);
      await tester.tap(connectBtn);
      await tester.pumpAndSettle();
    }

    Future<void> scrollTo(
      WidgetTester tester,
      Finder finder,
      double delta,
    ) =>
        tester
            .scrollUntilVisible(
              finder,
              delta,
              scrollable: find.byType(Scrollable).first,
            )
            .then((_) => tester.pumpAndSettle());

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
      expect(find.text('Learn With or Without Hardware'), findsOneWidget);
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

    testWidgets('Add USB Device requests a physical port and selects it',
        (tester) async {
      final capableBridge = _PhysicalCapableBridge();
      addTearDown(capableBridge.dispose);

      await pumpScreen(
        tester,
        viewport: const Size(1200, 3400),
        bridgeOverride: capableBridge,
      );

      final addButton = find.byKey(const Key('hardware_add_usb_device_button'));
      expect(addButton, findsOneWidget);

      await tester.tap(addButton);
      await tester.pumpAndSettle();

      expect(capableBridge.requestCount, 1);
      expect(find.textContaining('USB device ready'), findsOneWidget);
    });

    testWidgets(
        'short viewport: connects before terminal mounts and retains output',
        (tester) async {
      await pumpAndConnect(tester);

      // Scroll down until terminal is mounted and visible
      final terminalFinder = find.byKey(const Key('serial_command_input'));
      await scrollTo(tester, terminalFinder, 250);

      expect(terminalFinder, findsOneWidget);
      // Verify connection output is preserved in the terminal
      expect(
          find.textContaining('Ready for serial transmission'), findsOneWidget);
    });

    testWidgets(
        'scrolling terminal out of viewport preserves autoscroll preference',
        (tester) async {
      await pumpAndConnect(tester);

      // Scroll to reveal autoscroll button in terminal header
      final autoscrollBtn = find.byTooltip('Autoscroll On');
      await scrollTo(tester, autoscrollBtn, 200);

      // Toggle autoscroll off
      expect(autoscrollBtn, findsOneWidget);
      await tester.tap(autoscrollBtn);
      await tester.pumpAndSettle();
      final pausedBtn = find.byTooltip('Autoscroll Paused');
      expect(pausedBtn, findsOneWidget);

      // Scroll down past terminal to boards guide
      final boardsGuide = find.text('Supported Microcontroller Boards');
      await scrollTo(tester, boardsGuide, 300);

      // Scroll back up to terminal
      await scrollTo(tester, pausedBtn, -300);

      // Autoscroll preference is still paused
      expect(pausedBtn, findsOneWidget);
    });
  });
}

class _PhysicalCapableBridge extends VirtualSimulationBridge {
  _PhysicalCapableBridge() : super(enableTelemetryTimer: false);

  static const _board = DiscoveredBoard(
    portName: 'USB Serial Mega #1',
    boardModel: SupportedBoards.mega2560,
    vendorId: 0x2341,
    productId: 0x0010,
  );

  int requestCount = 0;

  @override
  bool get supportsPhysicalPorts => true;

  @override
  Future<List<DiscoveredBoard>> scanDevices() async {
    final boards = await super.scanDevices();
    return [...boards, _board];
  }

  // Overridden to simulate interactive user permission grant in tests.
  @override
  Future<DiscoveredBoard?> requestPhysicalPort() async {
    requestCount++;
    return _board;
  }
}
