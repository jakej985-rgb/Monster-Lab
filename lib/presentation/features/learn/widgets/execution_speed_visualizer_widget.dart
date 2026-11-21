import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

class ExecutionSpeedVisualizerWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const ExecutionSpeedVisualizerWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<ExecutionSpeedVisualizerWidget> createState() =>
      _ExecutionSpeedVisualizerWidgetState();
}

class _ExecutionSpeedVisualizerWidgetState
    extends State<ExecutionSpeedVisualizerWidget> {
  // 0: Without delay() (16 MHz fast), 1: With delay(1000) (Human visible)
  int _mode = 0;
  final Set<int> _testedModes = {0};
  bool _isLedOn = false;
  int _simulatedCycles = 0;
  Timer? _visualTimer;
  bool _hasAwardedCompletion = false;

  @override
  void initState() {
    super.initState();
    _startModeTimer();
  }

  @override
  void dispose() {
    _visualTimer?.cancel();
    super.dispose();
  }

  void _startModeTimer() {
    _visualTimer?.cancel();
    if (_mode == 0) {
      // 16 MHz simulation: Rapid ticks, LED looks solid dim
      _visualTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
        if (!mounted) return;
        setState(() {
          _simulatedCycles += 800000;
          _isLedOn =
              true; // In reality toggling at MHz, human perceives solid glow
        });
      });
    } else {
      // With delay(1000): Visible 1 second blink
      _isLedOn = true;
      _visualTimer =
          Timer.periodic(const Duration(milliseconds: 1000), (timer) {
        if (!mounted) return;
        setState(() {
          _isLedOn = !_isLedOn;
          _simulatedCycles += 16;
        });
      });
    }
  }

  void _switchMode(int newMode) {
    setState(() {
      _mode = newMode;
      _testedModes.add(newMode);
      _startModeTimer();

      if (_testedModes.length >= 2 && !_hasAwardedCompletion) {
        _hasAwardedCompletion = true;
        widget.onComplete?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        '16 MHz CPU vs Human Perception: Why We Need delay()';

    final isFastMode = _mode == 0;

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
              if (_hasAwardedCompletion)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                        'SPEED MASTERED',
                        style: TextStyle(
                          color: AppColors.success,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'The ATmega328P processor executes 16 million instructions every single second. Without delay(), physical changes happen too fast for humans to see!',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),

          // Speed Comparison Modes
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ChoiceChip(
                key: const Key('speed_mode_nodelay'),
                label: const Text('No delay() (16 MHz Full Speed)'),
                selected: isFastMode,
                onSelected: (val) {
                  if (val) _switchMode(0);
                },
              ),
              ChoiceChip(
                key: const Key('speed_mode_withdelay'),
                label: const Text('With delay(1000) (Human Pace)'),
                selected: !isFastMode,
                onSelected: (val) {
                  if (val) _switchMode(1);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Simulated Visual Experiment
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isFastMode ? AppColors.energyAmber : AppColors.success,
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                // Top Speedometer Telemetry
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  runSpacing: 8,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CPU CLOCK FREQUENCY',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          isFastMode ? '16,000,000 Hz' : '1 Hz (Regulated)',
                          style: TextStyle(
                            color: isFastMode
                                ? AppColors.energyAmber
                                : AppColors.success,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'HUMAN REACTION LIMIT',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '~200 milliseconds',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Simulated LED Display
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isLedOn
                            ? (isFastMode
                                ? const Color(
                                    0xAAFFA502) // 50% dimmed solid glow
                                : AppColors.energyAmber)
                            : const Color(0xFF334155),
                        boxShadow: _isLedOn
                            ? [
                                BoxShadow(
                                  color: AppColors.energyAmber.withValues(
                                    alpha: isFastMode ? 0.4 : 0.8,
                                  ),
                                  blurRadius: isFastMode ? 10 : 20,
                                  spreadRadius: isFastMode ? 1 : 4,
                                ),
                              ]
                            : null,
                        border: Border.all(color: Colors.white38),
                      ),
                      child: Icon(
                        Icons.lightbulb,
                        color: _isLedOn ? Colors.white : Colors.white24,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isFastMode
                                ? 'Human Eye: Solid Dim Glow'
                                : (_isLedOn
                                    ? 'LED State: HIGH (ON)'
                                    : 'LED State: LOW (OFF)'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isFastMode
                                ? 'Toggling 8,000,000x/sec! Appears static due to Persistence of Vision.'
                                : 'Pausing 1000 ms between toggles. Human eye sees clean 1 Hz blink!',
                            style: TextStyle(
                              color: isFastMode
                                  ? AppColors.energyAmber
                                  : AppColors.success,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Cycle Counter Bar
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    runSpacing: 4,
                    children: [
                      const Text(
                        'Total Clock Cycles Simulated:',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                      Text(
                        '$_simulatedCycles cycles',
                        style: const TextStyle(
                          color: AppColors.accentCyan,
                          fontFamily: 'monospace',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Educational takeaway
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: const Row(
              children: [
                Icon(Icons.tips_and_updates,
                    color: AppColors.accentCyan, size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Embedded Engineering Rule: Microcontrollers do not possess human senses. If you want a human to see a light or read an LCD, you must insert delay() or timers to bridge the speed gap!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
