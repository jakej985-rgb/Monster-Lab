import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/models/lesson_model.dart';
import '../../shared/providers.dart';
import '../../shared/widgets/monster_button.dart';
import '../../shared/widgets/monster_card.dart';
import '../../shared/widgets/monster_markdown.dart';
import 'activities/activity_registry.dart';
import 'widgets/blink_simulator_widget.dart';
import 'widgets/potentiometer_simulator_widget.dart';
import 'widgets/rgb_mixer_widget.dart';
import 'widgets/board_inspector_widget.dart';
import 'widgets/quiz_checkpoint_widget.dart';

class LessonDetailScreen extends ConsumerStatefulWidget {
  final String lessonId;

  const LessonDetailScreen({super.key, required this.lessonId});

  @override
  ConsumerState<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends ConsumerState<LessonDetailScreen> {
  int _currentStepIndex = 0;
  final Set<String> _checkedPhysicalTasks = {};
  final Set<String> _awardedCheckpointKeys = {};
  bool _isCompleting = false;

  void _showCompletionDialog(BuildContext context, Lesson lesson,
      {required bool isFirstCompletion}) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Column(
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: AppColors.energyAmber,
              child: Icon(Icons.emoji_events, color: Colors.white, size: 44),
            ),
            SizedBox(height: 12),
            Text(
              'Mission Complete!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'You successfully completed "${lesson.title}"!',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isFirstCompletion
                    ? AppColors.energyAmber.withValues(alpha: 0.15)
                    : AppColors.surfaceContainerLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isFirstCompletion
                    ? '+${lesson.xpReward} XP EARNED'
                    : 'LESSON COMPLETED (XP already earned)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isFirstCompletion
                      ? const Color(0xFFD48806)
                      : AppColors.textSecondaryLight,
                  fontWeight: FontWeight.bold,
                  fontSize: isFirstCompletion ? 16 : 14,
                ),
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          MonsterButton(
            label: 'Back to Learn Lab',
            icon: Icons.check,
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final curriculumRepo = ref.watch(curriculumRepositoryProvider);
    final activeProfile = ref.watch(activeProfileProvider);
    final activeProgress = ref.watch(activeProgressProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Learn Lab Session'),
      ),
      body: FutureBuilder<Lesson>(
        future: curriculumRepo.getLessonById(widget.lessonId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error loading lesson: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final lesson = snapshot.data!;
          final steps = lesson.steps;
          final currentStep = steps[_currentStepIndex];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Step Progress Bar
                LinearProgressIndicator(
                  value: (_currentStepIndex + 1) / steps.length,
                  backgroundColor: AppColors.surfaceContainerLight,
                  valueColor:
                      const AlwaysStoppedAnimation(AppColors.primaryViolet),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 14),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Step ${_currentStepIndex + 1} of ${steps.length}',
                      style: const TextStyle(
                        color: AppColors.primaryViolet,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      '${lesson.estimatedMinutes} min • +${lesson.xpReward} XP',
                      style: const TextStyle(
                        color: AppColors.textSecondaryLight,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  currentStep.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 12),

                // Main Interactive Content Area
                Expanded(
                  child: ListView(
                    children: [
                      // Story / Explanation Markdown Card
                      MonsterCard(
                        child: MonsterMarkdown(
                          data: currentStep.markdownContent,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Optional Illustration Asset
                      if (currentStep.illustrationAsset != null &&
                          currentStep.illustrationAsset!.isNotEmpty) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            currentStep.illustrationAsset!,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const SizedBox.shrink(),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Interactive Activities & Simulators (routed via ActivityRegistry with legacy fallback)
                      if (ActivityRegistry.hasActivity(
                          currentStep.interactiveWidgetType)) ...[
                        ActivityRegistry.buildActivity(
                          context: context,
                          activityType: currentStep.interactiveWidgetType,
                          config: currentStep.interactiveConfig,
                        )!,
                        const SizedBox(height: 16),
                      ] else ...[
                        // Legacy fallback when interactiveWidgetType is not set
                        if (currentStep.interactiveWidgetType == null &&
                            lesson.id == 'lesson_01' &&
                            currentStep.type == StepType.visualExplanation &&
                            steps.length <= 6) ...[
                          const BoardInspectorWidget(),
                          const SizedBox(height: 16),
                        ],
                        if (currentStep.interactiveWidgetType == null &&
                            lesson.id == 'lesson_05' &&
                            currentStep.type == StepType.codeExperiment &&
                            steps.length <= 6) ...[
                          const BlinkSimulatorWidget(),
                          const SizedBox(height: 16),
                        ],
                        if (currentStep.interactiveWidgetType == null &&
                            lesson.id == 'lesson_06' &&
                            currentStep.type == StepType.codeExperiment &&
                            steps.length <= 6) ...[
                          const PotentiometerSimulatorWidget(),
                          const SizedBox(height: 16),
                        ],
                        if (currentStep.interactiveWidgetType == null &&
                            lesson.id == 'lesson_07' &&
                            currentStep.type == StepType.codeExperiment &&
                            steps.length <= 6) ...[
                          const RgbMixerWidget(),
                          const SizedBox(height: 16),
                        ],
                      ],

                      // Physical Task Checklist (only when no interactive widget handles this step)
                      if (currentStep.type == StepType.physicalTask &&
                          currentStep.interactiveWidgetType == null) ...[
                        _buildPhysicalTaskChecklist(currentStep),
                        const SizedBox(height: 16),
                      ],

                      // Quiz Checkpoint
                      if (currentStep.type == StepType.quizCheckpoint &&
                          currentStep.interactiveConfig != null) ...[
                        QuizCheckpointWidget(
                          key: ValueKey(
                              '${widget.lessonId}_quiz_${currentStep.stepId}'),
                          question: currentStep.interactiveConfig!['question']
                                  as String? ??
                              'Checkpoint Question',
                          options: List<String>.from(currentStep
                                  .interactiveConfig!['options'] as List? ??
                              ['True', 'False']),
                          correctIndex: currentStep
                                  .interactiveConfig!['correctIndex'] as int? ??
                              0,
                          questions: (currentStep
                                  .interactiveConfig!['questions'] as List?)
                              ?.map((q) => Map<String, dynamic>.from(q as Map))
                              .toList(),
                          explanation: currentStep
                              .interactiveConfig!['explanation'] as String?,
                          onAnswerSubmitted: (isCorrect) async {
                            final checkpointKey =
                                '${widget.lessonId}_step_$_currentStepIndex';
                            final progress = activeProgress ??
                                (activeProfile != null
                                    ? await ref
                                        .read(progressRepositoryProvider)
                                        .getProgress(activeProfile.id)
                                    : null);
                            final isAlreadyCompleted = progress
                                    ?.completedLessonIds
                                    .contains(widget.lessonId) ??
                                false;
                            if (isCorrect &&
                                activeProfile != null &&
                                !isAlreadyCompleted &&
                                !_awardedCheckpointKeys
                                    .contains(checkpointKey)) {
                              _awardedCheckpointKeys.add(checkpointKey);
                              await ref
                                  .read(activeProgressProvider.notifier)
                                  .addXp(10);
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Navigation Button
                MonsterButton(
                  label: _currentStepIndex < steps.length - 1
                      ? 'Next Step'
                      : (_isCompleting
                          ? 'Saving Progress...'
                          : 'Complete Lesson (+${lesson.xpReward} XP)'),
                  icon: _currentStepIndex < steps.length - 1
                      ? Icons.arrow_forward
                      : Icons.celebration,
                  onPressed: _isCompleting
                      ? null
                      : () async {
                          if (_currentStepIndex < steps.length - 1) {
                            setState(() => _currentStepIndex++);
                          } else {
                            if (_isCompleting) return;
                            setState(() => _isCompleting = true);
                            try {
                              if (activeProfile == null) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Please select an active learner profile to record progress.'),
                                      backgroundColor: AppColors.danger,
                                    ),
                                  );
                                }
                                return;
                              }
                              final isFirstCompletion = await ref
                                  .read(activeProgressProvider.notifier)
                                  .completeLesson(lesson.id, lesson.xpReward);
                              if (context.mounted) {
                                _showCompletionDialog(context, lesson,
                                    isFirstCompletion: isFirstCompletion);
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Failed to save lesson progress: $e'),
                                    backgroundColor: AppColors.danger,
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
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPhysicalTaskChecklist(LessonStep step) {
    final taskKey = '${widget.lessonId}_step_$_currentStepIndex';
    final isDone = _checkedPhysicalTasks.contains(taskKey);

    return MonsterCard(
      color: isDone
          ? AppColors.success.withValues(alpha: 0.1)
          : AppColors.backgroundLight,
      child: Row(
        children: [
          Checkbox(
            value: isDone,
            activeColor: AppColors.success,
            onChanged: (val) {
              setState(() {
                if (val == true) {
                  _checkedPhysicalTasks.add(taskKey);
                } else {
                  _checkedPhysicalTasks.remove(taskKey);
                }
              });
            },
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'I have performed this step on my real Arduino board!',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
