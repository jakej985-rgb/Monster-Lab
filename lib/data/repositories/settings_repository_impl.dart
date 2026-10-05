import 'package:monster_lab/data/datasources/settings_datasource.dart';
import 'package:monster_lab/domain/models/app_settings.dart';
import 'package:monster_lab/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsDataSource _dataSource;

  SettingsRepositoryImpl(this._dataSource);

  @override
  AppSettings getSettings() {
    return _dataSource.getSettings();
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    await _dataSource.saveSettings(settings);
  }

  @override
  Future<void> setImmersiveLessonMode(bool value) async {
    final settings = getSettings().copyWith(immersiveLessonMode: value);
    await saveSettings(settings);
  }

  @override
  Future<void> setSoundEnabled(bool value) async {
    final settings = getSettings().copyWith(soundEnabled: value);
    await saveSettings(settings);
  }

  @override
  Future<void> setHighContrast(bool value) async {
    final settings = getSettings().copyWith(highContrast: value);
    await saveSettings(settings);
  }
}
