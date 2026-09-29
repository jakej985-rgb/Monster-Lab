enum DifficultyTier { rookie, builder, engineer, monsterMaster }

enum StepType {
  story,
  visualExplanation,
  physicalTask,
  interactiveWiring,
  codeExperiment,
  quizCheckpoint
}

class LessonStep {
  final String stepId;
  final String title;
  final StepType type;
  final String markdownContent;
  final String? illustrationAsset;
  final String? interactiveWidgetType;
  final Map<String, dynamic>? interactiveConfig;

  const LessonStep({
    required this.stepId,
    required this.title,
    required this.type,
    required this.markdownContent,
    this.illustrationAsset,
    this.interactiveWidgetType,
    this.interactiveConfig,
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
      };
}

class Lesson {
  final String id;
  final String title;
  final String summary;
  final DifficultyTier tier;
  final int estimatedMinutes;
  final List<String> prerequisites;
  final List<String> componentIds;
  final List<LessonStep> steps;
  final int xpReward;

  const Lesson({
    required this.id,
    required this.title,
    required this.summary,
    required this.tier,
    required this.estimatedMinutes,
    required this.prerequisites,
    required this.componentIds,
    required this.steps,
    required this.xpReward,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] as String,
      title: json['title'] as String,
      summary: json['summary'] as String,
      tier: DifficultyTier.values.byName(json['tier'] as String),
      estimatedMinutes: json['estimatedMinutes'] as int,
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
        'title': title,
        'summary': summary,
        'tier': tier.name,
        'estimatedMinutes': estimatedMinutes,
        'prerequisites': prerequisites,
        'componentIds': componentIds,
        'steps': steps.map((s) => s.toJson()).toList(),
        'xpReward': xpReward,
      };
}
