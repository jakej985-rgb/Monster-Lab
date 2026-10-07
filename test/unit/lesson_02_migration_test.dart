import 'package:flutter_test/flutter_test.dart';
import 'package:monster_lab/domain/models/learner_progress_model.dart';

void main() {
  group('Lesson 02 Backward Compatibility Migration Tests', () {
    test('migrateFromOldFormat automatically maps lesson_02 to l2b_01..l2b_08', () {
      final old = LearnerProgressModel(
        learnerId: 'learner_legacy',
        totalXp: 150,
        completedLessonIds: {'lesson_01', 'lesson_02'},
        lastSessionDate: DateTime.now(),
      );

      final migrated = LearnerProgressModel.migrateFromOldFormat(old);

      expect(migrated.completedLessonIds, contains('lesson_01'));
      expect(migrated.completedLessonIds, contains('lesson_02'));
      expect(migrated.completedLessonIds, containsAll([
        'l2b_01', 'l2b_02', 'l2b_03', 'l2b_04',
        'l2b_05', 'l2b_06', 'l2b_07', 'l2b_08'
      ]));
    });

    test('migrateFromOldFormat leaves progress untouched when lesson_02 not present', () {
      final fresh = LearnerProgressModel(
        learnerId: 'learner_fresh',
        totalXp: 50,
        completedLessonIds: {'lesson_01'},
        lastSessionDate: DateTime.now(),
      );

      final migrated = LearnerProgressModel.migrateFromOldFormat(fresh);

      expect(migrated.completedLessonIds, equals({'lesson_01'}));
    });
  });
}
