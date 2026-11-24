import 'package:material_ui/material_ui.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

/// Interactive cutaway inspector for 5mm LEDs.
/// Demonstrates anvil (cathode -) vs post (anode +), flat collar edge,
/// lead lengths, and forward vs reverse bias electrical conduction.
class LedPolarityInspectorWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const LedPolarityInspectorWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<LedPolarityInspectorWidget> createState() =>
      _LedPolarityInspectorWidgetState();
}

class _LedPolarityInspectorWidgetState
    extends State<LedPolarityInspectorWidget> {
  bool _isForwardBiased = true;
  bool _isPowerOn = false;
  String _inspectedPart = 'overview'; // 'overview', 'cathode', 'anode'
  bool _hasTestedForward = false;
  bool _hasTestedReverse = false;
  bool _hasCompleted = false;

  void _checkCompletion() {
    if (_hasTestedForward && _hasTestedReverse && !_hasCompleted) {
      _hasCompleted = true;
      widget.onComplete?.call();
    }
  }

  void _togglePolarity() {
    setState(() {
      _isForwardBiased = !_isForwardBiased;
      if (_isPowerOn) {
        if (_isForwardBiased) {
          _hasTestedForward = true;
        } else {
          _hasTestedReverse = true;
        }
        _checkCompletion();
      }
    });
  }

  void _togglePower() {
    setState(() {
      _isPowerOn = !_isPowerOn;
      if (_isPowerOn) {
        if (_isForwardBiased) {
          _hasTestedForward = true;
        } else {
          _hasTestedReverse = true;
        }
        _checkCompletion();
      }
    });
  }

  void _inspectPart(String part) {
    setState(() {
      _inspectedPart = part;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        '5mm LED Anatomy & Polarity Inspector';
    final isLit = _isPowerOn && _isForwardBiased;

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
                  color: isLit
                      ? AppColors.success.withValues(alpha: 0.2)
                      : (_isPowerOn && !_isForwardBiased)
                          ? AppColors.danger.withValues(alpha: 0.2)
                          : AppColors.surfaceContainerDark,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isLit
                        ? AppColors.success
                        : (_isPowerOn && !_isForwardBiased)
                            ? AppColors.danger
                            : AppColors.textSecondaryDark,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isLit
                          ? Icons.lightbulb
                          : (_isPowerOn && !_isForwardBiased)
                              ? Icons.block
                              : Icons.lightbulb_outline,
                      color: isLit
                          ? AppColors.energyAmber
                          : (_isPowerOn && !_isForwardBiased)
                              ? AppColors.danger
                              : AppColors.textSecondaryDark,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isLit
                          ? 'EMITTING PHOTONS'
                          : (_isPowerOn && !_isForwardBiased)
                              ? 'BLOCKED (REVERSE BIAS)'
                              : 'POWER OFF',
                      style: TextStyle(
                        color: isLit
                            ? AppColors.energyAmber
                            : (_isPowerOn && !_isForwardBiased)
                                ? AppColors.danger
                                : AppColors.textSecondaryDark,
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

          // Subtitle description
          Text(
            'LEDs are diodes that only conduct electricity in one direction. '
            'Inspect the internal anvil vs post and observe how reversing polarity blocks photon emission.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondaryDark,
            ),
          ),
          const SizedBox(height: 16),

          // Visual Cutaway Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.backgroundDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isLit
                    ? AppColors.energyAmber.withValues(alpha: 0.5)
                    : AppColors.surfaceContainerDark,
              ),
            ),
            child: Column(
              children: [
                // Cutaway graphic representation
                Center(
                  child: SizedBox(
                    width: 280,
                    height: 180,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Radial light glow behind bulb when lit
                        if (isLit)
                          Positioned(
                            top: 10,
                            child: Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    AppColors.energyAmber
                                        .withValues(alpha: 0.6),
                                    AppColors.energyAmber
                                        .withValues(alpha: 0.1),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),

                        // LED Epoxy Dome
                        Positioned(
                          top: 10,
                          child: Container(
                            width: 80,
                            height: 90,
                            decoration: BoxDecoration(
                              color: isLit
                                  ? AppColors.energyAmber
                                      .withValues(alpha: 0.35)
                                  : Colors.blueGrey.withValues(alpha: 0.2),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40),
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                              border: Border.all(
                                color: isLit
                                    ? AppColors.energyAmber
                                    : Colors.blueGrey.shade400,
                                width: 2,
                              ),
                            ),
                            child: Stack(
                              children: [
                                // Internal Anvil (Cathode - larger triangular flag)
                                Positioned(
                                  left: _isForwardBiased ? 12 : 38,
                                  top: 40,
                                  child: Container(
                                    width: 28,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: _inspectedPart == 'cathode'
                                          ? AppColors.accentCyan
                                          : Colors.grey.shade400,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4),
                                        bottomLeft: Radius.circular(2),
                                      ),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        '−',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // Internal Post (Anode - smaller contact)
                                Positioned(
                                  left: _isForwardBiased ? 48 : 14,
                                  top: 45,
                                  child: Container(
                                    width: 14,
                                    height: 27,
                                    decoration: BoxDecoration(
                                      color: _inspectedPart == 'anode'
                                          ? AppColors.energyAmber
                                          : Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        '+',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // Whisker wire / semiconductor die
                                Positioned(
                                  left: 36,
                                  top: 38,
                                  child: Container(
                                    width: 8,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: isLit
                                          ? Colors.white
                                          : Colors.amber.shade700,
                                      borderRadius: BorderRadius.circular(1),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Base Rim / Collar with Flat Edge
                        Positioned(
                          top: 100,
                          child: Container(
                            width: 88,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.blueGrey.shade700,
                              borderRadius: BorderRadius.only(
                                topLeft:
                                    Radius.circular(_isForwardBiased ? 0 : 4),
                                bottomLeft:
                                    Radius.circular(_isForwardBiased ? 0 : 4),
                                topRight:
                                    Radius.circular(_isForwardBiased ? 4 : 0),
                                bottomRight:
                                    Radius.circular(_isForwardBiased ? 4 : 0),
                              ),
                              border:
                                  Border.all(color: Colors.blueGrey.shade400),
                            ),
                            child: Center(
                              child: Text(
                                _isForwardBiased
                                    ? 'FLAT EDGE ◀ [CATHODE]'
                                    : '[CATHODE] ▶ FLAT EDGE',
                                style: const TextStyle(
                                  fontSize: 7,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Leads
                        // Cathode Lead (Shorter)
                        Positioned(
                          left: _isForwardBiased ? 116 : 144,
                          top: 112,
                          child: Container(
                            width: 4,
                            height: 50,
                            color: _inspectedPart == 'cathode'
                                ? AppColors.accentCyan
                                : Colors.grey.shade400,
                          ),
                        ),
                        // Anode Lead (Longer)
                        Positioned(
                          left: _isForwardBiased ? 144 : 116,
                          top: 112,
                          child: Container(
                            width: 4,
                            height: 65,
                            color: _inspectedPart == 'anode'
                                ? AppColors.energyAmber
                                : Colors.grey.shade400,
                          ),
                        ),

                        // Wire labels aligned beneath corresponding leads & rail sockets
                        Positioned(
                          bottom: 0,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.wireGround,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  _isForwardBiased
                                      ? 'Cathode (−) ➔ GND'
                                      : 'Anode (+) ➔ GND',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 24),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.wirePower5V,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  _isForwardBiased
                                      ? 'Anode (+) ➔ +5V'
                                      : 'Cathode (−) ➔ +5V',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Inspection breakdown callout
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerDark,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _inspectedPart == 'cathode'
                            ? Icons.flag
                            : _inspectedPart == 'anode'
                                ? Icons.straighten
                                : Icons.info_outline,
                        color: _inspectedPart == 'cathode'
                            ? AppColors.accentCyan
                            : _inspectedPart == 'anode'
                                ? AppColors.energyAmber
                                : AppColors.textSecondaryDark,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _inspectedPart == 'cathode'
                              ? 'CATHODE (−): Larger anvil flag inside epoxy, shorter external lead, flat rim edge. Must connect to GND.'
                              : _inspectedPart == 'anode'
                                  ? 'ANODE (+): Smaller post contact inside epoxy, longer external lead. Must connect to positive supply.'
                                  : 'Tap Cathode or Anode buttons below to inspect anatomical clues.',
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

          // Anatomy Inspection Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  key: const Key('led_inspect_cathode_button'),
                  onPressed: () => _inspectPart('cathode'),
                  icon: const Icon(Icons.search, size: 16),
                  label: const Text('Cathode (−) Anvil'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _inspectedPart == 'cathode'
                        ? AppColors.accentCyan
                        : AppColors.textSecondaryDark,
                    side: BorderSide(
                      color: _inspectedPart == 'cathode'
                          ? AppColors.accentCyan
                          : AppColors.surfaceContainerDark,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  key: const Key('led_inspect_anode_button'),
                  onPressed: () => _inspectPart('anode'),
                  icon: const Icon(Icons.search, size: 16),
                  label: const Text('Anode (+) Post'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _inspectedPart == 'anode'
                        ? AppColors.energyAmber
                        : AppColors.textSecondaryDark,
                    side: BorderSide(
                      color: _inspectedPart == 'anode'
                          ? AppColors.energyAmber
                          : AppColors.surfaceContainerDark,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Interactive Testing Controls
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  key: const Key('led_flip_polarity_button'),
                  onPressed: _togglePolarity,
                  icon: const Icon(Icons.swap_horiz),
                  label: Text(
                    _isForwardBiased ? 'Reverse Polarity' : 'Forward Bias',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryViolet,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  key: const Key('led_test_circuit_button'),
                  onPressed: _togglePower,
                  icon: Icon(
                    _isPowerOn ? Icons.power_settings_new : Icons.flash_on,
                  ),
                  label: Text(_isPowerOn ? 'Cut Power' : 'Apply 5V Power'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isPowerOn
                        ? AppColors.danger
                        : AppColors.accentCyanDark,
                    foregroundColor: Colors.white,
                  ),
                ),
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
                      'Polarity Mastery Complete! You observed both forward conduction and reverse blocking.',
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
}
