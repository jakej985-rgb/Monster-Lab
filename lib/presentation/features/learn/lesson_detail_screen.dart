import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/models/lesson_model.dart';
import '../../shared/providers.dart';
import '../../shared/widgets/monster_button.dart';
import '../../shared/widgets/monster_card.dart';
import '../../shared/widgets/monster_markdown.dart';
import '../../shared/widgets/immersive_lesson_controller.dart';
import '../../shared/widgets/lesson_action_bar.dart';
import 'activities/activity_registry.dart';
import 'widgets/blink_simulator_widget.dart';
import 'widgets/potentiometer_simulator_widget.dart';
import 'widgets/rgb_mixer_widget.dart';
import 'widgets/board_inspector_widget.dart';
import 'widgets/quiz_checkpoint_widget.dart';
import 'widgets/quick_check_modal.dart';
import '../../../domain/models/learner_progress_model.dart';
import '../../../domain/models/learner_profile_model.dart';
import '../../../domain/repositories/curriculum_repository.dart';
import '../../shared/widgets/expandable_lesson_image.dart';

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
  final Set<String> _completedQuizSteps = {};
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _interactiveKey = GlobalKey();
  bool _isCompleting = false;
  late Future<Lesson> _lessonFuture;
  late CurriculumRepository _repository;

  @override
  void initState() {
    super.initState();
    // Keep the repository future stable across step/quiz rebuilds so they do
    // not trigger a redundant lesson fetch.
    _loadLesson(ref.read(curriculumRepositoryProvider));
  }

  void _loadLesson(CurriculumRepository repository) {
    _repository = repository;
    _lessonFuture = repository.getLessonById(widget.lessonId);
  }

  void _resetScrollPosition() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    });
  }

  void _resetLessonState() {
    _currentStepIndex = 0;
    _checkedPhysicalTasks.clear();
    _awardedCheckpointKeys.clear();
    _completedQuizSteps.clear();
    _isCompleting = false;
    _resetScrollPosition();
  }

  @override
  void didUpdateWidget(covariant LessonDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lessonId != widget.lessonId) {
      _resetLessonState();
      _loadLesson(ref.read(curriculumRepositoryProvider));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showCompletionDialog(BuildContext context, Lesson lesson,
      {required bool isFirstCompletion, bool isPlaceholder = false}) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: isPlaceholder
                  ? AppColors.primaryViolet
                  : AppColors.energyAmber,
              child: Icon(
                isPlaceholder ? Icons.info_outline : Icons.emoji_events,
                color: Colors.white,
                size: 44,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              isPlaceholder ? 'Fallback Notice' : 'Mission Complete!',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isPlaceholder
                  ? 'Browsed fallback placeholder "${lesson.title}". Production curriculum is loading.'
                  : 'You successfully completed "${lesson.title}"!',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isPlaceholder
                    ? Theme.of(dialogCtx).colorScheme.surfaceContainerHighest
                    : isFirstCompletion
                        ? AppColors.energyAmber.withValues(alpha: 0.15)
                        : Theme.of(dialogCtx)
                            .colorScheme
                            .surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isPlaceholder
                    ? 'FALLBACK NOTICE (No XP or credit recorded)'
                    : isFirstCompletion
                        ? '+${lesson.xpReward} XP EARNED'
                        : 'LESSON COMPLETED (XP already earned)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isPlaceholder
                      ? Theme.of(dialogCtx).colorScheme.onSurfaceVariant
                      : isFirstCompletion
                          ? const Color(0xFFD48806)
                          : Theme.of(dialogCtx).colorScheme.onSurfaceVariant,
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

  bool _isCurrentStepComplete(LessonStep currentStep) {
    if (currentStep.type == StepType.quizCheckpoint &&
        currentStep.interactiveConfig != null) {
      final stepKey = '${widget.lessonId}_step_$_currentStepIndex';
      if (!_completedQuizSteps.contains(stepKey)) {
        return false;
      }
    }
    if (currentStep.type == StepType.physicalTask &&
        (currentStep.interactiveWidgetType == null ||
            currentStep.interactiveWidgetType == 'vocabularyMatch')) {
      final taskKey = '${widget.lessonId}_step_$_currentStepIndex';
      if (!_checkedPhysicalTasks.contains(taskKey)) {
        return false;
      }
    }
    return true;
  }

  void _scrollToIncompleteActivity(String reason) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(reason),
        backgroundColor: AppColors.energyAmber,
        duration: const Duration(seconds: 3),
      ),
    );

    if (_interactiveKey.currentContext != null) {
      Scrollable.ensureVisible(
        _interactiveKey.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final repository = ref.watch(curriculumRepositoryProvider);
    if (!identical(repository, _repository)) {
      // Reload if the provider is replaced or invalidated while this screen is
      // mounted, without refetching on ordinary step/quiz rebuilds.
      _resetLessonState();
      _loadLesson(repository);
    }
    final activeProfile = ref.watch(activeProfileProvider);
    final activeProgress = ref.watch(activeProgressProvider);

    return ImmersiveLessonController(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Learn Lab Session'),
        ),
        body: FutureBuilder<Lesson>(
          future: _lessonFuture,
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
              child: LayoutBuilder(builder: (context, constraints) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Step Progress Bar
                    LinearProgressIndicator(
                      value: (_currentStepIndex + 1) / steps.length,
                      backgroundColor: colorScheme.surfaceContainerHighest,
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
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
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
                    if (currentStep.quickCheck != null &&
                        currentStep.quickCheck!.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Builder(builder: (context) {
                        final quizScheme = Theme.of(context).colorScheme;
                        final quizIsDark =
                            Theme.of(context).brightness == Brightness.dark;
                        final qcKey = '${lesson.id}_${currentStep.stepId}';
                        final qcResult =
                            activeProgress?.quickCheckResults[qcKey];
                        Color badgeBg;
                        Color badgeFg;
                        String badgeText;
                        IconData badgeIcon;

                        if (qcResult == null) {
                          badgeBg =
                              AppColors.primaryViolet.withValues(alpha: 0.12);
                          badgeFg = AppColors.primaryViolet;
                          badgeText = '🧠 Quick Check Available (Optional)';
                          badgeIcon = Icons.help_outline;
                        } else {
                          switch (qcResult.readiness) {
                            case QuickCheckReadiness.ready:
                              badgeBg = AppColors.success
                                  .withValues(alpha: quizIsDark ? 0.2 : 0.12);
                              badgeFg = quizIsDark
                                  ? AppColors.success
                                  : AppColors.textSuccessOnLight;
                              badgeText = '🟢 Ready';
                              badgeIcon = Icons.check_circle;
                              break;
                            case QuickCheckReadiness.warmUp:
                              badgeBg = AppColors.warning
                                  .withValues(alpha: quizIsDark ? 0.2 : 0.12);
                              badgeFg = quizIsDark
                                  ? AppColors.energyGold
                                  : AppColors.textWarningOnLight;
                              badgeText = '🟡 Warm Up Review';
                              badgeIcon = Icons.lightbulb;
                              break;
                            case QuickCheckReadiness.notAssessed:
                              badgeBg = quizScheme.surfaceContainerHighest;
                              badgeFg = quizScheme.onSurfaceVariant;
                              badgeText = '⚪ Quick Check (Not Assessed)';
                              badgeIcon = Icons.info_outline;
                              break;
                          }
                        }

                        return Align(
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () {
                              QuickCheckModal.show(
                                context: context,
                                lessonId: lesson.id,
                                submoduleId: currentStep.stepId,
                                submoduleTitle: currentStep.title,
                                questions: currentStep.quickCheck!,
                                onCompleted: (res) {
                                  if (!_isPlaceholderLesson(lesson)) {
                                    ref
                                        .read(activeProgressProvider.notifier)
                                        .recordQuickCheckResult(res);
                                  }
                                },
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: badgeBg,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(badgeIcon, size: 16, color: badgeFg),
                                  const SizedBox(width: 6),
                                  Text(
                                    badgeText,
                                    style: TextStyle(
                                      color: badgeFg,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                    const SizedBox(height: 12),

                    // Main Interactive Content Area
                    Expanded(
                      child: ListView(
                        controller: _scrollController,
                        children: [
                          if (_currentStepIndex == 0 &&
                              lesson.learningGoal != null)
                            MonsterCard(
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'After this lesson, you should be able to…',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 4),
                                    Text(lesson.learningGoal!),
                                    if (lesson.vocabulary.isNotEmpty) ...[
                                      const SizedBox(height: 10),
                                      Text('New words',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 4),
                                      for (final word in lesson.vocabulary) ...[
                                        Text(
                                            '${word.term}  (${word.pronunciation})',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                        Text(word.meaning),
                                        const SizedBox(height: 4),
                                      ],
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          if (_currentStepIndex == 0 &&
                              lesson.learningGoal != null)
                            const SizedBox(height: 12),
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
                              child: ExpandableLessonImage(
                                assetPath: currentStep.illustrationAsset!,
                                semanticsLabel: currentStep.title,
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          // Interactive Activities & Simulators (routed via ActivityRegistry with legacy fallback)
                          if (ActivityRegistry.hasActivity(
                              currentStep.interactiveWidgetType)) ...[
                            KeyedSubtree(
                              key: _interactiveKey,
                              child: ActivityRegistry.buildActivity(
                                context: context,
                                activityType: currentStep.interactiveWidgetType,
                                config: currentStep.interactiveConfig,
                                onComplete: currentStep.interactiveWidgetType ==
                                        'vocabularyMatch'
                                    ? () {
                                        if (mounted) {
                                          setState(() => _checkedPhysicalTasks.add(
                                              '${widget.lessonId}_step_$_currentStepIndex'));
                                        }
                                      }
                                    : null,
                              )!,
                            ),
                            const SizedBox(height: 16),
                          ] else ...[
                            // Legacy fallback when interactiveWidgetType is not set
                            if (currentStep.interactiveWidgetType == null &&
                                lesson.id == 'lesson_01' &&
                                currentStep.type ==
                                    StepType.visualExplanation &&
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
                            KeyedSubtree(
                              key: _interactiveKey,
                              child: _buildPhysicalTaskChecklist(currentStep),
                            ),
                            const SizedBox(height: 16),
                          ],

                          // Quiz Checkpoint
                          if (currentStep.type == StepType.quizCheckpoint &&
                              currentStep.interactiveConfig != null) ...[
                            KeyedSubtree(
                              key: _interactiveKey,
                              child: QuizCheckpointWidget(
                                key: ValueKey(
                                    '${widget.lessonId}_quiz_${currentStep.stepId}'),
                                question:
                                    currentStep.interactiveConfig!['question']
                                            as String? ??
                                        'Checkpoint Question',
                                options: List<String>.from(
                                    currentStep.interactiveConfig!['options']
                                            as List? ??
                                        ['True', 'False']),
                                correctIndex: currentStep
                                            .interactiveConfig!['correctIndex']
                                        as int? ??
                                    0,
                                questions:
                                    (currentStep.interactiveConfig!['questions']
                                            as List?)
                                        ?.map((q) =>
                                            Map<String, dynamic>.from(q as Map))
                                        .toList(),
                                explanation: currentStep
                                        .interactiveConfig!['explanation']
                                    as String?,
                                onAnswerSubmitted: (isCorrect) async {
                                  final stepKey =
                                      '${widget.lessonId}_step_$_currentStepIndex';
                                  if (widget.lessonId != 'l01_18') {
                                    setState(() {
                                      _completedQuizSteps.add(stepKey);
                                    });
                                  }

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
                                  final isPlaceholder =
                                      _isPlaceholderLesson(lesson);
                                  if (isCorrect &&
                                      activeProfile != null &&
                                      !isAlreadyCompleted &&
                                      !isPlaceholder &&
                                      !_awardedCheckpointKeys
                                          .contains(checkpointKey)) {
                                    _awardedCheckpointKeys.add(checkpointKey);
                                    await ref
                                        .read(activeProgressProvider.notifier)
                                        .addXp(10);
                                  }
                                },
                                onDeckComplete: widget.lessonId == 'l01_18'
                                    ? () {
                                        if (mounted) {
                                          setState(() {
                                            _completedQuizSteps.add(
                                                '${widget.lessonId}_step_$_currentStepIndex');
                                          });
                                        }
                                      }
                                    : null,
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          const SizedBox(height: 16),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Docked Action Bar: Placed after lesson text and interactives
                    LessonActionBar(
                      enabled: !_isCompleting,
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
                          : () {
                              _handleStepNavigation(
                                currentStep,
                                steps,
                                lesson,
                                activeProfile,
                              );
                            },
                    ),
                  ],
                );
              }),
            );
          },
        ),
      ),
    );
  }

  void _handleStepNavigation(
    LessonStep currentStep,
    List<LessonStep> steps,
    Lesson lesson,
    LearnerProfileModel? activeProfile,
  ) {
    if (!_isCurrentStepComplete(currentStep)) {
      final prompt = switch (currentStep.type) {
        StepType.quizCheckpoint =>
          'Please complete the checkpoint quiz before moving forward!',
        StepType.physicalTask =>
          'Please check off the physical hardware task before continuing!',
        _ => 'Please complete the activity on this step first!',
      };
      _scrollToIncompleteActivity(prompt);
      return;
    }

    if (_currentStepIndex < steps.length - 1) {
      setState(() => _currentStepIndex++);
      _resetScrollPosition();
      return;
    }
    _executeLessonCompletion(lesson, activeProfile);
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.danger,
      ),
    );
  }

  Widget _buildPhysicalTaskChecklist(LessonStep step) {
    final taskKey = '${widget.lessonId}_step_$_currentStepIndex';
    final isDone = _checkedPhysicalTasks.contains(taskKey);

    return MonsterCard(
      color: isDone ? AppColors.success.withValues(alpha: 0.1) : null,
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

  bool _isPlaceholderLesson(Lesson lesson) {
    final curriculumRepo = ref.read(curriculumRepositoryProvider);
    return lesson.isPlaceholder || curriculumRepo.isFallbackActive;
  }

  Future<void> _executeLessonCompletion(
    Lesson lesson,
    LearnerProfileModel? activeProfile,
  ) async {
    if (_isCompleting) return;
    setState(() => _isCompleting = true);
    try {
      if (activeProfile == null) {
        _showError(
            'Please select an active learner profile to record progress.');
        return;
      }

      final curriculumRepo = ref.read(curriculumRepositoryProvider);
      final isPlaceholder = _isPlaceholderLesson(lesson);

      bool isFirstCompletion = false;
      if (!isPlaceholder) {
        isFirstCompletion = await ref
            .read(activeProgressProvider.notifier)
            .completeLesson(lesson.id, lesson.xpReward);
        if (!mounted) return;
        ref.read(soundEffectsProvider).success();

        await _checkAndCompleteCourse(curriculumRepo, lesson);
        if (!mounted) return;
      } else {
        ref.read(soundEffectsProvider).success();
      }

      if (context.mounted) {
        _showCompletionDialog(
          context,
          lesson,
          isFirstCompletion: isFirstCompletion,
          isPlaceholder: isPlaceholder,
        );
      }
    } catch (e) {
      _showError('Failed to save lesson progress: $e');
    } finally {
      if (mounted) setState(() => _isCompleting = false);
    }
  }

  Future<void> _checkAndCompleteCourse(
    CurriculumRepository curriculumRepo,
    Lesson lesson,
  ) async {
    final courseId = lesson.courseId;
    if (courseId == null) return;
    try {
      final course = await curriculumRepo.getCourseById(courseId);
      if (!mounted) return;
      final progress = ref.read(activeProgressProvider);
      final allDone = course.lessonIds.isNotEmpty &&
          course.lessonIds.every((lid) =>
              (progress?.completedLessonIds.contains(lid) ?? false) ||
              lid == lesson.id);
      if (allDone) {
        await ref
            .read(activeProgressProvider.notifier)
            .completeCourse(course.id, course.xpReward);
      }
    } catch (_) {
      // Course lookup or completion optional in fallback mode
    }
  }
}
