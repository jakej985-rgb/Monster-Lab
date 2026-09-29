import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/route_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../domain/models/hardware_connection_model.dart';
import '../../../shared/providers.dart';

class HardwareStatusBadge extends ConsumerWidget {
  final bool showLabel;

  const HardwareStatusBadge({
    super.key,
    this.showLabel = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bridge = ref.watch(hardwareBridgeProvider);
    final stateAsync = ref.watch(hardwareStateStreamProvider);
    final state = stateAsync.value ?? bridge.currentState;
    final board = bridge.currentBoard;

    Color badgeColor;
    IconData iconData;
    String statusText;

    switch (state) {
      case HardwareConnectionState.connectedPhysical:
        badgeColor = AppColors.success;
        iconData = Icons.usb;
        statusText = board?.boardModel.name ?? 'Arduino USB';
        break;
      case HardwareConnectionState.connectedVirtual:
        badgeColor = AppColors.accentCyan;
        iconData = Icons.developer_board;
        statusText = 'Virtual Simulator';
        break;
      case HardwareConnectionState.scanning:
        badgeColor = AppColors.energyAmber;
        iconData = Icons.sync;
        statusText = 'Scanning...';
        break;
      case HardwareConnectionState.error:
        badgeColor = AppColors.danger;
        iconData = Icons.error_outline;
        statusText = 'Hardware Error';
        break;
      case HardwareConnectionState.disconnected:
        badgeColor = AppColors.textSecondaryLight;
        iconData = Icons.usb_off;
        statusText = 'Hardware Offline';
        break;
    }

    return Semantics(
      button: true,
      label: 'Hardware Companion: $statusText',
      child: Tooltip(
        message: 'Hardware Companion: $statusText (Tap to Open)',
        child: InkWell(
          key: const Key('hardware_status_badge_button'),
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            try {
              context.push(RoutePaths.hardware);
            } catch (_) {}
          },
          child: Container(
            constraints: const BoxConstraints(minHeight: 48),
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(
              horizontal: showLabel ? 12 : 10,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: badgeColor.withValues(alpha: 0.35),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  iconData,
                  color: badgeColor,
                  size: 18,
                ),
                if (showLabel) ...[
                  const SizedBox(width: 6),
                  Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: badgeColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
