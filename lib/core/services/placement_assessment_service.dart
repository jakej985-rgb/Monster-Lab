import '../../domain/models/lesson_model.dart';

class PlacementQuestion {
  final String id;
  final String topic; // 'circuits', 'code', 'hardware'
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const PlacementQuestion({
    required this.id,
    required this.topic,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}

class PlacementEvaluationResult {
  final int correctCount;
  final int totalQuestions;
  final double scoreRatio;
  final DifficultyTier recommendedTier;
  final String suggestedStartingCourseId;
  final List<String> unlockedCourseIds;
  final String rationale;
  final Map<String, double> topicScores;

  const PlacementEvaluationResult({
    required this.correctCount,
    required this.totalQuestions,
    required this.scoreRatio,
    required this.recommendedTier,
    required this.suggestedStartingCourseId,
    required this.unlockedCourseIds,
    required this.rationale,
    required this.topicScores,
  });
}

class PlacementAssessmentService {
  static const List<PlacementQuestion> diagnosticQuestions = [
    PlacementQuestion(
      id: 'q_circuit_loop',
      topic: 'circuits',
      question:
          'What is required for electricity to flow through an LED safely?',
      options: [
        'A complete closed circuit with a current-limiting resistor',
        'Just connecting both wires to 5V power',
        'Leaving the ground wire disconnected',
        'No wires at all, electricity travels through air',
      ],
      correctIndex: 0,
      explanation:
          'Electricity requires a closed loop return to GND, and LEDs need resistors to prevent burning out.',
    ),
    PlacementQuestion(
      id: 'q_code_loop',
      topic: 'code',
      question:
          'In an Arduino sketch, how many times does the setup() function run?',
      options: [
        'Once when the board powers up or resets',
        'Continuously forever in a loop',
        'Every time an LED turns on',
        'Never, setup() is optional',
      ],
      correctIndex: 0,
      explanation:
          'setup() executes exactly once at startup to configure pin modes and serial ports.',
    ),
    PlacementQuestion(
      id: 'q_sensor_analog',
      topic: 'hardware',
      question:
          'Which Arduino pin reads varying brightness from a light sensor (LDR)?',
      options: [
        'An Analog Input pin (A0 - A5)',
        'A Digital Output pin (D13)',
        'The GND pin',
        'The Reset pin',
      ],
      correctIndex: 0,
      explanation:
          'Analog pins convert continuous voltage levels (0-5V) into numerical values (0-1023).',
    ),
    PlacementQuestion(
      id: 'q_code_conditional',
      topic: 'code',
      question: 'What command checks whether a button is currently pressed?',
      options: [
        'if (digitalRead(buttonPin) == HIGH)',
        'digitalWrite(buttonPin, LOW)',
        'pinMode(buttonPin, OUTPUT)',
        'Serial.println(buttonPin)',
      ],
      correctIndex: 0,
      explanation:
          'digitalRead() inspects the instantaneous electrical state of an input pin.',
    ),
    PlacementQuestion(
      id: 'q_circuit_short',
      topic: 'circuits',
      question:
          'What happens if 5V is connected directly to GND without any load?',
      options: [
        'A short circuit that causes extreme current and thermal danger',
        'The microcontroller runs twice as fast',
        'Nothing happens, it is completely safe',
        'The LED glows brighter',
      ],
      correctIndex: 0,
      explanation:
          'Direct 5V to GND creates a short circuit, drawing maximum current and triggering thermal shutdown.',
    ),
  ];

  /// Evaluates learner responses to the diagnostic assessment
  static PlacementEvaluationResult evaluateAnswers(Map<String, int> answers) {
    int correct = 0;
    final topicCorrect = <String, int>{};
    final topicTotal = <String, int>{};

    for (final q in diagnosticQuestions) {
      topicTotal[q.topic] = (topicTotal[q.topic] ?? 0) + 1;
      final selected = answers[q.id];
      if (selected != null && selected == q.correctIndex) {
        correct++;
        topicCorrect[q.topic] = (topicCorrect[q.topic] ?? 0) + 1;
      }
    }

    final total = diagnosticQuestions.length;
    final ratio = total > 0 ? (correct / total) : 0.0;

    final topicScores = <String, double>{};
    for (final topic in topicTotal.keys) {
      final tCorrect = topicCorrect[topic] ?? 0;
      final tTotal = topicTotal[topic]!;
      topicScores[topic] = tTotal > 0 ? (tCorrect / tTotal) : 0.0;
    }

    DifficultyTier recommendedTier;
    String startingCourseId;
    List<String> unlockedCourses;
    String rationale;

    if (ratio >= 0.8) {
      recommendedTier = DifficultyTier.engineer;
      startingCourseId = 'lesson_05';
      unlockedCourses = [
        'lesson_01',
        'coding_foundations',
        'lesson_02',
        'lesson_03',
        'lesson_04'
      ];
      rationale =
          'Superstar engineer! You demonstrated advanced understanding of circuits and code logic. You are placed in Maker tier and can jump directly to advanced sensors and multi-sensor systems.';
    } else if (ratio >= 0.4) {
      recommendedTier = DifficultyTier.builder;
      startingCourseId = 'coding_foundations';
      unlockedCourses = ['lesson_01'];
      rationale =
          'Great start! You know circuit basics and are ready to master embedded C++ syntax and control structures. You are placed in Builder tier.';
    } else {
      recommendedTier = DifficultyTier.rookie;
      startingCourseId = 'lesson_01';
      unlockedCourses = [];
      rationale =
          'Welcome to Monster Lab! We will start at the very beginning with fundamentals of electricity, LEDs, and breadboards. You are placed in Rookie tier.';
    }

    return PlacementEvaluationResult(
      correctCount: correct,
      totalQuestions: total,
      scoreRatio: ratio,
      recommendedTier: recommendedTier,
      suggestedStartingCourseId: startingCourseId,
      unlockedCourseIds: unlockedCourses,
      rationale: rationale,
      topicScores: topicScores,
    );
  }
}
