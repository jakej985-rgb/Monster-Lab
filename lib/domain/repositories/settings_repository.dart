import 'package:monster_lab/domain/models/app_settings.dart';

abstract class SettingsRepository {
  AppSettings getSettings();
  Future<void> saveSettings(AppSettings settings);
  Future<void> setImmersiveLessonMode(bool value);
  Future<void> setSoundEnabled(bool value);
  Future<void> setHighContrast(bool value);
  Future<void> setUiScale(double value);
}
