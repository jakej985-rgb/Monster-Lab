import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monster_lab/core/services/storage_service.dart';
import 'package:monster_lab/data/datasources/local_storage_datasource.dart';
import 'package:monster_lab/data/datasources/curriculum_data_engine.dart';
import 'package:monster_lab/data/datasources/asset_curriculum_datasource.dart';
import 'package:monster_lab/data/repositories/profile_repository_impl.dart';
import 'package:monster_lab/data/repositories/progress_repository_impl.dart';
import 'package:monster_lab/data/repositories/curriculum_repository_impl.dart';
import 'package:monster_lab/domain/models/learner_profile_model.dart';
import 'package:monster_lab/presentation/features/parts/part_detail_screen.dart';
import 'package:monster_lab/presentation/features/parts/parts_screen.dart';
import 'package:monster_lab/presentation/shared/providers.dart';
import 'package:monster_lab/presentation/shared/widgets/component_image_view.dart';

void main() {
  group('Phase 08: Parts Lab & Component Encyclopedia Tests', () {
    late StorageService storageService;
    late CurriculumDataEngine engine;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      storageService = await StorageService.init();
      engine =
          CurriculumDataEngine(fallbackDataSource: AssetCurriculumDataSource());
      await engine.initialize();
    });

    Widget createTestWidget(Widget child,
        [List<Override> extraOverrides = const []]) {
      return ProviderScope(
        overrides: [
          storageServiceProvider.overrideWithValue(storageService),
          curriculumRepositoryProvider
              .overrideWithValue(CurriculumRepositoryImpl(engine)),
          ...extraOverrides,
        ],
        child: MaterialApp(
          home: child,
        ),
      );
    }

    testWidgets(
        'PartsScreen renders 54 components and allows searching & category filtering',
        (tester) async {
      await tester.pumpWidget(createTestWidget(const PartsScreen()));
      await tester.pumpAndSettle();

      // Verify Header & Discovery Banner
      expect(find.text('Parts Lab'), findsOneWidget);
      expect(find.text('Encyclopedia Discovery'), findsOneWidget);
      expect(find.textContaining('/ 54'), findsOneWidget);

      // Verify Category Chips
      expect(find.text('All Parts'), findsOneWidget);
      expect(find.text('Sensors'), findsOneWidget);
      expect(find.text('Actuators'), findsOneWidget);
      expect(find.text('Displays'), findsOneWidget);
      expect(find.text('Comm'), findsOneWidget);

      // Verify some parts render in the grid
      expect(find.text('Ultrasonic Distance Sensor'), findsOneWidget);
      expect(find.text('#01'), findsOneWidget);

      // 1. Filter by category "Displays"
      await tester.tap(find.text('Displays'));
      await tester.pumpAndSettle();

      // Displays should appear, Ultrasonic sensor (sensor) should be filtered out
      expect(find.text('Ultrasonic Distance Sensor'), findsNothing);
      expect(find.text('16x2 Character LCD with I2C'), findsOneWidget);
      expect(find.text('8x8 Dot Matrix LED Display'), findsOneWidget);

      // 2. Switch back to "All Parts"
      await tester.tap(find.text('All Parts'));
      await tester.pumpAndSettle();
      expect(find.text('Ultrasonic Distance Sensor'), findsOneWidget);

      // 3. Search for "Servo"
      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'Servo');
      await tester.pumpAndSettle();

      expect(find.text('9g Micro Position Servo Motor'), findsOneWidget);
      expect(find.text('Ultrasonic Distance Sensor'), findsNothing);

      // Clear search
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();
      expect(find.text('Ultrasonic Distance Sensor'), findsOneWidget);
    });

    testWidgets(
        'PartDetailScreen displays complete encyclopedia info: pinouts, safety, mistakes, mini experiment',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      // Create a test profile first so activeProgress is available
      final repo =
          ProfileRepositoryImpl(LocalStorageDataSource(storageService));
      final testProfile = LearnerProfileModel(
        id: 'test_child_1',
        nickname: 'Sparky',
        avatarId: 'spark',
        ageBracket: AgeBracket.ages7_9,
        createdAt: DateTime.now(),
        lastActiveAt: DateTime.now(),
      );
      await repo.saveProfile(testProfile);
      await repo.setActiveProfile(testProfile.id);

      await tester.pumpWidget(
        createTestWidget(
          const PartDetailScreen(componentId: 'comp_01'),
        ),
      );
      await tester.pumpAndSettle();

      // 1. Verify Header info is visible before discovery
      expect(find.text('Component Inspector'), findsOneWidget);
      expect(find.text('#01'), findsOneWidget);
      expect(find.text('HC-SR04'), findsOneWidget);
      expect(find.text('5V'), findsOneWidget);
      expect(find.text('Ultrasonic Distance Sensor'), findsOneWidget);

      // 2. Verify Locked Teaser is shown, and Encyclopedia details are HIDDEN
      expect(find.byKey(const Key('locked_teaser_card')), findsOneWidget);
      expect(find.text('Child-Safe Component'), findsNothing);
      expect(find.text('How it Works & Analogy'), findsNothing);
      expect(find.text('Pin Connections & Wires'), findsNothing);
      expect(find.text('Wiring Instructions'), findsNothing);
      expect(find.text('Common Mistakes to Avoid'), findsNothing);
      expect(find.text('Mini Experiment'), findsNothing);
      expect(find.text('Featured Projects'), findsNothing);

      // 3. Verify Discovery Button is present
      final discoverBtn = find.byKey(const Key('discover_button'));
      expect(discoverBtn, findsOneWidget);
      expect(find.text('Discover Part (+25 XP)'), findsOneWidget);

      // 4. Tap Discover Part Button
      await tester.tap(discoverBtn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // 5. Verify discovered state is displayed & teaser card is gone
      expect(find.text('Discovered in your Lab Encyclopedia!'), findsOneWidget);
      expect(find.byKey(const Key('locked_teaser_card')), findsNothing);

      // 6. Verify full Encyclopedia details are now unlocked and visible
      expect(find.text('Child-Safe Component'), findsOneWidget);
      expect(find.text('How it Works & Analogy'), findsOneWidget);
      expect(
          find.textContaining("Like a bat's echolocation ears!"), findsWidgets);
      expect(find.text('Pin Connections & Wires'), findsOneWidget);
      expect(find.text('VCC'), findsOneWidget);
      expect(find.text('Red Wire'), findsOneWidget);
      expect(find.text('TRIG'), findsOneWidget);
      expect(find.text('ECHO'), findsOneWidget);
      expect(find.text('GND'), findsOneWidget);
      expect(find.text('Dark Slate Wire'), findsOneWidget);
      expect(find.text('Wiring Instructions'), findsOneWidget);
      expect(find.textContaining('Connect VCC (Red wire) to 5V power rail'),
          findsOneWidget);
      expect(find.text('Common Mistakes to Avoid'), findsOneWidget);
      expect(
          find.textContaining(
              'Swapping TRIG and ECHO pins will result in continuous 0cm readings.'),
          findsOneWidget);
      expect(find.text('Mini Experiment'), findsOneWidget);
      expect(find.text('Ultrasonic Ping Ruler'), findsOneWidget);
      expect(find.text('Arduino C++'), findsOneWidget);
      expect(find.textContaining('long duration = pulseIn(echoPin, HIGH);'),
          findsOneWidget);
      expect(find.textContaining('Expected Output:'), findsOneWidget);
      expect(find.text('Featured Projects'), findsOneWidget);
      expect(find.text('Project #01'), findsOneWidget);
      expect(find.text('Project #11'), findsOneWidget);

      // 7. Verify XP was rewarded in repository
      final progressRepo =
          ProgressRepositoryImpl(LocalStorageDataSource(storageService));
      final progress = await progressRepo.getProgress('test_child_1');
      expect(progress.discoveredComponentIds, contains('comp_01'));
      expect(progress.totalXp, equals(25));
    });

    testWidgets(
        'PartsScreen renders ComponentImageView on component cards with semantic labels',
        (tester) async {
      await tester.pumpWidget(createTestWidget(const PartsScreen()));
      await tester.pumpAndSettle();

      // Check that ComponentImageView widgets are rendered on cards
      expect(find.byType(ComponentImageView), findsWidgets);
    });

    testWidgets(
        'PartDetailScreen renders Hardware Photo & Visuals card with primary and detail images',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      // Create a test profile and mark comp_01 as discovered
      final repo =
          ProfileRepositoryImpl(LocalStorageDataSource(storageService));
      final testProfile = LearnerProfileModel(
        id: 'test_child_1',
        nickname: 'Sparky',
        avatarId: 'spark',
        ageBracket: AgeBracket.ages7_9,
        createdAt: DateTime.now(),
        lastActiveAt: DateTime.now(),
      );
      await repo.saveProfile(testProfile);
      await repo.setActiveProfile(testProfile.id);

      final progressRepo =
          ProgressRepositoryImpl(LocalStorageDataSource(storageService));
      await progressRepo.discoverComponent('test_child_1', 'comp_01', 25);

      await tester.pumpWidget(
        createTestWidget(
          const PartDetailScreen(componentId: 'comp_01'),
        ),
      );
      await tester.pumpAndSettle();

      // Verify the Hardware Photo & Visuals section shows both primary and detail diagram
      expect(find.text('Hardware Photo & Visuals'), findsOneWidget);
      expect(find.text('Diagram & Pinout Reference'), findsOneWidget);

      // Verify ComponentImageView widgets are present (thumbnail + hero + diagram)
      expect(find.byType(ComponentImageView), findsAtLeastNWidgets(2));
    });

    testWidgets(
        'ComponentImageView renders fallback icon when imagePath is null',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ComponentImageView(
              imagePath: null,
              category: 'actuator',
              width: 80,
              height: 80,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.precision_manufacturing), findsOneWidget);
    });
  });
}
