import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/route_constants.dart';
// TODO: Agent 1 will add this provider
import '../../shared/providers.dart';
import '../../shared/widgets/monster_card.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          MonsterCard(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Sound Effects & Audio Chimes'),
                  subtitle: const Text('Plays celebratory chimes on milestones and clicks.'),
                  value: settings.soundEnabled,
                  onChanged: (val) => notifier.setSoundEnabled(val),
                ),
                const Divider(),
                SwitchListTile(
                  title: const Text('High Contrast Mode'),
                  subtitle: const Text('Increases visual borders and pin label contrast.'),
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
    );
  }
}
