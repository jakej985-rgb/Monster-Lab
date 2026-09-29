import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/models/lesson_model.dart';
import '../../../domain/models/project_model.dart';
import '../../shared/providers.dart';
import '../../shared/widgets/monster_card.dart';

class BuildScreen extends ConsumerStatefulWidget {
  const BuildScreen({super.key});

  @override
  ConsumerState<BuildScreen> createState() => _BuildScreenState();
}

class _BuildScreenState extends ConsumerState<BuildScreen> {
  late Future<List<ProjectModel>> _projectsFuture;
  DifficultyTier? _selectedTier;

  @override
  void initState() {
    super.initState();
    _projectsFuture = ref.read(curriculumRepositoryProvider).getProjects();
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

  String _formatTierName(DifficultyTier tier) {
    switch (tier) {
      case DifficultyTier.rookie:
        return 'ROOKIE';
      case DifficultyTier.builder:
        return 'BUILDER';
      case DifficultyTier.engineer:
        return 'ENGINEER';
      case DifficultyTier.monsterMaster:
        return 'MASTER';
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeProgress = ref.watch(activeProgressProvider);
    final completedLessonIds =
        activeProgress?.completedLessonIds.toSet() ?? <String>{};
    final completedProjectIds =
        activeProgress?.completedProjectIds.toSet() ?? <String>{};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Build Lab',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder<List<ProjectModel>>(
        future: _projectsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final allProjects = snapshot.data!;
          final filteredProjects = _selectedTier == null
              ? allProjects
              : allProjects.where((p) => p.tier == _selectedTier).toList();

          return Column(
            children: [
              // Tier Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('All Tiers'),
                      selected: _selectedTier == null,
                      onSelected: (_) => setState(() => _selectedTier = null),
                      selectedColor:
                          AppColors.primaryViolet.withValues(alpha: 0.2),
                      checkmarkColor: AppColors.primaryViolet,
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Rookie'),
                      selected: _selectedTier == DifficultyTier.rookie,
                      onSelected: (_) =>
                          setState(() => _selectedTier = DifficultyTier.rookie),
                      selectedColor:
                          AppColors.tierRookie.withValues(alpha: 0.2),
                      checkmarkColor: AppColors.tierRookie,
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Builder'),
                      selected: _selectedTier == DifficultyTier.builder,
                      onSelected: (_) => setState(
                          () => _selectedTier = DifficultyTier.builder),
                      selectedColor:
                          AppColors.tierBuilder.withValues(alpha: 0.2),
                      checkmarkColor: AppColors.tierBuilder,
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Engineer'),
                      selected: _selectedTier == DifficultyTier.engineer,
                      onSelected: (_) => setState(
                          () => _selectedTier = DifficultyTier.engineer),
                      selectedColor:
                          AppColors.tierEngineer.withValues(alpha: 0.2),
                      checkmarkColor: AppColors.tierEngineer,
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Monster Master'),
                      selected: _selectedTier == DifficultyTier.monsterMaster,
                      onSelected: (_) => setState(
                          () => _selectedTier = DifficultyTier.monsterMaster),
                      selectedColor:
                          AppColors.tierMaster.withValues(alpha: 0.2),
                      checkmarkColor: AppColors.tierMaster,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: filteredProjects.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final project = filteredProjects[index];
                    final tierColor = _getTierColor(project.tier);
                    final isCompleted =
                        completedProjectIds.contains(project.id);

                    // Prerequisite check: all prerequisite lessons must be completed
                    final missingPrereqs = project.prerequisiteLessons
                        .where((lessonId) =>
                            !completedLessonIds.contains(lessonId))
                        .toList();
                    final isLocked = missingPrereqs.isNotEmpty;

                    return MonsterCard(
                      onTap: () {
                        if (isLocked) {
                          showDialog<void>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Row(
                                children: [
                                  Icon(Icons.lock_rounded,
                                      color: AppColors.warning),
                                  SizedBox(width: 8),
                                  Text('Project Locked'),
                                ],
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Complete the following foundational lessons first before building this project:',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 12),
                                  ...missingPrereqs.map((prereq) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2.0),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.school,
                                                size: 16,
                                                color: AppColors.primaryViolet),
                                            const SizedBox(width: 8),
                                            Text(prereq,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Close'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    context.go('/learn');
                                  },
                                  child: const Text('Go to Lessons'),
                                ),
                              ],
                            ),
                          );
                        } else {
                          context.push('/build/${project.id}');
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: tierColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: tierColor.withValues(alpha: 0.3)),
                                ),
                                child: Text(
                                  _formatTierName(project.tier),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                    color: tierColor,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  if (isCompleted)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: AppColors.success
                                            .withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Row(
                                        children: [
                                          Icon(Icons.check_circle_rounded,
                                              size: 13,
                                              color: AppColors.success),
                                          SizedBox(width: 4),
                                          Text(
                                            'COMPLETED',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.success,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  else if (isLocked)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: AppColors.warning
                                            .withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Row(
                                        children: [
                                          Icon(Icons.lock_rounded,
                                              size: 13,
                                              color: AppColors.warning),
                                          SizedBox(width: 4),
                                          Text(
                                            'LOCKED',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.warning,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  const SizedBox(width: 10),
                                  Text(
                                    '⏱ ${project.estimatedMinutes}m',
                                    style: const TextStyle(
                                      color: AppColors.textSecondaryLight,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            project.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: isLocked
                                  ? AppColors.textSecondaryLight
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            project.tagline,
                            style: const TextStyle(
                                color: AppColors.textSecondaryLight,
                                fontSize: 14),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Icon(Icons.extension_rounded,
                                  size: 15,
                                  color: isLocked
                                      ? AppColors.textSecondaryLight
                                      : AppColors.primaryViolet),
                              const SizedBox(width: 6),
                              Text(
                                '${project.requiredComponents.length} Parts',
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textSecondaryLight),
                              ),
                              const SizedBox(width: 16),
                              const Icon(Icons.bolt_rounded,
                                  size: 16, color: AppColors.energyAmber),
                              const SizedBox(width: 4),
                              Text(
                                '+${project.xpReward} XP',
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.energyAmber),
                              ),
                              if (isLocked) ...[
                                const Spacer(),
                                Text(
                                  'Requires ${missingPrereqs.length} lesson(s)',
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.warning,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
