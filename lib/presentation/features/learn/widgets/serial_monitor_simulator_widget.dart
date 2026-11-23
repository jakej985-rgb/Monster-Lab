import 'package:material_ui/material_ui.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

class SerialMonitorSimulatorWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const SerialMonitorSimulatorWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<SerialMonitorSimulatorWidget> createState() =>
      _SerialMonitorSimulatorWidgetState();
}

class _SerialMonitorSimulatorWidgetState
    extends State<SerialMonitorSimulatorWidget> {
  static const List<int> _baudRates = [9600, 115200, 38400];
  static const int _targetBaud = 9600;

  int _selectedBaud =
      115200; // Start mismatched so learner sees the garbled text!
  final Set<int> _testedBauds = {115200};
  bool _hasAwardedCompletion = false;

  void _onBaudSelected(int baud) {
    setState(() {
      _selectedBaud = baud;
      _testedBauds.add(baud);

      if (_testedBauds.contains(9600) &&
          _testedBauds.length >= 2 &&
          !_hasAwardedCompletion) {
        _hasAwardedCompletion = true;
        widget.onComplete?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        'Serial Monitor Console & Baud Rate Sync';
    final isMatching = _selectedBaud == _targetBaud;

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
                        'BAUD SYNCED',
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
            'The sketch specifies Serial.begin(9600);. If the Serial Monitor listens at a mismatched baud rate, characters turn into garbled gibberish!',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),

          // Terminal Console Window
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isMatching
                    ? AppColors.success
                    : AppColors.danger.withValues(alpha: 0.7),
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Terminal Toolbar
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E293B),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(11)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Row(
                          children: [
                            Icon(Icons.terminal,
                                color: AppColors.accentCyan, size: 16),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'COM3 (Arduino Uno) • Serial Monitor',
                                overflow: TextOverflow.ellipsis,
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
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isMatching
                              ? AppColors.success.withValues(alpha: 0.2)
                              : AppColors.danger.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: isMatching
                                ? AppColors.success
                                : AppColors.danger,
                          ),
                        ),
                        child: Text(
                          isMatching ? 'SYNC MATCH' : 'MISMATCH',
                          style: TextStyle(
                            color: isMatching
                                ? AppColors.success
                                : AppColors.danger,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Terminal Text Output Area
                Container(
                  padding: const EdgeInsets.all(14),
                  height: 140,
                  color: Colors.black,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: isMatching
                          ? const [
                              Text(
                                '[BOOT] Microcontroller initialized.',
                                style: TextStyle(
                                  color: Color(0xFF00E676),
                                  fontFamily: 'monospace',
                                  fontSize: 11,
                                ),
                              ),
                              Text(
                                '[UART] Baud rate synchronized at 9600 bps.',
                                style: TextStyle(
                                  color: Color(0xFF00E676),
                                  fontFamily: 'monospace',
                                  fontSize: 11,
                                ),
                              ),
                              Text(
                                '[DATA] Heartbeat ping #1: millis=1000',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'monospace',
                                  fontSize: 11,
                                ),
                              ),
                              Text(
                                '[DATA] Heartbeat ping #2: millis=2000',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'monospace',
                                  fontSize: 11,
                                ),
                              ),
                              Text(
                                '[STATUS] Monster Lab Telemetry: ALL SYSTEMS NOMINAL',
                                style: TextStyle(
                                  color: AppColors.accentCyan,
                                  fontFamily: 'monospace',
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ]
                          : [
                              const Text(
                                r'⸮⸮x~??⸮f⸮⸮▒▒$@⸮??',
                                style: TextStyle(
                                  color: AppColors.danger,
                                  fontFamily: 'monospace',
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                '⸮⸮\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD\uFFFD?x!!⸮',
                                style: TextStyle(
                                  color: AppColors.energyAmber,
                                  fontFamily: 'monospace',
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '[BAUD MISMATCH WARNING] Sketch sends at 9600 baud, but monitor is sampling at $_selectedBaud baud! Bit frames are corrupted.',
                                style: const TextStyle(
                                  color: Color(0xFFFF7675),
                                  fontFamily: 'monospace',
                                  fontSize: 10,
                                ),
                              ),
                            ],
                    ),
                  ),
                ),

                // Bottom Baud Rate Selector Toolbar
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E293B),
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(11)),
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      const Text(
                        'Monitor Baud Rate:',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: _baudRates.map((baud) {
                          final isSelected = baud == _selectedBaud;
                          return ChoiceChip(
                            key: Key('baud_chip_$baud'),
                            label: Text('$baud baud'),
                            selected: isSelected,
                            onSelected: (val) {
                              if (val) _onBaudSelected(baud);
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Diagnostic Rule Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Row(
              children: [
                Icon(
                  isMatching ? Icons.check_circle : Icons.lightbulb_outline,
                  color: isMatching ? AppColors.success : AppColors.accentCyan,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    isMatching
                        ? 'Match Confirmed! Both ATmega328P and host PC clock each bit at exactly 9600 pulses/sec.'
                        : 'Rule: The baud rate in Serial.begin(rate) MUST match the Serial Monitor selector dropdown exactly.',
                    style: TextStyle(
                      color: isMatching ? AppColors.success : Colors.white70,
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
