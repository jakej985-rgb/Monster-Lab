import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

enum RgbPackageType { commonCathode, commonAnode }

/// Interactive schematic toggle comparing Common Cathode (CC) vs Common Anode (CA) RGB LEDs.
/// Demonstrates pinout polarity, current sourcing vs sinking, and Active-HIGH vs Active-LOW software inversion.
class CommonCathodeVsAnodeDiagramWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const CommonCathodeVsAnodeDiagramWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<CommonCathodeVsAnodeDiagramWidget> createState() =>
      _CommonCathodeVsAnodeDiagramWidgetState();
}

class _CommonCathodeVsAnodeDiagramWidgetState
    extends State<CommonCathodeVsAnodeDiagramWidget> {
  RgbPackageType _type = RgbPackageType.commonCathode;
  double _softwarePwm = 255.0; // 0 to 255

  bool _hasTestedCc = false;
  bool _hasTestedCa = false;
  bool _hasCompleted = false;

  bool get _isCc => _type == RgbPackageType.commonCathode;

  // Effective brightness:
  // For CC: PWM 255 is 100% brightness, PWM 0 is 0%
  // For CA: PWM 0 is 100% brightness (sinking), PWM 255 is 0% (5V vs 5V = 0V diff)
  double get _effectiveBrightnessPct {
    if (_isCc) {
      return (_softwarePwm / 255.0) * 100.0;
    } else {
      return ((255.0 - _softwarePwm) / 255.0) * 100.0;
    }
  }

  void _checkCompletion() {
    if (_isCc) _hasTestedCc = true;
    if (!_isCc) _hasTestedCa = true;

    if (_hasTestedCc && _hasTestedCa && !_hasCompleted) {
      _hasCompleted = true;
      widget.onComplete?.call();
    }
  }

  void _setType(RgbPackageType type) {
    setState(() {
      _type = type;
      _checkCompletion();
    });
  }

  @override
  void initState() {
    super.initState();
    _hasTestedCc = true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        'Common Cathode vs Common Anode RGB LED Inspector';

    final isCc = _isCc;
    final pwm = _softwarePwm.round();
    final brightnessPct = _effectiveBrightnessPct;

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
                  color: isCc
                      ? AppColors.success.withValues(alpha: 0.2)
                      : AppColors.primaryViolet.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isCc ? AppColors.success : AppColors.primaryViolet,
                  ),
                ),
                child: Text(
                  isCc ? 'COMMON CATHODE (CC)' : 'COMMON ANODE (CA)',
                  style: TextStyle(
                    color: isCc ? AppColors.success : AppColors.accentCyan,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Text(
            'RGB LEDs share one physical common lead. Common Cathode ties the shared lead to GND (Active-HIGH); '
            'Common Anode ties it to +5V (Active-LOW, requiring inverted software logic: 255 - value).',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondaryDark,
            ),
          ),
          const SizedBox(height: 16),

          // Schematic and Pinout Visual Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.backgroundDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.surfaceContainerDark),
            ),
            child: Column(
              children: [
                // 4-Lead Pinout and Schematic Representation
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Physical Lead Diagram
                    Column(
                      children: [
                        const Text(
                          'Physical 4-Pin Leadout',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textSecondaryDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLead(
                                label: 'R',
                                length: 50,
                                color: AppColors.danger),
                            const SizedBox(width: 8),
                            _buildLead(
                              label: isCc ? 'GND' : '5V',
                              length: 70, // Longest Lead
                              color: isCc
                                  ? AppColors.wireGround
                                  : AppColors.wirePower5V,
                              isLongest: true,
                            ),
                            const SizedBox(width: 8),
                            _buildLead(
                                label: 'G',
                                length: 55,
                                color: AppColors.success),
                            const SizedBox(width: 8),
                            _buildLead(
                                label: 'B', length: 50, color: AppColors.info),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Lead 2: Longest (${isCc ? "GND" : "+5V"})',
                          style: const TextStyle(
                            fontSize: 9,
                            fontFamily: 'monospace',
                            color: AppColors.energyAmber,
                          ),
                        ),
                      ],
                    ),

                    // Circuit Logic & Output Preview
                    Column(
                      children: [
                        // Light emission globe
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(
                                alpha:
                                    (brightnessPct / 100.0).clamp(0.05, 1.0)),
                            border: Border.all(
                              color: Colors.white70,
                              width: 2,
                            ),
                            boxShadow: brightnessPct > 10
                                ? [
                                    BoxShadow(
                                      color: Colors.white.withValues(
                                          alpha: (brightnessPct / 100.0) * 0.8),
                                      blurRadius: 18,
                                      spreadRadius: 3,
                                    )
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.lightbulb,
                              size: 28,
                              color: brightnessPct > 10
                                  ? Colors.amber
                                  : Colors.grey.shade700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Brightness: ${brightnessPct.round()}%',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: brightnessPct > 50
                                ? AppColors.energyAmber
                                : AppColors.textSecondaryDark,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(
                    height: 24, color: AppColors.surfaceContainerDark),

                // Code and Hardware Logic Callout
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade800),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isCc
                                ? 'Logic: ACTIVE-HIGH'
                                : 'Logic: ACTIVE-LOW (INVERTED)',
                            style: TextStyle(
                              color:
                                  isCc ? AppColors.success : AppColors.danger,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                          Text(
                            'Shared Pin ➔ ${isCc ? "Uno GND (0V)" : "Uno 5V (+5V)"}',
                            style: const TextStyle(
                              color: AppColors.energyAmber,
                              fontFamily: 'monospace',
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        isCc
                            ? 'analogWrite(pin, $pwm); // $pwm produces ${brightnessPct.round()}% brightness'
                            : 'analogWrite(pin, 255 - $pwm); // Sinks current: value 0 is ON, 255 is OFF',
                        style: const TextStyle(
                          color: AppColors.accentCyan,
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Package Type Toggle Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  key: const Key('toggle_common_cathode'),
                  onPressed: () => _setType(RgbPackageType.commonCathode),
                  icon: const Icon(Icons.download),
                  label: const Text('Common Cathode (GND)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isCc
                        ? AppColors.primaryViolet
                        : AppColors.surfaceContainerDark,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  key: const Key('toggle_common_anode'),
                  onPressed: () => _setType(RgbPackageType.commonAnode),
                  icon: const Icon(Icons.upload),
                  label: const Text('Common Anode (+5V)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: !isCc
                        ? AppColors.primaryViolet
                        : AppColors.surfaceContainerDark,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Brightness PWM Slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Test PWM Value (0–255):',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                'analogWrite: $pwm',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                  color: AppColors.energyAmber,
                ),
              ),
            ],
          ),
          Slider(
            key: const Key('cc_ca_brightness_slider'),
            value: _softwarePwm,
            min: 0.0,
            max: 255.0,
            divisions: 255,
            activeColor: AppColors.accentCyan,
            onChanged: (val) {
              setState(() {
                _softwarePwm = val;
                _checkCompletion();
              });
            },
          ),
          const SizedBox(height: 8),

          ElevatedButton.icon(
            key: const Key('cc_ca_test_button'),
            onPressed: () {
              _checkCompletion();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isCc
                        ? 'Common Cathode: PWM $pwm generates ${brightnessPct.round()}% brightness.'
                        : 'Common Anode: Inverted logic active! Value $pwm yields ${brightnessPct.round()}% light.',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            icon: const Icon(Icons.check),
            label: const Text('Confirm Polarity Understanding'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentCyanDark,
              foregroundColor: Colors.white,
            ),
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
                      'RGB Package Polarity Mastered! You verified both Common Cathode (Active-HIGH) and Common Anode (Active-LOW).',
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

  Widget _buildLead({
    required String label,
    required double length,
    required Color color,
    bool isLongest = false,
  }) {
    return Column(
      children: [
        Container(
          width: isLongest ? 6 : 4,
          height: length,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
            border:
                isLongest ? Border.all(color: Colors.white, width: 1) : null,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: color,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }
}
