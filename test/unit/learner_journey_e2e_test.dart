import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monster_lab/core/services/storage_service.dart';
import 'package:monster_lab/data/datasources/local_storage_datasource.dart';
import 'package:monster_lab/data/repositories/profile_repository_impl.dart';
import 'package:monster_lab/data/repositories/progress_repository_impl.dart';
import 'package:monster_lab/domain/models/learner_profile_model.dart';
import 'package:monster_lab/domain/models/learner_progress_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Core Learner Journey Integration Suite (Issue #45)', () {
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

    test(
        'End-to-End Learner Journey: Onboarding -> Lesson -> Challenge -> Resume',
        () async {
      // Step 1: Learner Onboarding & Profile Creation
      final profile = LearnerProfileModel(
        id: 'learner_journey_01',
        nickname: 'Pixel Spark',
        avatarId: 'dr_volt',
        ageBracket: AgeBracket.ages7_9,
        createdAt: DateTime.now(),
        lastActiveAt: DateTime.now(),
      );
      await profileRepo.saveProfile(profile);
      await profileRepo.setActiveProfile(profile.id);

      final activeProfile = await profileRepo.getActiveProfile();
      expect(activeProfile, isNotNull);
      expect(activeProfile!.nickname, equals('Pixel Spark'));
      expect(activeProfile.ageBracket, equals(AgeBracket.ages7_9));

      // Step 2: Course Initiation (12 sequential lessons)
      final initialProgress = LearnerProgressModel(
        learnerId: profile.id,
        completedLessonIds: {},
        completedCourseIds: {},
        earnedBadgeIds: {},
        totalXp: 0,
        lastSessionDate: DateTime.now(),
      );
      await progressRepo.saveProgress(initialProgress);

      var progress = await progressRepo.getProgress(profile.id);
      expect(progress.totalXp, equals(0));
      expect(progress.completedLessonIds, isEmpty);

      // Step 3: Complete First Lesson (l01_01)
      const lesson1Id = 'l01_01';
      final updatedWithLesson1 = progress.copyWith(
        completedLessonIds: {...progress.completedLessonIds, lesson1Id},
        totalXp: progress.totalXp + 50,
        processedTransactionIds: {
          ...progress.processedTransactionIds,
          'tx_$lesson1Id',
        },
      );
      await progressRepo.saveProgress(updatedWithLesson1);

      progress = await progressRepo.getProgress(profile.id);
      expect(progress.completedLessonIds, contains(lesson1Id));
      expect(progress.totalXp, equals(50));

      // Step 4: Replay protection (Deduplication invariant)
      // Calling addXp with same transactionId should be idempotent
      await progressRepo.addXp(profile.id, 50, 'tx_$lesson1Id');
      progress = await progressRepo.getProgress(profile.id);
      expect(progress.totalXp, equals(50)); // XP remains 50, not duplicated

      // Step 5: Complete Hands-on Project & Unlock Reward Badge
      const projectId = 'proj_breadboard_basics';
      const badgeId = 'badge_circuit_rookie';
      final withProjectAndBadge = progress.copyWith(
        completedProjectIds: {...progress.completedProjectIds, projectId},
        earnedBadgeIds: {...progress.earnedBadgeIds, badgeId},
        totalXp: progress.totalXp + 100,
        processedTransactionIds: {
          ...progress.processedTransactionIds,
          'tx_$projectId',
        },
      );
      await progressRepo.saveProgress(withProjectAndBadge);

      progress = await progressRepo.getProgress(profile.id);
      expect(progress.completedProjectIds, contains(projectId));
      expect(progress.earnedBadgeIds, contains(badgeId));
      expect(progress.totalXp, equals(150));

      // Step 6: Session Interruption & Fresh Resume
      // Simulate app restart by re-initializing repository instances from same storage
      final newStorage = await StorageService.init();
      final newDataSource = LocalStorageDataSource(newStorage);
      final newProfileRepo = ProfileRepositoryImpl(newDataSource);
      final newProgressRepo = ProgressRepositoryImpl(newDataSource);

      final resumedProfile = await newProfileRepo.getActiveProfile();
      expect(resumedProfile, isNotNull);
      expect(resumedProfile!.id, equals(profile.id));

      final resumedProgress =
          await newProgressRepo.getProgress(resumedProfile.id);
      expect(resumedProgress.totalXp, equals(150));
      expect(resumedProgress.completedLessonIds, contains('l01_01'));
      expect(resumedProgress.earnedBadgeIds, contains('badge_circuit_rookie'));
      expect(resumedProgress.completedProjectIds,
          contains('proj_breadboard_basics'));

      // Determine next lesson to resume
      final allCourseLessons = [
        'l01_01',
        'l01_02',
        'l01_03',
        'l01_04',
        'l01_05',
        'l01_06',
        'l01_07',
        'l01_08',
        'l01_09',
        'l01_10',
        'l01_11',
        'l01_12'
      ];
      final nextLesson = allCourseLessons.firstWhere(
        (id) => !resumedProgress.completedLessonIds.contains(id),
        orElse: () => '',
      );
      expect(nextLesson, equals('l01_02'));
    });
  });
}
