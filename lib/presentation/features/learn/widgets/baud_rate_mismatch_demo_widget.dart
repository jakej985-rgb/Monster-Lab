import 'package:material_ui/material_ui.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

/// Interactive demonstration of baud rate clock synchronization and framing errors.
/// Shows how unshared transmitter and receiver clocks produce gibberish characters and
/// framing errors when baud rates mismatch.
class BaudRateMismatchDemoWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const BaudRateMismatchDemoWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<BaudRateMismatchDemoWidget> createState() =>
      _BaudRateMismatchDemoWidgetState();
}

class _BaudRateMismatchDemoWidgetState
    extends State<BaudRateMismatchDemoWidget> {
  int _txBaud = 115200;
  int _rxBaud = 9600;

  final String _txMessage = 'TELEMETRY OK';
  String _decodedMessage = '';
  bool _testedMismatch = false;
  bool _testedMatch = false;
  bool _hasCompleted = false;

  final List<int> _baudRates = [9600, 38400, 115200];

  @override
  void initState() {
    super.initState();
    _computeDecodedMessage();
  }

  void _computeDecodedMessage() {
    if (_txBaud == _rxBaud) {
      _decodedMessage = _txMessage;
      _testedMatch = true;
    } else {
      _testedMismatch = true;
      // Generate realistic gibberish based on baud disparity
      final ratio = _txBaud / _rxBaud;
      if (ratio > 1.0) {
        // Transmitter much faster than receiver: receiver samples across multiple bytes
        _decodedMessage = 'ÿþ\x00\x1F?!\x80';
      } else {
        // Transmitter much slower than receiver: receiver samples same bit multiple times
        _decodedMessage = 'ääÀÀüü\x00\x00';
      }
    }
  }

  void _transmit() {
    setState(() {
      _computeDecodedMessage();
      _checkCompletion();
    });
  }

  void _setMatch() {
    setState(() {
      _rxBaud = _txBaud;
      _transmit();
    });
  }

  void _checkCompletion() {
    if (_testedMismatch && _testedMatch && !_hasCompleted) {
      _hasCompleted = true;
      widget.onComplete?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        'Baud Rate Clock Mismatch & Framing Error Lab';

    final isMatch = _txBaud == _rxBaud;
    final txBitPeriodUs = 1000000.0 / _txBaud;
    final rxBitPeriodUs = 1000000.0 / _rxBaud;

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
                        'TIMING SYNC MASTERED',
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
            'Because UART is asynchronous, there is no shared clock wire! '
            'If the sender and receiver oscillators run at different baud rates, '
            'sampling points drift out of alignment, generating unreadable gibberish and Framing Errors.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondaryDark,
            ),
          ),
          const SizedBox(height: 14),

          // Baud Rate Configuration Bench
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.backgroundDark,
              borderRadius: BorderRadius.circular(8),
              border:
                  Border.all(color: AppColors.surfaceContainerDark, width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Transmitter Baud selector
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text(
                      'TX Baud (Sender):',
                      style: TextStyle(
                        color: AppColors.textSecondaryDark,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ..._baudRates.map((rate) {
                      final isSelected = _txBaud == rate;
                      return ChoiceChip(
                        key: Key('tx_baud_chip_$rate'),
                        label: Text('$rate baud',
                            style: const TextStyle(fontSize: 11)),
                        selected: isSelected,
                        selectedColor: AppColors.energyAmber,
                        backgroundColor: AppColors.surfaceDark,
                        onSelected: (val) {
                          if (val) {
                            setState(() {
                              _txBaud = rate;
                              _computeDecodedMessage();
                              _checkCompletion();
                            });
                          }
                        },
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 10),

                // Receiver Baud selector
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text(
                      'RX Baud (Receiver):',
                      style: TextStyle(
                        color: AppColors.textSecondaryDark,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ..._baudRates.map((rate) {
                      final isSelected = _rxBaud == rate;
                      return ChoiceChip(
                        key: Key('rx_baud_chip_$rate'),
                        label: Text('$rate baud',
                            style: const TextStyle(fontSize: 11)),
                        selected: isSelected,
                        selectedColor: AppColors.accentCyan,
                        backgroundColor: AppColors.surfaceDark,
                        onSelected: (val) {
                          if (val) {
                            setState(() {
                              _rxBaud = rate;
                              _computeDecodedMessage();
                              _checkCompletion();
                            });
                          }
                        },
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 8),

                // Quick Match button
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    key: const Key('match_baud_button'),
                    onPressed: _setMatch,
                    icon: const Icon(Icons.sync, size: 14),
                    label: Text(
                      'Synchronize Clocks ($_txBaud baud)',
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Clock Drift Comparison Card
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: isMatch ? AppColors.success : AppColors.danger),
            ),
            child: Wrap(
              alignment: WrapAlignment.spaceAround,
              runAlignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                Column(
                  children: [
                    const Text(
                      'TX Bit Duration',
                      style: TextStyle(color: Colors.white60, fontSize: 10),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${txBitPeriodUs.toStringAsFixed(1)} µs',
                      style: const TextStyle(
                        color: AppColors.energyAmber,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
                Icon(
                  isMatch ? Icons.check_circle : Icons.warning_amber_rounded,
                  color: isMatch ? AppColors.success : AppColors.danger,
                  size: 20,
                ),
                Column(
                  children: [
                    const Text(
                      'RX Bit Duration',
                      style: TextStyle(color: Colors.white60, fontSize: 10),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${rxBitPeriodUs.toStringAsFixed(1)} µs',
                      style: const TextStyle(
                        color: AppColors.accentCyan,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      'Sampling Clock Drift',
                      style: TextStyle(color: Colors.white60, fontSize: 10),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isMatch
                          ? '0.0% (IN PHASE)'
                          : '${((_txBaud / _rxBaud - 1.0) * 100).abs().toStringAsFixed(0)}% SKEW',
                      style: TextStyle(
                        color: isMatch ? AppColors.success : AppColors.danger,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Dual Terminal View: Sender vs Receiver Output
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: Transmitter
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(minHeight: 130),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.upload,
                              size: 13, color: AppColors.energyAmber),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'TX ($_txBaud)',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.energyAmber,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(color: Colors.white10),
                      Text(
                        '> "$_txMessage"',
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'monospace',
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        '100% Valid 8-N-1',
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Right: Receiver Console
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(minHeight: 130),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B132B),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isMatch ? AppColors.success : AppColors.danger,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.download,
                            size: 13,
                            color:
                                isMatch ? AppColors.success : AppColors.danger,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'RX ($_rxBaud)',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: isMatch
                                    ? AppColors.success
                                    : AppColors.danger,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(color: Colors.white10),
                      Text(
                        '> "$_decodedMessage"',
                        style: TextStyle(
                          color: isMatch ? AppColors.success : AppColors.danger,
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        isMatch ? 'Status: DECODE OK' : 'Status: FRAMING ERR',
                        style: TextStyle(
                          color: isMatch ? AppColors.success : AppColors.danger,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Diagnostic Alert Banner
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isMatch
                  ? AppColors.success.withValues(alpha: 0.15)
                  : AppColors.danger.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isMatch ? AppColors.success : AppColors.danger,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isMatch ? Icons.verified : Icons.error_outline,
                  color: isMatch ? AppColors.success : AppColors.danger,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isMatch
                        ? 'SYNCHRONIZED: Receiver samples exactly in the center of each bit window (50% midpoint). 0% bit error rate!'
                        : 'FRAMING ERROR: Clocks are unsynchronized! Receiver clock ticks out of phase and fails to detect the valid STOP bit (HIGH).',
                    style: TextStyle(
                      color: isMatch ? AppColors.success : AppColors.danger,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Transmit Action Button
          ElevatedButton.icon(
            key: const Key('send_packet_button'),
            onPressed: _transmit,
            icon: const Icon(Icons.send, size: 16),
            label: const Text('Transmit Serial Packet'),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isMatch ? AppColors.success : AppColors.primaryViolet,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
