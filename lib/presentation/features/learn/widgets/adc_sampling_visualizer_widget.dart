import 'package:material_ui/material_ui.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

/// Interactive 10-Bit Successive Approximation ADC sampling visualizer.
/// Demonstrates continuous voltage quantization (0.00V–5.00V) into discrete
/// integer counts (0–1023), resolution step size (4.887 mV), and binary register states.
class AdcSamplingVisualizerWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const AdcSamplingVisualizerWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<AdcSamplingVisualizerWidget> createState() =>
      _AdcSamplingVisualizerWidgetState();
}

class _AdcSamplingVisualizerWidgetState
    extends State<AdcSamplingVisualizerWidget> {
  double _inputVoltage = 2.50; // Continuous voltage 0.0 to 5.0 V
  final Set<int> _testedAdcBuckets = {};
  bool _hasCompleted = false;

  static const double _vRef = 5.0;
  static const int _maxSteps = 1023; // 10-bit (0..1023)
  static const double _stepMv = (_vRef / _maxSteps) * 1000.0; // ~4.8876 mV

  int get _adcCount =>
      ((_inputVoltage / _vRef) * _maxSteps).round().clamp(0, _maxSteps);
  double get _quantizedVoltage => (_adcCount * _vRef) / _maxSteps;
  double get _quantizationErrorMv =>
      ((_inputVoltage - _quantizedVoltage).abs()) * 1000.0;

  String get _binaryRepresentation {
    final bin = _adcCount.toRadixString(2).padLeft(10, '0');
    return '0b$bin';
  }

  void _checkCompletion() {
    _testedAdcBuckets.add((_adcCount / 200).floor());
    if (_testedAdcBuckets.length >= 3 && !_hasCompleted) {
      _hasCompleted = true;
      widget.onComplete?.call();
    }
  }

  void _setVoltage(double val) {
    setState(() {
      _inputVoltage = val.clamp(0.0, 5.0);
      _checkCompletion();
    });
  }

  @override
  void initState() {
    super.initState();
    _checkCompletion();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        '10-Bit ADC Sampling & Quantization Visualizer';

    final adc = _adcCount;
    final vIn = _inputVoltage;
    final vQuant = _quantizedVoltage;
    final errorMv = _quantizationErrorMv;
    final binary = _binaryRepresentation;

    return MonsterCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.accentCyan,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryViolet.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primaryViolet),
                ),
                child: Text(
                  'ADC: $adc / 1023',
                  style: const TextStyle(
                    color: AppColors.accentCyan,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Text(
            'The ATmega328P has a 10-bit Successive Approximation ADC (2^10 = 1024 levels). '
            'It maps continuous analog voltages into integer values from 0 to 1023 with a resolution of ~4.89 mV per step.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondaryDark,
            ),
          ),
          const SizedBox(height: 16),

          // Sampling Visual Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.backgroundDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.surfaceContainerDark),
            ),
            child: Column(
              children: [
                // Digital Converter Display
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildAdcBox(
                      title: 'Analog Input',
                      mainVal: '${vIn.toStringAsFixed(3)} V',
                      subVal: 'Continuous',
                      color: AppColors.energyAmber,
                    ),
                    const Icon(Icons.arrow_forward,
                        color: AppColors.accentCyan, size: 20),
                    _buildAdcBox(
                      title: '10-Bit ADC Count',
                      mainVal: '$adc',
                      subVal: binary,
                      color: AppColors.accentCyan,
                    ),
                    const Icon(Icons.arrow_forward,
                        color: AppColors.accentCyan, size: 20),
                    _buildAdcBox(
                      title: 'Quantized Output',
                      mainVal: '${vQuant.toStringAsFixed(3)} V',
                      subVal: 'Δ: ${errorMv.toStringAsFixed(2)} mV',
                      color: AppColors.success,
                    ),
                  ],
                ),
                const Divider(
                    height: 24, color: AppColors.surfaceContainerDark),

                // Visual Quantization Staircase Bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Discrete Quantization Ladder (0 to 1023 steps):',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondaryDark,
                          ),
                        ),
                        Text(
                          'Step Size: ${_stepMv.toStringAsFixed(2)} mV',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.energyAmber,
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Progress bar showing current quantization position
                    Stack(
                      children: [
                        Container(
                          height: 18,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerDark,
                            borderRadius: BorderRadius.circular(9),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: (adc / 1023.0).clamp(0.01, 1.0),
                          child: Container(
                            height: 18,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.wireGround,
                                  AppColors.accentCyan,
                                  AppColors.energyAmber,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(9),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('0.0V (0)',
                            style: TextStyle(
                                fontSize: 9,
                                color: AppColors.textSecondaryDark)),
                        Text('2.5V (512)',
                            style: TextStyle(
                                fontSize: 9,
                                color: AppColors.textSecondaryDark)),
                        Text('5.0V (1023)',
                            style: TextStyle(
                                fontSize: 9,
                                color: AppColors.textSecondaryDark)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Successive Approximation Register (SAR) 10-bit bit flags
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (int bit = 9; bit >= 0; bit--)
                        _buildBitIndicator(bit, (adc & (1 << bit)) != 0),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Voltage Input Slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Input Voltage (A0):',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                '${vIn.toStringAsFixed(2)} Volts',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                  color: AppColors.energyAmber,
                ),
              ),
            ],
          ),
          Slider(
            key: const Key('adc_voltage_slider'),
            value: _inputVoltage,
            min: 0.0,
            max: 5.0,
            divisions: 500,
            activeColor: AppColors.accentCyan,
            onChanged: (val) => _setVoltage(val),
          ),
          const SizedBox(height: 8),

          // Presets
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ActionChip(
                key: const Key('adc_preset_0v'),
                label: const Text('0.00 V (Count 0)'),
                onPressed: () => _setVoltage(0.0),
              ),
              ActionChip(
                key: const Key('adc_preset_1_25v'),
                label: const Text('1.25 V (Count 256)'),
                onPressed: () => _setVoltage(1.25),
              ),
              ActionChip(
                key: const Key('adc_preset_2_5v'),
                label: const Text('2.50 V (Count 512)'),
                onPressed: () => _setVoltage(2.50),
              ),
              ActionChip(
                key: const Key('adc_preset_3_3v'),
                label: const Text('3.30 V (Count 675)'),
                onPressed: () => _setVoltage(3.30),
              ),
              ActionChip(
                key: const Key('adc_preset_5v'),
                label: const Text('5.00 V (Count 1023)'),
                onPressed: () => _setVoltage(5.00),
              ),
            ],
          ),

          if (_hasCompleted) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.success),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle, color: AppColors.success, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '10-Bit ADC Quantization Mastered! You verified voltage steps, SAR bit registers, and 4.89mV resolution.',
                      style: TextStyle(
                        color: AppColors.success,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAdcBox({
    required String title,
    required String mainVal,
    required String subVal,
    required Color color,
  }) {
    return Column(
      children: [
        Text(title,
            style: const TextStyle(
                color: AppColors.textSecondaryDark, fontSize: 10)),
        const SizedBox(height: 2),
        Text(
          mainVal,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
            fontSize: 14,
          ),
        ),
        Text(
          subVal,
          style: const TextStyle(
            color: AppColors.textSecondaryDark,
            fontFamily: 'monospace',
            fontSize: 9,
          ),
        ),
      ],
    );
  }

  Widget _buildBitIndicator(int bitIndex, bool isHigh) {
    return Column(
      children: [
        Container(
          width: 14,
          height: 16,
          decoration: BoxDecoration(
            color: isHigh ? AppColors.accentCyan : Colors.grey.shade900,
            borderRadius: BorderRadius.circular(2),
          ),
          child: Center(
            child: Text(
              isHigh ? '1' : '0',
              style: TextStyle(
                color: isHigh ? Colors.black : Colors.white38,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'b$bitIndex',
          style: const TextStyle(
            color: AppColors.textSecondaryDark,
            fontSize: 8,
          ),
        ),
      ],
    );
  }
}
