import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/route_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../shared/providers.dart';
import '../../shared/widgets/monster_card.dart';
import '../../shared/widgets/responsive_content_container.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Widget _buildScaleChip({
    required String label,
    required double value,
    required double currentValue,
    required VoidCallback onSelected,
  }) {
    final isSelected = (currentValue == value);
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      selectedColor: AppColors.primaryViolet.withValues(alpha: 0.2),
      checkmarkColor: AppColors.primaryViolet,
      labelStyle: TextStyle(
        color:
            isSelected ? AppColors.primaryViolet : AppColors.textPrimaryLight,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 12,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                        'Plays celebratory chimes on milestones and clicks.'),
                    value: settings.soundEnabled,
                    onChanged: (val) => notifier.setSoundEnabled(val),
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: const Text('High Contrast Mode'),
                    subtitle: const Text(
                        'Increases visual borders and pin label contrast.'),
                    value: settings.highContrast,
                    onChanged: (val) => notifier.setHighContrast(val),
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
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
                    child: Row(
                      children: [
                        Icon(Icons.zoom_in, color: AppColors.primaryViolet),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Display & UI Scaling',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Calibrate size of text, cards, and buttons for your screen.',
                                style: TextStyle(
                                    color: AppColors.textSecondaryLight,
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
                          label: 'Auto (Recommended)',
                          value: 0.0,
                          currentValue: settings.uiScale,
                          onSelected: () => notifier.setUiScale(0.0),
                        ),
                        _buildScaleChip(
                          label: '80% (Compact)',
                          value: 0.80,
                          currentValue: settings.uiScale,
                          onSelected: () => notifier.setUiScale(0.80),
                        ),
                        _buildScaleChip(
                          label: '90% (Desktop Standard)',
                          value: 0.90,
                          currentValue: settings.uiScale,
                          onSelected: () => notifier.setUiScale(0.90),
                        ),
                        _buildScaleChip(
                          label: '100% (Default)',
                          value: 1.00,
                          currentValue: settings.uiScale,
                          onSelected: () => notifier.setUiScale(1.00),
                        ),
                        _buildScaleChip(
                          label: '110% (Large)',
                          value: 1.10,
                          currentValue: settings.uiScale,
                          onSelected: () => notifier.setUiScale(1.10),
                        ),
                        _buildScaleChip(
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
          ],
        ),
      ),
    );
  }
}
