import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monster_lab/core/services/storage_service.dart';
import 'package:monster_lab/data/datasources/local_storage_datasource.dart';
import 'package:monster_lab/data/repositories/progress_repository_impl.dart';
import 'package:monster_lab/domain/models/learner_progress_model.dart';

void main() {
  group('ProgressRepository Multi-Learner Isolation Tests', () {
    late ProgressRepositoryImpl progressRepo;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final storageService = await StorageService.init();
      final dataSource = LocalStorageDataSource(storageService);
      progressRepo = ProgressRepositoryImpl(dataSource);
    });

    test('Learner progress states are strictly isolated by learner ID',
        () async {
      const childA = 'child_alex';
      const childB = 'child_bella';

      // Child A completes lesson 1
      await progressRepo.completeLesson(childA, 'lesson_01', 100);
      await progressRepo.recordProjectPhase(childA, 'proj_01', 2);

      // Child B starts fresh and completes lesson 2
      await progressRepo.completeLesson(childB, 'lesson_02', 50);

      final progressA = await progressRepo.getProgress(childA);
      final progressB = await progressRepo.getProgress(childB);

      // Verify Child A state
      expect(progressA.totalXp, equals(100));
      expect(progressA.completedLessonIds, contains('lesson_01'));
      expect(progressA.completedLessonIds, isNot(contains('lesson_02')));
      expect(progressA.projectStepBookmarks['proj_01'], equals(2));

      // Verify Child B state
      expect(progressB.totalXp, equals(50));
      expect(progressB.completedLessonIds, contains('lesson_02'));
      expect(progressB.completedLessonIds, isNot(contains('lesson_01')));
      expect(progressB.projectStepBookmarks['proj_01'], isNull);
    });

    test('Resetting progress only clears the targeted learner profile',
        () async {
      const childA = 'child_alex';
      const childB = 'child_bella';

      await progressRepo.addXp(childA, 500);
      await progressRepo.addXp(childB, 300);

      await progressRepo.resetProgress(childA);

      final progressA = await progressRepo.getProgress(childA);
      final progressB = await progressRepo.getProgress(childB);

      expect(progressA.totalXp, equals(0));
      expect(progressB.totalXp, equals(300));
    });
  });

  group('ProgressRepository Idempotency & XP Reliability Tests', () {
    late ProgressRepositoryImpl progressRepo;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final storageService = await StorageService.init();
      final dataSource = LocalStorageDataSource(storageService);
      progressRepo = ProgressRepositoryImpl(dataSource);
    });

    test(
        'completeLesson awards XP and returns true on first call, returns false on replay without duplicate XP',
        () async {
      const learnerId = 'learner_replay';
      const lessonId = 'lesson_01';

      final firstResult =
          await progressRepo.completeLesson(learnerId, lessonId, 50);
      expect(firstResult, isTrue);

      var progress = await progressRepo.getProgress(learnerId);
      expect(progress.totalXp, equals(50));
      expect(progress.completedLessonIds, contains(lessonId));

      // Replaying the same lesson
      final secondResult =
          await progressRepo.completeLesson(learnerId, lessonId, 50);
      expect(secondResult, isFalse);

      progress = await progressRepo.getProgress(learnerId);
      expect(progress.totalXp, equals(50),
          reason: 'Replay must not award duplicate XP');
      expect(progress.completedLessonIds, contains(lessonId));
    });

    test(
        'completeProject awards XP and badge on first call, returns false on replay without duplicate XP',
        () async {
      const learnerId = 'learner_project';
      const projectId = 'proj_01';

      final firstResult = await progressRepo.completeProject(
          learnerId, projectId, 100, 'badge_builder');
      expect(firstResult, isTrue);

      var progress = await progressRepo.getProgress(learnerId);
      expect(progress.totalXp, equals(100));
      expect(progress.completedProjectIds, contains(projectId));
      expect(progress.earnedBadgeIds, contains('badge_builder'));

      // Replay project
      final secondResult = await progressRepo.completeProject(
          learnerId, projectId, 100, 'badge_builder');
      expect(secondResult, isFalse);

      progress = await progressRepo.getProgress(learnerId);
      expect(progress.totalXp, equals(100),
          reason: 'Replay must not award duplicate XP');
    });

    test(
        'solveChallenge awards XP on first call, returns false on replay without duplicate XP',
        () async {
      const learnerId = 'learner_challenge';
      const challengeId = 'chal_01';

      final firstResult =
          await progressRepo.solveChallenge(learnerId, challengeId, 30);
      expect(firstResult, isTrue);

      var progress = await progressRepo.getProgress(learnerId);
      expect(progress.totalXp, equals(30));
      expect(progress.solvedChallengeIds, contains(challengeId));

      // Solve again
      final secondResult =
          await progressRepo.solveChallenge(learnerId, challengeId, 30);
      expect(secondResult, isFalse);

      progress = await progressRepo.getProgress(learnerId);
      expect(progress.totalXp, equals(30),
          reason: 'Replay must not award duplicate XP');
    });

    test(
        'concurrent completeLesson calls for same lesson are serialized and award XP only once',
        () async {
      const learnerId = 'learner_concurrent_1';
      const lessonId = 'lesson_01';

      final results = await Future.wait([
        progressRepo.completeLesson(learnerId, lessonId, 50),
        progressRepo.completeLesson(learnerId, lessonId, 50),
      ]);

      // Exactly one should be true (first completion), the other false
      expect(results.where((r) => r == true).length, equals(1));
      expect(results.where((r) => r == false).length, equals(1));

      final progress = await progressRepo.getProgress(learnerId);
      expect(progress.totalXp, equals(50));
      expect(progress.completedLessonIds, contains(lessonId));
    });

    test(
        'concurrent completeLesson calls for different lessons are serialized without clobbering',
        () async {
      const learnerId = 'learner_concurrent_2';

      final results = await Future.wait([
        progressRepo.completeLesson(learnerId, 'lesson_01', 50),
        progressRepo.completeLesson(learnerId, 'lesson_02', 60),
      ]);

      expect(results, equals([true, true]));

      final progress = await progressRepo.getProgress(learnerId);
      expect(progress.totalXp, equals(110));
      expect(
          progress.completedLessonIds, containsAll(['lesson_01', 'lesson_02']));
    });

    test('first completed lesson awards First Circuit Scout exactly once',
        () async {
      const learnerId = 'learner_first_badge';

      await progressRepo.completeLesson(learnerId, 'lesson_01', 50);
      var progress = await progressRepo.getProgress(learnerId);

      expect(progress.earnedBadgeIds,
          contains(ProgressBadgeIds.firstCircuitScout));
      expect(
        progress.eventLedger
            .where((event) => event.eventType == ProgressEventType.badgeEarned)
            .length,
        1,
      );

      await progressRepo.completeLesson(learnerId, 'lesson_01', 50);
      progress = await progressRepo.getProgress(learnerId);

      expect(progress.totalXp, equals(50));
      expect(
        progress.eventLedger
            .where((event) => event.eventType == ProgressEventType.badgeEarned)
            .length,
        1,
      );
    });

    test('getProgress backfills First Circuit Scout for legacy progress',
        () async {
      const learnerId = 'learner_legacy_badge';
      await progressRepo.saveProgress(
        LearnerProgressModel(
          learnerId: learnerId,
          completedLessonIds: const {'l01_01'},
          lastSessionDate: DateTime.utc(2026, 1, 1),
        ),
      );

      final progress = await progressRepo.getProgress(learnerId);

      expect(progress.earnedBadgeIds,
          contains(ProgressBadgeIds.firstCircuitScout));
      expect(
        progress.eventLedger
            .where((event) => event.eventType == ProgressEventType.badgeEarned)
            .length,
        1,
      );
    });
  });
}
