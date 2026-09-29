import 'package:flutter_test/flutter_test.dart';
import 'package:monster_lab/domain/models/lesson_model.dart';
import 'package:monster_lab/domain/models/component_model.dart';
import 'package:monster_lab/domain/models/learner_progress_model.dart';

void main() {
  group('Domain Models Unit Tests', () {
    test('LessonModel serializes to and from JSON accurately', () {
      const lesson = Lesson(
        id: 'lesson_01',
        title: 'What is Arduino',
        summary: 'Intro to robotics',
        tier: DifficultyTier.rookie,
        estimatedMinutes: 10,
        prerequisites: [],
        componentIds: ['comp_01'],
        steps: [
          LessonStep(
            stepId: 'step_1',
            title: 'Welcome',
            type: StepType.story,
            markdownContent: 'Hello Monster Lab',
          ),
        ],
        xpReward: 50,
      );

      final json = lesson.toJson();
      final reconstructed = Lesson.fromJson(json);

      expect(reconstructed.id, equals('lesson_01'));
      expect(reconstructed.title, equals('What is Arduino'));
      expect(reconstructed.tier, equals(DifficultyTier.rookie));
      expect(reconstructed.steps.length, equals(1));
      expect(reconstructed.steps.first.title, equals('Welcome'));
      expect(reconstructed.xpReward, equals(50));
    });

    test('ComponentModel parses pinout and safety metadata correctly', () {
      const component = ComponentModel(
        id: 'comp_01',
        peripheralNumber: 1,
        name: 'Ultrasonic Sensor',
        partNumber: 'HC-SR04',
        category: 'sensor',
        description: 'Measures distance',
        realWorldAnalogy: 'Bat sonar',
        voltage: OperatingVoltage.v5,
        pinout: [
          PinDefinition(
              pinName: 'TRIG',
              type: PinType.digitalOut,
              description: 'Trigger pulse'),
        ],
        safety: SafetyClassification(
          level: SafetyLevel.safe,
          hazards: [],
          requiresParentUnlock: false,
        ),
        projectIds: ['proj_01'],
      );

      final json = component.toJson();
      final reconstructed = ComponentModel.fromJson(json);

      expect(reconstructed.peripheralNumber, equals(1));
      expect(reconstructed.partNumber, equals('HC-SR04'));
      expect(reconstructed.voltage, equals(OperatingVoltage.v5));
      expect(reconstructed.pinout.first.pinName, equals('TRIG'));
      expect(reconstructed.safety.level, equals(SafetyLevel.safe));
    });

    test(
        'LearnerProgressModel accurately computes level and next level XP threshold',
        () {
      // Level 1 at 0 XP
      final progressL1 = LearnerProgressModel(
        learnerId: 'test_1',
        totalXp: 0,
        lastSessionDate: DateTime.now(),
      );
      expect(progressL1.currentLevel, equals(1));

      // Level 2 requires floor(sqrt(50/50)) + 1 = 2
      final progressL2 = LearnerProgressModel(
        learnerId: 'test_1',
        totalXp: 50,
        lastSessionDate: DateTime.now(),
      );
      expect(progressL2.currentLevel, equals(2));

      // Level 5 requires 800 XP: floor(sqrt(800/50)) + 1 = floor(sqrt(16)) + 1 = 5
      final progressL5 = LearnerProgressModel(
        learnerId: 'test_1',
        totalXp: 800,
        lastSessionDate: DateTime.now(),
      );
      expect(progressL5.currentLevel, equals(5));
      expect(progressL5.levelProgressRatio, inInclusiveRange(0.0, 1.0));
    });
  });
}
