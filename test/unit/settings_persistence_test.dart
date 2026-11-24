import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monster_lab/core/services/storage_service.dart';
import 'package:monster_lab/data/datasources/settings_datasource.dart';
import 'package:monster_lab/data/repositories/settings_repository_impl.dart';
import 'package:monster_lab/domain/models/app_settings.dart';
import 'package:monster_lab/presentation/shared/providers.dart';

void main() {
  group('Settings Persistence Tests', () {
    test('Default settings are immersive=false, sound=true, highContrast=false',
        () async {
      SharedPreferences.setMockInitialValues({});
      final storage = await StorageService.init();
      final ds = SettingsDataSource(storage);
      final repo = SettingsRepositoryImpl(ds);

      final settings = repo.getSettings();
      expect(settings.immersiveLessonMode, isFalse);
      expect(settings.soundEnabled, isTrue);
      expect(settings.highContrast, isFalse);
    });

    test('Updating immersive lesson mode persists across reload', () async {
      SharedPreferences.setMockInitialValues({});
      final storage = await StorageService.init();
      final ds = SettingsDataSource(storage);
      final repo = SettingsRepositoryImpl(ds);

      await repo.setImmersiveLessonMode(true);
      expect(repo.getSettings().immersiveLessonMode, isTrue);

      // Re-create repository and verify persisted state
      final ds2 = SettingsDataSource(storage);
      final repo2 = SettingsRepositoryImpl(ds2);
      expect(repo2.getSettings().immersiveLessonMode, isTrue);
    });

    test('Updating sound and contrast persists correctly', () async {
      SharedPreferences.setMockInitialValues({});
      final storage = await StorageService.init();
      final ds = SettingsDataSource(storage);
      final repo = SettingsRepositoryImpl(ds);

      await repo.setSoundEnabled(false);
      await repo.setHighContrast(true);

      final settings = repo.getSettings();
      expect(settings.soundEnabled, isFalse);
      expect(settings.highContrast, isTrue);
    });

    test('Updating uiScale persists and reloads correctly', () async {
      SharedPreferences.setMockInitialValues({});
      final storage = await StorageService.init();
      final ds = SettingsDataSource(storage);
      final repo = SettingsRepositoryImpl(ds);

      expect(repo.getSettings().uiScale, 0.0);

      await repo.setUiScale(0.80);
      expect(repo.getSettings().uiScale, 0.80);

      final ds2 = SettingsDataSource(storage);
      final repo2 = SettingsRepositoryImpl(ds2);
      expect(repo2.getSettings().uiScale, 0.80);
    });

    test('Updating themeMode and themePreset persists and reloads correctly',
        () async {
      SharedPreferences.setMockInitialValues({});
      final storage = await StorageService.init();
      final ds = SettingsDataSource(storage);
      final repo = SettingsRepositoryImpl(ds);

      expect(repo.getSettings().themeMode, 'system');
      expect(repo.getSettings().themePreset, 'default');

      await repo.setThemeMode('dark');
      await repo.setThemePreset('mint');

      expect(repo.getSettings().themeMode, 'dark');
      expect(repo.getSettings().themePreset, 'mint');

      final ds2 = SettingsDataSource(storage);
      final repo2 = SettingsRepositoryImpl(ds2);
      expect(repo2.getSettings().themeMode, 'dark');
      expect(repo2.getSettings().themePreset, 'mint');
    });

    test(
        'defaultUiScale returns AppSettings.desktopAutoUiScale for desktop and 1.0 for web/mobile',
        () {
      expect(defaultUiScale(isDesktopOverride: true),
          AppSettings.desktopAutoUiScale);
      expect(defaultUiScale(isDesktopOverride: false), 1.0);
    });

    test('SettingsNotifier zoomIn and zoomOut respects baseScale from unset',
        () async {
      SharedPreferences.setMockInitialValues({});
      final storage = await StorageService.init();
      final ds = SettingsDataSource(storage);
      final repo = SettingsRepositoryImpl(ds);
      final notifier = SettingsNotifier(repo);

      // On desktop configured baseline from Auto
      expect(defaultUiScale(isDesktopOverride: true), 1.0);
      await notifier.zoomIn(baseScale: AppSettings.desktopAutoUiScale);
      expect(notifier.state.uiScale, 1.05);

      await notifier.resetZoom();
      expect(notifier.state.uiScale, 0.0);

      await notifier.zoomOut(baseScale: AppSettings.desktopAutoUiScale);
      expect(notifier.state.uiScale, 0.95);

      // Verify reset zoom returns to auto (0.0), with next zoomIn starting from auto baseline
      await notifier.resetZoom();
      expect(notifier.state.uiScale, 0.0);
      await notifier.zoomIn();
      expect(notifier.state.uiScale, 1.05);
    });
  });
}
