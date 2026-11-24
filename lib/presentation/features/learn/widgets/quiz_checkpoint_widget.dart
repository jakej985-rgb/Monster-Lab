import 'package:material_ui/material_ui.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';
import '../../../shared/widgets/monster_button.dart';

class QuizCheckpointWidget extends StatefulWidget {
  final String question;
  final List<String> options;
  final int correctIndex;
  final ValueChanged<bool> onAnswerSubmitted;
  final VoidCallback? onDeckComplete;
  final List<Map<String, dynamic>>? questions;
  final String? explanation;

  const QuizCheckpointWidget({
    super.key,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.onAnswerSubmitted,
    this.onDeckComplete,
    this.questions,
    this.explanation,
  });

  @override
  State<QuizCheckpointWidget> createState() => _QuizCheckpointWidgetState();
}

class _QuizCheckpointWidgetState extends State<QuizCheckpointWidget> {
  int _currentQuestionIndex = 0;
  int? _selectedIndex;
  bool _hasSubmitted = false;
  int _correctCount = 0;
  bool _isDeckComplete = false;

  @override
  void didUpdateWidget(covariant QuizCheckpointWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question != widget.question ||
        oldWidget.questions != widget.questions) {
      setState(() {
        _currentQuestionIndex = 0;
        _selectedIndex = null;
        _hasSubmitted = false;
        _correctCount = 0;
        _isDeckComplete = false;
      });
    }
  }

  bool get _isMultiQuestion =>
      widget.questions != null && widget.questions!.isNotEmpty;

  void _submitSingle() {
    if (_selectedIndex == null || _hasSubmitted) return;
    setState(() => _hasSubmitted = true);
    widget.onAnswerSubmitted(_selectedIndex == widget.correctIndex);
  }

  void _submitMulti() {
    if (_selectedIndex == null || _hasSubmitted) return;
    final currentQ = widget.questions![_currentQuestionIndex];
    final correctIdx = currentQ['correctIndex'] as int? ?? 0;
    final isCorrect = _selectedIndex == correctIdx;

    setState(() {
      _hasSubmitted = true;
      if (isCorrect) {
        _correctCount++;
      }
    });

    widget.onAnswerSubmitted(isCorrect);
  }

  void _advanceMulti() {
    if (_isDeckComplete) return;
    if (_currentQuestionIndex < widget.questions!.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedIndex = null;
        _hasSubmitted = false;
      });
    } else {
      setState(() {
        _isDeckComplete = true;
      });
      widget.onAnswerSubmitted(true);
      widget.onDeckComplete?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isMultiQuestion) {
      return _buildMultiQuestion();
    }
    return _buildSingleQuestion();
  }

  Widget _buildMultiQuestion() {
    final colorScheme = Theme.of(context).colorScheme;
    if (_isDeckComplete) {
      return MonsterCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Row(
              children: [
                Icon(Icons.military_tech,
                    color: AppColors.energyAmber, size: 28),
                SizedBox(width: 8),
                Text(
                  'Assessment Complete!',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Assessment Complete! All ${widget.questions!.length} Questions Answered.',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 8),
            Text(
              'You scored $_correctCount of ${widget.questions!.length} correct! Great job mastering these robotics concepts.',
              style:
                  TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      );
    }

    final currentQ = widget.questions![_currentQuestionIndex];
    final qText = currentQ['question'] as String? ?? '';
    final qOptions = List<String>.from(currentQ['options'] as List? ?? []);
    final qCorrectIndex = currentQ['correctIndex'] as int? ?? 0;
    final qExplanation = currentQ['explanation'] as String?;
    final isCorrect = _selectedIndex == qCorrectIndex;

    return MonsterCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.quiz, color: AppColors.energyAmber),
              const SizedBox(width: 8),
              const Text(
                'Knowledge Checkpoint',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const Spacer(),
              Text(
                'Question ${_currentQuestionIndex + 1} of ${widget.questions!.length}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: AppColors.primaryViolet,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / widget.questions!.length,
            backgroundColor: colorScheme.surfaceContainerHighest,
            valueColor: const AlwaysStoppedAnimation(AppColors.primaryViolet),
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
          const SizedBox(height: 12),
          Text(
            qText,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 16),

          // Options List
          ..._buildOptionsList(
            options: qOptions,
            correctIndex: qCorrectIndex,
            isCorrect: isCorrect,
          ),

          const SizedBox(height: 12),

          if (!_hasSubmitted)
            MonsterButton(
              label: 'Submit Answer',
              icon: Icons.check,
              onPressed: _selectedIndex != null ? _submitMulti : null,
            )
          else ...[
            _buildFeedback(
              isCorrect: isCorrect,
              explanation: qExplanation,
            ),
            const SizedBox(height: 12),
            MonsterButton(
              label: _currentQuestionIndex < widget.questions!.length - 1
                  ? 'Next Question'
                  : 'Finish Assessment',
              icon: _currentQuestionIndex < widget.questions!.length - 1
                  ? Icons.arrow_forward
                  : Icons.check_circle,
              onPressed: _advanceMulti,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSingleQuestion() {
    final isCorrect = _selectedIndex == widget.correctIndex;

    return MonsterCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            children: [
              Icon(Icons.quiz, color: AppColors.energyAmber),
              SizedBox(width: 8),
              Text(
                'Knowledge Checkpoint',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.question,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 16),

          // Options List
          ..._buildOptionsList(
            options: widget.options,
            correctIndex: widget.correctIndex,
            isCorrect: isCorrect,
          ),

          const SizedBox(height: 12),

          if (!_hasSubmitted)
            MonsterButton(
              label: 'Submit Answer',
              icon: Icons.check,
              onPressed: _selectedIndex != null ? _submitSingle : null,
            )
          else
            _buildFeedback(
              isCorrect: isCorrect,
              explanation: widget.explanation,
            ),
        ],
      ),
    );
  }

  List<Widget> _buildOptionsList({
    required List<String> options,
    required int correctIndex,
    required bool isCorrect,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return List.generate(options.length, (index) {
      final optionText = options[index];
      final isChosen = _selectedIndex == index;

      Color borderColor = colorScheme.outlineVariant;
      Color bgColor = colorScheme.surface;
      IconData? trailingIcon;

      if (_hasSubmitted) {
        if (index == correctIndex) {
          borderColor = AppColors.success;
          bgColor = AppColors.success.withValues(alpha: 0.1);
          trailingIcon = Icons.check_circle;
        } else if (isChosen && !isCorrect) {
          borderColor = AppColors.danger;
          bgColor = AppColors.danger.withValues(alpha: 0.1);
          trailingIcon = Icons.cancel;
        }
      } else if (isChosen) {
        borderColor = AppColors.primaryViolet;
        bgColor = AppColors.primaryViolet.withValues(alpha: 0.08);
      }

      final optionLetter = String.fromCharCode(65 + index);
      return Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Semantics(
          button: !_hasSubmitted,
          selected: isChosen,
          inMutuallyExclusiveGroup: true,
          excludeSemantics: true,
          label: 'Option $optionLetter: $optionText',
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: _hasSubmitted
                ? null
                : () => setState(() => _selectedIndex = index),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: borderColor, width: 2),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: isChosen
                        ? (_hasSubmitted
                            ? (isCorrect ? AppColors.success : AppColors.danger)
                            : AppColors.primaryViolet)
                        : colorScheme.surfaceContainerHighest,
                    child: Text(
                      optionLetter,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isChosen
                            ? Colors.white
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      optionText,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                  if (trailingIcon != null)
                    Icon(
                      trailingIcon,
                      color: index == correctIndex
                          ? AppColors.success
                          : AppColors.danger,
                      size: 20,
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildFeedback({
    required bool isCorrect,
    String? explanation,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final successColor =
        isDark ? AppColors.success : AppColors.textSuccessOnLight;
    final prefix = isCorrect ? 'Spot on! ' : 'Not quite! ';
    final feedbackText = explanation != null
        ? '$prefix$explanation'
        : (isCorrect
            ? 'Spot on! You nailed this concept.'
            : 'Not quite! Check the explanation above and review the rule.');

    return Semantics(
      liveRegion: true,
      label: feedbackText,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isCorrect
              ? AppColors.success.withValues(alpha: 0.12)
              : AppColors.danger.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              isCorrect ? Icons.celebration : Icons.info_outline,
              color: isCorrect ? successColor : AppColors.danger,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                feedbackText,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isCorrect ? successColor : AppColors.danger,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
