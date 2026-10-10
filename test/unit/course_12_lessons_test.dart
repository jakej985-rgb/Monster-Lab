import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:monster_lab/core/curriculum/curriculum_validator.dart';
import 'package:monster_lab/domain/models/lesson_model.dart';

void main() {
  group('Course 12 Sub-Lessons (l12_01 to l12_08) Validation', () {
    for (int i = 1; i <= 8; i++) {
      final lessonId = 'l12_${i.toString().padLeft(2, '0')}';

      test('$lessonId loads valid JSON and passes CurriculumValidator', () {
        final file = File('assets/curriculum/lessons/$lessonId.json');
        expect(file.existsSync(), isTrue,
            reason: 'File $lessonId.json must exist');

        final content = file.readAsStringSync();
        final jsonMap = jsonDecode(content) as Map<String, dynamic>;

        final lesson = Lesson.fromJson(jsonMap);

        expect(lesson.id, equals(lessonId));
        expect(lesson.courseId, equals('lesson_12'));
        expect(lesson.tier, equals(DifficultyTier.engineer));
        expect(lesson.sortOrder, equals(i));
        expect(lesson.isOptional, isFalse);
        expect(lesson.steps.length, equals(4));

        // Validate using CurriculumValidator
        expect(
            () => CurriculumValidator.validateLesson(lesson), returnsNormally);

        // Verify Step 1: type story, 2 quickCheck questions
        expect(lesson.steps[0].type, equals(StepType.story));
        expect(lesson.steps[0].quickCheck, isNotNull);
        expect(lesson.steps[0].quickCheck!.length, equals(2));
        for (final q in lesson.steps[0].quickCheck!) {
          expect(q.options.length, equals(3));
          expect(q.correctIndex, inInclusiveRange(0, 2));
        }

        // Verify Step 2: visualExplanation or physicalTask
        expect(
          [StepType.visualExplanation, StepType.physicalTask],
          contains(lesson.steps[1].type),
        );

        // Verify Step 3: codeExperiment with sketch and interactiveConfig
        expect(lesson.steps[2].type, equals(StepType.codeExperiment));
        expect(lesson.steps[2].markdownContent, contains('```cpp'));
        expect(lesson.steps[2].interactiveConfig, isNotNull);

        // Verify Step 4: quizCheckpoint with 3 questions
        expect(lesson.steps[3].type, equals(StepType.quizCheckpoint));
        expect(lesson.steps[3].interactiveConfig, isNotNull);
        final questions =
            lesson.steps[3].interactiveConfig!['questions'] as List<dynamic>;
        expect(questions.length, equals(3));
        for (final q in questions) {
          final options = q['options'] as List<dynamic>;
          expect(options.length, equals(3));
          final correctIdx = q['correctIndex'] as int;
          expect(correctIdx, inInclusiveRange(0, 2));
        }
      });
    }

    test('Course 12 sub-lesson progression prerequisites chain', () {
      final expectedPrereqs = [
        ['l11_08'],
        ['l12_01'],
        ['l12_02'],
        ['l12_03'],
        ['l12_04'],
        ['l12_05'],
        ['l12_06'],
        ['l12_07'],
      ];

      for (int i = 1; i <= 8; i++) {
        final lessonId = 'l12_${i.toString().padLeft(2, '0')}';
        final file = File('assets/curriculum/lessons/$lessonId.json');
        final jsonMap =
            jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
        final lesson = Lesson.fromJson(jsonMap);

        expect(lesson.prerequisites, equals(expectedPrereqs[i - 1]));
      }
    });
  });
}
