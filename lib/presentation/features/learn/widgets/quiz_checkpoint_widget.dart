import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';
import '../../../shared/widgets/monster_button.dart';

class QuizCheckpointWidget extends StatefulWidget {
  final String question;
  final List<String> options;
  final int correctIndex;
  final ValueChanged<bool> onAnswerSubmitted;

  const QuizCheckpointWidget({
    super.key,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.onAnswerSubmitted,
  });

  @override
  State<QuizCheckpointWidget> createState() => _QuizCheckpointWidgetState();
}

class _QuizCheckpointWidgetState extends State<QuizCheckpointWidget> {
  int? _selectedIndex;
  bool _hasSubmitted = false;

  bool get _isCorrect => _selectedIndex == widget.correctIndex;

  void _submit() {
    if (_selectedIndex == null) return;
    setState(() => _hasSubmitted = true);
    widget.onAnswerSubmitted(_isCorrect);
  }

  @override
  Widget build(BuildContext context) {
    return MonsterCard(
      color: AppColors.backgroundLight,
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
          ...List.generate(widget.options.length, (index) {
            final optionText = widget.options[index];
            final isChosen = _selectedIndex == index;

            Color borderColor = Colors.grey.shade300;
            Color bgColor = Colors.white;
            IconData? trailingIcon;

            if (_hasSubmitted) {
              if (index == widget.correctIndex) {
                borderColor = AppColors.success;
                bgColor = AppColors.success.withValues(alpha: 0.1);
                trailingIcon = Icons.check_circle;
              } else if (isChosen && !_isCorrect) {
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
                                  ? (_isCorrect
                                      ? AppColors.success
                                      : AppColors.danger)
                                  : AppColors.primaryViolet)
                              : Colors.grey.shade200,
                          child: Text(
                            optionLetter, // A, B, C...
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isChosen
                                  ? Colors.white
                                  : AppColors.textPrimaryLight,
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
                            color: index == widget.correctIndex
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
          }),

          const SizedBox(height: 12),

          if (!_hasSubmitted)
            MonsterButton(
              label: 'Submit Answer',
              icon: Icons.check,
              onPressed: _selectedIndex != null ? _submit : null,
            )
          else ...[
            Semantics(
              liveRegion: true,
              label: _isCorrect
                  ? 'Spot on! You nailed this concept.'
                  : 'Not quite! Check the explanation above and review the rule.',
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _isCorrect
                      ? AppColors.success.withValues(alpha: 0.12)
                      : AppColors.danger.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      _isCorrect ? Icons.celebration : Icons.info_outline,
                      color: _isCorrect
                          ? AppColors.textSuccessOnLight
                          : AppColors.danger,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _isCorrect
                            ? 'Spot on! You nailed this concept.'
                            : 'Not quite! Check the explanation above and review the rule.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _isCorrect
                              ? AppColors.textSuccessOnLight
                              : AppColors.danger,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
