import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

/// Virtual inductive coil simulator demonstrating Lenz's Law (V = -L * di/dt),
/// high-voltage inductive kickback spikes destroying driver transistors,
/// and safe suppression via an antiparallel 1N4007 flyback diode.
class InductiveKickbackSimulatorWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const InductiveKickbackSimulatorWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<InductiveKickbackSimulatorWidget> createState() =>
      _InductiveKickbackSimulatorWidgetState();
}

class _InductiveKickbackSimulatorWidgetState
    extends State<InductiveKickbackSimulatorWidget> {
  // Transistor switch state: true = ON (Conducting), false = OFF (Abruptly Opened)
  bool _isSwitchClosed = true;

  // Flyback diode installed: false = No Diode (Vulnerable), true = 1N4007 Installed
  bool _hasFlybackDiode = false;

  bool _experiencedSpike = false;
  bool _experiencedClamped = false;
  bool _hasCompleted = false;

  void _toggleSwitch() {
    setState(() {
      _isSwitchClosed = !_isSwitchClosed;
      if (!_isSwitchClosed) {
        if (!_hasFlybackDiode) {
          _experiencedSpike = true;
        } else {
          _experiencedClamped = true;
        }
      }
      _checkCompletion();
    });
  }

  void _toggleDiode() {
    setState(() {
      _hasFlybackDiode = !_hasFlybackDiode;
      _checkCompletion();
    });
  }

  void _checkCompletion() {
    if (_experiencedSpike && _experiencedClamped && !_hasCompleted) {
      _hasCompleted = true;
      widget.onComplete?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        'Inductive Kickback & Flyback Diode Simulator';

    // Voltage spike values:
    // When ON: Collector is ~0.2V (saturated)
    // When OFF & Unprotected: Spikes to 85V! (Destroying 40V transistor)
    // When OFF & Protected: Clamped to 12.7V (12V rail + 0.7V diode forward drop)
    final double collectorVoltage;
    if (_isSwitchClosed) {
      collectorVoltage = 0.2;
    } else {
      collectorVoltage = _hasFlybackDiode ? 12.7 : 85.0;
    }

    final isTransistorFried = !_isSwitchClosed && !_hasFlybackDiode;
    final isProtected = !_isSwitchClosed && _hasFlybackDiode;

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
              if (_hasCompleted)
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
                        'DIODE CLAMP VERIFIED',
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
          const SizedBox(height: 6),
          Text(
            'When a motor switch opens, the magnetic field in its copper coils abruptly collapses. '
            'According to Lenz\'s Law (V = -L · di/dt), this generates an 80V+ reverse kickback spike '
            'that destroys driver transistors unless clamped by a 1N4007 flyback diode!',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondaryDark,
            ),
          ),
          const SizedBox(height: 14),

          // Interactive Control Bench
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.backgroundDark,
              borderRadius: BorderRadius.circular(8),
              border:
                  Border.all(color: AppColors.surfaceContainerDark, width: 1.5),
            ),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                // Switch button
                ElevatedButton.icon(
                  key: const Key('toggle_motor_switch'),
                  onPressed: _toggleSwitch,
                  icon: Icon(
                    _isSwitchClosed ? Icons.power_settings_new : Icons.flash_on,
                    size: 18,
                  ),
                  label: Text(_isSwitchClosed
                      ? 'OPEN SWITCH (Turn OFF)'
                      : 'CLOSE SWITCH (Turn ON)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isSwitchClosed
                        ? AppColors.energyAmber
                        : AppColors.accentCyanDark,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                ),

                // Diode toggle
                FilterChip(
                  key: const Key('toggle_flyback_diode'),
                  label: Text(
                    _hasFlybackDiode
                        ? '1N4007 Diode INSTALLED'
                        : 'NO DIODE (UNPROTECTED)',
                    style: TextStyle(
                      fontSize: 11,
                      color: _hasFlybackDiode ? Colors.black : AppColors.danger,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  selected: _hasFlybackDiode,
                  selectedColor: AppColors.success,
                  backgroundColor: AppColors.surfaceDark,
                  onSelected: (val) => _toggleDiode(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Schematic and Oscilloscope View
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 580;

              final schematicWidget = Container(
                height: 220,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.white12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // +12V Rail
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.danger.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: const Text(
                        '+12V Motor Rail',
                        style: TextStyle(
                          color: AppColors.danger,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                    const Spacer(),

                    // Motor Coil and Parallel Diode
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Motor Coil
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: _isSwitchClosed
                                ? AppColors.energyAmber.withValues(alpha: 0.2)
                                : Colors.white10,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: _isSwitchClosed
                                  ? AppColors.energyAmber
                                  : Colors.white24,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.cyclone,
                                size: 24,
                                color: _isSwitchClosed
                                    ? AppColors.energyAmber
                                    : Colors.white54,
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'Motor Coil (L)\n10 mH',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 1N4007 Diode
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: _hasFlybackDiode
                                ? AppColors.success.withValues(alpha: 0.2)
                                : Colors.white10,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: _hasFlybackDiode
                                  ? AppColors.success
                                  : Colors.white24,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                _hasFlybackDiode
                                    ? Icons.arrow_upward
                                    : Icons.close,
                                size: 20,
                                color: _hasFlybackDiode
                                    ? AppColors.success
                                    : Colors.white38,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _hasFlybackDiode
                                    ? '1N4007 Diode\n[Clamping]'
                                    : 'No Diode\n[Open Circuit]',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: _hasFlybackDiode
                                      ? AppColors.success
                                      : Colors.white38,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),

                    // Transistor Switch
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isTransistorFried
                            ? AppColors.danger.withValues(alpha: 0.3)
                            : Colors.black45,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isTransistorFried
                              ? AppColors.danger
                              : Colors.white24,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isTransistorFried
                                ? Icons.warning
                                : (_isSwitchClosed
                                    ? Icons.link
                                    : Icons.link_off),
                            size: 16,
                            color: isTransistorFried
                                ? AppColors.danger
                                : (_isSwitchClosed
                                    ? AppColors.syntaxFunction
                                    : Colors.white60),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              isTransistorFried
                                  ? 'NPN DESTROYED (85V Arc)'
                                  : (_isSwitchClosed
                                      ? 'NPN Switch: CLOSED (ON)'
                                      : 'NPN Switch: OPEN (OFF)'),
                              style: TextStyle(
                                color: isTransistorFried
                                    ? AppColors.danger
                                    : Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );

              final oscilloscopeWidget = Container(
                height: 220,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF050811),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFF1E293B)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.show_chart,
                            size: 14, color: AppColors.accentCyan),
                        const SizedBox(width: 4),
                        const Expanded(
                          child: Text(
                            'OSCILLOSCOPE: V_collector',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.accentCyan,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${collectorVoltage.toStringAsFixed(1)}V',
                          style: TextStyle(
                            color: isTransistorFried
                                ? AppColors.danger
                                : (isProtected
                                    ? AppColors.success
                                    : AppColors.syntaxFunction),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Colors.white12),

                    // Voltage Wave Simulation
                    Expanded(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Breakdown threshold line (40V)
                          Positioned(
                            top: 40,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 1,
                              color: AppColors.danger.withValues(alpha: 0.5),
                            ),
                          ),
                          const Positioned(
                            top: 26,
                            right: 2,
                            child: Text(
                              'V_CEO Breakdown Limit (40V)',
                              style: TextStyle(
                                color: AppColors.danger,
                                fontSize: 8,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),

                          // Clamped +12.7V line
                          Positioned(
                            top: 75,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 1,
                              color: AppColors.success.withValues(alpha: 0.5),
                            ),
                          ),
                          const Positioned(
                            top: 62,
                            right: 2,
                            child: Text(
                              'Diode Clamped (+12.7V)',
                              style: TextStyle(
                                color: AppColors.success,
                                fontSize: 8,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),

                          // Active Waveform Graphic
                          if (isTransistorFried)
                            const Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.bolt,
                                      color: AppColors.energyAmber, size: 36),
                                  Text(
                                    '+85V SPIKE! ARC BREAKDOWN',
                                    style: TextStyle(
                                      color: AppColors.danger,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else if (isProtected)
                            const Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.verified_user,
                                      color: AppColors.success, size: 30),
                                  Text(
                                    'CLAMPED: Current Recirculating',
                                    style: TextStyle(
                                      color: AppColors.success,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            const Center(
                              child: Text(
                                'Steady Current: 0.2V V_CE (ON)',
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 10,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );

              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isTransistorFried
                        ? AppColors.danger
                        : (isProtected ? AppColors.success : Colors.white24),
                    width: 1.5,
                  ),
                ),
                child: isNarrow
                    ? Column(
                        children: [
                          schematicWidget,
                          const SizedBox(height: 10),
                          oscilloscopeWidget,
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(flex: 3, child: schematicWidget),
                          const SizedBox(width: 10),
                          Expanded(flex: 4, child: oscilloscopeWidget),
                        ],
                      ),
              );
            },
          ),
          const SizedBox(height: 12),

          // Diagnostic Summary Banner
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isTransistorFried
                  ? AppColors.danger.withValues(alpha: 0.15)
                  : (isProtected
                      ? AppColors.success.withValues(alpha: 0.15)
                      : AppColors.energyAmber.withValues(alpha: 0.15)),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isTransistorFried
                    ? AppColors.danger
                    : (isProtected ? AppColors.success : AppColors.energyAmber),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isTransistorFried
                      ? Icons.dangerous
                      : (isProtected ? Icons.shield : Icons.info_outline),
                  color: isTransistorFried
                      ? AppColors.danger
                      : (isProtected
                          ? AppColors.success
                          : AppColors.energyAmber),
                  size: 22,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isTransistorFried
                        ? 'CATASTROPHIC BACK-EMF: Abrupt switch shutoff induced an 85V spike. The NPN transistor collector-emitter rating is only 40V, destroying the chip!'
                        : (isProtected
                            ? 'PROTECTION ACTIVE: The 1N4007 flyback diode conducts when the collector rises above +12V, safely dissipating stored magnetic energy as gentle heat.'
                            : 'STEADY STATE: Switch is ON, current flows through the motor coil. Open the switch to observe the collapsing magnetic field!'),
                    style: TextStyle(
                      color: isTransistorFried
                          ? AppColors.danger
                          : (isProtected
                              ? AppColors.success
                              : AppColors.textPrimaryDark),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
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
