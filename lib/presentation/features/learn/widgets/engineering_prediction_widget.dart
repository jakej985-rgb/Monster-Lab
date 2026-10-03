import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

class EngineeringPredictionWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const EngineeringPredictionWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<EngineeringPredictionWidget> createState() =>
      _EngineeringPredictionWidgetState();
}

class _EngineeringPredictionWidgetState
    extends State<EngineeringPredictionWidget> {
  static const List<String> _habitSteps = [
    '1. Read Code',
    '2. Predict',
    '3. Upload',
    '4. Observe',
    '5. Verify',
    '6. Change & Test',
  ];

  int?
      _predictionIndex; // 0 = half brightness, 1 = OFF (correct), 2 = overheats
  bool _tested = false;

  void _testHypothesis() {
    setState(() {
      _tested = true;
    });
    if (_predictionIndex == 1) {
      widget.onComplete?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        'Trust But Verify: The Scientific Engineering Loop';

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
                  color: AppColors.energyAmber.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.science,
                  color: AppColors.energyAmber,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.energyAmber,
                  ),
                ),
              ),
              if (_tested && _predictionIndex == 1)
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
                        'VERIFIED',
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
          Text(
            'Engineers never blindly run code. We form a hypothesis, predict the physical result, and observe the reality.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 16),

          // Habit Loop Carousel / Chips
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'The 6-Step Robotics Loop:',
                  style: TextStyle(
                    color: AppColors.accentCyan,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: _habitSteps.map((step) {
                    final isHighlight = (_tested && step.contains('Verify')) ||
                        (!_tested &&
                            _predictionIndex != null &&
                            step.contains('Predict'));

                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isHighlight
                            ? AppColors.energyAmber.withValues(alpha: 0.25)
                            : const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isHighlight
                              ? AppColors.energyAmber
                              : const Color(0xFF475569),
                        ),
                      ),
                      child: Text(
                        step,
                        style: TextStyle(
                          color: isHighlight ? Colors.white : Colors.white70,
                          fontSize: 11,
                          fontWeight:
                              isHighlight ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Interactive Experiment Scenario
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2E),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _tested
                    ? (_predictionIndex == 1
                        ? AppColors.success
                        : AppColors.warning)
                    : const Color(0xFF475569),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hypothesis Challenge: You change the code to:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'digitalWrite(13, LOW);',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.syntaxConstant,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Predict: What will the Pin 13 LED physically do?',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                ...List.generate(3, (index) {
                  final labels = [
                    'Turn half brightness',
                    'Turn completely OFF (0.0 Volts)',
                    'Overheat the microcontroller chip'
                  ];

                  final isSelected = _predictionIndex == index;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _predictionIndex = index;
                          _tested = false;
                        });
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.accentCyan.withValues(alpha: 0.2)
                              : const Color(0xFF0F172A),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.accentCyan
                                : const Color(0xFF334155),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSelected
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_unchecked,
                              color: isSelected
                                  ? AppColors.accentCyan
                                  : Colors.white54,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                labels[index],
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.white70,
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
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: _predictionIndex != null ? _testHypothesis : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentCyan,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.flash_on, size: 18),
                  label: const Text(
                    'Upload & Observe LED ➔',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                if (_tested) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _predictionIndex == 1
                          ? AppColors.success.withValues(alpha: 0.15)
                          : AppColors.danger.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _predictionIndex == 1
                            ? AppColors.success
                            : AppColors.danger,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _predictionIndex == 1
                              ? Icons.verified
                              : Icons.warning_amber,
                          color: _predictionIndex == 1
                              ? AppColors.success
                              : AppColors.danger,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _predictionIndex == 1
                                ? 'Hypothesis Confirmed! Pin 13 is commanded to 0V (LOW). Current stops flowing, turning the LED OFF.'
                                : 'Notice the hardware: Digital pins can only output 0V or 5V. LOW connects to 0V ground, so the LED turns OFF completely.',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
