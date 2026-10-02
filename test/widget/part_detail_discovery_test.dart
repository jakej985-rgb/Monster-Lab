import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monster_lab/core/services/storage_service.dart';
import 'package:monster_lab/data/datasources/asset_curriculum_datasource.dart';
import 'package:monster_lab/data/datasources/curriculum_data_engine.dart';
import 'package:monster_lab/data/datasources/local_storage_datasource.dart';
import 'package:monster_lab/data/repositories/curriculum_repository_impl.dart';
import 'package:monster_lab/data/repositories/profile_repository_impl.dart';
import 'package:monster_lab/data/repositories/progress_repository_impl.dart';
import 'package:monster_lab/domain/models/learner_profile_model.dart';
import 'package:monster_lab/presentation/features/parts/part_detail_screen.dart';
import 'package:monster_lab/presentation/shared/providers.dart';

void main() {
  group('Parts Lab Progressive Discovery Tests', () {
    late StorageService storageService;
    late CurriculumDataEngine engine;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      storageService = await StorageService.init();
      engine =
          CurriculumDataEngine(fallbackDataSource: AssetCurriculumDataSource());
      await engine.initialize();
    });

    Widget createTestWidget(Widget child) {
      return ProviderScope(
        overrides: [
          storageServiceProvider.overrideWithValue(storageService),
          curriculumRepositoryProvider
              .overrideWithValue(CurriculumRepositoryImpl(engine)),
        ],
        child: MaterialApp(
          home: child,
        ),
      );
    }

    testWidgets(
        'Undiscovered part hides pinout and details, shows teaser card and Discover button',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final profileRepo =
          ProfileRepositoryImpl(LocalStorageDataSource(storageService));
      final testProfile = LearnerProfileModel(
        id: 'child_undiscovered',
        nickname: 'Volt',
        avatarId: 'monster_bolt',
        ageBracket: AgeBracket.ages10_12,
        createdAt: DateTime.now(),
        lastActiveAt: DateTime.now(),
      );
      await profileRepo.saveProfile(testProfile);
      await profileRepo.setActiveProfile(testProfile.id);

      await tester.pumpWidget(
        createTestWidget(
          const PartDetailScreen(componentId: 'comp_uno'),
        ),
      );
      await tester.pumpAndSettle();

      // Top Header is visible
      expect(find.text('Component Inspector'), findsOneWidget);
      expect(find.text('Arduino Uno R3'), findsOneWidget);
      expect(find.text('5V'), findsOneWidget);

      // Discover button and Locked Teaser Card are visible
      expect(find.byKey(const Key('discover_button')), findsOneWidget);
      expect(find.text('Discover Part (+25 XP)'), findsOneWidget);
      expect(find.byKey(const Key('locked_teaser_card')), findsOneWidget);
      expect(find.text('Component Locked in Lab Kit'), findsOneWidget);

      // Deep Encyclopedia specifications are HIDDEN
      expect(find.text('Pin Connections & Wires'), findsNothing);
      expect(find.text('How it Works & Analogy'), findsNothing);
      expect(find.text('Common Mistakes to Avoid'), findsNothing);
      expect(find.text('Mini Experiment'), findsNothing);
      expect(find.text('Featured Projects'), findsNothing);
    });

    testWidgets(
        'Tapping Discover awards +25 XP, discovers part, and unlocks full pinouts and specs',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final profileRepo =
          ProfileRepositoryImpl(LocalStorageDataSource(storageService));
      final testProfile = LearnerProfileModel(
        id: 'child_discoverer',
        nickname: 'Sparky',
        avatarId: 'monster_spark',
        ageBracket: AgeBracket.ages10_12,
        createdAt: DateTime.now(),
        lastActiveAt: DateTime.now(),
      );
      await profileRepo.saveProfile(testProfile);
      await profileRepo.setActiveProfile(testProfile.id);

      await tester.pumpWidget(
        createTestWidget(
          const PartDetailScreen(componentId: 'comp_01'),
        ),
      );
      await tester.pumpAndSettle();

      // Discover button is initially visible
      final discoverBtn = find.byKey(const Key('discover_button'));
      expect(discoverBtn, findsOneWidget);

      // Tap discover button
      await tester.tap(discoverBtn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Discovered badge appears
      expect(find.text('Discovered in your Lab Encyclopedia!'), findsOneWidget);
      expect(find.byKey(const Key('locked_teaser_card')), findsNothing);

      // Specs and pinouts are revealed
      expect(find.text('Pin Connections & Wires'), findsOneWidget);
      expect(find.text('Child-Safe Component'), findsOneWidget);
      expect(find.text('Mini Experiment'), findsOneWidget);

      // XP is awarded
      final progressRepo =
          ProgressRepositoryImpl(LocalStorageDataSource(storageService));
      final progress = await progressRepo.getProgress('child_discoverer');
      expect(progress.discoveredComponentIds, contains('comp_01'));
      expect(progress.totalXp, equals(25));
    });

    testWidgets(
        'Already discovered part directly shows full encyclopedia and badge without teaser',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final profileRepo =
          ProfileRepositoryImpl(LocalStorageDataSource(storageService));
      final testProfile = LearnerProfileModel(
        id: 'child_veteran',
        nickname: 'Ada',
        avatarId: 'monster_tinker',
        ageBracket: AgeBracket.ages10_12,
        createdAt: DateTime.now(),
        lastActiveAt: DateTime.now(),
      );
      await profileRepo.saveProfile(testProfile);
      await profileRepo.setActiveProfile(testProfile.id);

      final progressRepo =
          ProgressRepositoryImpl(LocalStorageDataSource(storageService));
      await progressRepo.discoverComponent('child_veteran', 'comp_nano', 25);

      await tester.pumpWidget(
        createTestWidget(
          const PartDetailScreen(componentId: 'comp_nano'),
        ),
      );
      await tester.pumpAndSettle();

      // Discovered badge is directly shown
      expect(find.text('Discovered in your Lab Encyclopedia!'), findsOneWidget);
      expect(find.byKey(const Key('discover_button')), findsNothing);
      expect(find.byKey(const Key('locked_teaser_card')), findsNothing);

      // Full details are directly shown
      expect(find.text('Arduino Nano V3'), findsOneWidget);
      expect(find.text('Hardware Photo & Visuals'), findsOneWidget);
      expect(find.text('Pin Connections & Wires'), findsOneWidget);
      expect(find.text('Child-Safe Component'), findsOneWidget);
    });

    testWidgets(
        'Rapid tapping of Discover button is debounced and awards XP exactly once',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final profileRepo =
          ProfileRepositoryImpl(LocalStorageDataSource(storageService));
      final testProfile = LearnerProfileModel(
        id: 'child_rapid_tap',
        nickname: 'Rapid',
        avatarId: 'monster_bolt',
        ageBracket: AgeBracket.ages10_12,
        createdAt: DateTime.now(),
        lastActiveAt: DateTime.now(),
      );
      await profileRepo.saveProfile(testProfile);
      await profileRepo.setActiveProfile(testProfile.id);

      await tester.pumpWidget(
        createTestWidget(
          const PartDetailScreen(componentId: 'comp_mega'),
        ),
      );
      await tester.pumpAndSettle();

      final discoverBtn = find.byKey(const Key('discover_button'));
      expect(discoverBtn, findsOneWidget);

      // Verify the discover button is positioned below the photo card
      final photoFinder = find.text('Hardware Photo & Visuals');
      expect(photoFinder, findsOneWidget);
      expect(tester.getTopLeft(discoverBtn).dy,
          greaterThan(tester.getTopLeft(photoFinder).dy));

      // Rapidly tap the button multiple times
      await tester.tap(discoverBtn);
      await tester.tap(discoverBtn, warnIfMissed: false);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();

      // Ensure component is discovered
      expect(find.text('Discovered in your Lab Encyclopedia!'), findsOneWidget);

      // Verify XP awarded exactly once (+25)
      final progressRepo =
          ProgressRepositoryImpl(LocalStorageDataSource(storageService));
      final progress = await progressRepo.getProgress('child_rapid_tap');
      expect(progress.discoveredComponentIds, contains('comp_mega'));
      expect(progress.totalXp, equals(25));
    });
  });
}
