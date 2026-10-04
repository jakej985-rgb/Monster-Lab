import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

/// Simulated interactive serial terminal running the standard Arduino I2C Scanner sketch,
/// scanning 7-bit addresses 0x01 through 0x7E.
class I2cAddressScannerWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const I2cAddressScannerWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<I2cAddressScannerWidget> createState() =>
      _I2cAddressScannerWidgetState();
}

class _I2cAddressScannerWidgetState extends State<I2cAddressScannerWidget> {
  bool _includeLcd = true; // 0x27
  bool _includeRtc = true; // 0x68

  bool _isScanning = false;
  int _currentScanAddress = 1;
  final List<String> _terminalLines = [
    '--- I2C Hardware Bus Scanner Ready ---',
    'Click "Run Scanner Sketch" to probe addresses 0x01..0x7E.',
  ];

  Timer? _scanTimer;
  bool _hasCompleted = false;

  @override
  void dispose() {
    _scanTimer?.cancel();
    super.dispose();
  }

  void _startScan() {
    if (_isScanning) return;
    _scanTimer?.cancel();

    setState(() {
      _isScanning = true;
      _currentScanAddress = 1;
      _terminalLines.clear();
      _terminalLines.add('--- Initializing Wire.begin() at 100 kHz ---');
      _terminalLines.add('Scanning bus...');
    });

    _scanTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (!mounted) return;
      setState(() {
        _currentScanAddress += 2;

        if (_currentScanAddress >= 0x27 &&
            _currentScanAddress - 2 < 0x27 &&
            _includeLcd) {
          _terminalLines
              .add('>> [ACK 0] Device found at 0x27 (16x2 LCD Display)');
        }

        if (_currentScanAddress >= 0x68 &&
            _currentScanAddress - 2 < 0x68 &&
            _includeRtc) {
          _terminalLines
              .add('>> [ACK 0] Device found at 0x68 (DS3231 RTC Module)');
        }

        if (_currentScanAddress >= 127) {
          _scanTimer?.cancel();
          _isScanning = false;
          final discovered = (_includeLcd ? 1 : 0) + (_includeRtc ? 1 : 0);
          _terminalLines
              .add('--- Scan complete: $discovered device(s) responded ---');

          if (discovered > 0 && !_hasCompleted) {
            _hasCompleted = true;
            widget.onComplete?.call();
          }
        }
      });
    });
  }

  void _toggleLcd() {
    if (_isScanning) return;
    setState(() {
      _includeLcd = !_includeLcd;
    });
  }

  void _toggleRtc() {
    if (_isScanning) return;
    setState(() {
      _includeRtc = !_includeRtc;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        'I2C Address Scanner: Terminal Diagnostic Bench';

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
                        'DEVICES DISCOVERED',
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
            'The standard Arduino I2C Scanner sketch iterates from address 1 to 126. '
            'It sends Wire.endTransmission() and listens for the hardware ACK bit (error code 0).',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(height: 16),

          // Hardware Connection Row
          Row(
            children: [
              Expanded(
                child: InkWell(
                  key: const Key('toggle_scan_lcd'),
                  onTap: _toggleLcd,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: _includeLcd
                          ? AppColors.accentCyan.withValues(alpha: 0.2)
                          : AppColors.surfaceContainerDark,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color:
                            _includeLcd ? AppColors.accentCyan : Colors.white12,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _includeLcd
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          size: 16,
                          color: _includeLcd
                              ? AppColors.accentCyan
                              : Colors.white54,
                        ),
                        const SizedBox(width: 4),
                        const Flexible(
                          child: Text(
                            'LCD (0x27)',
                            style: TextStyle(
                                fontSize: 11, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: InkWell(
                  key: const Key('toggle_scan_rtc'),
                  onTap: _toggleRtc,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: _includeRtc
                          ? AppColors.energyAmber.withValues(alpha: 0.2)
                          : AppColors.surfaceContainerDark,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _includeRtc
                            ? AppColors.energyAmber
                            : Colors.white12,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _includeRtc
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          size: 16,
                          color: _includeRtc
                              ? AppColors.energyAmber
                              : Colors.white54,
                        ),
                        const SizedBox(width: 4),
                        const Flexible(
                          child: Text(
                            'RTC (0x68)',
                            style: TextStyle(
                                fontSize: 11, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Run scan button
          ElevatedButton.icon(
            key: const Key('run_i2c_scan_button'),
            onPressed: _startScan,
            icon: Icon(
              _isScanning ? Icons.hourglass_top : Icons.play_arrow,
              color: Colors.black,
            ),
            label: Text(
              _isScanning
                  ? 'Pinging Addresses (0x${_currentScanAddress.toRadixString(16).padLeft(2, '0').toUpperCase()})...'
                  : 'Run I2C Scanner Sketch',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentCyan,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          const SizedBox(height: 14),

          // Simulated Serial Monitor Terminal
          Container(
            height: 150,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1117),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'SERIAL MONITOR (9600 BAUD)',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 10,
                          color: AppColors.accentCyan,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (_isScanning)
                      const SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.accentCyan,
                        ),
                      ),
                  ],
                ),
                const Divider(color: Colors.white12, height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: _terminalLines.length,
                    itemBuilder: (context, idx) {
                      final line = _terminalLines[idx];
                      final isAck = line.contains('[ACK 0]');
                      return Text(
                        line,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11,
                          color: isAck
                              ? AppColors.success
                              : (line.startsWith('>>')
                                  ? AppColors.energyAmber
                                  : Colors.white70),
                          fontWeight:
                              isAck ? FontWeight.bold : FontWeight.normal,
                        ),
                      );
                    },
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
