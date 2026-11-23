import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/models/learner_progress_model.dart';
import '../../shared/providers.dart';
import '../../shared/widgets/monster_card.dart';
import '../../shared/widgets/responsive_content_container.dart';
import '../../shared/widgets/xp_progress_bar.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeProgress = ref.watch(activeProgressProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final hasFirstBadge = activeProgress?.earnedBadgeIds
            .contains(ProgressBadgeIds.firstCircuitScout) ??
        false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress & Badges',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ResponsiveContentContainer(
        maxWidth: 1040,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            if (activeProgress != null) ...[
              XPProgressBar(
                totalXp: activeProgress.totalXp,
                currentLevel: activeProgress.currentLevel,
                progressRatio: activeProgress.levelProgressRatio,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: MonsterCard(
                      child: Column(
                        children: [
                          Text(
                            '${activeProgress.completedLessonIds.length}',
                            style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryViolet),
                          ),
                          const SizedBox(height: 4),
                          Text('Lessons Done',
                              style: TextStyle(
                                  color: colorScheme.onSurfaceVariant,
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: MonsterCard(
                      child: Column(
                        children: [
                          Text(
                            '${activeProgress.completedProjectIds.length}',
                            style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppColors.energyAmber),
                          ),
                          const SizedBox(height: 4),
                          Text('Robots Built',
                              style: TextStyle(
                                  color: colorScheme.onSurfaceVariant,
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: MonsterCard(
                      child: Column(
                        children: [
                          Text(
                            '${activeProgress.discoveredComponentIds.length}',
                            style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppColors.accentCyanDark),
                          ),
                          const SizedBox(height: 4),
                          Text('Parts Found',
                              style: TextStyle(
                                  color: colorScheme.onSurfaceVariant,
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              const Center(child: Text('No active profile selected.')),
            ],
            const SizedBox(height: 24),
            const Text('Earned Badges',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            MonsterCard(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: hasFirstBadge
                          ? AppColors.energyAmber.withValues(alpha: 0.15)
                          : colorScheme.surfaceContainerHighest,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      hasFirstBadge ? Icons.star : Icons.lock_outline,
                      color: hasFirstBadge
                          ? AppColors.energyAmber
                          : colorScheme.onSurfaceVariant,
                      size: 36,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hasFirstBadge
                              ? 'First Circuit Scout'
                              : 'Your first badge is waiting',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          hasFirstBadge
                              ? 'Completed your first lesson in Monster Lab!'
                              : 'Complete your first lesson to earn the First Circuit Scout badge.',
                          style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
