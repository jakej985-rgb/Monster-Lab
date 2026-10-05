import 'dart:convert';
import 'package:monster_lab/core/services/storage_service.dart';
import 'package:monster_lab/domain/models/app_settings.dart';

class SettingsDataSource {
  static const _settingsKey = 'monster_lab_settings';
  final StorageService _storageService;

  SettingsDataSource(this._storageService);

  AppSettings getSettings() {
    final jsonStr = _storageService.getString(_settingsKey);
    if (jsonStr != null) {
      try {
        final json = jsonDecode(jsonStr) as Map<String, dynamic>;
        return AppSettings.fromJson(json);
      } catch (_) {
        // Fallback to default
      }
    }
    return const AppSettings();
  }

  Future<void> saveSettings(AppSettings settings) async {
    final jsonStr = jsonEncode(settings.toJson());
    await _storageService.setString(_settingsKey, jsonStr);
  }
}
