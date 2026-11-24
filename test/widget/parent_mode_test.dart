import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monster_lab/core/services/parent_data_service.dart';
import 'package:monster_lab/core/services/parent_session_service.dart';
import 'package:monster_lab/core/services/storage_service.dart';
import 'package:monster_lab/data/datasources/asset_curriculum_datasource.dart';
import 'package:monster_lab/data/datasources/curriculum_data_engine.dart';
import 'package:monster_lab/data/datasources/local_storage_datasource.dart';
import 'package:monster_lab/data/repositories/curriculum_repository_impl.dart';
import 'package:monster_lab/data/repositories/profile_repository_impl.dart';
import 'package:monster_lab/data/repositories/progress_repository_impl.dart';
import 'package:monster_lab/domain/models/learner_profile_model.dart';
import 'package:monster_lab/domain/models/learner_progress_model.dart';
import 'package:monster_lab/domain/models/parent_insights_model.dart';
import 'package:monster_lab/presentation/features/parent/parent_gate_dialog.dart';
import 'package:monster_lab/presentation/features/parent/parent_screen.dart';
import 'package:monster_lab/presentation/features/profile/profile_select_screen.dart';
import 'package:monster_lab/presentation/shared/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Phase 12: Parent Mode & Insights Dashboard Tests', () {
    late StorageService storageService;
    late CurriculumDataEngine engine;
    late ProfileRepositoryImpl profileRepo;
    late ProgressRepositoryImpl progressRepo;

    final testProfile1 = LearnerProfileModel(
      id: 'learner_sparky',
      nickname: 'Sparky',
      avatarId: 'avatar_robot',
      ageBracket: AgeBracket.ages10_12,
      createdAt: DateTime.parse('2026-09-01T10:00:00Z'),
      lastActiveAt: DateTime.parse('2026-09-28T15:30:00Z'),
    );

    final testProfile2 = LearnerProfileModel(
      id: 'learner_bolt',
      nickname: 'Bolt',
      avatarId: 'avatar_dino',
      ageBracket: AgeBracket.ages7_9,
      createdAt: DateTime.parse('2026-09-02T11:00:00Z'),
      lastActiveAt: DateTime.parse('2026-09-28T16:00:00Z'),
    );

    final testProgress1 = LearnerProgressModel(
      learnerId: 'learner_sparky',
      totalXp: 850,
      completedLessonIds: {
        'lesson_01',
        'lesson_02',
        'lesson_03',
        'lesson_04',
        'lesson_05',
        'lesson_06'
      },
      completedProjectIds: {'proj_01', 'proj_04'},
      discoveredComponentIds: {'comp_01', 'comp_02', 'comp_03', 'comp_20'},
      solvedChallengeIds: {'chal_01', 'chal_09', 'chal_02'},
      lastActivity: LastActivityInfo(
        type: ActivityType.project,
        activityId: 'proj_01',
        title: 'Project 1: Intruder Alarm MONSTER',
        timestamp: DateTime.parse('2026-09-28T15:25:00Z'),
      ),
      lastSessionDate: DateTime.parse('2026-09-28T15:30:00Z'),
    );

    final testProgress2 = LearnerProgressModel(
      learnerId: 'learner_bolt',
      totalXp: 50,
      completedLessonIds: {'lesson_01'},
      lastSessionDate: DateTime.parse('2026-09-28T16:00:00Z'),
    );

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      storageService = await StorageService.init();
      appParentSessionService.authenticate(
        duration: const Duration(minutes: 15),
      );
      engine =
          CurriculumDataEngine(fallbackDataSource: AssetCurriculumDataSource());
      await engine.initialize();

      final localDataSource = LocalStorageDataSource(storageService);
      profileRepo = ProfileRepositoryImpl(localDataSource);
      progressRepo = ProgressRepositoryImpl(localDataSource);

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        SystemChannels.platform,
        (MethodCall methodCall) async => null,
      );

      // Save profiles and progress
      await profileRepo.saveProfile(testProfile1);
      await profileRepo.saveProfile(testProfile2);
      await profileRepo.setActiveProfile(testProfile1.id);
      await progressRepo.saveProgress(testProgress1);
      await progressRepo.saveProgress(testProgress2);
    });

    Widget createTestWidget(Widget child) {
      return ProviderScope(
        overrides: [
          storageServiceProvider.overrideWithValue(storageService),
          curriculumRepositoryProvider
              .overrideWithValue(CurriculumRepositoryImpl(engine)),
          profileRepositoryProvider.overrideWithValue(profileRepo),
          progressRepositoryProvider.overrideWithValue(progressRepo),
        ],
        child: MaterialApp(
          home: child,
        ),
      );
    }

    test(
        'ParentCompetencyAnalyzer accurately analyzes competencies and quick takes',
        () {
      final competencies =
          ParentCompetencyAnalyzer.analyzeCompetencies(testProgress1);
      expect(competencies.length, 6);

      // Basic Circuitry: has lesson_01, lesson_05, proj_01, chal_01, chal_09 => 5/5 = 1.0 (Mastered)
      final circuits = competencies.firstWhere((c) => c.id == 'comp_circuits');
      expect(circuits.status, CompetencyStatus.mastered);
      expect(circuits.progressRatio, 1.0);

      // Analog: lesson_06, comp_20, chal_02 are present => 3/4 = 0.75 (Mastered)
      final analog = competencies.firstWhere((c) => c.id == 'comp_analog');
      expect(analog.status, CompetencyStatus.mastered);

      // State Machines: proj_04 is present => 1/3 (In Progress)
      final logic = competencies.firstWhere((c) => c.id == 'comp_logic');
      expect(logic.status, CompetencyStatus.inProgress);

      final quickTake = ParentCompetencyAnalyzer.generateQuickTake(
          testProfile1, testProgress1);
      expect(quickTake.contains('Sparky'), isTrue);
      expect(quickTake.contains('real physical monsters'), isTrue);
    });

    test('ParentDataService exports valid JSON and restores correctly', () {
      final jsonStr =
          ParentDataService.exportBackupJson(testProfile1, testProgress1);
      expect(jsonStr.contains('MonsterLab'), isTrue);
      expect(jsonStr.contains('learner_sparky'), isTrue);

      final restored = ParentDataService.importBackupJson(jsonStr);
      expect(restored.profile.id, 'learner_sparky');
      expect(restored.profile.nickname, 'Sparky');
      expect(restored.progress.totalXp, 850);
      expect(restored.progress.completedProjectIds.contains('proj_01'), isTrue);

      // Invalid JSON throws FormatException
      expect(
          () => ParentDataService.importBackupJson(''), throwsFormatException);
      expect(() => ParentDataService.importBackupJson('{"app":"OtherApp"}'),
          throwsFormatException);
      expect(
          () => ParentDataService.importBackupJson(
              '{"app":"MonsterLab","version":999}'),
          throwsFormatException);
    });

    testWidgets('ParentGateDialog enforces arithmetic verification challenge',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const ParentGateDialog(fixedA: 7, fixedB: 8),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Parental Verification'), findsOneWidget);
      expect(find.text('Grown-Ups Only'), findsOneWidget);
      expect(find.textContaining('7 × 8 = ?'), findsOneWidget);

      // Enter wrong answer (50)
      await tester.enterText(find.byType(TextField), '50');
      await tester.tap(find.text('Verify & Enter'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Incorrect answer. Please calculate 7 × 8.'),
          findsOneWidget);

      // Enter correct answer (56)
      await tester.enterText(find.byType(TextField), '56');
      await tester.tap(find.text('Verify & Enter'));
      await tester.pump();
      // Cancel the shared 15-minute session timer before the fake clock teardown.
      appParentSessionService.revokeSession();
      // Should attempt navigation without error
    });

    testWidgets('Profile deletion requires parent verification',
        (tester) async {
      await tester.pumpWidget(createTestWidget(const ProfileSelectScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Delete Profile').first);
      await tester.pumpAndSettle();

      expect(find.text('Grown-Ups Only'), findsOneWidget);
      expect(find.textContaining('please solve'), findsOneWidget);

      await tester.ensureVisible(find.text('Cancel'));
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Grown-Ups Only'), findsNothing);
      final profiles = await profileRepo.getAllProfiles();
      expect(profiles.any((p) => p.id == testProfile1.id), isTrue);
    });

    testWidgets(
        'ParentScreen renders executive summary, quick-take, competencies, and safety switches',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestWidget(const ParentScreen()));
      await tester.pumpAndSettle();

      // Title & Active profile
      expect(find.text('Parent Dashboard & Insights'), findsOneWidget);
      expect(find.text('Sparky'), findsOneWidget);
      expect(find.textContaining('850 Total XP'), findsOneWidget);

      // 4 Metric Counters, with denominators from the curriculum repository
      expect(find.text('72/141'),
          findsOneWidget); // Lessons (6 legacy + 66 migrated sub-lessons)
      expect(find.text('2/20'), findsOneWidget); // Projects
      expect(find.text('4/54'), findsOneWidget); // Parts
      expect(find.text('3/24'), findsOneWidget); // Challenges

      // Quick-Take & Growth Focus
      expect(
          find.text('Pedagogical Quick-Take (60-Sec Digest)'), findsOneWidget);
      expect(find.textContaining('Sparky is actively engineering'),
          findsOneWidget);
      expect(find.textContaining('Recommended Growth Focus:'), findsOneWidget);

      // Competencies
      expect(find.text('Basic Circuitry & Closed Loops'), findsOneWidget);
      expect(find.text('Analog Signals & Voltage Dividers'), findsOneWidget);
      expect(find.text('PWM & Color Synthesis'), findsOneWidget);
      expect(find.text('Digital Bus Protocols (I2C & SPI)'), findsOneWidget);
      expect(find.text('State Machines & Automation Logic'), findsOneWidget);
      expect(find.text('Systematic Hardware Debugging'), findsOneWidget);

      // Recent Activity
      expect(find.text('Recent Activity Timeline'), findsOneWidget);
      expect(find.text('Project 1: Intruder Alarm MONSTER'), findsOneWidget);

      // Safety switches
      final laserSwitch = find.byKey(const Key('laser_interlock_switch'));
      expect(laserSwitch, findsOneWidget);
      await tester.tap(laserSwitch);
      await tester.pumpAndSettle();

      final gasSwitch = find.byKey(const Key('gas_interlock_switch'));
      expect(gasSwitch, findsOneWidget);
      await tester.tap(gasSwitch);
      await tester.pumpAndSettle();

      final relaySwitch = find.byKey(const Key('relay_interlock_switch'));
      expect(relaySwitch, findsOneWidget);
      await tester.tap(relaySwitch);
      await tester.pumpAndSettle();

      // Data Controls Buttons
      expect(find.byKey(const Key('export_backup_button')), findsOneWidget);
      expect(find.byKey(const Key('import_backup_button')), findsOneWidget);
      expect(find.byKey(const Key('reset_progress_button')), findsOneWidget);
    });

    testWidgets('ParentScreen export backup displays modal with JSON',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestWidget(const ParentScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('export_backup_button')));
      await tester.pumpAndSettle();

      expect(find.text('Export Backup JSON'), findsOneWidget);
      expect(find.byKey(const Key('export_json_preview')), findsOneWidget);
      expect(find.byKey(const Key('copy_backup_json_button')), findsOneWidget);

      // Tap copy to clipboard
      await tester.tap(find.byKey(const Key('copy_backup_json_button')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Backup JSON copied to clipboard.'), findsOneWidget);
    });

    testWidgets(
        'ParentScreen import backup validates and restores learner data',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestWidget(const ParentScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('import_backup_button')));
      await tester.pumpAndSettle();

      expect(find.text('Import Progress Backup'), findsOneWidget);

      // Invalid input test
      await tester.enterText(
          find.byKey(const Key('import_json_input')), 'not valid json');
      await tester.tap(find.byKey(const Key('confirm_restore_backup_button')));
      await tester.pumpAndSettle();

      expect(find.textContaining('Invalid backup:'), findsOneWidget);

      // Valid input test with new profile and progress
      final importedProfile = LearnerProfileModel(
        id: 'learner_restore',
        nickname: 'RestoredKid',
        avatarId: 'avatar_star',
        ageBracket: AgeBracket.ages13Plus,
        createdAt: DateTime.parse('2026-09-10T10:00:00Z'),
        lastActiveAt: DateTime.parse('2026-09-28T18:00:00Z'),
      );
      final importedProgress = LearnerProgressModel(
        learnerId: 'learner_restore',
        totalXp: 1200,
        completedLessonIds: {'lesson_01', 'lesson_02'},
        lastSessionDate: DateTime.parse('2026-09-28T18:00:00Z'),
      );
      final validJson =
          ParentDataService.exportBackupJson(importedProfile, importedProgress);

      await tester.enterText(
          find.byKey(const Key('import_json_input')), validJson);
      await tester.tap(find.byKey(const Key('confirm_restore_backup_button')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(
          find.textContaining('Backup successfully restored for RestoredKid!'),
          findsOneWidget);
    });

    testWidgets(
        'ParentScreen reset progress confirms and clears learner progress',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestWidget(const ParentScreen()));
      await tester.pumpAndSettle();

      expect(find.textContaining('850 Total XP'), findsOneWidget);

      await tester.tap(find.byKey(const Key('reset_progress_button')));
      await tester.pumpAndSettle();

      expect(find.text('Reset All Progress?'), findsOneWidget);
      expect(
          find.textContaining('This will permanently clear completed lessons'),
          findsOneWidget);

      // Confirm reset
      await tester.tap(find.byKey(const Key('confirm_reset_progress_button')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(
          find.text('All progress for Sparky has been reset.'), findsOneWidget);

      // Progress should now be 0 XP
      expect(find.textContaining('0 Total XP'), findsOneWidget);
    });
  });
}
