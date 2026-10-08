import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../domain/models/lesson_model.dart';
import '../../../../domain/models/learner_progress_model.dart';
import '../../../shared/widgets/monster_button.dart';
import '../../../shared/widgets/monster_card.dart';

/// Modal dialog offering an optional 2-question pre-test diagnostic (Quick Check).
class QuickCheckModal extends StatefulWidget {
  final String lessonId;
  final String submoduleId;
  final String submoduleTitle;
  final List<QuickCheckQuestion> questions;
  final void Function(QuickCheckResult result) onCompleted;

  const QuickCheckModal({
    super.key,
    required this.lessonId,
    required this.submoduleId,
    required this.submoduleTitle,
    required this.questions,
    required this.onCompleted,
  });

  /// Shows the Quick Check dialog. Returns true if completed/dismissed.
  static Future<void> show({
    required BuildContext context,
    required String lessonId,
    required String submoduleId,
    required String submoduleTitle,
    required List<QuickCheckQuestion> questions,
    required void Function(QuickCheckResult result) onCompleted,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => QuickCheckModal(
        lessonId: lessonId,
        submoduleId: submoduleId,
        submoduleTitle: submoduleTitle,
        questions: questions,
        onCompleted: onCompleted,
      ),
    );
  }

  @override
  State<QuickCheckModal> createState() => _QuickCheckModalState();
}

class _QuickCheckModalState extends State<QuickCheckModal> {
  bool _isTakingCheck = false;
  int _currentQuestionIndex = 0;
  final Map<int, int> _selectedOptions = {};
  bool _hasSubmitted = false;

  void _bypassCheck() {
    final result = QuickCheckResult(
      lessonId: widget.lessonId,
      submoduleId: widget.submoduleId,
      questionIds: widget.questions.map((q) => q.questionId).toList(),
      selectedAnswers: const [],
      isBypassed: true,
      readiness: QuickCheckReadiness.notAssessed,
      timestamp: DateTime.now(),
      warmupShown: false,
    );
    widget.onCompleted(result);
    Navigator.of(context).pop();
  }

  void _submitAnswers() {
    setState(() {
      _hasSubmitted = true;
    });

    int correctCount = 0;
    for (int i = 0; i < widget.questions.length; i++) {
      if (_selectedOptions[i] == widget.questions[i].correctIndex) {
        correctCount++;
      }
    }

    final isReady = correctCount == widget.questions.length;
    final readiness =
        isReady ? QuickCheckReadiness.ready : QuickCheckReadiness.warmUp;

    final result = QuickCheckResult(
      lessonId: widget.lessonId,
      submoduleId: widget.submoduleId,
      questionIds: widget.questions.map((q) => q.questionId).toList(),
      selectedAnswers: List.generate(
        widget.questions.length,
        (i) => _selectedOptions[i] ?? -1,
      ),
      isBypassed: false,
      readiness: readiness,
      timestamp: DateTime.now(),
      warmupShown: !isReady,
    );
    widget.onCompleted(result);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: AppColors.surfaceLight,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (!_isTakingCheck) {
      return _buildIntroView();
    }
    if (_hasSubmitted) {
      return _buildResultView();
    }
    return _buildQuestionView();
  }

  Widget _buildIntroView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.primaryViolet,
              child: Text('🧠', style: TextStyle(fontSize: 24)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quick Check — About 1 minute',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.submoduleTitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        const Text(
          "Let's see what you already know. Your answers help Monster Lab decide what to explain.",
          style: TextStyle(
            fontSize: 15,
            color: AppColors.textPrimaryLight,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 24),
        MonsterButton(
          label: 'Take Quick Check',
          icon: Icons.checklist,
          onPressed: () {
            setState(() {
              _isTakingCheck = true;
            });
          },
        ),
        const SizedBox(height: 10),
        OutlinedButton(
          onPressed: _bypassCheck,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'I already know this — Start Lesson',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: AppColors.primaryViolet,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionView() {
    final q = widget.questions[_currentQuestionIndex];
    final selected = _selectedOptions[_currentQuestionIndex];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Question ${_currentQuestionIndex + 1} of ${widget.questions.length}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: AppColors.primaryViolet,
              ),
            ),
            Text(
              'Diagnostic',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondaryLight.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          q.question,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 16),
        ...List.generate(q.options.length, (optIdx) {
          final isSelected = selected == optIdx;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                setState(() {
                  _selectedOptions[_currentQuestionIndex] = optIdx;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryViolet.withValues(alpha: 0.12)
                      : AppColors.surfaceContainerLight,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryViolet
                        : Colors.transparent,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: isSelected
                          ? AppColors.primaryViolet
                          : AppColors.textSecondaryLight,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        q.options[optIdx],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: AppColors.textPrimaryLight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_currentQuestionIndex > 0)
              TextButton(
                onPressed: () {
                  setState(() {
                    _currentQuestionIndex--;
                  });
                },
                child: const Text('Previous'),
              )
            else
              const SizedBox.shrink(),
            if (_currentQuestionIndex < widget.questions.length - 1)
              MonsterButton(
                label: 'Next Question',
                icon: Icons.arrow_forward,
                onPressed: selected != null
                    ? () {
                        setState(() {
                          _currentQuestionIndex++;
                        });
                      }
                    : null,
              )
            else
              MonsterButton(
                label: 'Check Readiness',
                icon: Icons.done_all,
                onPressed: selected != null ? _submitAnswers : null,
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildResultView() {
    int correctCount = 0;
    for (int i = 0; i < widget.questions.length; i++) {
      if (_selectedOptions[i] == widget.questions[i].correctIndex) {
        correctCount++;
      }
    }
    final isReady = correctCount == widget.questions.length;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor:
                  isReady ? const Color(0xFF2E7D32) : const Color(0xFFF57F17),
              child: Icon(
                isReady ? Icons.check : Icons.lightbulb,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isReady ? '🟢 Ready!' : '🟡 Warm Up Review',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    '$correctCount of ${widget.questions.length} questions correct',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (isReady)
          const Text(
            "Great foundation! You're fully prepared to dive into this submodule.",
            style: TextStyle(fontSize: 14, height: 1.4),
          )
        else ...[
          const Text(
            "No problem! Here is a quick warm-up tip before we begin:",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          MonsterCard(
            color: const Color(0xFFFFF8E1),
            child: Text(
              widget.questions
                      .firstWhere(
                        (q) => q.warmupExplanation != null,
                        orElse: () => widget.questions.first,
                      )
                      .warmupExplanation ??
                  widget.questions.first.explanation,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF424242),
                height: 1.4,
              ),
            ),
          ),
        ],
        const SizedBox(height: 20),
        MonsterButton(
          label: 'Continue to Lesson',
          icon: Icons.play_arrow,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
