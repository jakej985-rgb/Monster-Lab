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
import 'package:monster_lab/domain/models/learner_profile_model.dart';
import 'package:monster_lab/presentation/features/learn/lesson_detail_screen.dart';
import 'package:monster_lab/presentation/shared/providers.dart';

void main() {
  group('Learn Lab Lesson Completion Flow Tests', () {
    late StorageService storageService;
    late CurriculumDataEngine engine;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      storageService = await StorageService.init();
      engine =
          CurriculumDataEngine(fallbackDataSource: AssetCurriculumDataSource());
      await engine.initialize();
    });

    Widget createTestWidget(
        {required Widget child, List<Override> extraOverrides = const []}) {
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
        'Shows error SnackBar when completing lesson without an active profile',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const LessonDetailScreen(lessonId: 'lesson_01'),
        ),
      );
      await tester.pumpAndSettle();

      // Advance through all steps
      while (find.text('Next Step').evaluate().isNotEmpty) {
        await tester.ensureVisible(find.text('Next Step'));
        await tester.tap(find.text('Next Step'));
        await tester.pumpAndSettle();
      }

      // Step N -> Complete Lesson
      final completeButton = find.text('Complete Lesson (+50 XP)');
      await tester.ensureVisible(completeButton);
      expect(completeButton, findsOneWidget);
      await tester.tap(completeButton);
      await tester.pumpAndSettle();

      // Verify SnackBar
      expect(
          find.text(
              'Please select an active learner profile to record progress.'),
          findsOneWidget);
      // Dialog should NOT be shown
      expect(find.text('Mission Complete!'), findsNothing);
    });

    testWidgets(
        'First completion awards XP and displays "+50 XP EARNED" in dialog',
        (tester) async {
      final localDataSource = LocalStorageDataSource(storageService);
      final profileRepo = ProfileRepositoryImpl(localDataSource);
      final testProfile = LearnerProfileModel(
        id: 'learner_test_1',
        nickname: 'Sparky',
        ageBracket: AgeBracket.ages7_9,
        avatarId: 'avatar_1',
        createdAt: DateTime.now(),
        lastActiveAt: DateTime.now(),
      );
      await profileRepo.saveProfile(testProfile);
      await profileRepo.setActiveProfile(testProfile.id);

      await tester.pumpWidget(
        createTestWidget(
          child: const LessonDetailScreen(lessonId: 'lesson_01'),
        ),
      );
      await tester.pumpAndSettle();

      // Advance through steps
      while (find.text('Next Step').evaluate().isNotEmpty) {
        await tester.ensureVisible(find.text('Next Step'));
        await tester.tap(find.text('Next Step'));
        await tester.pumpAndSettle();
      }

      // Complete Lesson
      final completeButton = find.text('Complete Lesson (+50 XP)');
      await tester.ensureVisible(completeButton);
      await tester.tap(completeButton);
      await tester.pumpAndSettle();

      // Verify Dialog with XP earned
      expect(find.text('Mission Complete!'), findsOneWidget);
      expect(find.text('+50 XP EARNED'), findsOneWidget);

      // Dismiss dialog
      await tester.tap(find.text('Back to Learn Lab'));
      await tester.pumpAndSettle();

      // Verify progress persisted in storage
      final progress = localDataSource.getProgress('learner_test_1');
      expect(progress.totalXp, equals(50));
      expect(progress.completedLessonIds, contains('lesson_01'));
    });

    testWidgets(
        'Replay shows "LESSON COMPLETED (XP already earned)" and does not duplicate XP',
        (tester) async {
      final localDataSource = LocalStorageDataSource(storageService);
      final profileRepo = ProfileRepositoryImpl(localDataSource);
      final testProfile = LearnerProfileModel(
        id: 'learner_test_2',
        nickname: 'Sparky',
        ageBracket: AgeBracket.ages7_9,
        avatarId: 'avatar_1',
        createdAt: DateTime.now(),
        lastActiveAt: DateTime.now(),
      );
      await profileRepo.saveProfile(testProfile);
      await profileRepo.setActiveProfile(testProfile.id);

      // Pre-complete lesson 1
      var progress = localDataSource.getProgress('learner_test_2');
      progress = progress.copyWith(
        totalXp: 50,
        completedLessonIds: {'lesson_01'},
      );
      await localDataSource.saveProgress(progress);

      await tester.pumpWidget(
        createTestWidget(
          child: const LessonDetailScreen(lessonId: 'lesson_01'),
        ),
      );
      await tester.pumpAndSettle();

      // Advance through steps
      while (find.text('Next Step').evaluate().isNotEmpty) {
        await tester.ensureVisible(find.text('Next Step'));
        await tester.tap(find.text('Next Step'));
        await tester.pumpAndSettle();
      }

      // Complete Lesson replay
      final replayButton = find.text('Complete Lesson (+50 XP)');
      await tester.ensureVisible(replayButton);
      await tester.tap(replayButton);
      await tester.pumpAndSettle();

      // Verify Dialog with replay text
      expect(find.text('Mission Complete!'), findsOneWidget);
      expect(find.text('LESSON COMPLETED (XP already earned)'), findsOneWidget);
      expect(find.text('+50 XP EARNED'), findsNothing);

      // Verify progress XP remains 50
      final updated = localDataSource.getProgress('learner_test_2');
      expect(updated.totalXp, equals(50));
    });

    testWidgets(
        'Quiz checkpoint does not award XP on replay of already completed lesson',
        (tester) async {
      final localDataSource = LocalStorageDataSource(storageService);
      final profileRepo = ProfileRepositoryImpl(localDataSource);
      final testProfile = LearnerProfileModel(
        id: 'learner_test_quiz_replay',
        nickname: 'Sparky',
        ageBracket: AgeBracket.ages7_9,
        avatarId: 'avatar_1',
        createdAt: DateTime.now(),
        lastActiveAt: DateTime.now(),
      );
      await profileRepo.saveProfile(testProfile);
      await profileRepo.setActiveProfile(testProfile.id);

      // Pre-complete lesson 3
      var progress = localDataSource.getProgress('learner_test_quiz_replay');
      progress = progress.copyWith(
        totalXp: 60,
        completedLessonIds: {'lesson_03'},
      );
      await localDataSource.saveProgress(progress);

      await tester.pumpWidget(
        createTestWidget(
          child: const LessonDetailScreen(lessonId: 'lesson_03'),
        ),
      );
      await tester.pumpAndSettle();

      // Navigate to quiz checkpoint step
      while (find.text('Next Step').evaluate().isNotEmpty) {
        await tester.ensureVisible(find.text('Next Step'));
        await tester.tap(find.text('Next Step'));
        await tester.pumpAndSettle();
      }

      // Quiz step: select correct answer (Option A) and submit
      final optionFinder = find.text(
          'They speed up code by writing complex hardware protocols for you');
      if (optionFinder.evaluate().isNotEmpty) {
        await tester.ensureVisible(optionFinder);
        await tester.tap(optionFinder);
        await tester.pumpAndSettle();

        final submitBtn = find.text('Submit Answer');
        if (submitBtn.evaluate().isNotEmpty) {
          await tester.tap(submitBtn);
          await tester.pumpAndSettle();
        }
      }

      // Verify progress XP did not increase on replay
      final currentProgress =
          localDataSource.getProgress('learner_test_quiz_replay');
      expect(currentProgress.totalXp, equals(60),
          reason: 'Quiz checkpoint must not award XP on replay');
    });
  });
}
