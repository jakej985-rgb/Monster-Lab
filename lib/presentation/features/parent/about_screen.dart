import 'package:flutter/material.dart';
import '../../../core/app_metadata.dart';
import '../../../core/theme/app_colors.dart';
import '../../shared/widgets/monster_card.dart';
import '../../shared/widgets/monster_button.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final successColor = Theme.of(context).brightness == Brightness.dark
        ? AppColors.success
        : AppColors.textSuccessOnLight;

    return Scaffold(
      appBar: AppBar(
        title: const Text('About Monster Lab'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          // App Header
          Center(
            child: Column(
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: AppColors.primaryViolet,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x286C5CE7),
                        blurRadius: 16,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.smart_toy_rounded,
                      size: 56,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Monster Lab',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryViolet,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    appVersionDisplay,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Hands-on physical computing, electronics, and Arduino robotics for young inventors.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Privacy & COPPA Card
          MonsterCard(
            color: successColor.withValues(alpha: 0.08),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.verified_user_rounded,
                        color: successColor, size: 24),
                    const SizedBox(width: 10),
                    Text(
                      '100% Offline & Child-Safe',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: successColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Monster Lab operates entirely on-device without an internet connection. '
                  'There are zero third-party ads, zero tracking scripts, zero cloud telemetry, '
                  'and zero personal data collection. Designed to satisfy COPPA and FERPA standards.',
                  style: TextStyle(fontSize: 13, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Curriculum Statistics Card
          MonsterCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.inventory_2_rounded,
                        color: AppColors.primaryViolet, size: 22),
                    SizedBox(width: 10),
                    Text(
                      'Curriculum Scope',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _buildStatRow(context, Icons.school, '12 Step-by-Step Lessons',
                    'Digital buses, I2C, SPI, UART, & motor physics'),
                const Divider(height: 16),
                _buildStatRow(context, Icons.memory, '54 Kit Components',
                    'Full pinouts, operating voltage, & sample C++ codes'),
                const Divider(height: 16),
                _buildStatRow(context, Icons.handyman, '20 Guided Projects',
                    'Interactive wiring, code diffs, & variants'),
                const Divider(height: 16),
                _buildStatRow(context, Icons.quiz, '24 Circuit Challenges',
                    'Progressive tiered hints & interactive quizzes'),
                const Divider(height: 16),
                _buildStatRow(context, Icons.military_tech, '20 Mastery Badges',
                    'XP achievements and milestone progression'),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Open Source Licenses Button
          MonsterButton.secondary(
            key: const Key('open_licenses_button'),
            label: 'Open Source Licenses & Acknowledgments',
            icon: Icons.article_outlined,
            onPressed: () {
              showLicensePage(
                context: context,
                applicationName: 'Monster Lab',
                applicationVersion: appVersionFull,
                applicationLegalese:
                    'Copyright (c) 2026 Monster Lab Contributors. Open-source educational platform.',
              );
            },
          ),
          const SizedBox(height: 12),

          // Privacy Policy Dialog
          MonsterButton.secondary(
            key: const Key('privacy_policy_dialog_button'),
            label: 'View Detailed Privacy Policy',
            icon: Icons.privacy_tip_outlined,
            onPressed: () => _showPrivacyPolicyDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(
      BuildContext context, IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primaryViolet),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 13)),
              Text(subtitle,
                  style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
      ],
    );
  }

  void _showPrivacyPolicyDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.shield_outlined, color: AppColors.primaryViolet),
            SizedBox(width: 8),
            Text('Privacy Policy'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Text(
            'Monster Lab Privacy Policy (Summary):\n\n'
            '1. No Personal Data Collected: Monster Lab does not collect, transmit, or store names, email addresses, location, or biometric data.\n\n'
            '2. 100% Offline Storage: All learner progress, custom avatar nicknames, XP points, and project completion logs are stored exclusively in local device memory.\n\n'
            '3. Zero Third-Party Services: The app does not include third-party advertising SDKs, cloud analytics, crash loggers, or behavioral trackers.\n\n'
            '4. Hardware Access: USB and Serial permissions are used exclusively to communicate with physical Arduino microcontrollers via direct serial cables upon user initiation. No data is sent over networks.\n\n'
            '5. COPPA & FERPA: Fully designed to protect young learners and comply with school privacy standards.',
            style: TextStyle(fontSize: 13, height: 1.4),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
