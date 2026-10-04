import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

class DiagnosticCheck {
  final String id;
  final String title;
  final String symptom;
  final String rootCause;
  final String fixLabel;
  final String verifiedText;
  final IconData icon;

  const DiagnosticCheck({
    required this.id,
    required this.title,
    required this.symptom,
    required this.rootCause,
    required this.fixLabel,
    required this.verifiedText,
    required this.icon,
  });
}

class PortTroubleshootingBenchWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const PortTroubleshootingBenchWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<PortTroubleshootingBenchWidget> createState() =>
      _PortTroubleshootingBenchWidgetState();
}

class _PortTroubleshootingBenchWidgetState
    extends State<PortTroubleshootingBenchWidget> {
  static const List<DiagnosticCheck> _checks = [
    DiagnosticCheck(
      id: 'usb_cable',
      title: '1. USB Cable Physical Seating',
      symptom: 'Arduino ON LED is unlit or flickers when bumped.',
      rootCause:
          'USB Type-B connector is only partially pushed in, or power/data spring contacts are loose.',
      fixLabel: 'Firmly Push Cable Until It Clicks',
      verifiedText:
          'Firm 5V connection established. USB power LED glows solid green.',
      icon: Icons.usb,
    ),
    DiagnosticCheck(
      id: 'wrong_port',
      title: '2. COM Port Selection Mismatch',
      symptom: 'IDE error: "avrdude: ser_open(): can\'t open device COM1".',
      rootCause:
          'COM1 is an internal motherboard legacy header. The USB-to-UART bridge enumerated as COM3.',
      fixLabel: 'Switch IDE Menu to COM3 (Arduino Uno)',
      verifiedText:
          'Correct virtual serial COM port selected. Target handshake confirmed.',
      icon: Icons.settings_ethernet,
    ),
    DiagnosticCheck(
      id: 'missing_driver',
      title: '3. CH340 / CP2102 USB Bridge Driver',
      symptom:
          'Device Manager shows yellow exclamation mark "Unknown USB Device".',
      rootCause:
          'Clone boards with WCH CH340 USB interface chips require an OS device driver to create a virtual COM port.',
      fixLabel: 'Install Certified CH340 Driver',
      verifiedText:
          'Driver loaded into OS kernel. Virtual serial COM port successfully created.',
      icon: Icons.download_done,
    ),
    DiagnosticCheck(
      id: 'disconnected_board',
      title: '4. Microcontroller Power State',
      symptom: 'Port menu is completely greyed out with "No Ports Discovered".',
      rootCause:
          'Cable is unplugged from the computer or plugged into a passive dead USB hub.',
      fixLabel: 'Plug Directly Into Powered PC Port',
      verifiedText:
          'Hardware discovered! ATmega328P bootloader responded to serial ping.',
      icon: Icons.power,
    ),
  ];

  final Set<String> _fixedCheckIds = {};
  int _activeCheckIndex = 0;

  void _toggleFix(String id) {
    setState(() {
      if (_fixedCheckIds.contains(id)) {
        _fixedCheckIds.remove(id);
      } else {
        _fixedCheckIds.add(id);
      }

      if (_fixedCheckIds.length == _checks.length) {
        widget.onComplete?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        'Port Not Found! 4-Step Diagnostic Triage';
    final allFixed = _fixedCheckIds.length == _checks.length;
    final activeCheck = _checks[_activeCheckIndex];
    final isCurrentFixed = _fixedCheckIds.contains(activeCheck.id);

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
                    color: AppColors.energyAmber,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: allFixed
                      ? AppColors.success.withValues(alpha: 0.2)
                      : AppColors.energyAmber.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: allFixed ? AppColors.success : AppColors.energyAmber,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      allFixed ? Icons.check_circle : Icons.warning_amber,
                      color:
                          allFixed ? AppColors.success : AppColors.energyAmber,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      allFixed
                          ? 'PORT OPERATIONAL'
                          : '${_fixedCheckIds.length}/4 RESOLVED',
                      style: TextStyle(
                        color: allFixed
                            ? AppColors.success
                            : AppColors.energyAmber,
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
            'When the Arduino IDE reports "Port Not Found", do not panic! Systematically test the 4 most common causes below:',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(height: 16),

          // Check Tabs Navigation
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_checks.length, (index) {
                final check = _checks[index];
                final isSelected = index == _activeCheckIndex;
                final isFixed = _fixedCheckIds.contains(check.id);

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    avatar: Icon(
                      isFixed ? Icons.check_circle : check.icon,
                      size: 16,
                      color: isFixed
                          ? AppColors.success
                          : (isSelected
                              ? AppColors.energyAmber
                              : Colors.white54),
                    ),
                    label: Text(
                      'Check ${index + 1}',
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (val) {
                      setState(() {
                        _activeCheckIndex = index;
                      });
                    },
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),

          // Diagnostic Card Body
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isCurrentFixed
                    ? AppColors.success
                    : AppColors.energyAmber.withValues(alpha: 0.6),
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(activeCheck.icon,
                        color: isCurrentFixed
                            ? AppColors.success
                            : AppColors.energyAmber,
                        size: 24),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        activeCheck.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Symptom Callout
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'SYMPTOM:',
                        style: TextStyle(
                          color: AppColors.danger,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        activeCheck.symptom,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Root Cause
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ROOT CAUSE:',
                        style: TextStyle(
                          color: AppColors.energyAmber,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        activeCheck.rootCause,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Status & Fix Button
                ElevatedButton.icon(
                  key: Key('toggle_fix_${activeCheck.id}'),
                  onPressed: () => _toggleFix(activeCheck.id),
                  icon: Icon(
                    isCurrentFixed ? Icons.undo : Icons.build_circle,
                    size: 18,
                  ),
                  label: Text(
                    isCurrentFixed
                        ? 'ISSUE RESOLVED (Tap to Re-test)'
                        : activeCheck.fixLabel,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isCurrentFixed
                        ? const Color(0xFF007A60)
                        : AppColors.primaryViolet,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

                if (isCurrentFixed) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.success),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle,
                            color: AppColors.success, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            activeCheck.verifiedText,
                            style: const TextStyle(
                              color: AppColors.success,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Completion Status
          if (allFixed)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.success, width: 1.5),
              ),
              child: const Row(
                children: [
                  Icon(Icons.verified, color: AppColors.success, size: 24),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'All 4 triage checks passed! The IDE can now detect and flash the ATmega328P without port interruption.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
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
