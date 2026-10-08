import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/models/project_model.dart';
import '../../shared/providers.dart';
import '../../shared/widgets/monster_button.dart';
import '../../shared/widgets/monster_card.dart';
import 'widgets/breadboard_wiring_widget.dart';
import 'widgets/code_studio_widget.dart';
import 'widgets/gather_parts_widget.dart';
import 'widgets/troubleshooting_sheet.dart';
import 'widgets/wiring_check_widget.dart';

class BuildDetailScreen extends ConsumerStatefulWidget {
  final String projectId;

  const BuildDetailScreen({super.key, required this.projectId});

  @override
  ConsumerState<BuildDetailScreen> createState() => _BuildDetailScreenState();
}

class _BuildDetailScreenState extends ConsumerState<BuildDetailScreen> {
  late Future<ProjectModel?> _projectFuture;
  int _currentPhaseIndex = 0;
  final Set<String> _checkedCheckpoints = <String>{};
  bool _isCompleting = false;

  @override
  void initState() {
    super.initState();
    _projectFuture =
        ref.read(curriculumRepositoryProvider).getProjectById(widget.projectId);
  }

  void _toggleCheckpoint(String checkpoint) {
    setState(() {
      if (_checkedCheckpoints.contains(checkpoint)) {
        _checkedCheckpoints.remove(checkpoint);
      } else {
        _checkedCheckpoints.add(checkpoint);
      }
    });
  }

  Widget _buildPhaseContent(BuildPhase phase, ProjectModel project) {
    switch (phase.type) {
      case PhaseType.gatherParts:
        return GatherPartsWidget(
          phase: phase,
          requiredComponents: project.requiredComponents,
          checkedCheckpoints: _checkedCheckpoints,
          onToggleCheckpoint: _toggleCheckpoint,
        );
      case PhaseType.breadboardWiring:
        return BreadboardWiringWidget(
          phase: phase,
          checkedCheckpoints: _checkedCheckpoints,
          onToggleCheckpoint: _toggleCheckpoint,
        );
      case PhaseType.wiringCheck:
        return WiringCheckWidget(
          phase: phase,
          checkedCheckpoints: _checkedCheckpoints,
          onToggleCheckpoint: _toggleCheckpoint,
        );
      case PhaseType.codeReview:
        return CodeStudioWidget(
          phase: phase,
          checkedCheckpoints: _checkedCheckpoints,
          onToggleCheckpoint: _toggleCheckpoint,
        );
      case PhaseType.uploadSketch:
      case PhaseType.physicalTest:
      case PhaseType.debugTuning:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.energyAmber.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.energyAmber.withValues(alpha: 0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.flash_on_rounded,
                      color: AppColors.energyAmber, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      phase.instructions,
                      style: const TextStyle(
                          fontSize: 15,
                          height: 1.45,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            if (phase.verificationCheckpoints.isNotEmpty) ...[
              const SizedBox(height: 24),
              const Text(
                'PHYSICAL VERIFICATION CHECKPOINTS',
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
                  final isChecked = _checkedCheckpoints.contains(checkpoint);

                  return Card(
                    elevation: 0,
                    color: isChecked
                        ? AppColors.success.withValues(alpha: 0.08)
                        : AppColors.surfaceContainerLight
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
                      onChanged: (_) => _toggleCheckpoint(checkpoint),
                      activeColor: AppColors.success,
                      title: Text(
                        checkpoint,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                              isChecked ? FontWeight.w600 : FontWeight.normal,
                          decoration:
                              isChecked ? TextDecoration.lineThrough : null,
                          color:
                              isChecked ? AppColors.textSecondaryLight : null,
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
      case PhaseType.missionComplete:
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border:
                    Border.all(color: AppColors.success.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  const Icon(Icons.stars_rounded,
                      color: AppColors.success, size: 56),
                  const SizedBox(height: 12),
                  const Text(
                    'BUILD READY FOR COMPLETION!',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.success),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    phase.instructions,
                    style: const TextStyle(fontSize: 15, height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.energyAmber.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.bolt_rounded,
                            color: AppColors.energyAmber, size: 20),
                        const SizedBox(width: 6),
                        Text(
                          '+${project.xpReward} XP Reward',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: AppColors.energyAmber),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (project.variants.isNotEmpty)
              ProjectVariantsSection(variants: project.variants),
            if (project.extensionMissions.isNotEmpty)
              EngineeringMissionsSection(missions: project.extensionMissions),
          ],
        );
    }
  }

  void _showVariantsAndMissionsSheet(
      BuildContext context, ProjectModel project) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.4,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: ListView(
            controller: scrollController,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textSecondaryLight.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Variants & Missions',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              if (project.variants.isNotEmpty)
                ProjectVariantsSection(variants: project.variants)
              else
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text('No alternative variants for this build.',
                      style: TextStyle(color: AppColors.textSecondaryLight)),
                ),
              if (project.extensionMissions.isNotEmpty)
                EngineeringMissionsSection(missions: project.extensionMissions)
              else
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text('No extension missions for this build.',
                      style: TextStyle(color: AppColors.textSecondaryLight)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeProfile = ref.watch(activeProfileProvider);
    final activeProgress = ref.watch(activeProgressProvider);
    final progressRepo = ref.watch(progressRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Guided Build Lab',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.alt_route_rounded),
            tooltip: 'Project Variants & Missions',
            onPressed: () async {
              final project = await _projectFuture;
              if (project != null && context.mounted) {
                _showVariantsAndMissionsSheet(context, project);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.build_circle_outlined),
            tooltip: 'Diagnostics & Troubleshooting',
            onPressed: () async {
              final project = await _projectFuture;
              if (project != null && context.mounted) {
                TroubleshootingSheet.show(context, project.troubleshooting);
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<ProjectModel?>(
        future: _projectFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final project = snapshot.data;
          if (project == null) {
            return const Center(child: Text('Project not found.'));
          }

          // Check prerequisites
          final completedLessons =
              activeProgress?.completedLessonIds.toSet() ?? <String>{};
          final missingPrereqs = project.prerequisiteLessons
              .where((id) => !completedLessons.contains(id))
              .toList();

          if (missingPrereqs.isNotEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.lock_rounded,
                          size: 48, color: AppColors.warning),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${project.title} is Locked',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Complete foundational lessons (${missingPrereqs.join(', ')}) before building this project to ensure safety and mastery.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: AppColors.textSecondaryLight, fontSize: 14),
                    ),
                    const SizedBox(height: 24),
                    MonsterButton(
                      label: 'Explore Foundational Lessons',
                      icon: Icons.school_rounded,
                      onPressed: () => context.go('/learn'),
                    ),
                  ],
                ),
              ),
            );
          }

          final phases = project.phases;
          if (_currentPhaseIndex >= phases.length) {
            _currentPhaseIndex = phases.length - 1;
          }
          final currentPhase = phases[_currentPhaseIndex];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Phase Progress Bar
                LinearProgressIndicator(
                  value: (_currentPhaseIndex + 1) / phases.length,
                  backgroundColor: AppColors.surfaceContainerLight,
                  valueColor:
                      const AlwaysStoppedAnimation(AppColors.primaryViolet),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Step ${_currentPhaseIndex + 1} of ${phases.length}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: AppColors.primaryViolet,
                      ),
                    ),
                    Text(
                      project.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  currentPhase.phaseTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                if (currentPhase.safetyCallout != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.danger.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.danger.withValues(alpha: 0.35),
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          color: AppColors.danger,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            currentPhase.safetyCallout!,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.danger,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 14),
                // Phase Dynamic Content
                Expanded(
                  child: MonsterCard(
                    child: SingleChildScrollView(
                      child: _buildPhaseContent(currentPhase, project),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                // Navigation Buttons (Previous / Next)
                Row(
                  children: [
                    if (_currentPhaseIndex > 0) ...[
                      Expanded(
                        flex: 1,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            setState(() => _currentPhaseIndex--);
                          },
                          icon: const Icon(Icons.arrow_back_rounded, size: 18),
                          label: const Text('Back'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      flex: 2,
                      child: MonsterButton(
                        label: _currentPhaseIndex < phases.length - 1
                            ? 'Next Phase'
                            : 'Complete Build (+${project.xpReward} XP)',
                        icon: _currentPhaseIndex < phases.length - 1
                            ? Icons.arrow_forward_rounded
                            : Icons.celebration_rounded,
                        onPressed: _isCompleting
                            ? null
                            : () async {
                                if (_currentPhaseIndex < phases.length - 1) {
                                  setState(() => _currentPhaseIndex++);
                                  if (activeProfile != null) {
                                    await progressRepo.recordProjectPhase(
                                      activeProfile.id,
                                      project.id,
                                      _currentPhaseIndex + 1,
                                    );
                                  }
                                } else {
                                  if (_isCompleting) return;
                                  setState(() => _isCompleting = true);
                                  bool isFirst = false;
                                  try {
                                    if (activeProfile != null) {
                                      isFirst = await ref
                                          .read(activeProgressProvider.notifier)
                                          .completeProject(
                                            project.id,
                                            project.xpReward,
                                            project.badgeRewardId,
                                          );
                                    }
                                    if (context.mounted) {
                                      showDialog<void>(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (dialogContext) => AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16)),
                                          title: const Row(
                                            children: [
                                              Icon(Icons.military_tech_rounded,
                                                  color: AppColors.energyAmber,
                                                  size: 28),
                                              SizedBox(width: 8),
                                              Text('Mission Complete!'),
                                            ],
                                          ),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'Congratulations! You successfully engineered and built ${project.title}!',
                                                style: const TextStyle(
                                                    fontSize: 15),
                                              ),
                                              const SizedBox(height: 16),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(12),
                                                decoration: BoxDecoration(
                                                  color: isFirst
                                                      ? AppColors.success
                                                          .withValues(
                                                              alpha: 0.1)
                                                      : AppColors
                                                          .surfaceContainerLight,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      isFirst
                                                          ? Icons.bolt_rounded
                                                          : Icons
                                                              .check_circle_outline,
                                                      color: isFirst
                                                          ? AppColors
                                                              .energyAmber
                                                          : AppColors
                                                              .textSecondaryLight,
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Text(
                                                      isFirst
                                                          ? '+${project.xpReward} XP Awarded'
                                                          : 'PROJECT COMPLETED (XP already earned)',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            isFirst ? 16 : 14,
                                                        color: isFirst
                                                            ? null
                                                            : AppColors
                                                                .textSecondaryLight,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(dialogContext)
                                                    .pop();
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text(
                                                  'Back to Build Lab'),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  } finally {
                                    if (mounted) {
                                      setState(() => _isCompleting = false);
                                    }
                                  }
                                }
                              },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ProjectVariantsSection extends StatelessWidget {
  final List<ProjectVariant> variants;

  const ProjectVariantsSection({super.key, required this.variants});

  @override
  Widget build(BuildContext context) {
    if (variants.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Row(
          children: [
            Icon(Icons.alt_route_rounded,
                color: AppColors.primaryViolet, size: 22),
            SizedBox(width: 8),
            Text(
              'PROJECT VARIANTS & SWAPS',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
                color: AppColors.primaryViolet,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...variants.map((v) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                    color: AppColors.primaryViolet.withValues(alpha: 0.25)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            v.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        if (v.alternativeComponents.isNotEmpty)
                          Wrap(
                            spacing: 4,
                            children: v.alternativeComponents
                                .map((c) => Chip(
                                      label: Text(c,
                                          style: const TextStyle(fontSize: 11)),
                                      backgroundColor:
                                          AppColors.surfaceContainerLight,
                                      visualDensity: VisualDensity.compact,
                                      padding: EdgeInsets.zero,
                                    ))
                                .toList(),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(v.description,
                        style: const TextStyle(fontSize: 14, height: 1.4)),
                    if (v.wiringDifferences.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.cable_rounded,
                              size: 16, color: AppColors.accentCyan),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Wiring: ${v.wiringDifferences}',
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondaryLight),
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (v.codeAdaptation.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.code_rounded,
                              size: 16, color: AppColors.energyAmber),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Code: ${v.codeAdaptation}',
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondaryLight),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            )),
      ],
    );
  }
}

class EngineeringMissionsSection extends StatelessWidget {
  final List<EngineeringMission> missions;

  const EngineeringMissionsSection({super.key, required this.missions});

  @override
  Widget build(BuildContext context) {
    if (missions.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Row(
          children: [
            Icon(Icons.flag_rounded, color: AppColors.energyAmber, size: 22),
            SizedBox(width: 8),
            Text(
              'ENGINEERING MISSIONS',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
                color: AppColors.energyAmber,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...missions.map((m) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                    color: AppColors.energyAmber.withValues(alpha: 0.3)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            m.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color:
                                AppColors.energyAmber.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '+${m.xpReward} XP',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: AppColors.energyAmber),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(m.objective,
                        style: const TextStyle(fontSize: 14, height: 1.4)),
                    if (m.hints.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      ExpansionTile(
                        tilePadding: EdgeInsets.zero,
                        dense: true,
                        title: const Text(
                          'Engineering Hints',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accentCyan),
                        ),
                        leading: const Icon(Icons.lightbulb_outline_rounded,
                            size: 18, color: AppColors.accentCyan),
                        children: m.hints
                            .map((hint) => Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, bottom: 6),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('• ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Expanded(
                                          child: Text(hint,
                                              style: const TextStyle(
                                                  fontSize: 13))),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),
            )),
      ],
    );
  }
}
