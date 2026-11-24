import 'dart:math' as math;
import 'package:material_ui/material_ui.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

class LcdContrastSimulatorWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const LcdContrastSimulatorWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<LcdContrastSimulatorWidget> createState() =>
      _LcdContrastSimulatorWidgetState();
}

class _LcdContrastSimulatorWidgetState
    extends State<LcdContrastSimulatorWidget> {
  // Trimmer pot value from 0.0 to 1.0. Start at 0.10 (too low/blank) or 0.95 (solid blocks).
  double _contrastValue = 0.10;
  bool _hasTunedSuccess = false;

  bool get _isOptimal => _contrastValue >= 0.42 && _contrastValue <= 0.65;
  bool get _isTooLow => _contrastValue < 0.35;
  bool get _isTooHigh => _contrastValue > 0.72;

  void _onSliderChanged(double value) {
    setState(() {
      _contrastValue = value;
      if (_isOptimal && !_hasTunedSuccess) {
        _hasTunedSuccess = true;
        widget.onComplete?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        'LCD Contrast Tuning: The Blue Potentiometer';

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
              if (_hasTunedSuccess)
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
                        'CONTRAST TUNED',
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
            'The #1 problem when powering on an LCD is incorrect contrast voltage! Adjust the trimmer potentiometer screw below to find the crisp readability sweet spot.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),

          // Simulated 16x2 LCD Display Screen
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF002244), // Classic LCD deep blue
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color:
                    _isOptimal ? AppColors.accentCyan : const Color(0xFF1E3A8A),
                width: 2.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0044AA).withValues(alpha: 0.5),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // LCD Bezel Label
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runSpacing: 4,
                  children: [
                    const Text(
                      '1602A I2C DISPLAY',
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 9,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'V0 BIAS: ${(_contrastValue * 5.0).toStringAsFixed(2)}V',
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 9,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // LCD Glass Screen Matrix
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D3B82),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFF1E40AF)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildLcdLine('MONSTER LAB v1.0'),
                      const SizedBox(height: 4),
                      _buildLcdLine('READY FOR CODE! '),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Trimmer Potentiometer Control Station
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          _buildBrassTrimmerScrew(_contrastValue),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Backpack Trimmer Potentiometer',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  'Controls V0 liquid crystal bias voltage',
                                  style: TextStyle(
                                    color: Colors.white60,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _isOptimal
                            ? AppColors.success.withValues(alpha: 0.2)
                            : (_isTooLow || _isTooHigh
                                ? AppColors.energyAmber.withValues(alpha: 0.2)
                                : Colors.white10),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _isOptimal
                            ? 'SWEET SPOT'
                            : (_isTooLow ? 'TOO LOW' : 'TOO HIGH'),
                        style: TextStyle(
                          color: _isOptimal
                              ? AppColors.success
                              : AppColors.energyAmber,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Trimmer Potentiometer Slider
                Slider(
                  key: const Key('lcd_contrast_slider'),
                  value: _contrastValue,
                  min: 0.0,
                  max: 1.0,
                  divisions: 50,
                  label: '${(_contrastValue * 100).round()}%',
                  activeColor:
                      _isOptimal ? AppColors.success : AppColors.accentCyan,
                  onChanged: _onSliderChanged,
                ),

                // Status Guidance Banner
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _isOptimal
                        ? AppColors.success.withValues(alpha: 0.15)
                        : const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _isOptimal ? AppColors.success : Colors.white24,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isOptimal ? Icons.verified : Icons.info_outline,
                        color: _isOptimal
                            ? AppColors.success
                            : AppColors.energyAmber,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _isOptimal
                              ? 'PERFECT CONTRAST: Sharp white characters with clean pixel boundaries.'
                              : (_isTooLow
                                  ? 'BLANK SCREEN: Contrast bias is near 0V. Crystals are transparent. Turn screw clockwise!'
                                  : 'SOLID WHITE BOXES: Bias is saturated! All 5x8 pixel blocks are activated. Turn screw counter-clockwise!'),
                          style: TextStyle(
                            color:
                                _isOptimal ? AppColors.success : Colors.white,
                            fontSize: 11,
                            fontWeight: _isOptimal
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLcdLine(String text) {
    if (_contrastValue > 0.75) {
      // Saturated blocks
      final blockOpacity = ((_contrastValue - 0.70) / 0.30).clamp(0.4, 1.0);
      return FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Text(
          '■■■■■■■■■■■■■■■■',
          style: TextStyle(
            color: Colors.white.withValues(alpha: blockOpacity),
            fontFamily: 'monospace',
            fontSize: 15,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
      );
    }

    // Text with dynamic contrast opacity
    final double textOpacity;
    if (_contrastValue < 0.20) {
      textOpacity = 0.04;
    } else if (_contrastValue < 0.40) {
      textOpacity = 0.15 + ((_contrastValue - 0.20) / 0.20) * 0.55;
    } else {
      textOpacity = 1.0;
    }

    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withValues(alpha: textOpacity),
          fontFamily: 'monospace',
          fontSize: 15,
          fontWeight: FontWeight.bold,
          letterSpacing: 2.0,
          shadows: _isOptimal
              ? [
                  const Shadow(
                    color: Colors.white70,
                    blurRadius: 4,
                  ),
                ]
              : null,
        ),
      ),
    );
  }

  Widget _buildBrassTrimmerScrew(double value) {
    final angle = value * math.pi * 2;

    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: const Color(0xFF1E40AF), // Blue potentiometer body
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF3B82F6)),
      ),
      alignment: Alignment.center,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          width: 22,
          height: 22,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFD4AF37), // Brass screw center
          ),
          alignment: Alignment.center,
          child: Container(
            width: 16,
            height: 3,
            color: const Color(0xFF4A3B00), // Screw screwdriver slot
          ),
        ),
      ),
    );
  }
}
