import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

/// Interactive additive RGB optical color mixing synthesizer.
/// Demonstrates 3-channel PWM duty cycles (Red, Green, Blue 0–255),
/// converging optical beams into a frosted lens, Hex/RGB code generation,
/// and primary vs secondary color synthesis.
class RgbColorSynthesizerWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const RgbColorSynthesizerWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<RgbColorSynthesizerWidget> createState() =>
      _RgbColorSynthesizerWidgetState();
}

class _RgbColorSynthesizerWidgetState extends State<RgbColorSynthesizerWidget> {
  double _red = 255.0;
  double _green = 165.0;
  double _blue = 0.0; // Starts at amber/orange

  final Set<String> _synthesizedPresets = {};
  bool _hasCompleted = false;

  Color get _currentColor {
    return Color.fromARGB(
      255,
      _red.round().clamp(0, 255),
      _green.round().clamp(0, 255),
      _blue.round().clamp(0, 255),
    );
  }

  String get _hexString {
    final r = _red.round().toRadixString(16).padLeft(2, '0').toUpperCase();
    final g = _green.round().toRadixString(16).padLeft(2, '0').toUpperCase();
    final b = _blue.round().toRadixString(16).padLeft(2, '0').toUpperCase();
    return '#$r$g$b';
  }

  void _checkCompletion() {
    if (_synthesizedPresets.length >= 2 && !_hasCompleted) {
      _hasCompleted = true;
      widget.onComplete?.call();
    }
  }

  void _setPreset(String name, double r, double g, double b) {
    setState(() {
      _red = r;
      _green = g;
      _blue = b;
      _synthesizedPresets.add(name);
      _checkCompletion();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        'RGB Additive Optical Color Synthesizer';

    final color = _currentColor;
    final rVal = _red.round();
    final gVal = _green.round();
    final bVal = _blue.round();
    final hex = _hexString;

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
                  color: color.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color),
                ),
                child: Text(
                  hex,
                  style: TextStyle(
                    color:
                        color.computeLuminance() < 0.2 ? Colors.white : color,
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
            'Additive color theory mixes light rather than pigments. By independently modulating Red, Green, and Blue '
            'duty cycles with PWM (analogWrite 0–255), you stimulate retinal cone cells to perceive over 16.7 million colors!',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondaryDark,
            ),
          ),
          const SizedBox(height: 16),

          // Optical Convergence Chamber Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.backgroundDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.surfaceContainerDark),
            ),
            child: Column(
              children: [
                // 3 Light Beams Converging into Central Frosted Lens
                Center(
                  child: SizedBox(
                    width: 280,
                    height: 140,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Red Emitter (Top Left)
                        Positioned(
                          left: 20,
                          top: 10,
                          child: _buildEmitter(
                            label: 'RED (Pin 9)',
                            color: Colors.red,
                            duty: (rVal / 255.0),
                          ),
                        ),
                        // Green Emitter (Top Center)
                        Positioned(
                          top: 0,
                          child: _buildEmitter(
                            label: 'GREEN (Pin 10)',
                            color: Colors.green,
                            duty: (gVal / 255.0),
                          ),
                        ),
                        // Blue Emitter (Top Right)
                        Positioned(
                          right: 20,
                          top: 10,
                          child: _buildEmitter(
                            label: 'BLUE (Pin 11)',
                            color: Colors.blue,
                            duty: (bVal / 255.0),
                          ),
                        ),

                        // Center Frosted Optical Diffuser Lens
                        Positioned(
                          bottom: 6,
                          child: Column(
                            children: [
                              Container(
                                width: 68,
                                height: 68,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: color,
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: color.withValues(alpha: 0.7),
                                      blurRadius: 24,
                                      spreadRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    'FROSTED\nLENS',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: color.computeLuminance() > 0.5
                                          ? Colors.black87
                                          : Colors.white,
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'rgb($rVal, $gVal, $bVal)',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontFamily: 'monospace',
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(
                    height: 20, color: AppColors.surfaceContainerDark),

                // Generated Arduino C++ Snippet
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade800),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        '// Generated Arduino Firmware Commands:',
                        style: TextStyle(
                          color: AppColors.textSecondaryDark,
                          fontSize: 10,
                          fontFamily: 'monospace',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'analogWrite(9,  $rVal); // Red duty: ${(rVal / 2.55).round()}%\n'
                        'analogWrite(10, $gVal); // Green duty: ${(gVal / 2.55).round()}%\n'
                        'analogWrite(11, $bVal); // Blue duty: ${(bVal / 2.55).round()}%',
                        style: const TextStyle(
                          color: AppColors.accentCyan,
                          fontSize: 11,
                          fontFamily: 'monospace',
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Red Channel Slider
          _buildColorSlider(
            keyStr: 'slider_red',
            label: 'Red (Pin 9):',
            val: _red,
            color: Colors.redAccent,
            onChanged: (v) {
              setState(() {
                _red = v;
                _checkCompletion();
              });
            },
          ),

          // Green Channel Slider
          _buildColorSlider(
            keyStr: 'slider_green',
            label: 'Green (Pin 10):',
            val: _green,
            color: Colors.greenAccent,
            onChanged: (v) {
              setState(() {
                _green = v;
                _checkCompletion();
              });
            },
          ),

          // Blue Channel Slider
          _buildColorSlider(
            keyStr: 'slider_blue',
            label: 'Blue (Pin 11):',
            val: _blue,
            color: Colors.lightBlueAccent,
            onChanged: (v) {
              setState(() {
                _blue = v;
                _checkCompletion();
              });
            },
          ),
          const SizedBox(height: 8),

          // Color Palette Presets
          const Text(
            'Mix Compound Secondary Colors:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ActionChip(
                key: const Key('preset_yellow'),
                label: const Text('Yellow (R + G)'),
                onPressed: () => _setPreset('yellow', 255, 255, 0),
              ),
              ActionChip(
                key: const Key('preset_cyan'),
                label: const Text('Cyan (G + B)'),
                onPressed: () => _setPreset('cyan', 0, 255, 255),
              ),
              ActionChip(
                key: const Key('preset_magenta'),
                label: const Text('Magenta (R + B)'),
                onPressed: () => _setPreset('magenta', 255, 0, 255),
              ),
              ActionChip(
                key: const Key('preset_white'),
                label: const Text('White (R + G + B)'),
                onPressed: () => _setPreset('white', 255, 255, 255),
              ),
              ActionChip(
                key: const Key('preset_orange'),
                label: const Text('Orange'),
                onPressed: () => _setPreset('orange', 255, 128, 0),
              ),
              ActionChip(
                key: const Key('preset_purple'),
                label: const Text('Monster Violet'),
                onPressed: () => _setPreset('purple', 108, 92, 231),
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
                      'Additive RGB Mixing Mastered! You synthesized secondary and compound optical colors.',
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

  Widget _buildEmitter({
    required String label,
    required Color color,
    required double duty,
  }) {
    return Column(
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: duty.clamp(0.1, 1.0)),
            boxShadow: duty > 0.05
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: duty * 0.8),
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ]
                : null,
          ),
          child: const Center(
            child: Icon(Icons.flash_on, size: 12, color: Colors.white),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 8,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildColorSlider({
    required String keyStr,
    required String label,
    required double val,
    required Color color,
    required ValueChanged<double> onChanged,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
        Expanded(
          child: Slider(
            key: Key(keyStr),
            value: val,
            min: 0.0,
            max: 255.0,
            divisions: 255,
            activeColor: color,
            onChanged: onChanged,
          ),
        ),
        SizedBox(
          width: 36,
          child: Text(
            '${val.round()}',
            textAlign: TextAlign.end,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontFamily: 'monospace',
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
