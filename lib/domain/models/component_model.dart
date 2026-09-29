enum OperatingVoltage { v3_3, v5, dual }

enum PinType {
  power,
  ground,
  digitalIn,
  digitalOut,
  analogIn,
  i2c,
  spi,
  uart,
  passive
}

enum SafetyLevel { safe, caution, restrictedAdultSupervision }

class PinDefinition {
  final String pinName;
  final PinType type;
  final String description;

  const PinDefinition({
    required this.pinName,
    required this.type,
    required this.description,
  });

  factory PinDefinition.fromJson(Map<String, dynamic> json) {
    return PinDefinition(
      pinName: json['pinName'] as String,
      type: PinType.values.byName(json['type'] as String),
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'pinName': pinName,
        'type': type.name,
        'description': description,
      };
}

class SafetyClassification {
  final SafetyLevel level;
  final List<String> hazards;
  final String? childSafeAlternative;
  final bool requiresParentUnlock;

  const SafetyClassification({
    required this.level,
    required this.hazards,
    this.childSafeAlternative,
    required this.requiresParentUnlock,
  });

  factory SafetyClassification.fromJson(Map<String, dynamic> json) {
    return SafetyClassification(
      level: SafetyLevel.values.byName(json['level'] as String),
      hazards: List<String>.from(json['hazards'] as List),
      childSafeAlternative: json['childSafeAlternative'] as String?,
      requiresParentUnlock: json['requiresParentUnlock'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
        'level': level.name,
        'hazards': hazards,
        'childSafeAlternative': childSafeAlternative,
        'requiresParentUnlock': requiresParentUnlock,
      };
}

class ComponentModel {
  final String id;
  final int peripheralNumber;
  final String name;
  final String partNumber;
  final String category;
  final String description;
  final String realWorldAnalogy;
  final OperatingVoltage voltage;
  final List<PinDefinition> pinout;
  final String? datasheetRef;
  final SafetyClassification safety;
  final List<String> projectIds;
  final String? wiringGuidance;
  final List<String> commonMistakes;
  final Map<String, dynamic>? miniExperiment;

  const ComponentModel({
    required this.id,
    required this.peripheralNumber,
    required this.name,
    required this.partNumber,
    required this.category,
    required this.description,
    required this.realWorldAnalogy,
    required this.voltage,
    required this.pinout,
    this.datasheetRef,
    required this.safety,
    required this.projectIds,
    this.wiringGuidance,
    this.commonMistakes = const [],
    this.miniExperiment,
  });

  factory ComponentModel.fromJson(Map<String, dynamic> json) {
    return ComponentModel(
      id: json['id'] as String,
      peripheralNumber: json['peripheralNumber'] as int,
      name: json['name'] as String,
      partNumber: json['partNumber'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      realWorldAnalogy: json['realWorldAnalogy'] as String,
      voltage: OperatingVoltage.values.byName(json['voltage'] as String),
      pinout: (json['pinout'] as List)
          .map((p) => PinDefinition.fromJson(p as Map<String, dynamic>))
          .toList(),
      datasheetRef: json['datasheetRef'] as String?,
      safety:
          SafetyClassification.fromJson(json['safety'] as Map<String, dynamic>),
      projectIds: List<String>.from(json['projectIds'] as List),
      wiringGuidance: json['wiringGuidance'] as String?,
      commonMistakes: List<String>.from(json['commonMistakes'] as List? ?? []),
      miniExperiment: json['miniExperiment'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'peripheralNumber': peripheralNumber,
        'name': name,
        'partNumber': partNumber,
        'category': category,
        'description': description,
        'realWorldAnalogy': realWorldAnalogy,
        'voltage': voltage.name,
        'pinout': pinout.map((p) => p.toJson()).toList(),
        'datasheetRef': datasheetRef,
        'safety': safety.toJson(),
        'projectIds': projectIds,
        if (wiringGuidance != null) 'wiringGuidance': wiringGuidance,
        'commonMistakes': commonMistakes,
        if (miniExperiment != null) 'miniExperiment': miniExperiment,
      };
}
