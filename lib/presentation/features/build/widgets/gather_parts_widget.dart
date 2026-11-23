import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../domain/models/project_model.dart';

class GatherPartsWidget extends StatelessWidget {
  final BuildPhase phase;
  final List<String> requiredComponents;
  final Set<String> checkedCheckpoints;
  final ValueChanged<String> onToggleCheckpoint;

  const GatherPartsWidget({
    super.key,
    required this.phase,
    required this.requiredComponents,
    required this.checkedCheckpoints,
    required this.onToggleCheckpoint,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.primaryViolet.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: AppColors.primaryViolet.withValues(alpha: 0.2)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.handyman_rounded,
                  color: AppColors.primaryViolet, size: 28),
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
        if (requiredComponents.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text(
            'REQUIRED LAB COMPONENTS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: requiredComponents.map((compId) {
              return ActionChip(
                avatar: const Icon(Icons.memory,
                    size: 16, color: AppColors.primaryViolet),
                label: Text(compId),
                backgroundColor: colorScheme.surfaceContainerHighest,
                side: BorderSide(
                    color: AppColors.primaryViolet.withValues(alpha: 0.3)),
                onPressed: () => context.push('/parts/$compId'),
                tooltip: 'Tap to view pinout & specs',
              );
            }).toList(),
          ),
        ],
        if (phase.verificationCheckpoints.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text(
            'TOOL & HARDWARE CHECKPOINTS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
              color: colorScheme.onSurfaceVariant,
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
                    : colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.5),
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
                      color: isChecked ? colorScheme.onSurfaceVariant : null,
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
