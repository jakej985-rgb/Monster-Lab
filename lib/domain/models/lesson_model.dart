enum DifficultyTier { rookie, builder, engineer, monsterMaster }

enum StepType {
  story,
  visualExplanation,
  physicalTask,
  interactiveWiring,
  codeExperiment,
  quizCheckpoint,
  placementCheck
}

class QuickCheckQuestion {
  final String questionId;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final String? warmupExplanation;

  const QuickCheckQuestion({
    required this.questionId,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    this.warmupExplanation,
  });

  factory QuickCheckQuestion.fromJson(Map<String, dynamic> json) {
    return QuickCheckQuestion(
      questionId: json['questionId'] as String,
      question: json['question'] as String,
      options: List<String>.from(json['options'] as List),
      correctIndex: json['correctIndex'] as int,
      explanation: json['explanation'] as String,
      warmupExplanation: json['warmupExplanation'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'questionId': questionId,
        'question': question,
        'options': options,
        'correctIndex': correctIndex,
        'explanation': explanation,
        if (warmupExplanation != null) 'warmupExplanation': warmupExplanation,
      };
}

class LessonStep {
  final String stepId;
  final String title;
  final StepType type;
  final String markdownContent;
  final String? illustrationAsset;
  final String? interactiveWidgetType;
  final Map<String, dynamic>? interactiveConfig;
  final List<QuickCheckQuestion>? quickCheck;

  const LessonStep({
    required this.stepId,
    required this.title,
    required this.type,
    required this.markdownContent,
    this.illustrationAsset,
    this.interactiveWidgetType,
    this.interactiveConfig,
    this.quickCheck,
  });

  factory LessonStep.fromJson(Map<String, dynamic> json) {
    return LessonStep(
      stepId: json['stepId'] as String,
      title: json['title'] as String,
      type: StepType.values.byName(json['type'] as String),
      markdownContent: json['markdownContent'] as String,
      illustrationAsset: json['illustrationAsset'] as String?,
      interactiveWidgetType: json['interactiveWidgetType'] as String?,
      interactiveConfig: json['interactiveConfig'] as Map<String, dynamic>?,
      quickCheck: json['quickCheck'] != null
          ? (json['quickCheck'] as List)
              .map(
                  (q) => QuickCheckQuestion.fromJson(q as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'stepId': stepId,
        'title': title,
        'type': type.name,
        'markdownContent': markdownContent,
        'illustrationAsset': illustrationAsset,
        'interactiveWidgetType': interactiveWidgetType,
        'interactiveConfig': interactiveConfig,
        if (quickCheck != null)
          'quickCheck': quickCheck!.map((q) => q.toJson()).toList(),
      };
}

class LessonVocabulary {
  final String term;
  final String pronunciation;
  final String meaning;

  const LessonVocabulary({
    required this.term,
    required this.pronunciation,
    required this.meaning,
  });

  factory LessonVocabulary.fromJson(Map<String, dynamic> json) =>
      LessonVocabulary(
        term: json['term'] as String,
        pronunciation: json['pronunciation'] as String,
        meaning: json['meaning'] as String,
      );

  Map<String, dynamic> toJson() => {
        'term': term,
        'pronunciation': pronunciation,
        'meaning': meaning,
      };
}

class Lesson {
  final String id;
  final String? courseId;
  final String title;
  final String summary;
  final String? learningGoal;
  final List<LessonVocabulary> vocabulary;
  final DifficultyTier tier;
  final int estimatedMinutes;
  final int sortOrder;
  final bool isOptional;
  final List<String> prerequisites;
  final List<String> componentIds;
  final List<LessonStep> steps;
  final int xpReward;

  const Lesson({
    required this.id,
    this.courseId,
    required this.title,
    required this.summary,
    this.learningGoal,
    this.vocabulary = const [],
    required this.tier,
    required this.estimatedMinutes,
    this.sortOrder = 0,
    this.isOptional = false,
    required this.prerequisites,
    required this.componentIds,
    required this.steps,
    required this.xpReward,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] as String,
      courseId: json['courseId'] as String?,
      title: json['title'] as String,
      summary: json['summary'] as String,
      learningGoal: json['learningGoal'] as String?,
      vocabulary: (json['vocabulary'] as List? ?? const [])
          .map(
              (item) => LessonVocabulary.fromJson(item as Map<String, dynamic>))
          .toList(),
      tier: DifficultyTier.values.byName(json['tier'] as String),
      estimatedMinutes: json['estimatedMinutes'] as int,
      sortOrder: json['sortOrder'] as int? ?? 0,
      isOptional: json['isOptional'] as bool? ?? false,
      prerequisites: List<String>.from(json['prerequisites'] as List),
      componentIds: List<String>.from(json['componentIds'] as List),
      steps: (json['steps'] as List)
          .map((s) => LessonStep.fromJson(s as Map<String, dynamic>))
          .toList(),
      xpReward: json['xpReward'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'courseId': courseId,
        'title': title,
        'summary': summary,
        if (learningGoal != null) 'learningGoal': learningGoal,
        if (vocabulary.isNotEmpty)
          'vocabulary': vocabulary.map((item) => item.toJson()).toList(),
        'tier': tier.name,
        'estimatedMinutes': estimatedMinutes,
        'sortOrder': sortOrder,
        'isOptional': isOptional,
        'prerequisites': prerequisites,
        'componentIds': componentIds,
        'steps': steps.map((s) => s.toJson()).toList(),
        'xpReward': xpReward,
      };
}
