import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import '../../../core/app_metadata.dart';

/// Authentic GTK About Dialog styled for Linux desktop environments.
class GtkAboutDialog extends StatelessWidget {
  const GtkAboutDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) => const GtkAboutDialog(),
    );
  }

  String get _environmentLabel {
    if (kIsWeb) return 'Environment: Web';
    return switch (defaultTargetPlatform) {
      TargetPlatform.linux => 'Environment: Linux desktop (GTK)',
      TargetPlatform.windows => 'Environment: Windows desktop',
      TargetPlatform.macOS => 'Environment: macOS desktop',
      TargetPlatform.android => 'Environment: Android',
      TargetPlatform.iOS => 'Environment: iOS',
      TargetPlatform.fuchsia => 'Environment: Fuchsia',
    };
  }

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied to clipboard'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      backgroundColor: theme.colorScheme.surface,
      elevation: 8,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // App Icon
                CircleAvatar(
                  radius: 32,
                  backgroundColor: primaryColor.withValues(alpha: 0.15),
                  child: Icon(
                    Icons.smart_toy_outlined,
                    color: primaryColor,
                    size: 38,
                  ),
                ),
                const SizedBox(height: 12),

                // Title & Version
                const Text(
                  'Monster Lab',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    appVersionDisplay,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Subtitle & Description
                const Text(
                  'Hands-on Arduino & Electronics Studio for Kids',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'An interactive educational learning environment designed for young makers to explore electronics, sensors, actuators, and microcontroller programming with safe, guided workflows.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: theme.textTheme.bodySmall?.color
                        ?.withValues(alpha: 0.8),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),

                Divider(
                  height: 1,
                  color: theme.colorScheme.outlineVariant,
                ),
                const SizedBox(height: 10),

                // System & License details
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Text(
                      _environmentLabel,
                      style: TextStyle(
                        fontSize: 11,
                        color: theme.textTheme.bodySmall?.color
                            ?.withValues(alpha: 0.7),
                      ),
                    ),
                    Text(
                      'License: MIT (100% Offline)',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: theme.textTheme.bodySmall?.color
                            ?.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Action Buttons (GTK Desktop Order: links left, Close right)
                OverflowBar(
                  alignment: MainAxisAlignment.end,
                  overflowAlignment: OverflowBarAlignment.end,
                  spacing: 8,
                  overflowSpacing: 8,
                  children: [
                    Tooltip(
                      message: 'Copy the Monster Lab website URL',
                      child: OutlinedButton.icon(
                        onPressed: () => _copyToClipboard(
                          context,
                          'https://jakej985-rgb.github.io/M3tal-Hub/Monster-Lab/',
                          'Website URL',
                        ),
                        icon: const Icon(Icons.language, size: 14),
                        label: const Text('Copy website'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          minimumSize: const Size(60, 30),
                        ),
                      ),
                    ),
                    Tooltip(
                      message: 'Copy the Monster Lab GitHub repository URL',
                      child: OutlinedButton.icon(
                        onPressed: () => _copyToClipboard(
                          context,
                          'https://github.com/jakej985-rgb/Monster-Lab',
                          'GitHub repository URL',
                        ),
                        icon: const Icon(Icons.code, size: 14),
                        label: const Text('Copy GitHub'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          minimumSize: const Size(60, 30),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(70, 30),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 4),
                      ),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
