import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/models/app_settings.dart';
import '../../../domain/models/hardware_connection_model.dart';
import '../providers.dart';

/// Compact native-style desktop status bar for Linux desktop environments.
class DesktopStatusBar extends ConsumerWidget {
  const DesktopStatusBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final activeProfile = ref.watch(activeProfileProvider);
    final settings = ref.watch(settingsNotifierProvider);
    final bridge = ref.watch(hardwareBridgeProvider);
    final hardwareState =
        ref.watch(hardwareStateStreamProvider).value ?? bridge.currentState;
    final (hardwareLabel, hardwareColor) =
        _hardwareStatus(colorScheme, hardwareState);

    final zoomText = settings.uiScale > 0.0
        ? '${(settings.uiScale * 100).round()}%'
        : 'Auto (${(AppSettings.desktopAutoUiScale * 100).round()}%)';

    final textScale = MediaQuery.textScalerOf(context).scale(12.0) / 12.0;

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border(
            top: BorderSide(color: colorScheme.outlineVariant, width: 1),
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Keep the profile out when enlarged text would crowd the bar.
            final showProfile = activeProfile != null &&
                constraints.maxWidth >= 700 * textScale;
            final showZoomLabel = constraints.maxWidth >= 420 * textScale;

            return Row(
              children: [
                Flexible(
                  flex: 3,
                  child: Semantics(
                    label: 'Hardware status: $hardwareLabel',
                    liveRegion: true,
                    child: ExcludeSemantics(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: hardwareColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              hardwareLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (showProfile) ...[
                  const SizedBox(width: 12),
                  Flexible(
                    flex: 2,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.person_outline,
                            size: 12, color: colorScheme.primary),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            'Profile: ${activeProfile.nickname}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const Spacer(),
                Flexible(
                  flex: 2,
                  child: Text(
                    showZoomLabel ? 'Zoom: $zoomText' : zoomText,
                    maxLines: 1,
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Tooltip(
                  message: 'Press F1 to open Help',
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(color: colorScheme.outlineVariant),
                    ),
                    child: Text(
                      'F1 Help',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

(String, Color) _hardwareStatus(
  ColorScheme colorScheme,
  HardwareConnectionState state,
) {
  return switch (state) {
    HardwareConnectionState.connected ||
    HardwareConnectionState.connectedPhysical =>
      ('Hardware Ready', colorScheme.primary),
    HardwareConnectionState.simulation ||
    HardwareConnectionState.connectedVirtual =>
      ('Simulator Ready', colorScheme.tertiary),
    HardwareConnectionState.connecting || HardwareConnectionState.scanning => (
        'Connecting...',
        colorScheme.secondary
      ),
    HardwareConnectionState.safetyLocked => (
        'Safety Locked',
        colorScheme.error
      ),
    HardwareConnectionState.unavailable => (
        'Port Unavailable',
        colorScheme.onSurfaceVariant
      ),
    HardwareConnectionState.unsupported => (
        'Device Unsupported',
        colorScheme.onSurfaceVariant
      ),
    HardwareConnectionState.error => ('Hardware Error', colorScheme.error),
    HardwareConnectionState.disconnected => (
        'Hardware Offline',
        colorScheme.onSurfaceVariant
      ),
  };
}
