import 'package:flutter/material.dart';
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
        'PartsScreen renders 38 components and allows searching & category filtering',
        (tester) async {
      await tester.pumpWidget(createTestWidget(const PartsScreen()));
      await tester.pumpAndSettle();

      // Verify Header & Discovery Banner
      expect(find.text('Parts Lab'), findsOneWidget);
      expect(find.text('Encyclopedia Discovery'), findsOneWidget);
      expect(find.textContaining('/ 38'), findsOneWidget);

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

      // 1. Verify Header info
      expect(find.text('Component Inspector'), findsOneWidget);
      expect(find.text('#01'), findsOneWidget);
      expect(find.text('HC-SR04'), findsOneWidget);
      expect(find.text('5V'), findsOneWidget);
      expect(find.text('Ultrasonic Distance Sensor'), findsOneWidget);

      // 2. Verify Safety Card
      expect(find.text('Child-Safe Component'), findsOneWidget);

      // 3. Verify Description & Real-World Analogy
      expect(find.text('How it Works & Analogy'), findsOneWidget);
      expect(
          find.textContaining("Like a bat's echolocation ears!"), findsWidgets);

      // 4. Verify Pinout Table with wire standards
      expect(find.text('Pin Connections & Wires'), findsOneWidget);
      expect(find.text('VCC'), findsOneWidget);
      expect(find.text('Red Wire'), findsOneWidget);
      expect(find.text('TRIG'), findsOneWidget);
      expect(find.text('ECHO'), findsOneWidget);
      expect(find.text('GND'), findsOneWidget);
      expect(find.text('Dark Slate Wire'), findsOneWidget);

      // 5. Verify Wiring Instructions
      expect(find.text('Wiring Instructions'), findsOneWidget);
      expect(find.textContaining('Connect VCC (Red wire) to 5V power rail'),
          findsOneWidget);

      // 6. Verify Common Mistakes
      expect(find.text('Common Mistakes to Avoid'), findsOneWidget);
      expect(
          find.textContaining(
              'Swapping TRIG and ECHO pins will result in continuous 0cm readings.'),
          findsOneWidget);

      // 7. Verify Mini Experiment Card
      expect(find.text('Mini Experiment'), findsOneWidget);
      expect(find.text('Ultrasonic Ping Ruler'), findsOneWidget);
      expect(find.text('Arduino C++'), findsOneWidget);
      expect(find.textContaining('long duration = pulseIn(echoPin, HIGH);'),
          findsOneWidget);
      expect(find.textContaining('Expected Output:'), findsOneWidget);

      // 8. Verify Featured Projects
      expect(find.text('Featured Projects'), findsOneWidget);
      expect(find.text('Project #01'), findsOneWidget);
      expect(find.text('Project #11'), findsOneWidget);

      // 9. Verify Discovery Flow
      final discoverBtn = find.byKey(const Key('discover_button'));
      expect(discoverBtn, findsOneWidget);
      expect(find.text('Discover Part (+25 XP)'), findsOneWidget);

      // Tap discover button
      await tester.tap(discoverBtn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Verify discovered state is displayed
      expect(find.text('Discovered in your Lab Encyclopedia!'), findsOneWidget);

      // Verify XP was rewarded in repository
      final progressRepo =
          ProgressRepositoryImpl(LocalStorageDataSource(storageService));
      final progress = await progressRepo.getProgress('test_child_1');
      expect(progress.discoveredComponentIds, contains('comp_01'));
      expect(progress.totalXp, equals(25));
    });
  });
}
