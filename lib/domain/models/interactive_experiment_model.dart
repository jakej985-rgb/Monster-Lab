import 'lesson_model.dart';

enum ExperimentType {
  breadboardWiring,
  codeSandbox,
  sensorTelemetry,
  circuitSimulation,
  logicSwitch,
}

class ExperimentValidationRule {
  final String ruleId;
  final String description;
  final String conditionType;
  final Map<String, dynamic> parameters;

  const ExperimentValidationRule({
    required this.ruleId,
    required this.description,
    required this.conditionType,
    this.parameters = const {},
  });

  factory ExperimentValidationRule.fromJson(Map<String, dynamic> json) {
    return ExperimentValidationRule(
      ruleId: json['ruleId'] as String,
      description: json['description'] as String,
      conditionType: json['conditionType'] as String,
      parameters: json['parameters'] != null
          ? Map<String, dynamic>.from(json['parameters'] as Map)
          : const {},
    );
  }

  Map<String, dynamic> toJson() => {
        'ruleId': ruleId,
        'description': description,
        'conditionType': conditionType,
        'parameters': parameters,
      };
}

class InteractiveExperimentModel {
  final String id;
  final ExperimentType type;
  final String title;
  final String description;
  final DifficultyTier difficulty;
  final Map<String, dynamic> configuration;
  final List<ExperimentValidationRule> validationRules;
  final List<String> hints;
  final int xpReward;

  const InteractiveExperimentModel({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.difficulty,
    this.configuration = const {},
    this.validationRules = const [],
    this.hints = const [],
    this.xpReward = 25,
  });

  factory InteractiveExperimentModel.fromJson(Map<String, dynamic> json) {
    return InteractiveExperimentModel(
      id: json['id'] as String,
      type: ExperimentType.values.byName(json['type'] as String),
      title: json['title'] as String,
      description: json['description'] as String,
      difficulty: json['difficulty'] != null
          ? DifficultyTier.values.byName(json['difficulty'] as String)
          : DifficultyTier.rookie,
      configuration: json['configuration'] != null
          ? Map<String, dynamic>.from(json['configuration'] as Map)
          : const {},
      validationRules: json['validationRules'] != null
          ? (json['validationRules'] as List)
              .map((r) =>
                  ExperimentValidationRule.fromJson(r as Map<String, dynamic>))
              .toList()
          : const [],
      hints: json['hints'] != null
          ? List<String>.from(json['hints'] as List)
          : const [],
      xpReward: json['xpReward'] as int? ?? 25,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'title': title,
        'description': description,
        'difficulty': difficulty.name,
        'configuration': configuration,
        'validationRules': validationRules.map((r) => r.toJson()).toList(),
        'hints': hints,
        'xpReward': xpReward,
      };

  /// Validates an experiment definition for schema correctness
  List<String> validate() {
    final errors = <String>[];
    if (id.trim().isEmpty) errors.add('Experiment id cannot be empty');
    if (title.trim().length < 3) {
      errors.add('Experiment title must be at least 3 characters');
    }
    if (description.trim().isEmpty) {
      errors.add('Experiment description cannot be empty');
    }
    if (xpReward < 0) {
      errors.add('xpReward cannot be negative');
    }
    for (final rule in validationRules) {
      if (rule.ruleId.trim().isEmpty) {
        errors.add('ValidationRule must have a valid ruleId');
      }
      if (rule.conditionType.trim().isEmpty) {
        errors.add("Rule '${rule.ruleId}' missing conditionType");
      }
    }
    return errors;
  }
}
