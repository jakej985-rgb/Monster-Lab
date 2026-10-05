class AppSettings {
  final bool immersiveLessonMode;
  final bool soundEnabled;
  final bool highContrast;

  const AppSettings({
    this.immersiveLessonMode = false,
    this.soundEnabled = true,
    this.highContrast = false,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      immersiveLessonMode: json['immersiveLessonMode'] as bool? ?? false,
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      highContrast: json['highContrast'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'immersiveLessonMode': immersiveLessonMode,
        'soundEnabled': soundEnabled,
        'highContrast': highContrast,
      };

  AppSettings copyWith({
    bool? immersiveLessonMode,
    bool? soundEnabled,
    bool? highContrast,
  }) {
    return AppSettings(
      immersiveLessonMode: immersiveLessonMode ?? this.immersiveLessonMode,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      highContrast: highContrast ?? this.highContrast,
    );
  }
}
