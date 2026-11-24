import 'dart:async';
import 'package:material_ui/material_ui.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

class IdeLifecycleSimulatorWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const IdeLifecycleSimulatorWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<IdeLifecycleSimulatorWidget> createState() =>
      _IdeLifecycleSimulatorWidgetState();
}

class _IdeLifecycleSimulatorWidgetState
    extends State<IdeLifecycleSimulatorWidget> {
  // Execution phase
  // 0: Reset / Idle
  // 1: setup() phase (runs once)
  // 2: loop() step 1 (digitalWrite HIGH)
  // 3: loop() step 2 (delay)
  // 4: loop() step 3 (digitalWrite LOW)
  // 5: loop() step 4 (delay)
  int _currentPhase = 0;
  bool _isRunning = false;
  bool _setupCompleted = false;
  int _loopIteration = 0;
  int _totalSteps = 0;
  double _delayMs = 800;
  double _playbackSpeed = 1.0;
  bool _pin13State = false;
  Timer? _stepTimer;
  bool _hasAwardedCompletion = false;

  @override
  void dispose() {
    _stepTimer?.cancel();
    super.dispose();
  }

  void _startOrResume() {
    setState(() {
      _isRunning = true;
    });
    _scheduleNextStep();
  }

  void _pause() {
    _stepTimer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _reset() {
    _stepTimer?.cancel();
    setState(() {
      _isRunning = false;
      _currentPhase = 0;
      _setupCompleted = false;
      _loopIteration = 0;
      _totalSteps = 0;
      _pin13State = false;
    });
  }

  void _changeSpeed(double speed) {
    setState(() {
      _playbackSpeed = speed;
    });
    if (_isRunning) {
      _scheduleNextStep();
    }
  }

  void _advanceStep() {
    if (!mounted) return;

    setState(() {
      _totalSteps++;
      if (_currentPhase == 0) {
        // Start setup()
        _currentPhase = 1;
        _pin13State = false;
      } else if (_currentPhase == 1) {
        // setup() finishes, enter loop() step 1
        _setupCompleted = true;
        _currentPhase = 2;
        _loopIteration++;
        _pin13State = true;
      } else if (_currentPhase == 2) {
        // loop() step 2: delay HIGH
        _currentPhase = 3;
        _pin13State = true;
      } else if (_currentPhase == 3) {
        // loop() step 3: digitalWrite LOW
        _currentPhase = 4;
        _pin13State = false;
      } else if (_currentPhase == 4) {
        // loop() step 4: delay LOW
        _currentPhase = 5;
        _pin13State = false;
      } else if (_currentPhase == 5) {
        // orbit back to loop() step 1
        _currentPhase = 2;
        _loopIteration++;
        _pin13State = true;
      }

      if (_loopIteration >= 2 && !_hasAwardedCompletion) {
        _hasAwardedCompletion = true;
        widget.onComplete?.call();
      }
    });

    if (_isRunning) {
      _scheduleNextStep();
    }
  }

  void _scheduleNextStep() {
    _stepTimer?.cancel();
    final effectiveDelay = (_delayMs / _playbackSpeed).round().clamp(100, 3000);
    _stepTimer = Timer(Duration(milliseconds: effectiveDelay), _advanceStep);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        'IDE Lifecycle: setup() vs loop() Orbit';

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
                        'ORBIT MASTERED',
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
            'Watch how the microcontroller boots: setup() runs ONCE to initialize hardware, then loop() cycles repeatedly forever.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),

          // Lifecycle Architecture Stage
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Column(
              children: [
                // setup() Beacon Section
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _currentPhase == 1
                        ? AppColors.success.withValues(alpha: 0.15)
                        : const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _currentPhase == 1
                          ? AppColors.success
                          : (_setupCompleted
                              ? AppColors.success.withValues(alpha: 0.5)
                              : Colors.white24),
                      width: _currentPhase == 1 ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Beacon Icon
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPhase == 1
                              ? AppColors.success
                              : (_setupCompleted
                                  ? const Color(0xFF007A60)
                                  : Colors.grey.shade800),
                          boxShadow: _currentPhase == 1
                              ? [
                                  const BoxShadow(
                                    color: AppColors.success,
                                    blurRadius: 14,
                                    spreadRadius: 3,
                                  )
                                ]
                              : null,
                        ),
                        child: const Icon(Icons.flash_auto,
                            color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'void setup() { pinMode(13, OUTPUT); }',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                fontFamily: 'monospace',
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _currentPhase == 1
                                  ? 'RUNNING NOW: Initializing pin modes once...'
                                  : (_setupCompleted
                                      ? 'COMPLETED: Runs only once at boot/reset.'
                                      : 'Waiting for boot / reset.'),
                              style: TextStyle(
                                color: _currentPhase == 1
                                    ? AppColors.accentCyan
                                    : Colors.white60,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _setupCompleted
                              ? AppColors.success.withValues(alpha: 0.2)
                              : Colors.white10,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _setupCompleted ? '1x EXECUTED' : 'PENDING',
                          style: TextStyle(
                            color: _setupCompleted
                                ? AppColors.success
                                : Colors.white54,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Icon(Icons.arrow_downward,
                    color: AppColors.accentCyan, size: 22),
                const SizedBox(height: 8),

                // loop() Orbit Container
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _currentPhase >= 2
                          ? AppColors.primaryViolet
                          : Colors.white24,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.autorenew,
                                  color: AppColors.energyAmber, size: 18),
                              SizedBox(width: 6),
                              Text(
                                'void loop() { ... }  [Perpetual Orbit]',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.accentCyan
                                      .withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Step: $_totalSteps',
                                  style: const TextStyle(
                                    color: AppColors.accentCyan,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.energyAmber
                                      .withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Cycle: #$_loopIteration',
                                  style: const TextStyle(
                                    color: AppColors.energyAmber,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // 4 Step Orbital Code Blocks
                      _buildOrbitStep(
                        stepNum: 1,
                        code: 'digitalWrite(13, HIGH);',
                        desc: 'LED 13 turns ON (+5V)',
                        isActive: _currentPhase == 2,
                      ),
                      _buildOrbitStep(
                        stepNum: 2,
                        code: 'delay(${_delayMs.round()});',
                        desc: 'Microcontroller pauses clock',
                        isActive: _currentPhase == 3,
                      ),
                      _buildOrbitStep(
                        stepNum: 3,
                        code: 'digitalWrite(13, LOW);',
                        desc: 'LED 13 turns OFF (0V GND)',
                        isActive: _currentPhase == 4,
                      ),
                      _buildOrbitStep(
                        stepNum: 4,
                        code: 'delay(${_delayMs.round()});',
                        desc: 'Pause before orbiting back to top',
                        isActive: _currentPhase == 5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Hardware Simulation (Pin 13 LED output)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _pin13State
                            ? AppColors.energyAmber
                            : const Color(0xFF334155),
                        boxShadow: _pin13State
                            ? [
                                const BoxShadow(
                                  color: AppColors.energyAmber,
                                  blurRadius: 14,
                                  spreadRadius: 3,
                                )
                              ]
                            : null,
                        border: Border.all(color: Colors.white30),
                      ),
                      child: Icon(
                        Icons.lightbulb,
                        color: _pin13State ? Colors.white : Colors.white38,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Digital Pin 13 LED',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _pin13State ? 'State: HIGH (5V)' : 'State: LOW (0V)',
                          style: TextStyle(
                            color: _pin13State
                                ? AppColors.energyAmber
                                : Colors.white60,
                            fontSize: 11,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _currentPhase == 0
                          ? 'OFFLINE'
                          : (_currentPhase == 1
                              ? 'BOOTING'
                              : 'ORBITING (Cycle $_loopIteration)'),
                      style: TextStyle(
                        color: _currentPhase >= 2
                            ? AppColors.accentCyan
                            : Colors.white60,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Total Steps: $_totalSteps',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Delay Slider
          Row(
            children: [
              const Text(
                'Delay:',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Expanded(
                child: Slider(
                  value: _delayMs,
                  min: 200,
                  max: 2000,
                  divisions: 9,
                  label: '${_delayMs.round()} ms',
                  activeColor: AppColors.accentCyan,
                  onChanged: (val) {
                    setState(() {
                      _delayMs = val;
                    });
                    if (_isRunning) {
                      _scheduleNextStep();
                    }
                  },
                ),
              ),
              Text(
                '${_delayMs.round()} ms',
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'monospace',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Speed Control
          Row(
            children: [
              const Text(
                'Speed:',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(width: 8),
              Wrap(
                spacing: 6,
                children: [0.5, 1.0, 2.0].map((speed) {
                  return ChoiceChip(
                    key: Key('speed_chip_${speed}x'),
                    label: Text('${speed}x'),
                    selected: _playbackSpeed == speed,
                    onSelected: (selected) {
                      if (selected) {
                        _changeSpeed(speed);
                      }
                    },
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Controls Bar
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  key: const Key('lifecycle_run_button'),
                  onPressed: _isRunning ? _pause : _startOrResume,
                  icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                  label: Text(_isRunning ? 'PAUSE' : 'RUN ORBIT'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isRunning
                        ? AppColors.energyAmber
                        : AppColors.primaryViolet,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                key: const Key('lifecycle_step_button'),
                onPressed: _isRunning ? null : _advanceStep,
                icon: const Icon(Icons.skip_next),
                label: const Text('STEP'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                key: const Key('lifecycle_reset_button'),
                onPressed: _reset,
                icon: const Icon(Icons.refresh),
                label: const Text('RESET'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white70,
                  side: const BorderSide(color: Colors.white24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrbitStep({
    required int stepNum,
    required String code,
    required String desc,
    required bool isActive,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.accentCyan.withValues(alpha: 0.18)
            : const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive ? AppColors.accentCyan : const Color(0xFF334155),
          width: isActive ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? AppColors.accentCyan : Colors.white12,
            ),
            alignment: Alignment.center,
            child: Text(
              '$stepNum',
              style: TextStyle(
                color: isActive ? Colors.black : Colors.white60,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  code,
                  style: TextStyle(
                    color: isActive ? Colors.white : Colors.white70,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    fontFamily: 'monospace',
                  ),
                ),
                Text(
                  desc,
                  style: TextStyle(
                    color: isActive ? AppColors.accentCyan : Colors.white54,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          if (isActive)
            const Icon(Icons.chevron_left,
                color: AppColors.accentCyan, size: 20),
        ],
      ),
    );
  }
}
