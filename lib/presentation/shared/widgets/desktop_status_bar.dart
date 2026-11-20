import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';

/// Compact 24px native-style desktop status bar for Linux Mint / desktop environments.
class DesktopStatusBar extends ConsumerWidget {
  const DesktopStatusBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.colorScheme.primary;

    final activeProfile = ref.watch(activeProfileProvider);
    final settings = ref.watch(settingsNotifierProvider);

    final zoomText = settings.uiScale > 0.0
        ? '${(settings.uiScale * 100).round()}%'
        : 'Auto (88%)';

    final borderColor =
        isDark ? const Color(0xFF3C4049) : const Color(0xFFDCDCDC);
    final textColor =
        isDark ? const Color(0xFFA0AAB8) : const Color(0xFF636E72);

    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(color: borderColor, width: 1),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final showDetailedHardware = constraints.maxWidth >= 780;
          final showProfile =
              constraints.maxWidth >= 600 && activeProfile != null;

          return Row(
            children: [
              // Left: Status indicator
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: Color(0xFF00B894),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'Ready',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
              if (showDetailedHardware) ...[
                const SizedBox(width: 6),
                Text(
                  '• Hardware Ready',
                  style: TextStyle(
                    fontSize: 11,
                    color: textColor.withValues(alpha: 0.8),
                  ),
                ),
              ],

              const Spacer(),

              // Center: Active Profile
              if (showProfile)
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.person_outline, size: 12, color: primaryColor),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          'Profile: ${activeProfile.nickname}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const Spacer(),

              // Right: Zoom & Shortcuts Help
              Text(
                'Zoom: $zoomText',
                style: TextStyle(
                  fontSize: 11,
                  color: textColor,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF2A2E37)
                      : const Color(0xFFEDEDED),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  'F1 Help',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
