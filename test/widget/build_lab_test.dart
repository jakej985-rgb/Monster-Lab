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
import 'package:monster_lab/domain/models/lesson_model.dart';
import 'package:monster_lab/domain/models/project_model.dart';
import 'package:monster_lab/presentation/features/build/build_detail_screen.dart';
import 'package:monster_lab/presentation/features/build/build_screen.dart';
import 'package:monster_lab/presentation/shared/providers.dart';

void main() {
  group('Phase 09: Build Lab & Project Engine Tests', () {
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
        'BuildScreen renders projects list, tier filters, and prerequisite badges',
        (tester) async {
      await tester.pumpWidget(createTestWidget(const BuildScreen()));
      await tester.pumpAndSettle();

      // Verify Header
      expect(find.text('Build Lab'), findsOneWidget);

      // Verify Tier Filter Chips
      expect(find.text('All Tiers'), findsOneWidget);
      expect(find.text('Rookie'), findsOneWidget);
      expect(find.text('Builder'), findsOneWidget);
      expect(find.text('Engineer'), findsOneWidget);
      expect(find.text('Monster Master'), findsOneWidget);

      // Verify initial projects in list (proj_01 is Rookie)
      expect(find.text('Intruder Alarm MONSTER'), findsOneWidget);

      // Filter by Builder tier
      await tester.tap(find.text('Builder'));
      await tester.pumpAndSettle();

      expect(find.text('Intruder Alarm MONSTER'), findsNothing);
      expect(find.text('Remote Control Funny Faces'), findsOneWidget);
      expect(find.text('Smart MONSTER Door'), findsOneWidget);

      // Filter by Monster Master tier
      await tester.tap(find.text('Monster Master'));
      await tester.pumpAndSettle();

      expect(find.text('Remote Control Funny Faces'), findsNothing);
      expect(find.text('MONSTER Autopilot'), findsOneWidget);
      expect(find.text('NRF24L01 Wireless MONSTER'), findsOneWidget);

      // Switch back to All Tiers
      await tester.tap(find.text('All Tiers'));
      await tester.pumpAndSettle();
      expect(find.text('Intruder Alarm MONSTER'), findsOneWidget);
    });

    testWidgets(
        'BuildScreen shows an error with retry when projects fail to load',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            storageServiceProvider.overrideWithValue(storageService),
            curriculumRepositoryProvider
                .overrideWithValue(_FailingBuildRepository(engine)),
          ],
          child: const MaterialApp(home: BuildScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Could not load Build Lab'), findsOneWidget);
      expect(find.text('Try Again'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);

      await tester.tap(find.text('Try Again'));
      await tester.pumpAndSettle();
      expect(find.text('Could not load Build Lab'), findsOneWidget);
    });

    testWidgets(
        'BuildDetailScreen shows an error with retry when a project fails to load',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            storageServiceProvider.overrideWithValue(storageService),
            curriculumRepositoryProvider
                .overrideWithValue(_FailingBuildRepository(engine)),
          ],
          child: const MaterialApp(
            home: BuildDetailScreen(projectId: 'proj_01'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Could not load project'), findsOneWidget);
      expect(find.text('Try Again'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('BuildScreen shows locked dialog when tapping locked project',
        (tester) async {
      await tester.pumpWidget(createTestWidget(const BuildScreen()));
      await tester.pumpAndSettle();

      // With no completed lessons, proj_01 (requires lesson_05) is locked
      expect(find.text('LOCKED'), findsWidgets);

      // Tap on Intruder Alarm MONSTER card
      await tester.tap(find.text('Intruder Alarm MONSTER'));
      await tester.pumpAndSettle();

      // Dialog opens explaining prerequisite lessons
      expect(find.text('Project Locked'), findsOneWidget);
      expect(find.textContaining('lesson_05'), findsOneWidget);
      expect(find.text('Go to Lessons'), findsOneWidget);

      // Close dialog
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      expect(find.text('Project Locked'), findsNothing);
    });

    testWidgets(
        'BuildDetailScreen shows locked barrier when prerequisites are missing',
        (tester) async {
      await tester.pumpWidget(
          createTestWidget(const BuildDetailScreen(projectId: 'proj_01')));
      await tester.pumpAndSettle();

      // Prerequisite barrier view
      expect(find.text('Intruder Alarm MONSTER is Locked'), findsOneWidget);
      expect(find.text('Explore Foundational Lessons'), findsOneWidget);
    });

    testWidgets(
        'BuildDetailScreen guided 6-phase build flow, diagnostics, and completion',
        (tester) async {
      // 1. Prepare profile that has completed prerequisite lesson_05
      final localSource = LocalStorageDataSource(storageService);
      final profileRepo = ProfileRepositoryImpl(localSource);
      final progressRepo = ProgressRepositoryImpl(localSource);

      final profile = LearnerProfileModel(
        id: 'test_builder',
        nickname: 'Sparky',
        avatarId: 'monster_bolt',
        ageBracket: AgeBracket.ages10_12,
        createdAt: DateTime.now(),
        lastActiveAt: DateTime.now(),
      );
      await profileRepo.saveProfile(profile);
      await profileRepo.setActiveProfile(profile.id);
      await progressRepo.completeLesson(profile.id, 'lesson_05', 50);

      await tester.pumpWidget(createTestWidget(
        const BuildDetailScreen(projectId: 'proj_01'),
      ));
      await tester.pumpAndSettle();

      // Phase 1: Gather Parts
      expect(find.text('Step 1 of 6'), findsOneWidget);
      expect(find.text('REQUIRED LAB COMPONENTS'), findsOneWidget);
      expect(find.text('TOOL & HARDWARE CHECKPOINTS'), findsOneWidget);
      expect(find.text('Arduino Uno and USB-B cable ready'), findsOneWidget);

      // Check a checkpoint
      await tester.tap(find.text('Arduino Uno and USB-B cable ready'));
      await tester.pumpAndSettle();

      // Test diagnostics sheet
      await tester.tap(find.byIcon(Icons.build_circle_outlined));
      await tester.pumpAndSettle();
      expect(find.text('Troubleshooting & Diagnostics'), findsOneWidget);
      expect(find.textContaining('Distance always reads 0 or 3000 cm'),
          findsOneWidget);
      // Close sheet
      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();

      // Advance to Phase 2: Breadboard Wiring
      await tester.tap(find.text('Next Phase'));
      await tester.pumpAndSettle();

      expect(find.text('Step 2 of 6'), findsOneWidget);
      expect(find.text('Breadboard Wiring'), findsOneWidget);
      expect(find.text('WIRE CONNECTION MATRIX'), findsOneWidget);
      expect(find.text('Red'), findsWidgets);
      expect(find.text('Dark Slate'), findsWidgets);
      expect(find.text('HC-SR04 VCC'), findsOneWidget);
      expect(find.text('Arduino 5V'), findsOneWidget);

      // Advance to Phase 3: Wiring Check (Pre-flight safety)
      await tester.tap(find.text('Next Phase'));
      await tester.pumpAndSettle();

      expect(find.text('Step 3 of 6'), findsOneWidget);
      expect(find.text('Wiring Pre-Flight Check'), findsOneWidget);
      expect(find.text('PRE-FLIGHT SAFETY INSPECTION'), findsOneWidget);
      expect(find.text('SAFETY VERIFICATION CHECKPOINTS'), findsOneWidget);
      expect(find.text('Unplug USB cable during physical inspection'),
          findsOneWidget);

      // Advance to Phase 4: Code Walkthrough
      await tester.tap(find.text('Next Phase'));
      await tester.pumpAndSettle();

      expect(find.text('Step 4 of 6'), findsOneWidget);
      expect(find.text('Code Walkthrough & Logic'), findsOneWidget);
      expect(find.text('ARDUINO SOURCE CODE'), findsOneWidget);
      expect(find.text('Copy Code'), findsOneWidget);
      expect(find.text('PEDAGOGICAL LOGIC BREAKDOWN'), findsOneWidget);

      // Advance to Phase 5: Physical Test
      await tester.tap(find.text('Next Phase'));
      await tester.pumpAndSettle();

      expect(find.text('Step 5 of 6'), findsOneWidget);
      expect(find.text('Upload & Physical Radar Test'), findsOneWidget);
      expect(find.text('PHYSICAL VERIFICATION CHECKPOINTS'), findsOneWidget);

      // Advance to Phase 6: Mission Complete
      await tester.tap(find.text('Next Phase'));
      await tester.pumpAndSettle();

      expect(find.text('Step 6 of 6'), findsOneWidget);
      expect(find.text('Mission Complete & Reflection'), findsOneWidget);
      expect(find.text('BUILD READY FOR COMPLETION!'), findsOneWidget);
      expect(find.text('PROJECT VARIANTS & SWAPS'), findsOneWidget);
      expect(find.text('Dual Piezo Stereo Siren'), findsOneWidget);
      expect(find.text('ENGINEERING MISSIONS'), findsOneWidget);
      expect(find.text('Stealth Silent Alarm'), findsOneWidget);
      expect(find.text('Complete Build (+100 XP)'), findsOneWidget);

      // Test opening Variants & Missions sheet from AppBar
      await tester.tap(find.byTooltip('Project Variants & Missions'));
      await tester.pumpAndSettle();
      expect(find.text('Variants & Missions'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();

      // Complete build!
      await tester.tap(find.text('Complete Build (+100 XP)'));
      await tester.pumpAndSettle();

      // Verification dialog appears
      expect(find.text('Mission Complete!'), findsOneWidget);
      expect(find.text('+100 XP Awarded'), findsOneWidget);
      expect(find.text('Back to Build Lab'), findsOneWidget);

      // Close celebration dialog
      await tester.tap(find.text('Back to Build Lab'));
      await tester.pumpAndSettle();

      // Verify progress was recorded in repository
      final progress = await progressRepo.getProgress(profile.id);
      expect(progress.completedProjectIds.contains('proj_01'), isTrue);
      expect(progress.totalXp, 150); // 50 from lesson + 100 from project
      expect(progress.earnedBadgeIds.contains('badge_security_rookie'), isTrue);
    });
  });
}

class _FailingBuildRepository extends CurriculumRepositoryImpl {
  _FailingBuildRepository(super.engine);

  @override
  Future<List<ProjectModel>> getProjects({DifficultyTier? tier}) async {
    throw Exception('simulated project list failure');
  }

  @override
  Future<ProjectModel> getProjectById(String id) async {
    throw Exception('simulated project load failure');
  }
}
