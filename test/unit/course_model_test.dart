import 'package:flutter_test/flutter_test.dart';
import 'package:monster_lab/domain/models/course_model.dart';

void main() {
  group('CourseModel Unit Tests', () {
    test('CourseModel serializes and deserializes from JSON accurately', () {
      final json = {
        'id': 'coding_foundations',
        'title': 'Coding Foundations',
        'summary': 'Learn programming from scratch before Arduino code.',
        'lessonIds': ['cf_01', 'cf_02', 'cf_03'],
        'isOptional': true,
        'placementLessonId': 'cf_08',
        'prerequisites': ['lesson_01'],
        'xpReward': 100,
        'estimatedMinutes': 90,
      };

      final course = CourseModel.fromJson(json);

      expect(course.id, equals('coding_foundations'));
      expect(course.title, equals('Coding Foundations'));
      expect(course.summary,
          equals('Learn programming from scratch before Arduino code.'));
      expect(course.lessonIds, equals(['cf_01', 'cf_02', 'cf_03']));
      expect(course.isOptional, isTrue);
      expect(course.placementLessonId, equals('cf_08'));
      expect(course.prerequisites, equals(['lesson_01']));
      expect(course.xpReward, equals(100));
      expect(course.estimatedMinutes, equals(90));

      final serialized = course.toJson();
      expect(serialized['id'], equals('coding_foundations'));
      expect(serialized['isOptional'], isTrue);
      expect(serialized['placementLessonId'], equals('cf_08'));
      expect(serialized['lessonIds'], equals(['cf_01', 'cf_02', 'cf_03']));
    });

    test('CourseModel handles defaults for optional fields', () {
      final json = {
        'id': 'lesson_2a',
        'title': 'Lesson 2A — Meet Monster Lab',
        'summary': 'Interactive walkthrough of Monster Lab',
        'lessonIds': ['l2a_01', 'l2a_02'],
        'prerequisites': ['lesson_01'],
        'xpReward': 75,
        'estimatedMinutes': 40,
      };

      final course = CourseModel.fromJson(json);

      expect(course.isOptional, isFalse);
      expect(course.placementLessonId, isNull);
    });
  });
}
