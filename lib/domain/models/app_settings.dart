class AppSettings {
  final bool immersiveLessonMode;
  final bool soundEnabled;
  final bool highContrast;
  final double uiScale;
  final String themeMode; // 'system', 'light', 'dark'
  final String themePreset; // 'default', 'mint'

  const AppSettings({
    this.immersiveLessonMode = false,
    this.soundEnabled = true,
    this.highContrast = false,
    this.uiScale = 0.0,
    this.themeMode = 'system',
    this.themePreset = 'default',
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      immersiveLessonMode: json['immersiveLessonMode'] as bool? ?? false,
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      highContrast: json['highContrast'] as bool? ?? false,
      uiScale: (json['uiScale'] as num?)?.toDouble() ?? 0.0,
      themeMode: json['themeMode'] as String? ?? 'system',
      themePreset: json['themePreset'] as String? ?? 'default',
    );
  }

  Map<String, dynamic> toJson() => {
        'immersiveLessonMode': immersiveLessonMode,
        'soundEnabled': soundEnabled,
        'highContrast': highContrast,
        'uiScale': uiScale,
        'themeMode': themeMode,
        'themePreset': themePreset,
      };

  AppSettings copyWith({
    bool? immersiveLessonMode,
    bool? soundEnabled,
    bool? highContrast,
    double? uiScale,
    String? themeMode,
    String? themePreset,
  }) {
    return AppSettings(
      immersiveLessonMode: immersiveLessonMode ?? this.immersiveLessonMode,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      highContrast: highContrast ?? this.highContrast,
      uiScale: uiScale ?? this.uiScale,
      themeMode: themeMode ?? this.themeMode,
      themePreset: themePreset ?? this.themePreset,
    );
  }
}
