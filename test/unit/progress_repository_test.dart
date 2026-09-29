import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monster_lab/core/services/storage_service.dart';
import 'package:monster_lab/data/datasources/local_storage_datasource.dart';
import 'package:monster_lab/data/repositories/progress_repository_impl.dart';

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
}
