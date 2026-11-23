import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/app_metadata.dart';
import '../../../core/routing/route_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../shared/providers.dart';
import '../../shared/widgets/gtk_about_dialog.dart';
import '../../shared/widgets/monster_card.dart';
import '../../shared/widgets/responsive_content_container.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Widget _buildScaleChip({
    required BuildContext context,
    required String label,
    required double value,
    required double currentValue,
    required VoidCallback onSelected,
  }) {
    final isSelected = (currentValue == value);
    final colorScheme = Theme.of(context).colorScheme;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      selectedColor: colorScheme.primary,
      checkmarkColor: colorScheme.onPrimary,
      labelStyle: TextStyle(
        color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 12,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final settings = ref.watch(settingsNotifierProvider);
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ResponsiveContentContainer(
        maxWidth: 800,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            MonsterCard(
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Sound Effects & Audio Chimes'),
                    subtitle: const Text(
                        'Play feedback sounds for lessons, projects, and challenges.'),
                    value: settings.soundEnabled,
                    onChanged: (value) => notifier.setSoundEnabled(value),
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: const Text('High Contrast Mode'),
                    subtitle: const Text(
                        'Use stronger text, borders, and surface contrast across the app.'),
                    value: settings.highContrast,
                    onChanged: (value) => notifier.setHighContrast(value),
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: const Text('Immersive Lesson Mode'),
                    subtitle: const Text(
                        'Hide system navigation controls while learning for a more immersive full-screen experience.'),
                    value: settings.immersiveLessonMode,
                    onChanged: (val) => notifier.setImmersiveLessonMode(val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Display & UI Zoom
            MonsterCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                    child: Row(
                      children: [
                        Icon(Icons.zoom_in, color: colorScheme.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Display & UI Scaling',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Calibrate size of text, cards, and buttons for your screen.',
                                style: TextStyle(
                                    color: colorScheme.onSurfaceVariant,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildScaleChip(
                          context: context,
                          label: 'Auto (Recommended)',
                          value: 0.0,
                          currentValue: settings.uiScale,
                          onSelected: () => notifier.setUiScale(0.0),
                        ),
                        _buildScaleChip(
                          context: context,
                          label: '75% (Ultra Compact)',
                          value: 0.75,
                          currentValue: settings.uiScale,
                          onSelected: () => notifier.setUiScale(0.75),
                        ),
                        _buildScaleChip(
                          context: context,
                          label: '80% (Compact)',
                          value: 0.80,
                          currentValue: settings.uiScale,
                          onSelected: () => notifier.setUiScale(0.80),
                        ),
                        _buildScaleChip(
                          context: context,
                          label: '90% (Comfortable)',
                          value: 0.90,
                          currentValue: settings.uiScale,
                          onSelected: () => notifier.setUiScale(0.90),
                        ),
                        _buildScaleChip(
                          context: context,
                          label: '100% (Default)',
                          value: 1.00,
                          currentValue: settings.uiScale,
                          onSelected: () => notifier.setUiScale(1.00),
                        ),
                        _buildScaleChip(
                          context: context,
                          label: '110% (Large)',
                          value: 1.10,
                          currentValue: settings.uiScale,
                          onSelected: () => notifier.setUiScale(1.10),
                        ),
                        _buildScaleChip(
                          context: context,
                          label: '125% (Touch)',
                          value: 1.25,
                          currentValue: settings.uiScale,
                          onSelected: () => notifier.setUiScale(1.25),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Appearance & Theming
            MonsterCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                    child: Row(
                      children: [
                        Icon(Icons.palette_outlined,
                            color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Appearance & Desktop Theme',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Configure color scheme and desktop appearance mode.',
                                style: TextStyle(
                                    color: colorScheme.onSurfaceVariant,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Theme Mode',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          children: [
                            ChoiceChip(
                              label: const Text('System (Auto)'),
                              selected: settings.themeMode == 'system',
                              onSelected: (_) =>
                                  notifier.setThemeMode('system'),
                            ),
                            ChoiceChip(
                              label: const Text('Light Lab'),
                              selected: settings.themeMode == 'light',
                              onSelected: (_) => notifier.setThemeMode('light'),
                            ),
                            ChoiceChip(
                              label: const Text('Dark Lab'),
                              selected: settings.themeMode == 'dark',
                              onSelected: (_) => notifier.setThemeMode('dark'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text('Color Palette Preset',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          children: [
                            ChoiceChip(
                              label: const Text('Default (Violet & Cyan)'),
                              selected: settings.themePreset == 'default',
                              onSelected: (_) =>
                                  notifier.setThemePreset('default'),
                            ),
                            ChoiceChip(
                              label: const Text('Linux Mint (Mint-Y Green)'),
                              selected: settings.themePreset == 'mint',
                              onSelected: (_) =>
                                  notifier.setThemePreset('mint'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
              ),
            ),
            const SizedBox(height: 16),

            MonsterCard(
              onTap: () => context.push(RoutePaths.profileSelect),
              child: const Row(
                children: [
                  Icon(Icons.switch_account, color: Colors.blueAccent),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text('Switch Learner Profile',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // About Monster Lab
            MonsterCard(
              onTap: () => GtkAboutDialog.show(context),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: AppColors.success),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('About Monster Lab',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        Text(
                            'Version $appVersion, license, and desktop system info',
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant)),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
