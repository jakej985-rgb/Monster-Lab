import 'dart:async';
import 'package:material_ui/material_ui.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

/// Interactive blink simulator with adjustable delay(HIGH) and delay(LOW).
/// Demonstrates Persistence of Vision (POV) fusion when flashing frequency
/// exceeds ~25–30 Hz (< 30ms delay intervals).
class BlinkTimingLabWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const BlinkTimingLabWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<BlinkTimingLabWidget> createState() => _BlinkTimingLabWidgetState();
}

class _BlinkTimingLabWidgetState extends State<BlinkTimingLabWidget> {
  double _delayHighMs = 1000.0;
  double _delayLowMs = 1000.0;
  bool _isLedOn = true;
  Timer? _timer;

  bool _hasTestedDiscrete = false;
  bool _hasTestedPov = false;
  bool _hasCompleted = false;

  double get _periodMs => _delayHighMs + _delayLowMs;
  double get _frequencyHz => 1000.0 / _periodMs;
  double get _dutyCyclePct => (_delayHighMs / _periodMs) * 100.0;

  bool get _isPovFusion => _delayHighMs <= 35.0 && _delayLowMs <= 35.0;

  void _restartBlinkTimer() {
    _timer?.cancel();
    if (_isPovFusion) {
      // In POV fusion, LED appears continuously illuminated to human eyes!
      setState(() {
        _isLedOn = true;
      });
      return;
    }

    _scheduleNextToggle();
  }

  void _scheduleNextToggle() {
    final interval = _isLedOn ? _delayHighMs.round() : _delayLowMs.round();
    _timer = Timer(Duration(milliseconds: interval.clamp(10, 5000)), () {
      if (!mounted) return;
      setState(() {
        _isLedOn = !_isLedOn;
      });
      _scheduleNextToggle();
    });
  }

  void _checkCompletion() {
    if (_isPovFusion) {
      _hasTestedPov = true;
    } else {
      _hasTestedDiscrete = true;
    }

    if (_hasTestedDiscrete && _hasTestedPov && !_hasCompleted) {
      _hasCompleted = true;
      widget.onComplete?.call();
    }
  }

  void _setDelays(double high, double low) {
    setState(() {
      _delayHighMs = high;
      _delayLowMs = low;
      _restartBlinkTimer();
      _checkCompletion();
    });
  }

  @override
  void initState() {
    super.initState();
    _hasTestedDiscrete = true; // Started at 1000ms / 1000ms
    _restartBlinkTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        'Blink Timing & Persistence of Vision (POV) Lab';

    final isPov = _isPovFusion;
    final freq = _frequencyHz;
    final duty = _dutyCyclePct;

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
                  color: isPov
                      ? AppColors.primaryViolet.withValues(alpha: 0.2)
                      : AppColors.energyAmber.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        isPov ? AppColors.primaryViolet : AppColors.energyAmber,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPov ? Icons.all_inclusive : Icons.flaky,
                      color:
                          isPov ? AppColors.accentCyan : AppColors.energyAmber,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isPov ? 'POV FUSION (>30 Hz)' : 'DISCRETE BLINKS',
                      style: TextStyle(
                        color: isPov
                            ? AppColors.accentCyan
                            : AppColors.energyAmber,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Text(
            'Explore how delay durations alter blinking cadence. '
            'When flashes occur faster than human optical reset times (~30ms), the brain fuses them into a solid glow!',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondaryDark,
            ),
          ),
          const SizedBox(height: 16),

          // Simulation Visual Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.backgroundDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isPov
                    ? AppColors.primaryViolet
                    : AppColors.surfaceContainerDark,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Physical Pin 13 LED Simulation
                    Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: _isLedOn
                                ? AppColors.energyAmber.withValues(alpha: 0.25)
                                : Colors.black45,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _isLedOn
                                  ? AppColors.energyAmber
                                  : Colors.grey.shade700,
                              width: 2,
                            ),
                            boxShadow: _isLedOn
                                ? [
                                    BoxShadow(
                                      color: AppColors.energyAmber
                                          .withValues(alpha: isPov ? 0.4 : 0.7),
                                      blurRadius: isPov ? 10 : 20,
                                      spreadRadius: isPov ? 2 : 4,
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.lightbulb,
                              size: 34,
                              color: _isLedOn
                                  ? (isPov
                                      ? AppColors.energyAmber
                                          .withValues(alpha: 0.8)
                                      : AppColors.energyAmber)
                                  : Colors.grey.shade700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _isLedOn ? 'LED PIN 13: HIGH' : 'LED PIN 13: LOW',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: _isLedOn
                                ? AppColors.energyAmber
                                : AppColors.textSecondaryDark,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),

                    // Metrics Block
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMetricRow(
                          label: 'Period (T):',
                          value: '${_periodMs.round()} ms',
                          color: AppColors.accentCyan,
                        ),
                        const SizedBox(height: 4),
                        _buildMetricRow(
                          label: 'Frequency (f):',
                          value: '${freq.toStringAsFixed(1)} Hz',
                          color: isPov ? AppColors.primaryViolet : Colors.white,
                        ),
                        const SizedBox(height: 4),
                        _buildMetricRow(
                          label: 'Duty Cycle:',
                          value: '${duty.toStringAsFixed(0)} %',
                          color: AppColors.energyAmber,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Explanation Banner
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerDark,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isPov ? Icons.visibility : Icons.timer,
                        color: isPov
                            ? AppColors.accentCyan
                            : AppColors.energyAmber,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          isPov
                              ? 'POV FUSION ACTIVE: Flashing at ${freq.toStringAsFixed(1)} Hz exceeds retinal flicker fusion rate (~30 Hz). The eye perceives a continuous glow!'
                              : 'DISCRETE CADENCE: Flashing at ${freq.toStringAsFixed(1)} Hz. Each ON/OFF pulse is individually distinguishable by human eyes.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textPrimaryDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // delay(HIGH) Slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('delay(HIGH) - ON duration:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                '${_delayHighMs.round()} ms',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                  color: AppColors.energyAmber,
                ),
              ),
            ],
          ),
          Slider(
            key: const Key('delay_high_slider'),
            value: _delayHighMs,
            min: 10.0,
            max: 2000.0,
            divisions: 199,
            activeColor: AppColors.energyAmber,
            onChanged: (val) {
              setState(() {
                _delayHighMs = val;
                _restartBlinkTimer();
                _checkCompletion();
              });
            },
          ),

          // delay(LOW) Slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('delay(LOW) - OFF duration:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                '${_delayLowMs.round()} ms',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                  color: AppColors.accentCyan,
                ),
              ),
            ],
          ),
          Slider(
            key: const Key('delay_low_slider'),
            value: _delayLowMs,
            min: 10.0,
            max: 2000.0,
            divisions: 199,
            activeColor: AppColors.accentCyan,
            onChanged: (val) {
              setState(() {
                _delayLowMs = val;
                _restartBlinkTimer();
                _checkCompletion();
              });
            },
          ),
          const SizedBox(height: 8),

          // Quick Presets
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ActionChip(
                key: const Key('preset_standard_blink'),
                label: const Text('Standard Blink (1000ms / 1000ms)'),
                backgroundColor: _delayHighMs == 1000 && _delayLowMs == 1000
                    ? AppColors.accentCyan.withValues(alpha: 0.3)
                    : null,
                onPressed: () => _setDelays(1000, 1000),
              ),
              ActionChip(
                key: const Key('preset_heartbeat'),
                label: const Text('Heartbeat Strobe (100ms / 900ms)'),
                backgroundColor: _delayHighMs == 100 && _delayLowMs == 900
                    ? AppColors.energyAmber.withValues(alpha: 0.3)
                    : null,
                onPressed: () => _setDelays(100, 900),
              ),
              ActionChip(
                key: const Key('preset_pov_fusion'),
                label: const Text('POV Fusion (20ms / 20ms)'),
                backgroundColor: isPov
                    ? AppColors.primaryViolet.withValues(alpha: 0.3)
                    : null,
                side: const BorderSide(color: AppColors.primaryViolet),
                onPressed: () => _setDelays(20, 20),
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
                      'Blink Timing Mastery Verified! You demonstrated both discrete cadences and retinal POV fusion.',
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

  Widget _buildMetricRow({
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondaryDark,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: color,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }
}
