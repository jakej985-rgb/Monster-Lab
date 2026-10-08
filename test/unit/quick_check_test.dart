import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monster_lab/domain/models/lesson_model.dart';
import 'package:monster_lab/domain/models/learner_progress_model.dart';
import 'package:monster_lab/core/curriculum/curriculum_validator.dart';
import 'package:monster_lab/data/repositories/progress_repository_impl.dart';
import 'package:monster_lab/data/datasources/local_storage_datasource.dart';
import 'package:monster_lab/core/services/storage_service.dart';

void main() {
  group('Phase 26: Quick Check Domain & Validation Tests', () {
    test('QuickCheckQuestion serialization and deserialization roundtrip', () {
      const question = QuickCheckQuestion(
        questionId: 'qc_test_01',
        question: 'What does a sensor do?',
        options: [
          'Gathers real-world data',
          'Burns energy',
          'Replaces a battery'
        ],
        correctIndex: 0,
        explanation:
            'A sensor converts physical input into an electrical signal.',
        warmupExplanation:
            'Remember: Sensors read the environment around the robot.',
      );

      final json = question.toJson();
      final restored = QuickCheckQuestion.fromJson(json);

      expect(restored.questionId, equals('qc_test_01'));
      expect(restored.question, equals('What does a sensor do?'));
      expect(restored.options.length, equals(3));
      expect(restored.correctIndex, equals(0));
      expect(restored.explanation, contains('converts physical input'));
      expect(
          restored.warmupExplanation, contains('Sensors read the environment'));
    });

    test('QuickCheckResult serializes ready, warmUp, and notAssessed correctly',
        () {
      final readyResult = QuickCheckResult(
        lessonId: 'lesson_01',
        submoduleId: 'l01_s01',
        questionIds: ['q1', 'q2'],
        selectedAnswers: [0, 1],
        isBypassed: false,
        readiness: QuickCheckReadiness.ready,
        timestamp: DateTime(2026, 10, 8),
      );

      final readyJson = readyResult.toJson();
      final restoredReady = QuickCheckResult.fromJson(readyJson);
      expect(restoredReady.readiness, equals(QuickCheckReadiness.ready));
      expect(restoredReady.isBypassed, isFalse);

      final warmUpResult = QuickCheckResult(
        lessonId: 'lesson_01',
        submoduleId: 'l01_s02',
        questionIds: ['q1', 'q2'],
        selectedAnswers: [1, 1],
        isBypassed: false,
        readiness: QuickCheckReadiness.warmUp,
        timestamp: DateTime(2026, 10, 8),
        warmupShown: true,
      );
      final restoredWarmUp = QuickCheckResult.fromJson(warmUpResult.toJson());
      expect(restoredWarmUp.readiness, equals(QuickCheckReadiness.warmUp));
      expect(restoredWarmUp.warmupShown, isTrue);

      final bypassedResult = QuickCheckResult(
        lessonId: 'lesson_01',
        submoduleId: 'l01_s03',
        questionIds: ['q1', 'q2'],
        selectedAnswers: const [],
        isBypassed: true,
        readiness: QuickCheckReadiness.notAssessed,
        timestamp: DateTime(2026, 10, 8),
      );
      final restoredBypassed =
          QuickCheckResult.fromJson(bypassedResult.toJson());
      expect(
          restoredBypassed.readiness, equals(QuickCheckReadiness.notAssessed));
      expect(restoredBypassed.isBypassed, isTrue);
    });

    test('CurriculumValidator accepts lesson with valid 2-question quickCheck',
        () {
      const validLesson = Lesson(
        id: 'lesson_01',
        title: 'Arduino Fundamentals',
        summary: 'Learn what Arduino is',
        tier: DifficultyTier.rookie,
        estimatedMinutes: 15,
        prerequisites: [],
        componentIds: ['comp_uno'],
        xpReward: 50,
        steps: [
          LessonStep(
            stepId: 'l01_s01',
            title: 'What Is Arduino?',
            type: StepType.story,
            markdownContent: 'Arduino is a microcontroller development board.',
            quickCheck: [
              QuickCheckQuestion(
                questionId: 'qc1',
                question: 'What is a computer chip that controls things?',
                options: ['A microcontroller', 'A battery', 'A plastic gear'],
                correctIndex: 0,
                explanation:
                    'A microcontroller is a tiny computer that controls electronics.',
              ),
              QuickCheckQuestion(
                questionId: 'qc2',
                question: 'Does a computer follow instructions?',
                options: ['Yes, exactly as told', 'No, it guesses randomly'],
                correctIndex: 0,
                explanation:
                    'Programs give the microcontroller exact step-by-step instructions.',
              ),
            ],
          ),
        ],
      );

      expect(() => CurriculumValidator.validateLesson(validLesson),
          returnsNormally);
    });

    test(
        'CurriculumValidator rejects step quickCheck if question count is not 2',
        () {
      const invalidLesson = Lesson(
        id: 'lesson_01',
        title: 'Arduino Fundamentals',
        summary: 'Learn what Arduino is',
        tier: DifficultyTier.rookie,
        estimatedMinutes: 15,
        prerequisites: [],
        componentIds: ['comp_uno'],
        xpReward: 50,
        steps: [
          LessonStep(
            stepId: 'l01_s01',
            title: 'What Is Arduino?',
            type: StepType.story,
            markdownContent: 'Arduino is a microcontroller development board.',
            quickCheck: [
              QuickCheckQuestion(
                questionId: 'qc1',
                question: 'What is a computer chip that controls things?',
                options: ['A microcontroller', 'A battery'],
                correctIndex: 0,
                explanation: 'A microcontroller controls electronics.',
              ),
            ],
          ),
        ],
      );

      expect(
        () => CurriculumValidator.validateLesson(invalidLesson),
        throwsA(isA<CurriculumValidationException>()),
      );
    });

    test(
        'recordQuickCheckResult preserves XP and records readiness in repository',
        () async {
      SharedPreferences.setMockInitialValues({});
      final storage = await StorageService.init();
      final dataSource = LocalStorageDataSource(storage);
      final repo = ProgressRepositoryImpl(dataSource);

      final initialProgress = await repo.getProgress('learner_01');
      expect(initialProgress.totalXp, equals(0));
      expect(initialProgress.quickCheckResults, isEmpty);

      final checkResult = QuickCheckResult(
        lessonId: 'lesson_01',
        submoduleId: 'l01_s01',
        questionIds: ['qc1', 'qc2'],
        selectedAnswers: [0, 0],
        isBypassed: false,
        readiness: QuickCheckReadiness.ready,
        timestamp: DateTime.now(),
      );

      await repo.recordQuickCheckResult('learner_01', checkResult);

      final updatedProgress = await repo.getProgress('learner_01');
      // Crucial: Taking Quick Check never modifies XP
      expect(updatedProgress.totalXp, equals(0));
      expect(updatedProgress.quickCheckResults.containsKey('lesson_01_l01_s01'),
          isTrue);
      expect(
        updatedProgress.quickCheckResults['lesson_01_l01_s01']?.readiness,
        equals(QuickCheckReadiness.ready),
      );
    });
  });
}
