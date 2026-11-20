class AppSettings {
  final bool immersiveLessonMode;
  final bool soundEnabled;
  final bool highContrast;
  final double uiScale;

  const AppSettings({
    this.immersiveLessonMode = false,
    this.soundEnabled = true,
    this.highContrast = false,
    this.uiScale = 0.0,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      immersiveLessonMode: json['immersiveLessonMode'] as bool? ?? false,
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      highContrast: json['highContrast'] as bool? ?? false,
      uiScale: (json['uiScale'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'immersiveLessonMode': immersiveLessonMode,
        'soundEnabled': soundEnabled,
        'highContrast': highContrast,
        'uiScale': uiScale,
      };

  AppSettings copyWith({
    bool? immersiveLessonMode,
    bool? soundEnabled,
    bool? highContrast,
    double? uiScale,
  }) {
    return AppSettings(
      immersiveLessonMode: immersiveLessonMode ?? this.immersiveLessonMode,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      highContrast: highContrast ?? this.highContrast,
      uiScale: uiScale ?? this.uiScale,
    );
  }
}
