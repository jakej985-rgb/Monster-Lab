import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/route_constants.dart';
import '../../shared/widgets/monster_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _soundEnabled = true;
  bool _highContrast = false;

  @override
  Widget build(BuildContext context) {
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
                  subtitle: const Text(
                      'Plays celebratory chimes on milestones and clicks.'),
                  value: _soundEnabled,
                  onChanged: (val) => setState(() => _soundEnabled = val),
                ),
                const Divider(),
                SwitchListTile(
                  title: const Text('High Contrast Mode'),
                  subtitle: const Text(
                      'Increases visual borders and pin label contrast.'),
                  value: _highContrast,
                  onChanged: (val) => setState(() => _highContrast = val),
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
