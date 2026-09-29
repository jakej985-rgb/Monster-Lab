import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/models/lesson_model.dart';
import '../../shared/providers.dart';
import '../../shared/widgets/monster_card.dart';

class LearnScreen extends ConsumerStatefulWidget {
  const LearnScreen({super.key});

  @override
  ConsumerState<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends ConsumerState<LearnScreen> {
  DifficultyTier? _selectedTier;

  @override
  Widget build(BuildContext context) {
    final curriculumRepo = ref.watch(curriculumRepositoryProvider);
    final activeProgress = ref.watch(activeProgressProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Learn Lab',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // Tier Filter Chips
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTierChip(label: 'All Tiers', tier: null),
                  const SizedBox(width: 8),
                  _buildTierChip(
                      label: 'Rookie (Beginner)', tier: DifficultyTier.rookie),
                  const SizedBox(width: 8),
                  _buildTierChip(
                      label: 'Builder (Intermediate)',
                      tier: DifficultyTier.builder),
                  const SizedBox(width: 8),
                  _buildTierChip(
                      label: 'Engineer (Advanced)',
                      tier: DifficultyTier.engineer),
                  const SizedBox(width: 8),
                  _buildTierChip(
                      label: 'Master', tier: DifficultyTier.monsterMaster),
                ],
              ),
            ),
          ),
          const Divider(height: 1),

          // Lesson List
          Expanded(
            child: FutureBuilder<List<Lesson>>(
              future: curriculumRepo.getLessons(tier: _selectedTier),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final lessons = snapshot.data!;

                if (lessons.isEmpty) {
                  return const Center(
                    child: Text('No lessons found in this tier yet.'),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: lessons.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final lesson = lessons[index];
                    final isCompleted = activeProgress?.completedLessonIds
                            .contains(lesson.id) ??
                        false;

                    // Prerequisite check
                    final missingPrereqs = lesson.prerequisites
                        .where(
                          (req) => !(activeProgress?.completedLessonIds
                                  .contains(req) ??
                              false),
                        )
                        .toList();
                    final isLocked = missingPrereqs.isNotEmpty;

                    return MonsterCard(
                      color: isLocked ? Colors.grey.shade100 : null,
                      onTap: isLocked
                          ? () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Complete prerequisite (${missingPrereqs.join(", ")}) first!'),
                                ),
                              );
                            }
                          : () => context.push('/learn/${lesson.id}'),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: isCompleted
                                ? AppColors.success
                                : (isLocked
                                    ? Colors.grey.shade400
                                    : AppColors.primaryViolet),
                            child: Icon(
                              isCompleted
                                  ? Icons.check
                                  : (isLocked ? Icons.lock : Icons.play_arrow),
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: _getTierColor(lesson.tier)
                                            .withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        lesson.tier.name.toUpperCase(),
                                        style: TextStyle(
                                          color: _getTierColor(lesson.tier),
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '⏱ ${lesson.estimatedMinutes} min',
                                      style: const TextStyle(
                                          color: AppColors.textSecondaryLight,
                                          fontSize: 11),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  lesson.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: isLocked
                                        ? AppColors.textSecondaryLight
                                        : AppColors.textPrimaryLight,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  lesson.summary,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: AppColors.textSecondaryLight,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color:
                                  AppColors.energyAmber.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '+${lesson.xpReward} XP',
                              style: const TextStyle(
                                color: Color(0xFFD48806),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTierChip(
      {required String label, required DifficultyTier? tier}) {
    final isSelected = _selectedTier == tier;
    return ChoiceChip(
      label: Text(label,
          style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      selected: isSelected,
      selectedColor: AppColors.primaryViolet,
      labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppColors.textPrimaryLight),
      onSelected: (_) => setState(() => _selectedTier = tier),
    );
  }

  Color _getTierColor(DifficultyTier tier) {
    switch (tier) {
      case DifficultyTier.rookie:
        return AppColors.tierRookie;
      case DifficultyTier.builder:
        return AppColors.tierBuilder;
      case DifficultyTier.engineer:
        return AppColors.tierEngineer;
      case DifficultyTier.monsterMaster:
        return AppColors.tierMaster;
    }
  }
}
