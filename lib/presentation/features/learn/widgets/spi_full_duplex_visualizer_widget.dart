import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

/// Interactive dual shift-register visualizer demonstrating simultaneous full-duplex
/// SPI data transfer between Master (MOSI) and Slave (MISO) on shared SCK clock pulses.
class SpiFullDuplexVisualizerWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const SpiFullDuplexVisualizerWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<SpiFullDuplexVisualizerWidget> createState() =>
      _SpiFullDuplexVisualizerWidgetState();
}

class _SpiFullDuplexVisualizerWidgetState
    extends State<SpiFullDuplexVisualizerWidget> {
  // Master sends 0xA5 (10100101), Slave sends 0x3C (00111100)
  final List<int> _masterOriginal = [1, 0, 1, 0, 0, 1, 0, 1];
  final List<int> _slaveOriginal = [0, 0, 1, 1, 1, 1, 0, 0];

  late List<int> _masterBuffer;
  late List<int> _slaveBuffer;

  int _clockTick = 0; // 0 to 8
  Timer? _autoTimer;
  bool _isAutoRunning = false;
  bool _hasCompleted = false;

  @override
  void initState() {
    super.initState();
    _resetRegisters();
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    super.dispose();
  }

  void _resetRegisters() {
    _autoTimer?.cancel();
    _isAutoRunning = false;
    _clockTick = 0;
    _masterBuffer = List.from(_masterOriginal);
    _slaveBuffer = List.from(_slaveOriginal);
  }

  void _clockStep() {
    if (_clockTick >= 8) {
      _resetRegisters();
    }

    setState(() {
      _clockTick++;

      // Shift operation: Master shifts out MSB, accepts Slave MSB at LSB
      final masterBitOut = _masterBuffer.removeAt(0);
      final slaveBitOut = _slaveBuffer.removeAt(0);

      _masterBuffer.add(slaveBitOut);
      _slaveBuffer.add(masterBitOut);

      if (_clockTick == 8 && !_hasCompleted) {
        _hasCompleted = true;
        widget.onComplete?.call();
      }
    });
  }

  void _autoTransfer() {
    if (_isAutoRunning) {
      _autoTimer?.cancel();
      setState(() => _isAutoRunning = false);
      return;
    }

    if (_clockTick >= 8) {
      setState(() => _resetRegisters());
    }

    setState(() => _isAutoRunning = true);
    _autoTimer = Timer.periodic(const Duration(milliseconds: 350), (timer) {
      if (!mounted) return;
      if (_clockTick < 8) {
        _clockStep();
      } else {
        _autoTimer?.cancel();
        setState(() => _isAutoRunning = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        'SPI Full-Duplex Shift Register Visualizer';

    final isFinished = _clockTick == 8;

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
                        'FULL-DUPLEX VERIFIED',
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
            'SPI connects Master and Slave registers into an unbroken 16-bit ring. '
            'On every clock pulse (SCK), one bit leaves MOSI while one bit arrives on MISO simultaneously!',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),

          // Control row
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  key: const Key('spi_clock_tick_button'),
                  onPressed: _clockStep,
                  icon: const Icon(Icons.touch_app, size: 18),
                  label: Text(_clockTick >= 8
                      ? 'Reset & Restart'
                      : 'Clock Bit ($_clockTick/8)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentCyan,
                    foregroundColor: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  key: const Key('spi_auto_transfer_button'),
                  onPressed: _autoTransfer,
                  icon: Icon(_isAutoRunning ? Icons.pause : Icons.fast_forward,
                      size: 18),
                  label: Text(_isAutoRunning ? 'Pause' : 'Auto 8-Bit Burst'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white24),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                key: const Key('spi_reset_button'),
                onPressed: () => setState(_resetRegisters),
                icon: const Icon(Icons.refresh, color: Colors.white60),
                tooltip: 'Reset Registers',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Shift Register Ring Display
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isFinished
                    ? AppColors.success
                    : AppColors.wireSPI.withValues(alpha: 0.5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Master Register
                _buildRegisterSection(
                  title: 'MASTER (Arduino Uno: Outgoing 0xA5)',
                  buffer: _masterBuffer,
                  color: AppColors.accentCyan,
                ),
                const SizedBox(height: 12),

                // Data lines in transit
                Row(
                  children: [
                    Expanded(
                      child: _buildWireIndicator(
                        label: 'MOSI (Pin 11 ➔ Out)',
                        color: AppColors.energyAmber,
                        direction: Icons.arrow_downward,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildWireIndicator(
                        label: 'MISO (Pin 12 ➔ In)',
                        color: AppColors.primaryViolet,
                        direction: Icons.arrow_upward,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Slave Register
                _buildRegisterSection(
                  title: 'SLAVE (RC522 RFID: Replying 0x3C)',
                  buffer: _slaveBuffer,
                  color: AppColors.energyGold,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Real-time Explanation Banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerDark,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.code,
                        color: AppColors.accentCyan, size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        isFinished
                            ? 'byte reply = SPI.transfer(0xA5); // 0x3C'
                            : 'SPI.transfer() (Pulse $_clockTick / 8)',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11,
                          color: AppColors.accentCyan,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  isFinished
                      ? 'Full-Duplex Complete! In the exact same 8 clock cycles, Master sent 0xA5 and simultaneously received 0x3C from the slave!'
                      : 'Every tick of SCK latches 1 bit in BOTH directions. Unlike I2C or Half-Duplex UART, SPI never waits for the other chip to respond in a separate turn.',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterSection({
    required String title,
    required List<int> buffer,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: buffer.asMap().entries.map((entry) {
            final bit = entry.value;
            return Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: bit == 1
                    ? color.withValues(alpha: 0.25)
                    : AppColors.surfaceContainerDark,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: bit == 1 ? color : Colors.white12,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                '$bit',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: bit == 1 ? color : Colors.white54,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildWireIndicator({
    required String label,
    required Color color,
    required IconData direction,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(direction, color: color, size: 14),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontFamily: 'monospace',
                color: color,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
