import 'package:flutter_test/flutter_test.dart';
import 'package:monster_lab/core/curriculum/curriculum_migration_service.dart';
import 'package:monster_lab/core/curriculum/curriculum_validator.dart';
import 'package:monster_lab/core/services/adaptive_recommendation_service.dart';
import 'package:monster_lab/core/services/competency_progression_service.dart';
import 'package:monster_lab/core/services/parent_data_service.dart';
import 'package:monster_lab/core/services/placement_assessment_service.dart';
import 'package:monster_lab/domain/models/course_model.dart';
import 'package:monster_lab/domain/models/interactive_experiment_model.dart';
import 'package:monster_lab/domain/models/learner_profile_model.dart';
import 'package:monster_lab/domain/models/learner_progress_model.dart';
import 'package:monster_lab/domain/models/lesson_model.dart';
import 'package:monster_lab/domain/models/project_model.dart';

void main() {
  group(
      'Educational Experience & Curriculum Expansion Suite (Parent #9, Issues #52-#59)',
      () {
    // --- Issue #52: Competency & Skill Progression Tracking ---
    group('Issue #52: Competency and Skill Progression Tracking', () {
      test('Evaluates verified completions across 6 STEM competency tracks',
          () {
        final progress = LearnerProgressModel(
          learnerId: 'learner_comp_01',
          completedLessonIds: const {'l01_01', 'l01_02', 'l01_05'},
          completedProjectIds: const {'proj_01'},
          solvedChallengeIds: const {'chal_01', 'chal_09'},
          totalXp: 250,
          lastSessionDate: DateTime.now(),
        );

        final tracks =
            CompetencyProgressionService.evaluateCompetencies(progress);
        expect(tracks.length, equals(6));

        final circuits =
            tracks.firstWhere((t) => t.id == 'competency_circuitry');
        expect(circuits.completedItems, equals(6));
        expect(circuits.totalItems, equals(6));
        expect(circuits.progressRatio, equals(1.0));
        expect(circuits.masteryLevel, equals(SkillMasteryLevel.master));
        expect(circuits.verifiedOutcomes, isNotEmpty);
      });

      test(
          'Novice learner with zero completions begins at Novice level across tracks',
          () {
        final progress = LearnerProgressModel(
          learnerId: 'starter_kid',
          totalXp: 0,
          lastSessionDate: DateTime.now(),
        );

        final tracks =
            CompetencyProgressionService.evaluateCompetencies(progress);
        for (final t in tracks) {
          expect(t.progressRatio, equals(0.0));
          expect(t.masteryLevel, equals(SkillMasteryLevel.novice));
        }
      });
    });

    // --- Issue #53: Diagnostic Pre-Tests & Placement Assessment ---
    group('Issue #53: Diagnostic Pre-Tests & Placement Assessment', () {
      test(
          'Scoring all questions correctly places learner in Maker tier with explainable rationale',
          () {
        final answers = {
          'q_circuit_loop': 0,
          'q_code_loop': 0,
          'q_sensor_analog': 0,
          'q_code_conditional': 0,
          'q_circuit_short': 0,
        };

        final result = PlacementAssessmentService.evaluateAnswers(answers);
        expect(result.correctCount, equals(5));
        expect(result.scoreRatio, equals(1.0));
        expect(result.recommendedTier, equals(DifficultyTier.engineer));
        expect(result.suggestedStartingCourseId, equals('lesson_05'));
        expect(result.rationale, contains('Superstar engineer'));
        expect(result.topicScores['circuits'], equals(1.0));
      });

      test('Intermediate scoring places learner in Builder tier', () {
        final answers = {
          'q_circuit_loop': 0,
          'q_code_loop': 0,
          'q_sensor_analog': 1, // incorrect
          'q_code_conditional': 1, // incorrect
          'q_circuit_short': 1, // incorrect
        };

        final result = PlacementAssessmentService.evaluateAnswers(answers);
        expect(result.correctCount, equals(2));
        expect(result.scoreRatio, equals(0.4));
        expect(result.recommendedTier, equals(DifficultyTier.builder));
        expect(result.suggestedStartingCourseId, equals('coding_foundations'));
      });

      test(
          'Beginner scoring places learner in Rookie tier starting at Course 1',
          () {
        final answers = <String, int>{};

        final result = PlacementAssessmentService.evaluateAnswers(answers);
        expect(result.correctCount, equals(0));
        expect(result.recommendedTier, equals(DifficultyTier.rookie));
        expect(result.suggestedStartingCourseId, equals('lesson_01'));
      });
    });

    // --- Issue #54: Transparent Adaptive Recommendations ---
    group('Issue #54: Transparent Adaptive Lesson Recommendations', () {
      const sampleCourse = CourseModel(
        id: 'lesson_01',
        title: 'Electricity Fundamentals',
        summary: 'Basics of electricity',
        lessonIds: ['l01_01', 'l01_02', 'l01_03'],
        prerequisites: [],
        xpReward: 100,
        estimatedMinutes: 45,
      );

      const lesson1 = Lesson(
        id: 'l01_01',
        courseId: 'lesson_01',
        sortOrder: 1,
        title: 'Closed Circuits',
        summary: 'How electrons flow',
        tier: DifficultyTier.rookie,
        estimatedMinutes: 10,
        prerequisites: [],
        componentIds: [],
        steps: [
          LessonStep(
            stepId: 's1',
            title: 'Intro',
            type: StepType.story,
            markdownContent: 'Intro text',
          )
        ],
        xpReward: 25,
      );

      const lesson2 = Lesson(
        id: 'l01_02',
        courseId: 'lesson_01',
        sortOrder: 2,
        title: 'Ohm\'s Law & Resistance',
        summary: 'Controlling current',
        tier: DifficultyTier.rookie,
        estimatedMinutes: 15,
        prerequisites: ['l01_01'],
        componentIds: [],
        steps: [
          LessonStep(
            stepId: 's1',
            title: 'Intro',
            type: StepType.story,
            markdownContent: 'Intro text',
          )
        ],
        xpReward: 30,
      );

      test(
          'Recommends second lesson when first lesson is completed with transparent rationale',
          () {
        final progress = LearnerProgressModel(
          learnerId: 'learner_rec_01',
          completedLessonIds: const {'l01_01'},
          totalXp: 25,
          lastSessionDate: DateTime.now(),
        );

        final rec = AdaptiveRecommendationService.recommendNextActivity(
          progress: progress,
          courses: [sampleCourse],
          allLessons: [lesson1, lesson2],
        );

        expect(rec.type, equals(RecommendationType.lesson));
        expect(rec.targetId, equals('l01_02'));
        expect(rec.title, equals('Ohm\'s Law & Resistance'));
        expect(rec.reason, contains('Because you completed'));
      });

      test(
          'Avoids prerequisite bypass: does not recommend lesson 2 if lesson 1 is not completed',
          () {
        final progress = LearnerProgressModel(
          learnerId: 'learner_fresh',
          totalXp: 0,
          lastSessionDate: DateTime.now(),
        );

        final rec = AdaptiveRecommendationService.recommendNextActivity(
          progress: progress,
          courses: [sampleCourse],
          allLessons: [lesson1, lesson2],
        );

        expect(rec.targetId, equals('l01_01')); // Must start at lesson 1
        expect(rec.reason, contains('Ready to start'));
      });
    });

    // --- Issue #55: Reusable Interactive Experiment Definitions ---
    group('Issue #55: Reusable Interactive Experiment Definitions', () {
      test('Validates experiment model serialization and constraint validation',
          () {
        const experiment = InteractiveExperimentModel(
          id: 'exp_led_resistor',
          type: ExperimentType.breadboardWiring,
          title: 'Current Limiting Resistor Experiment',
          description:
              'Explore what happens when resistor values change in an LED circuit.',
          difficulty: DifficultyTier.rookie,
          configuration: {
            'resistorValues': [220, 1000, 10000],
            'ledColor': 'red',
          },
          validationRules: [
            ExperimentValidationRule(
              ruleId: 'rule_resistor_present',
              description: 'Resistor must be connected in series',
              conditionType: 'seriesConnection',
            ),
          ],
          hints: ['Check the breadboard tie-points'],
          xpReward: 35,
        );

        final errors = experiment.validate();
        expect(errors, isEmpty);

        final json = experiment.toJson();
        final reconstructed = InteractiveExperimentModel.fromJson(json);
        expect(reconstructed.id, equals('exp_led_resistor'));
        expect(reconstructed.type, equals(ExperimentType.breadboardWiring));
        expect(reconstructed.validationRules.length, equals(1));
      });

      test(
          'Rejects invalid experiment definitions with actionable validation messages',
          () {
        const invalidExp = InteractiveExperimentModel(
          id: '',
          type: ExperimentType.circuitSimulation,
          title: 'X',
          description: '',
          difficulty: DifficultyTier.rookie,
          xpReward: -10,
        );

        final errors = invalidExp.validate();
        expect(errors, contains('Experiment id cannot be empty'));
        expect(
            errors, contains('Experiment title must be at least 3 characters'));
        expect(errors, contains('Experiment description cannot be empty'));
        expect(errors, contains('xpReward cannot be negative'));
      });
    });

    // --- Issue #56: Map Projects to Competencies & Learning Outcomes ---
    group('Issue #56: Map Projects to Competencies and Learning Outcomes', () {
      test(
          'CurriculumValidator accepts Project with valid competencies and learning outcomes',
          () {
        const validProject = ProjectModel(
          id: 'proj_01',
          title: 'Intruder Alarm Monster',
          tagline: 'Ultrasonic motion sentry',
          tier: DifficultyTier.rookie,
          estimatedMinutes: 30,
          requiredComponents: ['comp_01', 'comp_uno'],
          prerequisiteLessons: ['l01_01'],
          phases: [
            BuildPhase(
              phaseNumber: 1,
              phaseTitle: 'Gather Parts',
              type: PhaseType.gatherParts,
              instructions: 'Collect parts',
            ),
            BuildPhase(
              phaseNumber: 2,
              phaseTitle: 'Wire Circuit',
              type: PhaseType.breadboardWiring,
              instructions: 'Connect wires',
            ),
          ],
          competencies: ['competency_circuitry', 'competency_sensors'],
          learningOutcomes: [
            'Wire HC-SR04 ultrasonic sensor safely',
            'Compute obstacle distance from echo duration',
          ],
          xpReward: 100,
        );

        expect(() => CurriculumValidator.validateProject(validProject),
            returnsNormally);
      });

      test(
          'CurriculumValidator rejects empty competency or too-short learning outcomes',
          () {
        const invalidProject = ProjectModel(
          id: 'proj_01',
          title: 'Alarm Monster',
          tagline: 'Tagline',
          tier: DifficultyTier.rookie,
          estimatedMinutes: 30,
          requiredComponents: ['comp_01'],
          prerequisiteLessons: ['l01_01'],
          phases: [
            BuildPhase(
              phaseNumber: 1,
              phaseTitle: 'Phase 1',
              type: PhaseType.gatherParts,
              instructions: 'Instructions',
            ),
            BuildPhase(
              phaseNumber: 2,
              phaseTitle: 'Phase 2',
              type: PhaseType.breadboardWiring,
              instructions: 'Instructions',
            ),
          ],
          competencies: [' '], // Empty competency
          learningOutcomes: ['No'], // < 5 chars
          xpReward: 100,
        );

        expect(
          () => CurriculumValidator.validateProject(invalidProject),
          throwsA(isA<CurriculumValidationException>()),
        );
      });
    });

    // --- Issue #58: Privacy-Conscious Parent Learning Reports ---
    group('Issue #58: Privacy-Conscious Parent Learning Reports', () {
      test(
          'Generates structured offline report with zero sensitive telemetry or PII',
          () {
        final profile = LearnerProfileModel(
          id: 'privacy_kid_01',
          nickname: 'Sparky',
          avatarId: 'dr_volt',
          ageBracket: AgeBracket.ages7_9,
          createdAt: DateTime.now(),
          lastActiveAt: DateTime.now(),
        );

        final progress = LearnerProgressModel(
          learnerId: 'privacy_kid_01',
          completedLessonIds: const {'l01_01', 'l01_02'},
          completedProjectIds: const {'proj_01'},
          earnedBadgeIds: const {'badge_first_spark'},
          totalXp: 150,
          lastSessionDate: DateTime.now(),
        );

        final report =
            ParentDataService.generatePrivacyConsciousReport(profile, progress);

        expect(report['reportType'], equals('ParentLearningSummary'));
        expect(report['learnerAlias'], equals('Sparky'));
        expect(report['avatarId'], equals('dr_volt'));
        expect(report['ageBracket'], equals('ages7_9'));
        expect(report['overview']['totalXp'], equals(150));
        expect(report['competencies'], isNotEmpty);
        expect(report['privacyNotice'],
            contains('strictly never collects, transmits, or shares'));

        // Strict privacy exclusion guarantees: no IP, no email, no device identifiers
        expect(report.containsKey('ipAddress'), isFalse);
        expect(report.containsKey('email'), isFalse);
        expect(report.containsKey('deviceId'), isFalse);
      });
    });

    // --- Issue #59: Curriculum Version Compatibility & Progress Migrations ---
    group('Issue #59: Curriculum Version Compatibility & Progress Migrations',
        () {
      test(
          'Verifies schema compatibility for versions 1 and 2, rejects future v999 safely',
          () {
        expect(CurriculumMigrationService.isVersionCompatible(1), isTrue);
        expect(CurriculumMigrationService.isVersionCompatible(2), isTrue);
        expect(CurriculumMigrationService.isVersionCompatible(999), isFalse);

        expect(
          () => CurriculumMigrationService.migrate({'schemaVersion': 999}),
          throwsA(isA<UnsupportedCurriculumVersionException>()),
        );
      });

      test(
          'Migrates legacy unversioned progress into current version 2 format with applied steps',
          () {
        final legacyPayload = {
          'learnerId': 'migrated_learner',
          'totalXp': 100,
          'completedLessonIds': ['lesson_01'],
          'lastSessionDate': DateTime.now().toIso8601String(),
        };

        final result = CurriculumMigrationService.migrate(legacyPayload);
        expect(result.migrationApplied, isTrue);
        expect(result.initialSchemaVersion, equals(1));
        expect(result.finalSchemaVersion, equals(2));
        expect(result.progress.completedCourseIds, contains('lesson_01'));
        expect(result.appliedMigrationSteps, isNotEmpty);
      });
    });
  });
}
