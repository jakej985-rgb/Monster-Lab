import 'package:material_ui/material_ui.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

class PriorKnowledgeQuestion {
  final String question;
  final List<String> options;
  final int? correctIndex; // null means survey question
  final String? explanation;

  const PriorKnowledgeQuestion({
    required this.question,
    required this.options,
    this.correctIndex,
    this.explanation,
  });

  factory PriorKnowledgeQuestion.fromJson(Map<String, dynamic> json) {
    return PriorKnowledgeQuestion(
      question: json['question'] as String? ?? 'Question',
      options: (json['options'] as List? ?? ['Option 1', 'Option 2'])
          .map((e) => e.toString())
          .toList(),
      correctIndex: json['correctIndex'] as int?,
      explanation: json['explanation'] as String?,
    );
  }
}

class PriorKnowledgeCheckWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const PriorKnowledgeCheckWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<PriorKnowledgeCheckWidget> createState() =>
      _PriorKnowledgeCheckWidgetState();
}

class _PriorKnowledgeCheckWidgetState extends State<PriorKnowledgeCheckWidget> {
  late List<PriorKnowledgeQuestion> _questions;
  int _currentIndex = 0;
  int? _selectedOption;
  bool _answered = false;
  bool _isFinished = false;

  @override
  void initState() {
    super.initState();
    _initQuestions();
  }

  void _initQuestions() {
    if (widget.config != null && widget.config!['questions'] is List) {
      final list = widget.config!['questions'] as List;
      _questions = list
          .whereType<Map<String, dynamic>>()
          .map((item) => PriorKnowledgeQuestion.fromJson(item))
          .toList();
    } else {
      _questions = const [
        PriorKnowledgeQuestion(
          question:
              'Have you ever written code or programmed electronics before?',
          options: [
            'Yes, lots of times!',
            'A little bit with Scratch or Python',
            'This is my very first time!'
          ],
          correctIndex: null,
          explanation:
              'Welcome! Whether you are a total rookie or already know some coding, Monster Lab starts with physical intuition and guides you step-by-step.',
        ),
        PriorKnowledgeQuestion(
          question: 'In your own words, what is a computer program?',
          options: [
            'Step-by-step instructions that tell a computer what to do',
            'A type of physical battery that powers electronics',
            'A USB cable connecting components'
          ],
          correctIndex: 0,
          explanation:
              'Exactly! A program (called a "sketch" in Arduino) is simply a recipe of instructions that the microcontroller CPU executes.',
        ),
        PriorKnowledgeQuestion(
          question: 'What is the USB cable used for in your Monster Lab setup?',
          options: [
            'Connecting the computer to the Arduino for 5V power and sending compiled code',
            'Supplying unlimited power to heavy motors',
            'Making the Arduino completely wireless'
          ],
          correctIndex: 0,
          explanation:
              'Spot on! The USB cable acts as an umbilical cord: it delivers 5V DC electricity and carries data packets between your computer and the board.',
        ),
      ];
    }
  }

  void _submitAnswer(int index) {
    if (_answered) return;
    setState(() {
      _selectedOption = index;
      _answered = true;
    });

    if (_currentIndex == _questions.length - 1) {
      setState(() {
        _isFinished = true;
      });
      widget.onComplete?.call();
    }
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedOption = null;
        _answered = false;
      });
    } else {
      setState(() {
        _isFinished = true;
      });
      widget.onComplete?.call();
    }
  }

  void _reset() {
    setState(() {
      _currentIndex = 0;
      _selectedOption = null;
      _answered = false;
      _isFinished = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        'Station Setup: Prior Knowledge Check';

    return MonsterCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.accentCyan.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.psychology,
                  color: AppColors.accentCyan,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.accentCyan,
                  ),
                ),
              ),
              if (_isFinished)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.success),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle,
                          color: AppColors.success, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'CHECKED',
                        style: TextStyle(
                          color: AppColors.success,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          if (!_isFinished) ...[
            // Progress Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question ${_currentIndex + 1} of ${_questions.length}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Diagnostic Readiness',
                  style: TextStyle(
                    color: AppColors.energyAmber.withValues(alpha: 0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (_currentIndex + 1) / _questions.length,
                backgroundColor: const Color(0xFF1E293B),
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.accentCyan),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 16),

            // Question Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Text(
                _questions[_currentIndex].question,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Options
            ...List.generate(_questions[_currentIndex].options.length, (index) {
              final optText = _questions[_currentIndex].options[index];
              final isSelected = _selectedOption == index;
              final targetCorrect = _questions[_currentIndex].correctIndex;
              final isSurvey = targetCorrect == null;

              Color borderCol = const Color(0xFF334155);
              Color bgCol = const Color(0xFF1E293B);

              if (_answered) {
                if (isSurvey) {
                  if (isSelected) {
                    borderCol = AppColors.accentCyan;
                    bgCol = AppColors.accentCyan.withValues(alpha: 0.15);
                  }
                } else {
                  if (index == targetCorrect) {
                    borderCol = AppColors.success;
                    bgCol = AppColors.success.withValues(alpha: 0.15);
                  } else if (isSelected) {
                    borderCol = AppColors.danger;
                    bgCol = AppColors.danger.withValues(alpha: 0.15);
                  }
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  onTap: _answered ? null : () => _submitAnswer(index),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: bgCol,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: borderCol),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _answered
                              ? (isSurvey
                                  ? (isSelected
                                      ? Icons.check_circle
                                      : Icons.radio_button_unchecked)
                                  : (index == targetCorrect
                                      ? Icons.check_circle
                                      : (isSelected
                                          ? Icons.cancel
                                          : Icons.radio_button_unchecked)))
                              : Icons.radio_button_unchecked,
                          color: _answered
                              ? (isSurvey
                                  ? (isSelected
                                      ? AppColors.accentCyan
                                      : Colors.white30)
                                  : (index == targetCorrect
                                      ? AppColors.success
                                      : (isSelected
                                          ? AppColors.danger
                                          : Colors.white30)))
                              : Colors.white54,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            optText,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.white70,
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),

            if (_answered && _questions[_currentIndex].explanation != null) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.accentCyan),
                ),
                child: Text(
                  _questions[_currentIndex].explanation!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _nextQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentCyan,
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.arrow_forward),
                label: Text(
                  _currentIndex < _questions.length - 1
                      ? 'Next Question ➔'
                      : 'Complete Check ➔',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ] else ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.success),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.military_tech,
                    size: 48,
                    color: AppColors.accentCyan,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Pre-Check Complete!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'You are primed to explore the Arduino IDE workbench, compile code into machine hex, and flash your microcontroller.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 14),
                  OutlinedButton.icon(
                    onPressed: _reset,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.accentCyan,
                      side: const BorderSide(color: AppColors.accentCyan),
                    ),
                    icon: const Icon(Icons.refresh, size: 16),
                    label: const Text('Review Again'),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
