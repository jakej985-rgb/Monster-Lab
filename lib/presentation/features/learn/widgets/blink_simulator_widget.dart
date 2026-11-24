import 'dart:async';
import 'package:material_ui/material_ui.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

class BlinkSimulatorWidget extends StatefulWidget {
  final int initialDelayMs;

  const BlinkSimulatorWidget({super.key, this.initialDelayMs = 1000});

  @override
  State<BlinkSimulatorWidget> createState() => _BlinkSimulatorWidgetState();
}

class _BlinkSimulatorWidgetState extends State<BlinkSimulatorWidget> {
  late int _delayMs;
  bool _isOn = false;
  bool _isRunning = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _delayMs = widget.initialDelayMs.clamp(350, 2000);
    _startBlinkCycle();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startBlinkCycle() {
    _timer?.cancel();
    if (!_isRunning) return;

    _timer = Timer(Duration(milliseconds: _delayMs), () {
      if (!mounted) return;
      setState(() => _isOn = !_isOn);
      _startBlinkCycle();
    });
  }

  void _togglePlayPause() {
    setState(() {
      _isRunning = !_isRunning;
      if (_isRunning) {
        _startBlinkCycle();
      } else {
        _timer?.cancel();
        _isOn = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    return MonsterCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: AppColors.energyAmber),
                  SizedBox(width: 8),
                  Text(
                    'Virtual Blink Simulator',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(_isRunning
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_filled),
                color: AppColors.primaryViolet,
                iconSize: 28,
                onPressed: _togglePlayPause,
                tooltip: _isRunning ? 'Pause' : 'Resume',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Virtual LED and Pin Indicator
          Center(
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 80),
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isOn
                        ? AppColors.energyAmber
                        : colorScheme.surfaceContainerHighest,
                    boxShadow: _isOn
                        ? [
                            BoxShadow(
                              color:
                                  AppColors.energyAmber.withValues(alpha: 0.6),
                              blurRadius: 24,
                              spreadRadius: 8,
                            ),
                          ]
                        : null,
                  ),
                  child: Semantics(
                    liveRegion: true,
                    label: _isOn
                        ? 'Pin 13 LED: High (5 Volts), illuminated'
                        : 'Pin 13 LED: Low (0 Volts), unlit',
                    child: Center(
                      child: Icon(
                        Icons.lightbulb,
                        color: _isOn ? Colors.white : Colors.white54,
                        size: 38,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _isOn
                        ? AppColors.energyAmber.withValues(alpha: 0.15)
                        : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _isOn ? 'PIN 13: HIGH (5V)' : 'PIN 13: LOW (0V)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: _isOn
                          ? (isDark
                              ? AppColors.energyGold
                              : AppColors.textAmberOnLight)
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Delay Slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Blink Speed / Delay:',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              Text(
                'delay($_delayMs);',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryViolet,
                ),
              ),
            ],
          ),
          Slider(
            value: _delayMs.toDouble(),
            min: 350,
            max: 2000,
            divisions: 33,
            activeColor: AppColors.primaryViolet,
            label: '$_delayMs ms',
            onChanged: (val) {
              setState(() {
                _delayMs = val.round();
              });
              if (_isRunning) _startBlinkCycle();
            },
          ),
          const SizedBox(height: 8),

          // Generated Code Preview
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '// Live Arduino Code:\n'
              'digitalWrite(13, HIGH); // 5 Volts (ON)\n'
              'delay($_delayMs);         // Wait\n'
              'digitalWrite(13, LOW);  // 0 Volts (OFF)\n'
              'delay($_delayMs);         // Wait',
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: AppColors.syntaxString,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
