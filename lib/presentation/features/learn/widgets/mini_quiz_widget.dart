import 'package:material_ui/material_ui.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

class MiniQuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const MiniQuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  factory MiniQuizQuestion.fromJson(Map<String, dynamic> json) {
    return MiniQuizQuestion(
      question: json['question'] as String? ?? 'Question',
      options: (json['options'] as List? ?? ['Option 1', 'Option 2'])
          .map((e) => e.toString())
          .toList(),
      correctIndex: json['correctIndex'] as int? ?? 0,
      explanation: json['explanation'] as String? ?? '',
    );
  }
}

class MiniQuizWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const MiniQuizWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<MiniQuizWidget> createState() => _MiniQuizWidgetState();
}

class _MiniQuizWidgetState extends State<MiniQuizWidget> {
  late List<MiniQuizQuestion> _questions;
  int _currentIndex = 0;
  int? _selectedOption;
  bool _answered = false;
  int _correctScore = 0;
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
          .map((item) => MiniQuizQuestion.fromJson(item))
          .toList();
    } else {
      _questions = const [
        MiniQuizQuestion(
          question: 'In robotics, what is the role of an Input component?',
          options: [
            'Senses the environment and sends data into the Arduino',
            'Performs a physical action like spinning or lighting up',
            'Supplies unlimited electrical power',
          ],
          correctIndex: 0,
          explanation:
              'Inputs (sensors and buttons) feed real-world telemetry into the microcontroller.',
        ),
        MiniQuizQuestion(
          question: 'What is an Output component?',
          options: [
            'A sensor that measures room temperature',
            'An actuator (LED, buzzer, motor) that creates light, sound, or motion',
            'A computer mouse',
          ],
          correctIndex: 1,
          explanation:
              'Outputs receive commands from the microcontroller and act on the physical world.',
        ),
        MiniQuizQuestion(
          question:
              'Why must the pin number in your code match your physical wire?',
          options: [
            'The Arduino automatically moves electricity to any pin',
            'Electricity only flows to the specific physical pin commanded by code',
            'Pin numbers are just optional comments',
          ],
          correctIndex: 1,
          explanation:
              'digitalWrite(pin, HIGH) energizes that exact silicon pin on the microcontroller header.',
        ),
        MiniQuizQuestion(
          question: 'What is the purpose of software code?',
          options: [
            'To decorate the screen with colors',
            'To give the microcontroller instructions on what conditions to check and actions to take',
            'To replace the USB cable',
          ],
          correctIndex: 1,
          explanation:
              'Code is the brain\'s thought process, linking inputs to decisions and outputs.',
        ),
      ];
    }
  }

  void _submitAnswer(int index) {
    if (_answered) return;
    final isCorrect = index == _questions[_currentIndex].correctIndex;

    setState(() {
      _selectedOption = index;
      _answered = true;
      if (isCorrect) {
        _correctScore++;
      }
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
      _correctScore = 0;
      _isFinished = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        'Self-Reflection Checkpoint: Monster Lab Is the Teacher';

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
                  color: AppColors.primaryViolet.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.auto_awesome,
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
                        'REVIEWED',
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
            // Progress
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
                  'Score: $_correctScore / ${_questions.length}',
                  style: const TextStyle(
                    color: AppColors.energyAmber,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
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
              final isCorrect = index == _questions[_currentIndex].correctIndex;

              Color borderCol = const Color(0xFF334155);
              Color bgCol = const Color(0xFF1E293B);

              if (_answered) {
                if (isCorrect) {
                  borderCol = AppColors.success;
                  bgCol = AppColors.success.withValues(alpha: 0.15);
                } else if (isSelected) {
                  borderCol = AppColors.danger;
                  bgCol = AppColors.danger.withValues(alpha: 0.15);
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
                              ? (isCorrect
                                  ? Icons.check_circle
                                  : (isSelected
                                      ? Icons.cancel
                                      : Icons.radio_button_unchecked))
                              : Icons.radio_button_unchecked,
                          color: _answered
                              ? (isCorrect
                                  ? AppColors.success
                                  : (isSelected
                                      ? AppColors.danger
                                      : Colors.white30))
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

            if (_answered) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _selectedOption ==
                            _questions[_currentIndex].correctIndex
                        ? AppColors.success
                        : AppColors.energyAmber,
                  ),
                ),
                child: Text(
                  _questions[_currentIndex].explanation,
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
                      : 'Complete Reflection ➔',
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
                    Icons.workspace_premium,
                    size: 48,
                    color: AppColors.energyAmber,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Ready for the Final Knowledge Check!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You answered $_correctScore / ${_questions.length} questions correctly. You have solid understanding of inputs, decisions, outputs, and circuit wiring.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
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
