import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monster_lab/core/services/storage_service.dart';
import 'package:monster_lab/data/datasources/local_storage_datasource.dart';
import 'package:monster_lab/data/repositories/progress_repository_impl.dart';

void main() {
  group('Placement and Course Completion Logic Tests', () {
    late ProgressRepositoryImpl progressRepo;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final storageService = await StorageService.init();
      final dataSource = LocalStorageDataSource(storageService);
      progressRepo = ProgressRepositoryImpl(dataSource);
    });

    test('markPlacementPassed persists passed course ID', () async {
      const learnerId = 'learner_placement';

      await progressRepo.markPlacementPassed(learnerId, 'coding_foundations');
      final progress = await progressRepo.getProgress(learnerId);

      expect(progress.placementPassedCourseIds, contains('coding_foundations'));
    });

    test('completeCourse awards XP idempotently on first completion', () async {
      const learnerId = 'learner_course_test';

      final firstResult = await progressRepo.completeCourse(learnerId, 'coding_foundations', 100);
      expect(firstResult, isTrue);

      var progress = await progressRepo.getProgress(learnerId);
      expect(progress.completedCourseIds, contains('coding_foundations'));
      expect(progress.totalXp, equals(100));

      // Replay completion does not double XP
      final secondResult = await progressRepo.completeCourse(learnerId, 'coding_foundations', 100);
      expect(secondResult, isFalse);

      progress = await progressRepo.getProgress(learnerId);
      expect(progress.totalXp, equals(100));
    });
  });
}
