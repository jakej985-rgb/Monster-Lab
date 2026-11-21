import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

class EsdSafetyCheckWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const EsdSafetyCheckWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<EsdSafetyCheckWidget> createState() => _EsdSafetyCheckWidgetState();
}

class _EsdSafetyCheckWidgetState extends State<EsdSafetyCheckWidget> {
  bool _touchedMetalGround = false;
  bool _surfaceIsSafe = false;
  bool _holdsEdgesOnly = false;
  bool _hasCompleted = false;

  int get _staticVolts {
    int volts = 4500;
    if (_touchedMetalGround) volts -= 2000;
    if (_surfaceIsSafe) volts -= 1500;
    if (_holdsEdgesOnly) volts -= 1000;
    return volts;
  }

  void _checkCompletion() {
    if (_touchedMetalGround &&
        _surfaceIsSafe &&
        _holdsEdgesOnly &&
        !_hasCompleted) {
      _hasCompleted = true;
      widget.onComplete?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        'ESD Grounding & Microcontroller Safety Lab';
    final volts = _staticVolts;
    final isSafe = volts == 0;

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
                  color: isSafe
                      ? AppColors.success.withValues(alpha: 0.2)
                      : AppColors.danger.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSafe ? AppColors.success : AppColors.danger,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isSafe ? Icons.shield : Icons.electric_bolt,
                      color: isSafe ? AppColors.success : AppColors.danger,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isSafe ? 'ESD SAFE' : 'STATIC RISK: $volts V',
                      style: TextStyle(
                        color: isSafe ? AppColors.success : AppColors.danger,
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
          const SizedBox(height: 8),
          Text(
            'Electrostatic Discharge (ESD) can zap microchips with invisible thousands of volts. Practice the 3 Golden Rules of workshop ESD defense:',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),

          // Static Potential Voltmeter Display
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSafe ? AppColors.success : const Color(0xFF334155),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'BODY STATIC POTENTIAL METER',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$volts Volts',
                      style: TextStyle(
                        color:
                            isSafe ? AppColors.success : AppColors.energyAmber,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: volts / 4500,
                    minHeight: 12,
                    backgroundColor: const Color(0xFF1E293B),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isSafe
                          ? AppColors.success
                          : (volts > 2000
                              ? AppColors.danger
                              : AppColors.energyAmber),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isSafe
                      ? 'SAFE! Static potential discharged to earth ground reference.'
                      : 'WARNING: $volts Volts can blast microscopic holes in ATmega328P transistor gates!',
                  style: TextStyle(
                    color: isSafe ? AppColors.success : Colors.white60,
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 3 Interactive Lab Actions
          _buildCheckCard(
            keyId: 'esd_step_metal',
            title: '1. Touch Grounded Metal Desk',
            description:
                'Discharges accumulated static electricity from your skin safely into building earth ground before touching circuit components.',
            isComplete: _touchedMetalGround,
            buttonLabel: _touchedMetalGround
                ? 'TOUCHED METAL GROUND (Discharged)'
                : 'Touch Grounded Metal Desk',
            icon: Icons.touch_app,
            onTap: () {
              setState(() {
                _touchedMetalGround = !_touchedMetalGround;
                _checkCompletion();
              });
            },
          ),
          const SizedBox(height: 10),

          _buildCheckCard(
            keyId: 'esd_step_surface',
            title: '2. Avoid Carpets & Woolen Blankets',
            description:
                'Carpet fibers generate massive triboelectric friction. Work on a wood, laminate table, or antistatic workbench mat.',
            isComplete: _surfaceIsSafe,
            buttonLabel: _surfaceIsSafe
                ? 'DESK SURFACE SECURED (No Carpet)'
                : 'Switch Surface: Wood / Anti-Static Mat',
            icon: Icons.table_restaurant,
            onTap: () {
              setState(() {
                _surfaceIsSafe = !_surfaceIsSafe;
                _checkCompletion();
              });
            },
          ),
          const SizedBox(height: 10),

          _buildCheckCard(
            keyId: 'esd_step_edges',
            title: '3. Hold Board by Outer PCB Edges',
            description:
                'Grip the fiberglass corners of the Arduino Uno. Never touch the black ATmega328P chip pins or soldered bottom traces directly.',
            isComplete: _holdsEdgesOnly,
            buttonLabel: _holdsEdgesOnly
                ? 'EDGE GRIP ACTIVE (Pins Protected)'
                : 'Adopt Edge Grip Technique',
            icon: Icons.pan_tool,
            onTap: () {
              setState(() {
                _holdsEdgesOnly = !_holdsEdgesOnly;
                _checkCompletion();
              });
            },
          ),
          const SizedBox(height: 14),

          // Visual Safe Grip Diagram
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline,
                    color: AppColors.accentCyan, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(color: Colors.white70, fontSize: 11),
                      children: [
                        TextSpan(
                          text: 'Pro Tip: ',
                          style: TextStyle(
                            color: AppColors.accentCyan,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text:
                              'Humans only feel a static zap above 3,000V. Sensitive integrated circuits can be ruined by 100V! Always ground yourself first.',
                        ),
                      ],
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

  Widget _buildCheckCard({
    required String keyId,
    required String title,
    required String description,
    required bool isComplete,
    required String buttonLabel,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isComplete ? AppColors.success : const Color(0xFF475569),
          width: isComplete ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                isComplete ? Icons.check_circle : icon,
                color: isComplete ? AppColors.success : AppColors.accentCyan,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: isComplete ? AppColors.success : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            key: Key(keyId),
            onPressed: onTap,
            icon: Icon(
              isComplete ? Icons.verified : Icons.play_arrow,
              size: 16,
            ),
            label: Text(
              buttonLabel,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: isComplete
                  ? const Color(0xFF007A60)
                  : AppColors.primaryViolet,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
