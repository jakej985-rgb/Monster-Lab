import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/models/challenge_model.dart';
import '../../shared/providers.dart';
import '../../shared/widgets/monster_card.dart';

class ChallengesScreen extends ConsumerStatefulWidget {
  const ChallengesScreen({super.key});

  @override
  ConsumerState<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends ConsumerState<ChallengesScreen> {
  DifficultyTier? _selectedTier;

  Color _getDifficultyColor(DifficultyTier tier) {
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

  String _formatChallengeType(ChallengeType type) {
    switch (type) {
      case ChallengeType.identifyPart:
        return 'Identify Part';
      case ChallengeType.predictOutput:
        return 'Predict Output';
      case ChallengeType.fixWiring:
        return 'Fix Wiring';
      case ChallengeType.changeCode:
        return 'Code Modification';
      case ChallengeType.debugLogic:
        return 'Debug Logic';
      case ChallengeType.combineComponents:
        return 'Combine Parts';
      case ChallengeType.buildFromGoal:
        return 'Build From Goal';
      case ChallengeType.explainWhatHappened:
        return 'Explain Phenomenon';
    }
  }

  @override
  Widget build(BuildContext context) {
    final curriculumRepo = ref.watch(curriculumRepositoryProvider);
    final activeProgress = ref.watch(activeProgressProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Challenge Arena',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder<List<ChallengeModel>>(
        future: curriculumRepo.getChallenges(tier: _selectedTier),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Text('Failed to load challenges: ${snapshot.error}'),
            );
          }

          final challenges = snapshot.data!;
          final solvedCount = challenges
              .where(
                (c) =>
                    activeProgress?.solvedChallengeIds.contains(c.id) ?? false,
              )
              .length;
          final totalCount = challenges.length;
          final progressPercent =
              totalCount == 0 ? 0.0 : solvedCount / totalCount;

          return Column(
            children: [
              // Progress Banner
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryViolet.withValues(alpha: 0.15),
                      AppColors.accentCyan.withValues(alpha: 0.12),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: AppColors.primaryViolet.withValues(alpha: 0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.emoji_events,
                                color: AppColors.energyAmber, size: 22),
                            SizedBox(width: 8),
                            Text(
                              'Mastery Progress',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                        Text(
                          '$solvedCount / $totalCount Solved',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: progressPercent,
                        minHeight: 10,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.success),
                      ),
                    ),
                  ],
                ),
              ),

              // Difficulty Filter Chips (Responsive Wrap - No side scrolling)
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilterChip(
                      label: const Text('All Tiers'),
                      selected: _selectedTier == null,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedTier = null;
                          });
                        }
                      },
                    ),
                    FilterChip(
                      label: const Text('Rookie'),
                      selected: _selectedTier == DifficultyTier.rookie,
                      onSelected: (selected) {
                        setState(() {
                          _selectedTier =
                              selected ? DifficultyTier.rookie : null;
                        });
                      },
                    ),
                    FilterChip(
                      label: const Text('Builder'),
                      selected: _selectedTier == DifficultyTier.builder,
                      onSelected: (selected) {
                        setState(() {
                          _selectedTier =
                              selected ? DifficultyTier.builder : null;
                        });
                      },
                    ),
                    FilterChip(
                      label: const Text('Engineer'),
                      selected: _selectedTier == DifficultyTier.engineer,
                      onSelected: (selected) {
                        setState(() {
                          _selectedTier =
                              selected ? DifficultyTier.engineer : null;
                        });
                      },
                    ),
                    FilterChip(
                      label: const Text('Monster Master'),
                      selected: _selectedTier == DifficultyTier.monsterMaster,
                      onSelected: (selected) {
                        setState(() {
                          _selectedTier =
                              selected ? DifficultyTier.monsterMaster : null;
                        });
                      },
                    ),
                  ],
                ),
              ),

              // Challenges List
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: challenges.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final challenge = challenges[index];
                    final isSolved = activeProgress?.solvedChallengeIds
                            .contains(challenge.id) ??
                        false;
                    final tierColor = _getDifficultyColor(challenge.difficulty);

                    return MonsterCard(
                      child: InkWell(
                        onTap: () =>
                            context.push('/challenges/${challenge.id}'),
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color:
                                              tierColor.withValues(alpha: 0.15),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border: Border.all(
                                              color: tierColor, width: 1.0),
                                        ),
                                        child: Text(
                                          challenge.difficulty.name
                                              .toUpperCase(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                            color: tierColor,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryViolet
                                              .withValues(alpha: 0.12),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          _formatChallengeType(challenge.type),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
                                            color: AppColors.primaryViolet,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.energyAmber
                                          .withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '+${challenge.xpAward} XP',
                                      style: const TextStyle(
                                        color: AppColors.energyAmber,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                challenge.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                challenge.prompt,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: AppColors.textSecondaryLight,
                                    fontSize: 14),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (isSolved)
                                    const Row(
                                      children: [
                                        Icon(Icons.check_circle,
                                            color: AppColors.success, size: 20),
                                        SizedBox(width: 6),
                                        Text(
                                          'Mastered!',
                                          style: TextStyle(
                                              color: AppColors.success,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )
                                  else
                                    const Text(
                                      'Not attempted yet',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 13),
                                    ),
                                  const Row(
                                    children: [
                                      Text(
                                        'Open Quest',
                                        style: TextStyle(
                                          color: AppColors.primaryViolet,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Icon(Icons.arrow_forward_ios,
                                          size: 12,
                                          color: AppColors.primaryViolet),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
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
