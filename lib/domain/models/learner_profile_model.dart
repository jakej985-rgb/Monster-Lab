enum AgeBracket { ages7_9, ages10_12, ages13Plus }

class ProfileSettings {
  final bool soundEffectsEnabled;
  final bool voiceNarrationEnabled;
  final double textScalingFactor;
  final bool highContrastMode;

  const ProfileSettings({
    this.soundEffectsEnabled = true,
    this.voiceNarrationEnabled = false,
    this.textScalingFactor = 1.0,
    this.highContrastMode = false,
  });

  factory ProfileSettings.fromJson(Map<String, dynamic> json) {
    return ProfileSettings(
      soundEffectsEnabled: json['soundEffectsEnabled'] as bool? ?? true,
      voiceNarrationEnabled: json['voiceNarrationEnabled'] as bool? ?? false,
      textScalingFactor: (json['textScalingFactor'] as num?)?.toDouble() ?? 1.0,
      highContrastMode: json['highContrastMode'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'soundEffectsEnabled': soundEffectsEnabled,
        'voiceNarrationEnabled': voiceNarrationEnabled,
        'textScalingFactor': textScalingFactor,
        'highContrastMode': highContrastMode,
      };
}

class LearnerProfileModel {
  final String id;
  final String nickname;
  final String avatarId;
  final AgeBracket ageBracket;
  final DateTime createdAt;
  final DateTime lastActiveAt;
  final ProfileSettings settings;

  const LearnerProfileModel({
    required this.id,
    required this.nickname,
    required this.avatarId,
    required this.ageBracket,
    required this.createdAt,
    required this.lastActiveAt,
    this.settings = const ProfileSettings(),
  });

  factory LearnerProfileModel.fromJson(Map<String, dynamic> json) {
    return LearnerProfileModel(
      id: json['id'] as String,
      nickname: json['nickname'] as String,
      avatarId: json['avatarId'] as String,
      ageBracket: AgeBracket.values.byName(json['ageBracket'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastActiveAt: DateTime.parse(json['lastActiveAt'] as String),
      settings: json['settings'] != null
          ? ProfileSettings.fromJson(json['settings'] as Map<String, dynamic>)
          : const ProfileSettings(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nickname': nickname,
        'avatarId': avatarId,
        'ageBracket': ageBracket.name,
        'createdAt': createdAt.toIso8601String(),
        'lastActiveAt': lastActiveAt.toIso8601String(),
        'settings': settings.toJson(),
      };

  LearnerProfileModel copyWith({
    String? nickname,
    String? avatarId,
    AgeBracket? ageBracket,
    DateTime? lastActiveAt,
    ProfileSettings? settings,
  }) {
    return LearnerProfileModel(
      id: id,
      nickname: nickname ?? this.nickname,
      avatarId: avatarId ?? this.avatarId,
      ageBracket: ageBracket ?? this.ageBracket,
      createdAt: createdAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      settings: settings ?? this.settings,
    );
  }
}
