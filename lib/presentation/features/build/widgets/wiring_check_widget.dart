import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../domain/models/project_model.dart';

class WiringCheckWidget extends StatelessWidget {
  final BuildPhase phase;
  final Set<String> checkedCheckpoints;
  final ValueChanged<String> onToggleCheckpoint;

  const WiringCheckWidget({
    super.key,
    required this.phase,
    required this.checkedCheckpoints,
    required this.onToggleCheckpoint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.danger.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: AppColors.danger.withValues(alpha: 0.35), width: 1.5),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.danger.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.usb_off_rounded,
                    color: AppColors.danger, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'PRE-FLIGHT SAFETY INSPECTION',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.danger,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      phase.instructions,
                      style: const TextStyle(fontSize: 14, height: 1.45),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Row(
          children: [
            Icon(Icons.checklist_rounded,
                size: 18, color: AppColors.textSecondaryLight),
            SizedBox(width: 8),
            Text(
              'SAFETY VERIFICATION CHECKPOINTS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
                color: AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
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
                    fontWeight: isChecked ? FontWeight.w600 : FontWeight.normal,
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
    );
  }
}
