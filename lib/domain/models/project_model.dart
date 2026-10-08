import 'lesson_model.dart';

enum PhaseType {
  gatherParts,
  breadboardWiring,
  wiringCheck,
  codeReview,
  uploadSketch,
  physicalTest,
  debugTuning,
  missionComplete
}

class BuildPhase {
  final int phaseNumber;
  final String phaseTitle;
  final PhaseType type;
  final String instructions;
  final String? diagramAsset;
  final String? inoSketchPath;
  final String? codeSnippet;
  final String? codeExplanation;
  final String? safetyCallout;
  final List<Map<String, String>> wiringConnections;
  final List<String> verificationCheckpoints;

  const BuildPhase({
    required this.phaseNumber,
    required this.phaseTitle,
    required this.type,
    required this.instructions,
    this.diagramAsset,
    this.inoSketchPath,
    this.codeSnippet,
    this.codeExplanation,
    this.safetyCallout,
    this.wiringConnections = const [],
    this.verificationCheckpoints = const [],
  });

  factory BuildPhase.fromJson(Map<String, dynamic> json) {
    return BuildPhase(
      phaseNumber: json['phaseNumber'] as int,
      phaseTitle: json['phaseTitle'] as String,
      type: PhaseType.values.byName(json['type'] as String),
      instructions: json['instructions'] as String,
      diagramAsset: json['diagramAsset'] as String?,
      inoSketchPath: json['inoSketchPath'] as String?,
      codeSnippet: json['codeSnippet'] as String?,
      codeExplanation: json['codeExplanation'] as String?,
      safetyCallout: json['safetyCallout'] as String?,
      wiringConnections: json['wiringConnections'] != null
          ? (json['wiringConnections'] as List)
              .map((c) => Map<String, String>.from(c as Map))
              .toList()
          : const [],
      verificationCheckpoints: json['verificationCheckpoints'] != null
          ? List<String>.from(json['verificationCheckpoints'] as List)
          : const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'phaseNumber': phaseNumber,
        'phaseTitle': phaseTitle,
        'type': type.name,
        'instructions': instructions,
        'diagramAsset': diagramAsset,
        'inoSketchPath': inoSketchPath,
        if (codeSnippet != null) 'codeSnippet': codeSnippet,
        if (codeExplanation != null) 'codeExplanation': codeExplanation,
        if (safetyCallout != null) 'safetyCallout': safetyCallout,
        if (wiringConnections.isNotEmpty)
          'wiringConnections': wiringConnections,
        'verificationCheckpoints': verificationCheckpoints,
      };
}

class TroubleshootingItem {
  final String symptom;
  final String cause;
  final String solution;
  final String? category;
  final List<String> diagnosticSteps;

  const TroubleshootingItem({
    required this.symptom,
    required this.cause,
    required this.solution,
    this.category,
    this.diagnosticSteps = const [],
  });

  factory TroubleshootingItem.fromJson(Map<String, dynamic> json) {
    return TroubleshootingItem(
      symptom: json['symptom'] as String,
      cause: json['cause'] as String,
      solution: json['solution'] as String,
      category: json['category'] as String?,
      diagnosticSteps: json['diagnosticSteps'] != null
          ? (json['diagnosticSteps'] as List).map((e) => e.toString()).toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'symptom': symptom,
        'cause': cause,
        'solution': solution,
        if (category != null) 'category': category,
        'diagnosticSteps': diagnosticSteps,
      };
}

class ProjectVariant {
  final String id;
  final String title;
  final String description;
  final List<String> alternativeComponents;
  final String wiringDifferences;
  final String codeAdaptation;

  const ProjectVariant({
    required this.id,
    required this.title,
    required this.description,
    this.alternativeComponents = const [],
    required this.wiringDifferences,
    required this.codeAdaptation,
  });

  factory ProjectVariant.fromJson(Map<String, dynamic> json) {
    return ProjectVariant(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      alternativeComponents: json['alternativeComponents'] != null
          ? List<String>.from(json['alternativeComponents'] as List)
          : const [],
      wiringDifferences: json['wiringDifferences'] as String? ?? '',
      codeAdaptation: json['codeAdaptation'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'alternativeComponents': alternativeComponents,
        'wiringDifferences': wiringDifferences,
        'codeAdaptation': codeAdaptation,
      };
}

class EngineeringMission {
  final String id;
  final String title;
  final String objective;
  final DifficultyTier difficulty;
  final List<String> hints;
  final int xpReward;

  const EngineeringMission({
    required this.id,
    required this.title,
    required this.objective,
    required this.difficulty,
    this.hints = const [],
    required this.xpReward,
  });

  factory EngineeringMission.fromJson(Map<String, dynamic> json) {
    return EngineeringMission(
      id: json['id'] as String,
      title: json['title'] as String,
      objective: json['objective'] as String,
      difficulty: json['difficulty'] != null
          ? DifficultyTier.values.byName(json['difficulty'] as String)
          : DifficultyTier.builder,
      hints: json['hints'] != null
          ? List<String>.from(json['hints'] as List)
          : const [],
      xpReward: json['xpReward'] as int? ?? 50,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'objective': objective,
        'difficulty': difficulty.name,
        'hints': hints,
        'xpReward': xpReward,
      };
}

class ProjectModel {
  final String id;
  final String title;
  final String tagline;
  final String? story;
  final DifficultyTier tier;
  final int estimatedMinutes;
  final List<String> requiredComponents;
  final List<String> prerequisiteLessons;
  final List<BuildPhase> phases;
  final List<TroubleshootingItem> troubleshooting;
  final List<ProjectVariant> variants;
  final List<EngineeringMission> extensionMissions;
  final int xpReward;
  final String? badgeRewardId;

  const ProjectModel({
    required this.id,
    required this.title,
    required this.tagline,
    this.story,
    required this.tier,
    required this.estimatedMinutes,
    required this.requiredComponents,
    required this.prerequisiteLessons,
    required this.phases,
    this.troubleshooting = const [],
    this.variants = const [],
    this.extensionMissions = const [],
    required this.xpReward,
    this.badgeRewardId,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as String,
      title: json['title'] as String,
      tagline: json['tagline'] as String,
      story: json['story'] as String?,
      tier: DifficultyTier.values.byName(json['tier'] as String),
      estimatedMinutes: json['estimatedMinutes'] as int,
      requiredComponents: List<String>.from(json['requiredComponents'] as List),
      prerequisiteLessons:
          List<String>.from(json['prerequisiteLessons'] as List),
      phases: (json['phases'] as List)
          .map((p) => BuildPhase.fromJson(p as Map<String, dynamic>))
          .toList(),
      troubleshooting: json['troubleshooting'] != null
          ? (json['troubleshooting'] as List)
              .map((t) =>
                  TroubleshootingItem.fromJson(t as Map<String, dynamic>))
              .toList()
          : const [],
      variants: json['variants'] != null
          ? (json['variants'] as List)
              .map((v) => ProjectVariant.fromJson(v as Map<String, dynamic>))
              .toList()
          : const [],
      extensionMissions: json['extensionMissions'] != null
          ? (json['extensionMissions'] as List)
              .map(
                  (m) => EngineeringMission.fromJson(m as Map<String, dynamic>))
              .toList()
          : const [],
      xpReward: json['xpReward'] as int,
      badgeRewardId: json['badgeRewardId'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'tagline': tagline,
        if (story != null) 'story': story,
        'tier': tier.name,
        'estimatedMinutes': estimatedMinutes,
        'requiredComponents': requiredComponents,
        'prerequisiteLessons': prerequisiteLessons,
        'phases': phases.map((p) => p.toJson()).toList(),
        'troubleshooting': troubleshooting.map((t) => t.toJson()).toList(),
        'variants': variants.map((v) => v.toJson()).toList(),
        'extensionMissions': extensionMissions.map((m) => m.toJson()).toList(),
        'xpReward': xpReward,
        'badgeRewardId': badgeRewardId,
      };
}
