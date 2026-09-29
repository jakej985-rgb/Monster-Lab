import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monster_lab/core/services/storage_service.dart';
import 'package:monster_lab/data/datasources/local_storage_datasource.dart';
import 'package:monster_lab/data/repositories/profile_repository_impl.dart';
import 'package:monster_lab/data/repositories/progress_repository_impl.dart';
import 'package:monster_lab/domain/models/learner_profile_model.dart';
import 'package:monster_lab/domain/models/learner_progress_model.dart';
import 'package:monster_lab/domain/models/avatar_model.dart';

void main() {
  late StorageService storage;
  late LocalStorageDataSource dataSource;
  late ProfileRepositoryImpl profileRepo;
  late ProgressRepositoryImpl progressRepo;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    storage = await StorageService.init();
    dataSource = LocalStorageDataSource(storage);
    profileRepo = ProfileRepositoryImpl(dataSource);
    progressRepo = ProgressRepositoryImpl(dataSource);
  });

  group('Phase 06: Multi-Learner Isolation Tests', () {
    test('Two learners on the same device have strictly isolated progress',
        () async {
      // 1. Create two distinct learner profiles
      final aliceProfile = LearnerProfileModel(
        id: 'learner_alice',
        nickname: 'AliceVolt',
        avatarId: 'monster_volt',
        ageBracket: AgeBracket.ages7_9,
        createdAt: DateTime.now(),
        lastActiveAt: DateTime.now(),
      );

      final bobProfile = LearnerProfileModel(
        id: 'learner_bob',
        nickname: 'BobGear',
        avatarId: 'monster_gear',
        ageBracket: AgeBracket.ages10_12,
        createdAt: DateTime.now(),
        lastActiveAt: DateTime.now(),
      );

      await profileRepo.saveProfile(aliceProfile);
      await profileRepo.saveProfile(bobProfile);

      // 2. Alice completes Lesson 1 (+50 XP) and discovers Ultrasonic Sensor
      await progressRepo.completeLesson('learner_alice', 'lesson_01', 50);
      await progressRepo.discoverComponent('learner_alice', 'comp_01');
      await progressRepo.recordQuizScore('learner_alice', 'quiz_l01', 100, 20);

      // 3. Bob completes Project 1 (+100 XP) and earns a badge
      await progressRepo.completeProject(
          'learner_bob', 'proj_01', 100, 'badge_security_rookie');
      await progressRepo.solveChallenge('learner_bob', 'chal_01', 30);

      // 4. Verify Alice's state
      final aliceProgress = await progressRepo.getProgress('learner_alice');
      expect(aliceProgress.totalXp, equals(70)); // 50 (lesson) + 20 (quiz)
      expect(aliceProgress.completedLessonIds, contains('lesson_01'));
      expect(aliceProgress.discoveredComponentIds, contains('comp_01'));
      expect(aliceProgress.completedProjectIds, isEmpty);
      expect(aliceProgress.earnedBadgeIds, isEmpty);
      expect(aliceProgress.quizBestScores['quiz_l01'], equals(100));
      expect(aliceProgress.lastActivity?.type, equals(ActivityType.lesson));
      expect(aliceProgress.lastActivity?.activityId, equals('quiz_l01'));

      // 5. Verify Bob's state
      final bobProgress = await progressRepo.getProgress('learner_bob');
      expect(
          bobProgress.totalXp, equals(130)); // 100 (project) + 30 (challenge)
      expect(bobProgress.completedLessonIds, isEmpty);
      expect(bobProgress.discoveredComponentIds, isEmpty);
      expect(bobProgress.completedProjectIds, contains('proj_01'));
      expect(bobProgress.earnedBadgeIds, contains('badge_security_rookie'));
      expect(bobProgress.solvedChallengeIds, contains('chal_01'));
      expect(bobProgress.lastActivity?.type, equals(ActivityType.challenge));
      expect(bobProgress.lastActivity?.activityId, equals('chal_01'));
    });

    test('Progress survives simulated app restarts', () async {
      // Create learner progress in first session
      final profile = LearnerProfileModel(
        id: 'learner_persistent',
        nickname: 'PersistBot',
        avatarId: 'monster_spark',
        ageBracket: AgeBracket.ages10_12,
        createdAt: DateTime.now(),
        lastActiveAt: DateTime.now(),
      );
      await profileRepo.saveProfile(profile);
      await progressRepo.completeLesson('learner_persistent', 'lesson_01', 50);
      await progressRepo.completeLesson('learner_persistent', 'lesson_02', 50);
      await progressRepo.recordProjectPhase('learner_persistent', 'proj_04', 2);

      // Simulate App Restart by re-initializing repositories with the same persistent store
      final restartedDataSource = LocalStorageDataSource(storage);
      final restartedProgressRepo = ProgressRepositoryImpl(restartedDataSource);

      final restored =
          await restartedProgressRepo.getProgress('learner_persistent');
      expect(restored.totalXp, equals(100));
      expect(
          restored.completedLessonIds, containsAll(['lesson_01', 'lesson_02']));
      expect(restored.projectStepBookmarks['proj_04'], equals(2));
      expect(restored.lastActivity?.type, equals(ActivityType.project));
      expect(restored.lastActivity?.activityId, equals('proj_04'));
      expect(restored.lastActivity?.stepNumber, equals(2));
    });

    test('Resume Learning tracks latest action accurately', () async {
      const learnerId = 'learner_resumer';

      // 1. Initial empty state
      final p0 = await progressRepo.getProgress(learnerId);
      expect(p0.lastActivity, isNull);

      // 2. Discover component
      await progressRepo.discoverComponent(learnerId, 'comp_10');
      final p1 = await progressRepo.getProgress(learnerId);
      expect(p1.lastActivity?.type, equals(ActivityType.component));
      expect(p1.lastActivity?.activityId, equals('comp_10'));

      // 3. Complete lesson overrides last activity
      await progressRepo.completeLesson(learnerId, 'lesson_05', 75);
      final p2 = await progressRepo.getProgress(learnerId);
      expect(p2.lastActivity?.type, equals(ActivityType.lesson));
      expect(p2.lastActivity?.activityId, equals('lesson_05'));

      // 4. Custom activity record
      await progressRepo.recordActivity(
        learnerId,
        LastActivityInfo(
          type: ActivityType.project,
          activityId: 'proj_13',
          title: 'Tuning IMU Sensor Fusion',
          timestamp: DateTime.now(),
          stepNumber: 3,
        ),
      );
      final p3 = await progressRepo.getProgress(learnerId);
      expect(p3.lastActivity?.activityId, equals('proj_13'));
      expect(p3.lastActivity?.title, equals('Tuning IMU Sensor Fusion'));
    });

    test('Avatar registry lookup functions correctly', () {
      final spark = MonsterAvatar.findById('monster_spark');
      expect(spark.name, equals('Spark'));

      final volt = MonsterAvatar.findById('monster_volt');
      expect(volt.name, equals('Volt'));

      // Fallback for unknown avatar ID
      final fallback = MonsterAvatar.findById('unknown_monster_id');
      expect(fallback.name, equals('Spark'));
    });
  });
}
