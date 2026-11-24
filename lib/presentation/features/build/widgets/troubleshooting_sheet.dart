import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/route_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../domain/models/project_model.dart';

class TroubleshootingSheet extends StatefulWidget {
  final List<TroubleshootingItem> items;

  const TroubleshootingSheet({super.key, required this.items});

  static void show(BuildContext context, List<TroubleshootingItem> items) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TroubleshootingSheet(items: items),
    );
  }

  @override
  State<TroubleshootingSheet> createState() => _TroubleshootingSheetState();
}

class _TroubleshootingSheetState extends State<TroubleshootingSheet> {
  final Set<String> _checkedSteps = {};

  Color _getCategoryColor(String? category) {
    switch (category?.toLowerCase()) {
      case 'power':
        return AppColors.energyAmber;
      case 'wiring':
        return AppColors.tierBuilder;
      case 'code':
        return AppColors.tierEngineer;
      case 'upload':
        return AppColors.primaryViolet;
      case 'logic':
        return AppColors.accentCyan;
      default:
        return AppColors.primaryViolet;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final solutionColor = Theme.of(context).brightness == Brightness.dark
        ? AppColors.success
        : AppColors.textSuccessOnLight;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.35,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.energyAmber.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.bug_report_rounded,
                        color: AppColors.energyAmber, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Troubleshooting & Diagnostics',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Physical failure modes & diagnostic steps',
                          style: TextStyle(
                              fontSize: 13,
                              color: colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    tooltip: 'Close',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Quick launch to Doctor Monster Wizard
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  context.push(RoutePaths.troubleshoot);
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryViolet.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.primaryViolet.withValues(alpha: 0.3)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.healing,
                          color: AppColors.primaryViolet, size: 20),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Need general help? Open Doctor Monster Clinic',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryViolet,
                          ),
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios,
                          size: 12, color: AppColors.primaryViolet),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              Expanded(
                child: widget.items.isEmpty
                    ? Center(
                        child: Text(
                          'No known glitches reported for this project.',
                          style: TextStyle(color: colorScheme.onSurfaceVariant),
                        ),
                      )
                    : ListView.separated(
                        controller: scrollController,
                        itemCount: widget.items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = widget.items[index];
                          final catColor = _getCategoryColor(item.category);

                          return Card(
                            elevation: 0,
                            color: colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: colorScheme.outlineVariant,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Category Pill + Symptom
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (item.category != null) ...[
                                        Container(
                                          margin:
                                              const EdgeInsets.only(right: 8),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 7, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: catColor.withValues(
                                                alpha: 0.15),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            border: Border.all(
                                                color: catColor, width: 1.0),
                                          ),
                                          child: Text(
                                            item.category!.toUpperCase(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                              color: catColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                      Expanded(
                                        child: Text(
                                          item.symptom,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: AppColors.danger,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),

                                  // Cause
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(Icons.help_outline_rounded,
                                          color: colorScheme.onSurfaceVariant,
                                          size: 16),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Cause: ${item.cause}',
                                          style: TextStyle(
                                              fontSize: 13,
                                              color:
                                                  colorScheme.onSurfaceVariant),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),

                                  // Solution
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppColors.success
                                          .withValues(alpha: 0.08),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: AppColors.success
                                              .withValues(alpha: 0.3)),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.check_circle_rounded,
                                            color: solutionColor, size: 16),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            item.solution,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: solutionColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Diagnostic Steps (if available)
                                  if (item.diagnosticSteps.isNotEmpty) ...[
                                    const SizedBox(height: 10),
                                    const Text(
                                      'Diagnostic Steps:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                    const SizedBox(height: 4),
                                    ...item.diagnosticSteps.map((step) {
                                      final isChecked =
                                          _checkedSteps.contains(step);
                                      return Semantics(
                                        checked: isChecked,
                                        label: 'Diagnostic step: $step',
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              if (isChecked) {
                                                _checkedSteps.remove(step);
                                              } else {
                                                _checkedSteps.add(step);
                                              }
                                            });
                                          },
                                          child: Container(
                                            constraints: const BoxConstraints(
                                                minHeight: 48),
                                            alignment: Alignment.centerLeft,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 6.0, horizontal: 4.0),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  isChecked
                                                      ? Icons.check_box
                                                      : Icons
                                                          .check_box_outline_blank,
                                                  size: 20,
                                                  color: isChecked
                                                      ? solutionColor
                                                      : colorScheme
                                                          .onSurfaceVariant,
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    step,
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      decoration: isChecked
                                                          ? TextDecoration
                                                              .lineThrough
                                                          : null,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
