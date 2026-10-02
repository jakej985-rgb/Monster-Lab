import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monster_lab/core/services/storage_service.dart';
import 'package:monster_lab/data/datasources/local_storage_datasource.dart';
import 'package:monster_lab/data/repositories/progress_repository_impl.dart';
import 'package:monster_lab/presentation/shared/providers.dart';

void main() {
  group('ActiveProgressNotifier Unit Tests', () {
    late ProgressRepositoryImpl progressRepo;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final storageService = await StorageService.init();
      final dataSource = LocalStorageDataSource(storageService);
      progressRepo = ProgressRepositoryImpl(dataSource);
    });

    test('Initializes with null when learnerId is null', () {
      final notifier = ActiveProgressNotifier(progressRepo, null);
      expect(notifier.state, isNull);
    });

    test('completeLesson returns false and does nothing when learnerId is null',
        () async {
      final notifier = ActiveProgressNotifier(progressRepo, null);
      final result = await notifier.completeLesson('lesson_01', 50);
      expect(result, isFalse);
      expect(notifier.state, isNull);
    });

    test(
        'completeLesson updates state and awards XP on first call, returns true',
        () async {
      const learnerId = 'learner_active_1';
      final notifier = ActiveProgressNotifier(progressRepo, learnerId);
      await notifier.loadProgress();

      expect(notifier.state?.totalXp, equals(0));

      final firstCall = await notifier.completeLesson('lesson_01', 50);
      expect(firstCall, isTrue);
      expect(notifier.state?.totalXp, equals(50));
      expect(notifier.state?.completedLessonIds, contains('lesson_01'));

      // Replay
      final secondCall = await notifier.completeLesson('lesson_01', 50);
      expect(secondCall, isFalse);
      expect(notifier.state?.totalXp, equals(50));
    });

    test('completeProject updates state and awards XP/badge idempotently',
        () async {
      const learnerId = 'learner_active_2';
      final notifier = ActiveProgressNotifier(progressRepo, learnerId);
      await notifier.loadProgress();

      final firstCall =
          await notifier.completeProject('proj_01', 100, 'badge_master');
      expect(firstCall, isTrue);
      expect(notifier.state?.totalXp, equals(100));
      expect(notifier.state?.completedProjectIds, contains('proj_01'));
      expect(notifier.state?.earnedBadgeIds, contains('badge_master'));

      final secondCall =
          await notifier.completeProject('proj_01', 100, 'badge_master');
      expect(secondCall, isFalse);
      expect(notifier.state?.totalXp, equals(100));
    });

    test('solveChallenge updates state and awards XP idempotently', () async {
      const learnerId = 'learner_active_3';
      final notifier = ActiveProgressNotifier(progressRepo, learnerId);
      await notifier.loadProgress();

      final firstCall = await notifier.solveChallenge('chal_01', 40);
      expect(firstCall, isTrue);
      expect(notifier.state?.totalXp, equals(40));
      expect(notifier.state?.solvedChallengeIds, contains('chal_01'));

      final secondCall = await notifier.solveChallenge('chal_01', 40);
      expect(secondCall, isFalse);
      expect(notifier.state?.totalXp, equals(40));
    });
  });
}
