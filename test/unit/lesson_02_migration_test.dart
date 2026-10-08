import 'package:flutter_test/flutter_test.dart';
import 'package:monster_lab/domain/models/learner_progress_model.dart';

void main() {
  group('Lesson Backward Compatibility Migration Tests', () {
    test(
        'migrateFromOldFormat automatically maps legacy lessons to sub-lessons and courses',
        () {
      final old = LearnerProgressModel(
        learnerId: 'learner_legacy',
        totalXp: 150,
        completedLessonIds: {'lesson_01', 'lesson_02', 'lesson_03'},
        lastSessionDate: DateTime.now(),
      );

      final migrated = LearnerProgressModel.migrateFromOldFormat(old);

      expect(migrated.completedLessonIds, contains('lesson_01'));
      expect(migrated.completedLessonIds, contains('lesson_02'));
      expect(migrated.completedLessonIds, contains('lesson_03'));
      expect(migrated.completedCourseIds,
          containsAll(['lesson_01', 'lesson_2b', 'lesson_03']));
      expect(
          migrated.completedLessonIds,
          containsAll([
            'l01_01',
            'l01_12',
            'l2b_01',
            'l2b_08',
            'l03_01',
            'l03_09',
          ]));
    });

    test(
        'migrateFromOldFormat leaves progress untouched when legacy lessons not present',
        () {
      final fresh = LearnerProgressModel(
        learnerId: 'learner_fresh',
        totalXp: 50,
        completedLessonIds: {'l01_01'},
        lastSessionDate: DateTime.now(),
      );

      final migrated = LearnerProgressModel.migrateFromOldFormat(fresh);

      expect(migrated.completedLessonIds, equals({'l01_01'}));
    });
  });
}
