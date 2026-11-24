import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monster_lab/core/services/storage_service.dart';
import 'package:monster_lab/core/theme/app_theme.dart';
import 'package:monster_lab/data/datasources/settings_datasource.dart';
import 'package:monster_lab/data/repositories/settings_repository_impl.dart';
import 'package:monster_lab/presentation/features/settings/settings_screen.dart';
import 'package:monster_lab/presentation/shared/providers.dart';

void main() {
  testWidgets('Sound and High Contrast switches persist from Settings',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final storage = await StorageService.init();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [storageServiceProvider.overrideWithValue(storage)],
        child: const MaterialApp(home: SettingsScreen()),
      ),
    );
    await tester.pumpAndSettle();

    final soundTile = find.widgetWithText(
      SwitchListTile,
      'Sound Effects & Audio Chimes',
    );
    final contrastTile = find.widgetWithText(
      SwitchListTile,
      'High Contrast Mode',
    );

    expect(tester.widget<SwitchListTile>(soundTile).value, isTrue);
    expect(tester.widget<SwitchListTile>(contrastTile).value, isFalse);

    await tester.tap(soundTile);
    await tester.pumpAndSettle();
    await tester.tap(contrastTile);
    await tester.pumpAndSettle();

    final repo = SettingsRepositoryImpl(SettingsDataSource(storage));
    expect(repo.getSettings().soundEnabled, isFalse);
    expect(repo.getSettings().highContrast, isTrue);
    expect(tester.widget<SwitchListTile>(soundTile).value, isFalse);
    expect(tester.widget<SwitchListTile>(contrastTile).value, isTrue);
  });

  testWidgets('Selected scale chip follows the high-contrast theme',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final storage = await StorageService.init();
    final theme = AppTheme.buildTheme(isDark: true, highContrast: true);
    tester.view.physicalSize = const Size(900, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [storageServiceProvider.overrideWithValue(storage)],
        child: MaterialApp(theme: theme, home: const SettingsScreen()),
      ),
    );
    await tester.pumpAndSettle();

    final chip = tester.widget<ChoiceChip>(
      find.widgetWithText(ChoiceChip, 'Auto (Recommended)'),
    );

    expect(chip.selected, isTrue);
    expect(chip.selectedColor, theme.colorScheme.primary);
    expect(chip.checkmarkColor, theme.colorScheme.onPrimary);
    expect(chip.labelStyle?.color, theme.colorScheme.onPrimary);
  });
}
