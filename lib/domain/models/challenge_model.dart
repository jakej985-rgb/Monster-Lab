import 'lesson_model.dart';
export 'lesson_model.dart' show DifficultyTier;

enum ChallengeType {
  identifyPart,
  predictOutput,
  fixWiring,
  changeCode,
  debugLogic,
  combineComponents,
  buildFromGoal,
  explainWhatHappened
}

class ChallengeModel {
  final String id;
  final String title;
  final ChallengeType type;
  final DifficultyTier difficulty;
  final String prompt;
  final Map<String, dynamic> challengeData;
  final String hint;
  final List<String> hints;
  final String? explanation;
  final String? codeSnippet;
  final String? circuitSnippet;
  final Map<String, dynamic>? solutionValidation;
  final int xpAward;

  const ChallengeModel({
    required this.id,
    required this.title,
    required this.type,
    required this.difficulty,
    required this.prompt,
    required this.challengeData,
    required this.hint,
    this.hints = const [],
    this.explanation,
    this.codeSnippet,
    this.circuitSnippet,
    this.solutionValidation,
    required this.xpAward,
  });

  factory ChallengeModel.fromJson(Map<String, dynamic> json) {
    final singleHint = json['hint'] as String? ?? '';
    final hintsList = json['hints'] != null
        ? List<String>.from(json['hints'] as List)
        : (singleHint.isNotEmpty ? [singleHint] : <String>[]);

    return ChallengeModel(
      id: json['id'] as String,
      title: json['title'] as String,
      type: ChallengeType.values.byName(json['type'] as String),
      difficulty: DifficultyTier.values.byName(json['difficulty'] as String),
      prompt: json['prompt'] as String,
      challengeData: json['challengeData'] as Map<String, dynamic>,
      hint: singleHint.isNotEmpty
          ? singleHint
          : (hintsList.isNotEmpty ? hintsList.first : ''),
      hints: hintsList,
      explanation: json['explanation'] as String?,
      codeSnippet: json['codeSnippet'] as String?,
      circuitSnippet: json['circuitSnippet'] as String?,
      solutionValidation: json['solutionValidation'] as Map<String, dynamic>?,
      xpAward: json['xpAward'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'type': type.name,
        'difficulty': difficulty.name,
        'prompt': prompt,
        'challengeData': challengeData,
        'hint': hint,
        if (hints.isNotEmpty) 'hints': hints,
        if (explanation != null) 'explanation': explanation,
        if (codeSnippet != null) 'codeSnippet': codeSnippet,
        if (circuitSnippet != null) 'circuitSnippet': circuitSnippet,
        'solutionValidation': solutionValidation,
        'xpAward': xpAward,
      };
}

class QuizQuestion {
  final String questionText;
  final String? imageAsset;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;

  const QuizQuestion({
    required this.questionText,
    this.imageAsset,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      questionText: json['questionText'] as String,
      imageAsset: json['imageAsset'] as String?,
      options: List<String>.from(json['options'] as List),
      correctOptionIndex: json['correctOptionIndex'] as int,
      explanation: json['explanation'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'questionText': questionText,
        'imageAsset': imageAsset,
        'options': options,
        'correctOptionIndex': correctOptionIndex,
        'explanation': explanation,
      };
}
