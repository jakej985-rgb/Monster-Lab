import 'package:material_ui/material_ui.dart';
import 'package:flutter/widget_previews.dart';
import 'package:monster_lab/core/theme/app_colors.dart';
import 'package:monster_lab/core/theme/app_theme.dart';
import 'package:monster_lab/domain/models/lesson_model.dart';
import 'package:monster_lab/presentation/shared/widgets/monster_card.dart';
import 'package:monster_lab/presentation/shared/widgets/monster_markdown.dart';
import 'package:monster_lab/presentation/features/learn/widgets/quiz_checkpoint_widget.dart';
import 'package:monster_lab/presentation/features/learn/activities/activity_registry.dart';

/// Interactive Flutter Widget Preview Container for a Lesson Step.
/// Renders the exact UI card, theme, markdown, and interactive simulator widget.
class LessonStepPreviewView extends StatelessWidget {
  final Lesson lesson;
  final int stepIndex;
  final double? width;

  const LessonStepPreviewView({
    super.key,
    required this.lesson,
    required this.stepIndex,
    this.width = 420,
  });

  @override
  Widget build(BuildContext context) {
    final step = lesson.steps[stepIndex];
    final totalSteps = lesson.steps.length;

    return Container(
      width: width,
      decoration: BoxDecoration(
        color: AppColors.backgroundDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.surfaceContainerDark, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (stepIndex + 1) / totalSteps,
                backgroundColor: AppColors.surfaceContainerDark,
                valueColor:
                    const AlwaysStoppedAnimation(AppColors.primaryViolet),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 12),

            // Step Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Step ${stepIndex + 1} of $totalSteps',
                  style: const TextStyle(
                    color: AppColors.primaryViolet,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                Text(
                  '${lesson.estimatedMinutes} min • +${lesson.xpReward} XP',
                  style: const TextStyle(
                    color: AppColors.textSecondaryDark,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Step Title
            Text(
              step.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppColors.textPrimaryDark,
              ),
            ),

            if (step.quickCheck != null && step.quickCheck!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryViolet.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: AppColors.primaryViolet.withValues(alpha: 0.3)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('🧠', style: TextStyle(fontSize: 13)),
                    SizedBox(width: 6),
                    Text(
                      'Quick Check Diagnostic Available',
                      style: TextStyle(
                        color: AppColors.primaryViolet,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),

            // Markdown Card
            MonsterCard(
              color: AppColors.surfaceDark,
              child: MonsterMarkdown(
                data: step.markdownContent,
              ),
            ),
            const SizedBox(height: 14),

            // Interactive Activity / Simulator Widget
            if (ActivityRegistry.hasActivity(step.interactiveWidgetType)) ...[
              ActivityRegistry.buildActivity(
                context: context,
                activityType: step.interactiveWidgetType,
                config: step.interactiveConfig,
              )!,
              const SizedBox(height: 14),
            ],

            // Quiz Checkpoint
            if (step.type == StepType.quizCheckpoint &&
                step.interactiveConfig != null) ...[
              QuizCheckpointWidget(
                question: step.interactiveConfig!['question'] as String? ?? '',
                options: (step.interactiveConfig!['options'] as List?)
                        ?.map((e) => e.toString())
                        .toList() ??
                    const [],
                correctIndex:
                    step.interactiveConfig!['correctIndex'] as int? ?? 0,
                questions: (step.interactiveConfig!['questions'] as List?)
                    ?.map((q) => Map<String, dynamic>.from(q as Map))
                    .toList(),
                explanation: step.interactiveConfig!['explanation'] as String?,
                onAnswerSubmitted: (_) {},
              ),
              const SizedBox(height: 14),
            ],

            // Action Button
            Container(
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primaryViolet,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                stepIndex < totalSteps - 1
                    ? 'Next Step ➔'
                    : 'Complete Lesson (+${lesson.xpReward} XP)',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Sample Static Lesson Data for l01_01 Previews (Offline / In-Memory Mock)
// -----------------------------------------------------------------------------
const Lesson sampleL0101 = Lesson(
  id: 'l01_01',
  title: 'What Is Arduino?',
  summary: 'Every monster robot needs a brain to explore the world.',
  tier: DifficultyTier.rookie,
  estimatedMinutes: 10,
  courseId: 'lesson_01',
  sortOrder: 1,
  isOptional: false,
  prerequisites: [],
  componentIds: ['comp_uno'],
  xpReward: 10,
  steps: [
    LessonStep(
      stepId: 'l01_s01',
      title: 'What Is Arduino?',
      type: StepType.story,
      markdownContent:
          'Welcome to the Monster Lab! 🤖\n\nEvery monster robot needs a brain to explore the world. That brain is the **Arduino Uno**!\n\nThe Arduino is a friendly little computer board that connects a robot\'s **senses** to its **actions**:\n- When you press a button, the Arduino notices.\n- It thinks about what happened using your code.\n- Then it commands lights to glow or wheels to roll!\n\n`Sense (Input) ➔ Think (Arduino) ➔ Act (Output)`',
      quickCheck: [
        QuickCheckQuestion(
          questionId: 'l01_s01_q1',
          question: 'What part of a robot helps it decide what to do?',
          options: [
            'A small computer brain',
            'A shiny coat of paint',
            'A cardboard box'
          ],
          correctIndex: 0,
          explanation: 'A robot uses a computer brain to decide what to do!',
          warmupExplanation:
              'Robots have little computer brains to make choices.',
        ),
      ],
    ),
    LessonStep(
      stepId: 'l01_01_s02',
      title: 'The Robot Signal Flow',
      type: StepType.visualExplanation,
      markdownContent:
          '### How Signals Travel Through Monster Brains ⚡\n\nEvery smart robot follows the **Sense-Think-Act Loop**:\n- **Sense (Input)**: Sensors measure the world.\n- **Think (Arduino Brain)**: The microcontroller reads signals and executes instructions.\n- **Act (Output)**: Commands actuators to move, shine, or beep!\n\n> **Golden Rule**: The Arduino runs this loop thousands of times every single second.',
    ),
    LessonStep(
      stepId: 'l01_01_s03',
      title: 'Test the Brain\'s Signal Pulse',
      type: StepType.codeExperiment,
      interactiveWidgetType: 'visualFlowDiagram',
      markdownContent:
          '### Send a Pulse Through the Robot Brain! 🚀\n\nWatch a signal pulse travel across the 4-stage pipeline:\n1. **SENSE**: Sensor detects input.\n2. **TRANSMIT**: Wires send voltage to pins.\n3. **DECIDE**: Your code makes a choice.\n4. **ACT**: Actuator responds physically!\n\nTap each stage below to learn its job, then hit **Test Signal Pulse**!',
      interactiveConfig: {},
    ),
    LessonStep(
      stepId: 'l01_01_s04',
      title: 'Arduino Brain Checkpoint',
      type: StepType.quizCheckpoint,
      markdownContent:
          'Prove your rookie engineer skills by answering these checkpoint questions about the Arduino brain!',
      interactiveConfig: {
        'question': 'What is the main job of an Arduino in a robot project?',
        'options': [
          'It acts as the robot brain, reading sensors and commanding outputs',
          'It only paints the robot cool colors',
          'It acts like a heavy brick'
        ],
        'correctIndex': 0,
        'explanation':
            'The Arduino is the electronic brain that connects senses to physical actions!',
        'questions': [
          {
            'question':
                'What is the main job of an Arduino in a robot project?',
            'options': [
              'It acts as the robot brain, reading sensors and commanding outputs',
              'It only paints the robot cool colors',
              'It acts like a heavy brick'
            ],
            'correctIndex': 0,
            'explanation':
                'The Arduino is the electronic brain that connects senses to physical actions!'
          },
          {
            'question': 'What are the three steps in the robot decision loop?',
            'options': [
              'Sense (Input) ➔ Think (Arduino) ➔ Act (Output)',
              'Sleep ➔ Eat ➔ Nap',
              'Spin ➔ Drop ➔ Disappear'
            ],
            'correctIndex': 0,
            'explanation':
                'Robots sense physical signals, think using code, and act using outputs!'
          }
        ]
      },
    ),
  ],
);

// -----------------------------------------------------------------------------
// Official Flutter Widget Previews (@Preview annotations)
// -----------------------------------------------------------------------------

// MOBILE FORM FACTOR (390px)
@Preview(name: 'Mobile: Step 1 - Story & Pre-Test', group: 'Lesson 1 - Mobile')
Widget previewL0101Step1Mobile() {
  return MaterialApp(
    theme: AppTheme.darkTheme,
    home: const Scaffold(
      backgroundColor: Color(0xFF0F111A),
      body: Center(
        child: SingleChildScrollView(
          child: LessonStepPreviewView(
            lesson: sampleL0101,
            stepIndex: 0,
            width: 390,
          ),
        ),
      ),
    ),
  );
}

@Preview(
    name: 'Mobile: Step 2 - Visual Signal Flow', group: 'Lesson 1 - Mobile')
Widget previewL0101Step2Mobile() {
  return MaterialApp(
    theme: AppTheme.darkTheme,
    home: const Scaffold(
      backgroundColor: Color(0xFF0F111A),
      body: Center(
        child: SingleChildScrollView(
          child: LessonStepPreviewView(
            lesson: sampleL0101,
            stepIndex: 1,
            width: 390,
          ),
        ),
      ),
    ),
  );
}

@Preview(
    name: 'Mobile: Step 3 - Interactive Simulator', group: 'Lesson 1 - Mobile')
Widget previewL0101Step3Mobile() {
  return MaterialApp(
    theme: AppTheme.darkTheme,
    home: const Scaffold(
      backgroundColor: Color(0xFF0F111A),
      body: Center(
        child: SingleChildScrollView(
          child: LessonStepPreviewView(
            lesson: sampleL0101,
            stepIndex: 2,
            width: 390,
          ),
        ),
      ),
    ),
  );
}

@Preview(name: 'Mobile: Step 4 - Checkpoint Quiz', group: 'Lesson 1 - Mobile')
Widget previewL0101Step4Mobile() {
  return MaterialApp(
    theme: AppTheme.darkTheme,
    home: const Scaffold(
      backgroundColor: Color(0xFF0F111A),
      body: Center(
        child: SingleChildScrollView(
          child: LessonStepPreviewView(
            lesson: sampleL0101,
            stepIndex: 3,
            width: 390,
          ),
        ),
      ),
    ),
  );
}

// DESKTOP / TABLET FORM FACTOR (720px)
@Preview(
    name: 'Desktop: Step 1 - Story & Pre-Test', group: 'Lesson 1 - Desktop')
Widget previewL0101Step1Desktop() {
  return MaterialApp(
    theme: AppTheme.darkTheme,
    home: const Scaffold(
      backgroundColor: Color(0xFF0F111A),
      body: Center(
        child: SingleChildScrollView(
          child: LessonStepPreviewView(
            lesson: sampleL0101,
            stepIndex: 0,
            width: 720,
          ),
        ),
      ),
    ),
  );
}

@Preview(
    name: 'Desktop: Step 2 - Visual Signal Flow', group: 'Lesson 1 - Desktop')
Widget previewL0101Step2Desktop() {
  return MaterialApp(
    theme: AppTheme.darkTheme,
    home: const Scaffold(
      backgroundColor: Color(0xFF0F111A),
      body: Center(
        child: SingleChildScrollView(
          child: LessonStepPreviewView(
            lesson: sampleL0101,
            stepIndex: 1,
            width: 720,
          ),
        ),
      ),
    ),
  );
}

@Preview(
    name: 'Desktop: Step 3 - Interactive Simulator',
    group: 'Lesson 1 - Desktop')
Widget previewL0101Step3Desktop() {
  return MaterialApp(
    theme: AppTheme.darkTheme,
    home: const Scaffold(
      backgroundColor: Color(0xFF0F111A),
      body: Center(
        child: SingleChildScrollView(
          child: LessonStepPreviewView(
            lesson: sampleL0101,
            stepIndex: 2,
            width: 720,
          ),
        ),
      ),
    ),
  );
}

@Preview(name: 'Desktop: Step 4 - Checkpoint Quiz', group: 'Lesson 1 - Desktop')
Widget previewL0101Step4Desktop() {
  return MaterialApp(
    theme: AppTheme.darkTheme,
    home: const Scaffold(
      backgroundColor: Color(0xFF0F111A),
      body: Center(
        child: SingleChildScrollView(
          child: LessonStepPreviewView(
            lesson: sampleL0101,
            stepIndex: 3,
            width: 720,
          ),
        ),
      ),
    ),
  );
}
