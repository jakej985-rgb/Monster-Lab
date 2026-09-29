import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../domain/models/project_model.dart';

class BreadboardWiringWidget extends StatelessWidget {
  final BuildPhase phase;
  final Set<String> checkedCheckpoints;
  final ValueChanged<String> onToggleCheckpoint;

  const BreadboardWiringWidget({
    super.key,
    required this.phase,
    required this.checkedCheckpoints,
    required this.onToggleCheckpoint,
  });

  Color _resolveWireColor(String wireName) {
    switch (wireName.toLowerCase()) {
      case 'red':
        return AppColors.wirePower5V;
      case 'dark slate':
      case 'black':
        return AppColors.wireGround;
      case 'green':
        return AppColors.wireDigital;
      case 'yellow':
        return AppColors.wireAnalog;
      case 'blue':
        return AppColors.wireI2C;
      case 'orange':
        return AppColors.wireSPI;
      case 'purple':
        return AppColors.primaryViolet;
      default:
        return AppColors.wireSignalAlt;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.wireI2C.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.wireI2C.withValues(alpha: 0.2)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.cable_rounded,
                  color: AppColors.wireI2C, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  phase.instructions,
                  style: const TextStyle(
                      fontSize: 15, height: 1.45, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
        if (phase.wiringConnections.isNotEmpty) ...[
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'WIRE CONNECTION MATRIX',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                  color: AppColors.textSecondaryLight,
                ),
              ),
              Text(
                '${phase.wiringConnections.length} Wires',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Card(
            elevation: 0,
            color: AppColors.surfaceContainerLight.withValues(alpha: 0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                  color: AppColors.textSecondaryLight.withValues(alpha: 0.15)),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: phase.wiringConnections.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                color: AppColors.textSecondaryLight.withValues(alpha: 0.1),
              ),
              itemBuilder: (context, index) {
                final conn = phase.wiringConnections[index];
                final wireName = conn['wire'] ?? 'Wire';
                final wireColor = _resolveWireColor(wireName);
                final fromPin = conn['from'] ?? '';
                final toPin = conn['to'] ?? '';
                final type = conn['type'] ?? 'signal';

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: wireColor,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: wireColor.withValues(alpha: 0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          wireName,
                          style: TextStyle(
                            color: wireColor.computeLuminance() > 0.5
                                ? Colors.black
                                : Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    fromPin,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 6),
                                  child: Icon(Icons.arrow_forward_rounded,
                                      size: 14,
                                      color: AppColors.textSecondaryLight),
                                ),
                                Flexible(
                                  child: Text(
                                    toPin,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                        color: AppColors.primaryViolet),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              type.toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textSecondaryLight,
                                  letterSpacing: 0.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
        if (phase.verificationCheckpoints.isNotEmpty) ...[
          const SizedBox(height: 24),
          const Text(
            'CONNECTION VERIFICATIONS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
              color: AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: phase.verificationCheckpoints.length,
            itemBuilder: (context, index) {
              final checkpoint = phase.verificationCheckpoints[index];
              final isChecked = checkedCheckpoints.contains(checkpoint);

              return Card(
                elevation: 0,
                color: isChecked
                    ? AppColors.success.withValues(alpha: 0.08)
                    : AppColors.surfaceContainerLight.withValues(alpha: 0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: isChecked
                        ? AppColors.success.withValues(alpha: 0.4)
                        : Colors.transparent,
                  ),
                ),
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: CheckboxListTile(
                  value: isChecked,
                  onChanged: (_) => onToggleCheckpoint(checkpoint),
                  activeColor: AppColors.success,
                  title: Text(
                    checkpoint,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          isChecked ? FontWeight.w600 : FontWeight.normal,
                      decoration: isChecked ? TextDecoration.lineThrough : null,
                      color: isChecked ? AppColors.textSecondaryLight : null,
                    ),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              );
            },
          ),
        ],
      ],
    );
  }
}
