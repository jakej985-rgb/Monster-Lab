import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../domain/models/project_model.dart';

class CodeStudioWidget extends StatelessWidget {
  final BuildPhase phase;
  final Set<String> checkedCheckpoints;
  final ValueChanged<String> onToggleCheckpoint;

  const CodeStudioWidget({
    super.key,
    required this.phase,
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
            color: AppColors.accentCyan.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border:
                Border.all(color: AppColors.accentCyan.withValues(alpha: 0.2)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.code_rounded,
                  color: AppColors.accentCyanDark, size: 28),
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
        if (phase.codeSnippet != null && phase.codeSnippet!.isNotEmpty) ...[
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ARDUINO SOURCE CODE',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: phase.codeSnippet!));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Sketch code copied to clipboard!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.copy_rounded,
                    size: 16, color: AppColors.accentCyan),
                label: const Text('Copy Code',
                    style: TextStyle(
                        color: AppColors.accentCyan,
                        fontWeight: FontWeight.bold,
                        fontSize: 13)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.outlineVariant),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SelectableText(
              phase.codeSnippet!,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                height: 1.5,
                color: AppColors.syntaxString,
              ),
            ),
          ),
        ],
        if (phase.codeExplanation != null &&
            phase.codeExplanation!.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text(
            'PEDAGOGICAL LOGIC BREAKDOWN',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: phase.codeExplanation!
                  .split('\n')
                  .where((l) => l.trim().isNotEmpty)
                  .map((line) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 4, right: 8),
                        child: Icon(Icons.lightbulb_outline_rounded,
                            size: 16, color: AppColors.energyAmber),
                      ),
                      Expanded(
                        child: Text(
                          line.startsWith('- ') ? line.substring(2) : line,
                          style: const TextStyle(fontSize: 14, height: 1.45),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
        if (phase.verificationCheckpoints.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text(
            'CONCEPT CHECKPOINTS',
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
