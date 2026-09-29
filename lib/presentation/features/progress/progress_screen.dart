import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../shared/providers.dart';
import '../../shared/widgets/monster_card.dart';
import '../../shared/widgets/xp_progress_bar.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeProgress = ref.watch(activeProgressProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress & Badges',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
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
                        const Text('Lessons Done',
                            style: TextStyle(
                                color: AppColors.textSecondaryLight,
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
                        const Text('Robots Built',
                            style: TextStyle(
                                color: AppColors.textSecondaryLight,
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
                        const Text('Parts Found',
                            style: TextStyle(
                                color: AppColors.textSecondaryLight,
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
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFF3CD),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.star,
                      color: AppColors.energyAmber, size: 36),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('First Circuit Scout',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(height: 4),
                      Text('Completed your first lesson in Monster Lab!',
                          style: TextStyle(
                              color: AppColors.textSecondaryLight,
                              fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
