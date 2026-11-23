import 'dart:async';
import 'package:material_ui/material_ui.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

/// Interactive visualizer for asynchronous UART packet framing (8-N-1 standard).
/// Illustrates Start bit, 8 data bits (LSB to MSB), optional Parity, Stop bit,
/// and baud rate bit-period calculations.
class UartFrameVisualizerWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const UartFrameVisualizerWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<UartFrameVisualizerWidget> createState() =>
      _UartFrameVisualizerWidgetState();
}

class _UartFrameVisualizerWidgetState extends State<UartFrameVisualizerWidget> {
  // Selected baud rate: 9600, 19200, 38400, 115200
  int _baudRate = 9600;

  // Selected ASCII character: default 'A' (0x41 = 0b01000001)
  String _selectedChar = 'A';

  // Parity mode: 0 = None (8-N-1), 1 = Even (8-E-1), 2 = Odd (8-O-1)
  int _parityMode = 0;

  // Stop bits: 1 or 2 periods
  int _stopBits = 1;

  // Active inspected bit index in the frame
  int _activeBitIndex = 0;
  bool _isPlaying = false;
  Timer? _playTimer;
  bool _hasCompleted = false;
  final Set<int> _inspectedBits = {0};

  @override
  void dispose() {
    _playTimer?.cancel();
    super.dispose();
  }

  // Bit period in microseconds
  double get _bitPeriodMicroseconds => 1000000.0 / _baudRate;

  // Total frame bits: Start(1) + Data(8) + Parity(0 or 1) + Stop(1 or 2)
  int get _totalFrameBits => 1 + 8 + (_parityMode == 0 ? 0 : 1) + _stopBits;

  // Get ASCII code of selected character
  int get _asciiCode =>
      _selectedChar.isNotEmpty ? _selectedChar.codeUnitAt(0) : 65;

  // Calculate parity bit value
  int get _parityBitValue {
    if (_parityMode == 0) return 0;
    // Count number of 1s in 8 data bits
    int onesCount = 0;
    for (int i = 0; i < 8; i++) {
      if (((_asciiCode >> i) & 1) == 1) onesCount++;
    }
    if (_parityMode == 1) {
      // Even parity: parity bit makes total 1s even
      return (onesCount % 2 == 0) ? 0 : 1;
    } else {
      // Odd parity: parity bit makes total 1s odd
      return (onesCount % 2 == 1) ? 0 : 1;
    }
  }

  // Build the list of frame bits:
  // Index 0: Start bit (always 0 / LOW)
  // Index 1..8: Data bits D0 to D7 (LSB first)
  // Index 9 (if parity): Parity bit
  // Last index: Stop bit(s) (always 1 / HIGH)
  List<_UartBitInfo> get _frameBits {
    final list = <_UartBitInfo>[];

    // 0: Start Bit
    list.add(const _UartBitInfo(
      label: 'START',
      bitValue: 0,
      description:
          'Falling edge triggers receiver clock timer. Held LOW for 1 bit period.',
      isStart: true,
    ));

    // 1..8: Data Bits D0 to D7 (LSB to MSB)
    for (int i = 0; i < 8; i++) {
      final val = (_asciiCode >> i) & 1;
      final role = (i == 0)
          ? 'LSB (Least Significant Bit)'
          : (i == 7)
              ? 'MSB (Most Significant Bit)'
              : 'Data bit D$i';
      list.add(_UartBitInfo(
        label: 'D$i',
        bitValue: val,
        description:
            '$role of ASCII 0x${_asciiCode.toRadixString(16).toUpperCase()} (\'$_selectedChar\').',
      ));
    }

    // Parity if enabled
    if (_parityMode != 0) {
      final parityLabel = _parityMode == 1 ? 'EVEN' : 'ODD';
      list.add(_UartBitInfo(
        label: 'PAR',
        bitValue: _parityBitValue,
        description: '$parityLabel parity check bit. Value: $_parityBitValue.',
      ));
    }

    // Stop Bit(s)
    if (_stopBits == 1) {
      list.add(const _UartBitInfo(
        label: 'STOP',
        bitValue: 1,
        description:
            'Held HIGH for minimum 1 bit period to terminate packet and return bus to IDLE.',
        isStop: true,
      ));
    } else {
      list.add(const _UartBitInfo(
        label: 'STOP 1',
        bitValue: 1,
        description: 'Stop bit 1 (HIGH): Held HIGH for 1st stop bit period.',
        isStop: true,
      ));
      list.add(const _UartBitInfo(
        label: 'STOP 2',
        bitValue: 1,
        description:
            'Stop bit 2 (HIGH): Extended stop period (2 full bit times total).',
        isStop: true,
      ));
    }

    return list;
  }

  void _setActiveBit(int index) {
    setState(() {
      _activeBitIndex = index.clamp(0, _totalFrameBits - 1);
      _inspectedBits.add(_activeBitIndex);
      _checkCompletion();
    });
  }

  void _stepForward() {
    setState(() {
      _activeBitIndex = (_activeBitIndex + 1) % _totalFrameBits;
      _inspectedBits.add(_activeBitIndex);
      _checkCompletion();
    });
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _playTimer?.cancel();
        _playTimer = Timer.periodic(const Duration(milliseconds: 600), (timer) {
          if (!mounted) return;
          _stepForward();
        });
      } else {
        _playTimer?.cancel();
      }
    });
  }

  void _checkCompletion() {
    if (_inspectedBits.length >= 4 && !_hasCompleted) {
      _hasCompleted = true;
      widget.onComplete?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        'UART Frame & Waveform Visualizer (8-N-1)';
    final bits = _frameBits;
    final currentBit = bits[_activeBitIndex.clamp(0, bits.length - 1)];
    final totalDurationUs = _totalFrameBits * _bitPeriodMicroseconds;

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
                        'FRAME MASTERED',
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
            'Explore asynchronous UART packet framing. Observe how the line idles HIGH (+5V), '
            'pulls LOW for the Start Bit, sends 8 data bits LSB-first, and returns HIGH for the Stop Bit.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondaryDark,
            ),
          ),
          const SizedBox(height: 14),

          // Parameter Selectors
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
                // Character Preset Chips
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text(
                      'Character:',
                      style: TextStyle(
                        color: AppColors.textSecondaryDark,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ...['A', 'M', '!', '7'].map((ch) {
                      final isSelected = _selectedChar == ch;
                      return ChoiceChip(
                        key: Key('char_preset_$ch'),
                        label: Text(
                          '\'$ch\' (0x${ch.codeUnitAt(0).toRadixString(16).toUpperCase()})',
                          style: TextStyle(
                            fontSize: 11,
                            color: isSelected
                                ? Colors.black
                                : AppColors.textPrimaryDark,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: AppColors.accentCyan,
                        backgroundColor: AppColors.surfaceDark,
                        onSelected: (val) {
                          if (val) {
                            setState(() {
                              _selectedChar = ch;
                            });
                          }
                        },
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 10),

                // Baud Rate Chips
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text(
                      'Baud Rate:',
                      style: TextStyle(
                        color: AppColors.textSecondaryDark,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ...[9600, 19200, 38400, 115200].map((rate) {
                      final isSelected = _baudRate == rate;
                      return ChoiceChip(
                        key: Key('baud_chip_$rate'),
                        label: Text(
                          '$rate',
                          style: TextStyle(
                            fontSize: 11,
                            color: isSelected
                                ? Colors.black
                                : AppColors.textPrimaryDark,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: AppColors.energyAmber,
                        backgroundColor: AppColors.surfaceDark,
                        onSelected: (val) {
                          if (val) {
                            setState(() {
                              _baudRate = rate;
                            });
                          }
                        },
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 10),

                // Parity Options
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text(
                      'Parity Mode:',
                      style: TextStyle(
                        color: AppColors.textSecondaryDark,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ChoiceChip(
                      key: const Key('parity_none'),
                      label: const Text('None', style: TextStyle(fontSize: 11)),
                      selected: _parityMode == 0,
                      selectedColor: AppColors.primaryViolet,
                      backgroundColor: AppColors.surfaceDark,
                      onSelected: (v) {
                        if (v) setState(() => _parityMode = 0);
                      },
                    ),
                    ChoiceChip(
                      key: const Key('parity_even'),
                      label: const Text('Even', style: TextStyle(fontSize: 11)),
                      selected: _parityMode == 1,
                      selectedColor: AppColors.primaryViolet,
                      backgroundColor: AppColors.surfaceDark,
                      onSelected: (v) {
                        if (v) setState(() => _parityMode = 1);
                      },
                    ),
                    ChoiceChip(
                      key: const Key('parity_odd'),
                      label: const Text('Odd', style: TextStyle(fontSize: 11)),
                      selected: _parityMode == 2,
                      selectedColor: AppColors.primaryViolet,
                      backgroundColor: AppColors.surfaceDark,
                      onSelected: (v) {
                        if (v) setState(() => _parityMode = 2);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Stop Bits Options
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text(
                      'Stop Bits:',
                      style: TextStyle(
                        color: AppColors.textSecondaryDark,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ChoiceChip(
                      key: const Key('stop_bits_1'),
                      label: const Text('1 Stop Bit',
                          style: TextStyle(fontSize: 11)),
                      selected: _stopBits == 1,
                      selectedColor: AppColors.accentCyanDark,
                      backgroundColor: AppColors.surfaceDark,
                      onSelected: (v) {
                        if (v) setState(() => _stopBits = 1);
                      },
                    ),
                    ChoiceChip(
                      key: const Key('stop_bits_2'),
                      label: const Text('2 Stop Bits',
                          style: TextStyle(fontSize: 11)),
                      selected: _stopBits == 2,
                      selectedColor: AppColors.accentCyanDark,
                      backgroundColor: AppColors.surfaceDark,
                      onSelected: (v) {
                        if (v) setState(() => _stopBits = 2);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Timing Metric Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                  color: AppColors.primaryViolet.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildMetric(
                    '1 Bit Period',
                    '${_bitPeriodMicroseconds.toStringAsFixed(1)} µs',
                    AppColors.accentCyan,
                  ),
                ),
                Expanded(
                  child: _buildMetric(
                    'Total Packet',
                    '${totalDurationUs.toStringAsFixed(1)} µs',
                    AppColors.energyAmber,
                  ),
                ),
                Expanded(
                  child: _buildMetric(
                    'Binary Byte',
                    '0b${_asciiCode.toRadixString(2).padLeft(8, '0')}',
                    AppColors.syntaxString,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Interactive Waveform Display
          Text(
            'TRANSMISSION WAVEFORM (TX / RX PIN VOLTAGE)',
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppColors.accentCyan,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1117),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF30363D)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Idle Line lead-in
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'IDLE (HIGH: +5V)',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 9,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Divider(
                        color: AppColors.syntaxFunction,
                        thickness: 2,
                        indent: 8,
                        endIndent: 8,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Bit blocks (Responsive Wrap - No side scrolling)
                Wrap(
                  spacing: 4,
                  runSpacing: 6,
                  children: [
                    for (int i = 0; i < bits.length; i++)
                      _buildBitWaveBlock(
                        index: i,
                        info: bits[i],
                        isSelected: i == _activeBitIndex,
                        onTap: () => _setActiveBit(i),
                      ),
                  ],
                ),
                const SizedBox(height: 8),

                // Step position progress bar
                LinearProgressIndicator(
                  value: (_activeBitIndex + 1) / bits.length,
                  backgroundColor: Colors.white10,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(AppColors.accentCyan),
                  minHeight: 3,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Inspected Bit Inspector Card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: currentBit.bitValue == 1
                    ? AppColors.syntaxFunction
                    : AppColors.energyAmber,
                width: 1.5,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: currentBit.bitValue == 1
                        ? AppColors.syntaxFunction.withValues(alpha: 0.2)
                        : AppColors.energyAmber.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    children: [
                      Text(
                        currentBit.label,
                        style: TextStyle(
                          color: currentBit.bitValue == 1
                              ? AppColors.syntaxFunction
                              : AppColors.energyAmber,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        currentBit.bitValue == 1 ? '1 (HIGH)' : '0 (LOW)',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bit ${_activeBitIndex + 1} of $_totalFrameBits: ${currentBit.label}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currentBit.description,
                        style: const TextStyle(
                          color: AppColors.textSecondaryDark,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Sampling Window: ${(_activeBitIndex * _bitPeriodMicroseconds).toStringAsFixed(1)} µs to ${((_activeBitIndex + 1) * _bitPeriodMicroseconds).toStringAsFixed(1)} µs (Middle sample at ${((_activeBitIndex + 0.5) * _bitPeriodMicroseconds).toStringAsFixed(1)} µs)',
                        style: const TextStyle(
                          color: AppColors.syntaxComment,
                          fontSize: 10,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Interactive Controls (Step, Play/Pause, Reset)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ElevatedButton.icon(
                key: const Key('step_bit_button'),
                onPressed: _stepForward,
                icon: const Icon(Icons.skip_next, size: 18),
                label: const Text('Next Bit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryViolet,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                ),
              ),
              ElevatedButton.icon(
                key: const Key('play_waveform_button'),
                onPressed: _togglePlay,
                icon:
                    Icon(_isPlaying ? Icons.pause : Icons.play_arrow, size: 18),
                label: Text(_isPlaying ? 'Pause' : 'Animate Frame'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isPlaying
                      ? AppColors.energyAmber
                      : AppColors.accentCyanDark,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                ),
              ),
              OutlinedButton(
                key: const Key('reset_bit_button'),
                onPressed: () => _setActiveBit(0),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textSecondaryDark,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                ),
                child: const Text('Reset'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondaryDark,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 12,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }

  Widget _buildBitWaveBlock({
    required int index,
    required _UartBitInfo info,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isHigh = info.bitValue == 1;
    final blockColor = isSelected
        ? (isHigh ? AppColors.syntaxFunction : AppColors.energyAmber)
        : (isHigh
            ? AppColors.syntaxFunction.withValues(alpha: 0.3)
            : AppColors.energyAmber.withValues(alpha: 0.3));

    return InkWell(
      key: Key('bit_block_$index'),
      onTap: onTap,
      child: Container(
        width: 48,
        padding: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? (isHigh
                  ? AppColors.syntaxFunction.withValues(alpha: 0.2)
                  : AppColors.energyAmber.withValues(alpha: 0.2))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: isSelected ? Border.all(color: blockColor, width: 2) : null,
        ),
        child: Column(
          children: [
            // Bit label
            Text(
              info.label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textSecondaryDark,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 4),

            // High/Low wave bar
            SizedBox(
              height: 40,
              width: 32,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Baseline guide
                  Positioned(
                    bottom: 4,
                    left: 0,
                    right: 0,
                    child: Container(height: 1, color: Colors.white10),
                  ),
                  Positioned(
                    top: 4,
                    left: 0,
                    right: 0,
                    child: Container(height: 1, color: Colors.white10),
                  ),
                  // Pulse graphic
                  Positioned(
                    top: isHigh ? 2 : 24,
                    left: 2,
                    right: 2,
                    child: Container(
                      height: 14,
                      decoration: BoxDecoration(
                        color: blockColor,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${info.bitValue}',
                        style: TextStyle(
                          color: isSelected ? Colors.black : Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 2),
            Text(
              isHigh ? 'HIGH' : 'LOW',
              style: TextStyle(
                color:
                    isHigh ? AppColors.syntaxFunction : AppColors.energyAmber,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UartBitInfo {
  final String label;
  final int bitValue;
  final String description;
  final bool isStart;
  final bool isStop;

  const _UartBitInfo({
    required this.label,
    required this.bitValue,
    required this.description,
    this.isStart = false,
    this.isStop = false,
  });
}
