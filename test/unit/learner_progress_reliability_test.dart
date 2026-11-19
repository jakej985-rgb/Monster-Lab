import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monster_lab/core/services/parent_data_service.dart';
import 'package:monster_lab/core/services/storage_service.dart';
import 'package:monster_lab/data/datasources/local_storage_datasource.dart';
import 'package:monster_lab/data/repositories/profile_repository_impl.dart';
import 'package:monster_lab/data/repositories/progress_repository_impl.dart';
import 'package:monster_lab/domain/models/learner_profile_model.dart';
import 'package:monster_lab/domain/models/learner_progress_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Learner Progress and Data Reliability Suite (Issues #16-#21)', () {
    late StorageService storageService;
    late LocalStorageDataSource dataSource;
    late ProgressRepositoryImpl progressRepo;
    late ProfileRepositoryImpl profileRepo;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      storageService = await StorageService.init();
      dataSource = LocalStorageDataSource(storageService);
      progressRepo = ProgressRepositoryImpl(dataSource);
      profileRepo = ProfileRepositoryImpl(dataSource);
    });

    // --- Issue #16: Schema Migrations ---
    group('Issue #16: Schema Migrations & Version Invariants', () {
      test('migrates unversioned legacy payload to current schema version 2',
          () {
        final legacyJson = {
          'learnerId': 'learner_v1',
          'totalXp': 150,
          'completedLessonIds': ['lesson_01'], // Legacy lesson ID
          'completedCourseIds': <String>[],
          'lastSessionDate': DateTime.now().toIso8601String(),
        };

        final migrated = LearnerProgressModel.fromJson(legacyJson);
        expect(migrated.schemaVersion,
            equals(LearnerProgressModel.currentSchemaVersion));
        expect(migrated.completedCourseIds, contains('lesson_01'));
        expect(migrated.completedLessonIds, contains('l01_01'));
        expect(migrated.completedLessonIds, contains('l01_12'));
        expect(
            migrated.processedTransactionIds, contains('tx_course_lesson_01'));
      });

      test(
          'throws UnsupportedSchemaVersionException for future schema versions',
          () {
        final futureJson = {
          'schemaVersion': 999,
          'learnerId': 'future_learner',
          'totalXp': 500,
          'lastSessionDate': DateTime.now().toIso8601String(),
        };

        expect(
          () => LearnerProgressModel.fromJson(futureJson),
          throwsA(isA<UnsupportedSchemaVersionException>().having(
            (e) => e.requestedVersion,
            'requestedVersion',
            equals(999),
          )),
        );
      });

      test(
          'round-trip serialization preserves all fields and transaction history',
          () {
        final now = DateTime.now();
        final original = LearnerProgressModel(
          learnerId: 'learner_roundtrip',
          totalXp: 350,
          completedCourseIds: {'lesson_01'},
          completedLessonIds: {'l01_01', 'l01_02'},
          discoveredComponentIds: {'comp_01'},
          completedProjectIds: {'proj_01'},
          projectStepBookmarks: {'proj_01': 3},
          solvedChallengeIds: {'chal_01'},
          earnedBadgeIds: {'badge_first_build'},
          quizBestScores: {'quiz_01': 100},
          lastSessionDate: now,
          processedTransactionIds: {'tx_course_lesson_01', 'tx_lesson_l01_01'},
          eventLedger: [
            LearnerProgressEvent(
              eventId: 'tx_course_lesson_01',
              eventType: ProgressEventType.courseCompleted,
              learnerId: 'learner_roundtrip',
              activityId: 'lesson_01',
              timestamp: now,
              xpAwarded: 100,
            ),
          ],
        );

        final json = original.toJson();
        final restored = LearnerProgressModel.fromJson(json);

        expect(restored.schemaVersion, equals(original.schemaVersion));
        expect(restored.learnerId, equals(original.learnerId));
        expect(restored.totalXp, equals(original.totalXp));
        expect(
            restored.completedCourseIds, equals(original.completedCourseIds));
        expect(
            restored.completedLessonIds, equals(original.completedLessonIds));
        expect(restored.processedTransactionIds,
            equals(original.processedTransactionIds));
        expect(restored.eventLedger.length, equals(1));
        expect(
            restored.eventLedger.first.eventId, equals('tx_course_lesson_01'));
      });
    });

    // --- Issue #17: Append-Only Event Ledger ---
    group('Issue #17: Append-Only Progress Event Ledger', () {
      test('records ordered events to the ledger with full metadata', () async {
        const learnerId = 'learner_events';

        await progressRepo.completeLesson(learnerId, 'l01_01', 25);
        await progressRepo.completeCourse(learnerId, 'lesson_01', 100);
        await progressRepo.solveChallenge(learnerId, 'chal_01', 50);

        final progress = await progressRepo.getProgress(learnerId);
        expect(progress.eventLedger.length, equals(3));
        expect(progress.eventLedger[0].eventType,
            equals(ProgressEventType.lessonCompleted));
        expect(progress.eventLedger[0].activityId, equals('l01_01'));
        expect(progress.eventLedger[0].xpAwarded, equals(25));

        expect(progress.eventLedger[1].eventType,
            equals(ProgressEventType.courseCompleted));
        expect(progress.eventLedger[1].activityId, equals('lesson_01'));
        expect(progress.eventLedger[1].xpAwarded, equals(100));

        expect(progress.eventLedger[2].eventType,
            equals(ProgressEventType.challengeSolved));
        expect(progress.eventLedger[2].activityId, equals('chal_01'));
        expect(progress.eventLedger[2].xpAwarded, equals(50));
      });

      test('replays events from ledger to reconstruct identical state snapshot',
          () async {
        const learnerId = 'learner_replay';
        await progressRepo.completeLesson(learnerId, 'l01_01', 25);
        await progressRepo.completeCourse(learnerId, 'lesson_01', 100);
        await progressRepo.solveChallenge(learnerId, 'chal_01', 50);

        final original = await progressRepo.getProgress(learnerId);
        final replayed = LearnerProgressModel.replayFromEvents(
          learnerId,
          original.eventLedger,
        );

        expect(replayed.totalXp, equals(original.totalXp));
        expect(
            replayed.completedCourseIds, equals(original.completedCourseIds));
        expect(
            replayed.completedLessonIds, equals(original.completedLessonIds));
        expect(
            replayed.solvedChallengeIds, equals(original.solvedChallengeIds));
      });
    });

    // --- Issue #18: Prevent Duplicate XP / Rewards ---
    group('Issue #18: Idempotent Reward Transactions', () {
      test(
          'prevents duplicate XP when completing the same course multiple times',
          () async {
        const learnerId = 'learner_idempotent';

        final firstResult =
            await progressRepo.completeCourse(learnerId, 'lesson_01', 100);
        expect(firstResult, isTrue);

        var progress = await progressRepo.getProgress(learnerId);
        expect(progress.totalXp, equals(100));

        // Attempt second completion of the same course
        final secondResult =
            await progressRepo.completeCourse(learnerId, 'lesson_01', 100);
        expect(secondResult, isFalse);

        progress = await progressRepo.getProgress(learnerId);
        expect(progress.totalXp, equals(100)); // XP NOT duplicated!
      });

      test(
          'prevents duplicate XP when completing the same lesson multiple times',
          () async {
        const learnerId = 'learner_idempotent_lesson';

        final first =
            await progressRepo.completeLesson(learnerId, 'l01_01', 25);
        expect(first, isTrue);

        final second =
            await progressRepo.completeLesson(learnerId, 'l01_01', 25);
        expect(second, isFalse);

        final progress = await progressRepo.getProgress(learnerId);
        expect(progress.totalXp, equals(25));
      });

      test('idempotent addXp with explicit transactionId', () async {
        const learnerId = 'learner_idempotent_xp';
        const txId = 'unique_reward_event_123';

        await progressRepo.addXp(learnerId, 50, txId);
        var progress = await progressRepo.getProgress(learnerId);
        expect(progress.totalXp, equals(50));

        // Repeat with same txId
        await progressRepo.addXp(learnerId, 50, txId);
        progress = await progressRepo.getProgress(learnerId);
        expect(progress.totalXp, equals(50)); // No duplicate XP!
      });
    });

    // --- Issue #19: Progress Corruption Detection & Backup Recovery ---
    group('Issue #19: Corruption Detection & Snapshot Recovery', () {
      test(
          'auto-recovers from validated backup snapshot when primary slot is corrupt',
          () async {
        const learnerId = 'learner_corrupt_recovery';

        // 1. Establish valid progress
        await progressRepo.completeCourse(learnerId, 'lesson_01', 100);
        await progressRepo.completeLesson(learnerId, 'l01_01', 25);

        final valid = await progressRepo.getProgress(learnerId);
        expect(valid.totalXp, equals(125));

        // 2. Corrupt the primary storage slot directly
        await dataSource.saveRawProgress(
            learnerId, '{"corrupted_json: [invalid');

        // 3. getProgress should detect corruption and recover from backup snapshot
        final recovered = await progressRepo.getProgress(learnerId);
        expect(recovered.totalXp, equals(125));
        expect(recovered.completedCourseIds, contains('lesson_01'));
        expect(recovered.completedLessonIds, contains('l01_01'));

        // Primary slot should also be repaired
        final primaryRaw = dataSource.getRawProgressString(learnerId);
        expect(primaryRaw, isNotNull);
        expect(primaryRaw, isNot(contains('corrupted_json')));
      });

      test(
          'throws ProgressCorruptionException when both primary and backup are missing/unrecoverable',
          () async {
        const learnerId = 'learner_unrecoverable';
        await dataSource.saveRawProgress(learnerId, 'not valid json at all');
        // No backup snapshot exists

        expect(
          () => dataSource.getProgress(learnerId, throwOnUnrecoverable: true),
          throwsA(isA<ProgressCorruptionException>().having(
            (e) => e.learnerId,
            'learnerId',
            equals(learnerId),
          )),
        );

        // Also verify default behavior records corruption without crashing
        final safeFallback = dataSource.getProgress(learnerId);
        expect(safeFallback.totalXp, equals(0));
        expect(dataSource.lastCorruption?.learnerId, equals(learnerId));
      });
    });

    // --- Issue #20: Transactional Backup Imports ---
    group('Issue #20: Transactional Backup Imports with Atomic Rollback', () {
      test('imports valid backup and commits changes', () async {
        final profile = LearnerProfileModel(
          id: 'import_prof_1',
          nickname: 'Sparky',
          avatarId: 'avatar_sparky',
          ageBracket: AgeBracket.ages7_9,
          createdAt: DateTime.now(),
          lastActiveAt: DateTime.now(),
        );
        final progress = LearnerProgressModel(
          learnerId: 'import_prof_1',
          totalXp: 300,
          completedCourseIds: {'lesson_01'},
          lastSessionDate: DateTime.now(),
        );

        final jsonString =
            ParentDataService.exportBackupJson(profile, progress);
        final result = await ParentDataService.restoreBackupTransactional(
          jsonString: jsonString,
          profileRepo: profileRepo,
          progressRepo: progressRepo,
          storageDataSource: dataSource,
        );

        expect(result.profile.id, equals('import_prof_1'));
        expect(result.progress.totalXp, equals(300));

        final allProfiles = await profileRepo.getAllProfiles();
        final savedProfile =
            allProfiles.where((p) => p.id == 'import_prof_1').firstOrNull;
        final savedProgress = await progressRepo.getProgress('import_prof_1');
        expect(savedProfile?.nickname, equals('Sparky'));
        expect(savedProgress.totalXp, equals(300));
      });

      test(
          'rolls back atomically if progress write fails, preserving original data',
          () async {
        // 1. Establish pre-existing learner profile and progress
        final initialProfile = LearnerProfileModel(
          id: 'learner_rollback',
          nickname: 'Original Sparky',
          avatarId: 'avatar_sparky',
          ageBracket: AgeBracket.ages7_9,
          createdAt: DateTime.now(),
          lastActiveAt: DateTime.now(),
        );
        final initialProgress = LearnerProgressModel(
          learnerId: 'learner_rollback',
          totalXp: 150,
          completedCourseIds: {'lesson_01'},
          lastSessionDate: DateTime.now(),
        );

        await profileRepo.saveProfile(initialProfile);
        await progressRepo.saveProgress(initialProgress);

        // 2. Prepare import payload with mismatching future version to simulate failure during progress write
        final corruptPayload = jsonEncode({
          'app': 'MonsterLab',
          'version': 2,
          'exportedAt': DateTime.now().toIso8601String(),
          'profile': {
            'id': 'learner_rollback',
            'nickname': 'Mutated Sparky',
            'avatarId': 'avatar_sparky',
            'ageBracket': 'ages7_9',
            'createdAt': DateTime.now().toIso8601String(),
            'lastActiveAt': DateTime.now().toIso8601String(),
          },
          'progress': {
            'schemaVersion':
                999, // Will throw UnsupportedSchemaVersionException during progress handling!
            'learnerId': 'learner_rollback',
            'totalXp': 9999,
          },
        });

        // 3. Attempt restore - should throw and trigger rollback
        await expectLater(
          ParentDataService.restoreBackupTransactional(
            jsonString: corruptPayload,
            profileRepo: profileRepo,
            progressRepo: progressRepo,
            storageDataSource: dataSource,
          ),
          throwsA(isA<UnsupportedSchemaVersionException>()),
        );

        // 4. Verify original state was completely preserved!
        final allProfiles = await profileRepo.getAllProfiles();
        final preservedProfile =
            allProfiles.where((p) => p.id == 'learner_rollback').firstOrNull;
        final preservedProgress =
            await progressRepo.getProgress('learner_rollback');

        expect(preservedProfile?.nickname, equals('Original Sparky'));
        expect(preservedProgress.totalXp, equals(150));
      });
    });

    // --- Issue #21: Profile Switching and Concurrency Isolation ---
    group('Issue #21: Multi-Profile Concurrency & Isolation', () {
      test(
          'concurrent progress writes across multiple learners do not leak state',
          () async {
        const learnerA = 'learner_alpha';
        const learnerB = 'learner_beta';

        // Concurrently run 20 mutations for learner A and 20 for learner B
        final futures = <Future<void>>[];
        for (int i = 1; i <= 10; i++) {
          futures.add(progressRepo.completeLesson(
              learnerA, 'l01_${i.toString().padLeft(2, '0')}', 10));
          futures.add(progressRepo.completeLesson(
              learnerB, 'l02_${i.toString().padLeft(2, '0')}', 20));
        }

        await Future.wait(futures);

        final progressA = await progressRepo.getProgress(learnerA);
        final progressB = await progressRepo.getProgress(learnerB);

        expect(progressA.totalXp, equals(100)); // 10 * 10
        expect(progressA.completedLessonIds.length, equals(10));
        expect(
            progressA.completedLessonIds.every((id) => id.startsWith('l01_')),
            isTrue);

        expect(progressB.totalXp, equals(200)); // 10 * 20
        expect(progressB.completedLessonIds.length, equals(10));
        expect(
            progressB.completedLessonIds.every((id) => id.startsWith('l02_')),
            isTrue);
      });
    });
  });
}
