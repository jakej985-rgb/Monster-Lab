import 'package:material_ui/material_ui.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

class InteractiveBoardInspectorWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const InteractiveBoardInspectorWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<InteractiveBoardInspectorWidget> createState() =>
      _InteractiveBoardInspectorWidgetState();
}

class _InteractiveBoardInspectorWidgetState
    extends State<InteractiveBoardInspectorWidget> {
  // Digital state
  bool _digitalHigh = false;

  // Analog state (0.0 to 5.0 V)
  double _analogVoltage = 2.50;

  // Prediction state
  int?
      _selectedPrediction; // 0 = Stay same, 1 = Change gradually, 2 = Two values
  bool _hasCheckedPrediction = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        'Digital vs. Analog Signals & Prediction';
    final analogAdc = (_analogVoltage / 5.0 * 1023).round();

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
                  Icons.show_chart,
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
              if (_hasCheckedPrediction && _selectedPrediction == 1)
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
                        'EXPLORED',
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
            'Test the two different ways electronic signals speak to the Arduino brain: Binary Digital (HIGH / LOW) vs. Continuous Analog (smooth 0–5V).',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),

          // Digital Explorer Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _digitalHigh
                    ? const Color(0xFF00E676)
                    : const Color(0xFF334155),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.toggle_on,
                            color: Color(0xFF00E676), size: 22),
                        SizedBox(width: 8),
                        Text(
                          '1. Digital Signal (Pin 13)',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _digitalHigh
                            ? const Color(0xFF00E676).withValues(alpha: 0.2)
                            : const Color(0xFF334155),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _digitalHigh ? 'HIGH (5.0V)' : 'LOW (0.0V)',
                        style: TextStyle(
                          color: _digitalHigh
                              ? const Color(0xFF00E676)
                              : Colors.white60,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Digital pins only have TWO states. Think of a light switch: either on or off.',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _digitalHigh
                            ? const Color(0xFF00E676)
                            : const Color(0xFF1E293B),
                        boxShadow: _digitalHigh
                            ? [
                                const BoxShadow(
                                  color: Color(0xFF00E676),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                )
                              ]
                            : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _digitalHigh
                            ? 'LED is ON: Pin 13 is outputting full +5V'
                            : 'LED is OFF: Pin 13 is connected to 0V (GND)',
                        style: TextStyle(
                          color: _digitalHigh ? Colors.white : Colors.white60,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Switch(
                      value: _digitalHigh,
                      activeThumbColor: const Color(0xFF00E676),
                      activeTrackColor:
                          const Color(0xFF00E676).withValues(alpha: 0.5),
                      onChanged: (val) {
                        setState(() {
                          _digitalHigh = val;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Analog Explorer Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.energyAmber),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.tune,
                            color: AppColors.energyAmber, size: 22),
                        SizedBox(width: 8),
                        Text(
                          '2. Analog Signal (Pin A0)',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.energyAmber.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${_analogVoltage.toStringAsFixed(2)} V  ($analogAdc / 1023)',
                        style: const TextStyle(
                          color: AppColors.energyAmber,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Analog signals can be ANY voltage between 0V and 5V. Turn the virtual knob to see the 10-bit reading change gradually!',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 10),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColors.energyAmber,
                    inactiveTrackColor: const Color(0xFF334155),
                    thumbColor: AppColors.energyGold,
                    overlayColor: AppColors.energyAmber.withValues(alpha: 0.2),
                  ),
                  child: Slider(
                    value: _analogVoltage,
                    min: 0.0,
                    max: 5.0,
                    divisions: 50,
                    onChanged: (val) {
                      setState(() {
                        _analogVoltage = val;
                      });
                    },
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: _analogVoltage / 5.0,
                    backgroundColor: const Color(0xFF1E293B),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.energyAmber),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Prediction Challenge
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2E),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _hasCheckedPrediction
                    ? (_selectedPrediction == 1
                        ? AppColors.success
                        : AppColors.warning)
                    : AppColors.primaryViolet,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.psychology,
                        color: AppColors.primaryViolet, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Engineering Prediction Check',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'If you slowly twist a potentiometer knob from one end to the other, what will its electrical reading do?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                ...List.generate(3, (index) {
                  final labels = [
                    'Stay completely the same at all times',
                    'Change gradually and smoothly (0 to 1023)',
                    'Only have two possible values (0 or 5)'
                  ];

                  final isSelected = _selectedPrediction == index;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedPrediction = index;
                          _hasCheckedPrediction = true;
                        });
                        if (index == 1) {
                          widget.onComplete?.call();
                        }
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (index == 1
                                  ? AppColors.success.withValues(alpha: 0.2)
                                  : AppColors.warning.withValues(alpha: 0.2))
                              : const Color(0xFF0F172A),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? (index == 1
                                    ? AppColors.success
                                    : AppColors.warning)
                                : const Color(0xFF334155),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSelected
                                  ? (index == 1
                                      ? Icons.check_circle
                                      : Icons.cancel)
                                  : Icons.radio_button_unchecked,
                              color: isSelected
                                  ? (index == 1
                                      ? AppColors.success
                                      : AppColors.warning)
                                  : Colors.white54,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
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
                if (_hasCheckedPrediction) ...[
                  const SizedBox(height: 6),
                  Text(
                    _selectedPrediction == 1
                        ? 'Correct! A potentiometer divides voltage smoothly, giving the microcontroller an analog stream of numbers.'
                        : 'Think about the slider above! Notice how dragging it continuously alters the voltage and ADC number.',
                    style: TextStyle(
                      color: _selectedPrediction == 1
                          ? AppColors.success
                          : AppColors.energyAmber,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
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
