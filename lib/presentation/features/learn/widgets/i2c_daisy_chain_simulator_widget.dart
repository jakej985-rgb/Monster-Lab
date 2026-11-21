import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

/// Interactive I2C bus builder connecting multiple peripherals (LCD, RTC, OLED)
/// and demonstrating address conflicts when identical sensors share 0x68.
class I2cDaisyChainSimulatorWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const I2cDaisyChainSimulatorWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<I2cDaisyChainSimulatorWidget> createState() =>
      _I2cDaisyChainSimulatorWidgetState();
}

class _I2cDaisyChainSimulatorWidgetState
    extends State<I2cDaisyChainSimulatorWidget> {
  bool _isLcdConnected = true; // 0x27
  bool _isRtcConnected = true; // 0x68
  bool _isOledConnected = false; // 0x3C
  bool _isSecondRtcConnected = false; // 0x68 - conflict!

  bool _hasEncounteredCollision = false;
  bool _hasResolvedCollision = false;
  bool _hasCompleted = false;

  bool get _hasAddressCollision => _isRtcConnected && _isSecondRtcConnected;

  int get _connectedCount =>
      (_isLcdConnected ? 1 : 0) +
      (_isRtcConnected ? 1 : 0) +
      (_isOledConnected ? 1 : 0) +
      (_isSecondRtcConnected ? 1 : 0);

  void _toggleLcd() {
    setState(() {
      _isLcdConnected = !_isLcdConnected;
      _checkStatus();
    });
  }

  void _toggleRtc() {
    setState(() {
      _isRtcConnected = !_isRtcConnected;
      _checkStatus();
    });
  }

  void _toggleOled() {
    setState(() {
      _isOledConnected = !_isOledConnected;
      _checkStatus();
    });
  }

  void _toggleSecondRtc() {
    setState(() {
      _isSecondRtcConnected = !_isSecondRtcConnected;
      _checkStatus();
    });
  }

  void _checkStatus() {
    if (_hasAddressCollision) {
      _hasEncounteredCollision = true;
    } else if (_hasEncounteredCollision && !_hasAddressCollision) {
      _hasResolvedCollision = true;
    }

    if (_hasEncounteredCollision &&
        _hasResolvedCollision &&
        _connectedCount >= 2 &&
        !_hasCompleted) {
      _hasCompleted = true;
      widget.onComplete?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        'I2C Daisy-Chain Bus Builder & Address Collision';

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
                        'BUS INTEGRITY VERIFIED',
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
            'In I2C, every sensor shares the exact same two wires (SDA & SCL). '
            'Each peripheral must have a UNIQUE 7-bit hexadecimal address. Attach components below to test the bus!',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),

          // Component Toggles Palette
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildDeviceChip(
                key: const Key('toggle_device_lcd'),
                name: '16x2 LCD',
                address: '0x27',
                isConnected: _isLcdConnected,
                onTap: _toggleLcd,
              ),
              _buildDeviceChip(
                key: const Key('toggle_device_rtc'),
                name: 'DS3231 RTC #1',
                address: '0x68',
                isConnected: _isRtcConnected,
                onTap: _toggleRtc,
              ),
              _buildDeviceChip(
                key: const Key('toggle_device_oled'),
                name: '0.96" OLED',
                address: '0x3C',
                isConnected: _isOledConnected,
                onTap: _toggleOled,
              ),
              _buildDeviceChip(
                key: const Key('toggle_device_second_rtc'),
                name: 'DS3231 RTC #2 (Duplicate)',
                address: '0x68',
                isConnected: _isSecondRtcConnected,
                onTap: _toggleSecondRtc,
                isWarning: true,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Shared Bus Visualizer
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _hasAddressCollision
                    ? AppColors.danger
                    : AppColors.wireI2C.withValues(alpha: 0.5),
                width: _hasAddressCollision ? 2 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Master Info
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.developer_board,
                              color: AppColors.accentCyan, size: 18),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Arduino Uno (A4 SDA / A5 SCL)',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Pins: 2',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                        color: AppColors.accentCyan,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Bus Wire Lines
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      _buildBusWire(
                        label: 'SDA (Data: Pin A4)',
                        color: _hasAddressCollision
                            ? AppColors.danger
                            : AppColors.accentCyan,
                      ),
                      const SizedBox(height: 8),
                      _buildBusWire(
                        label: 'SCL (Clock: Pin A5)',
                        color: _hasAddressCollision
                            ? AppColors.danger
                            : AppColors.energyGold,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Attached Nodes Display
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isLcdConnected)
                      _buildBusNode('LCD (0x27)', AppColors.accentCyan),
                    if (_isRtcConnected)
                      _buildBusNode(
                          'RTC #1 (0x68)',
                          _hasAddressCollision
                              ? AppColors.danger
                              : AppColors.energyGold),
                    if (_isSecondRtcConnected)
                      _buildBusNode('RTC #2 (0x68)', AppColors.danger),
                    if (_isOledConnected)
                      _buildBusNode('OLED (0x3C)', AppColors.primaryViolet),
                    if (_connectedCount == 0)
                      const Text(
                        'No peripherals connected to bus',
                        style: TextStyle(fontSize: 11, color: Colors.white38),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Status & Conflict Diagnostic Banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color:
                  (_hasAddressCollision ? AppColors.danger : AppColors.success)
                      .withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: (_hasAddressCollision
                        ? AppColors.danger
                        : AppColors.success)
                    .withValues(alpha: 0.4),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  _hasAddressCollision
                      ? Icons.error_outline
                      : Icons.check_circle_outline,
                  color: _hasAddressCollision
                      ? AppColors.danger
                      : AppColors.success,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _hasAddressCollision
                        ? 'CRITICAL BUS CONFLICT: Two devices share address 0x68! Both chips will simultaneously pull SDA LOW during communication, causing bus collisions, corrupt data, and system lockups. Solution: Change hardware solder jumpers or use an I2C multiplexer.'
                        : 'Bus Healthy: All $_connectedCount connected peripheral(s) have unique 7-bit addresses. The Controller communicates with each target independently over the shared 2-wire bus!',
                    style: TextStyle(
                      fontSize: 11,
                      color: _hasAddressCollision
                          ? AppColors.danger
                          : AppColors.textPrimaryDark,
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

  Widget _buildDeviceChip({
    required Key key,
    required String name,
    required String address,
    required bool isConnected,
    required VoidCallback onTap,
    bool isWarning = false,
  }) {
    return InkWell(
      key: key,
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isConnected
              ? (isWarning
                  ? AppColors.danger.withValues(alpha: 0.3)
                  : AppColors.accentCyan.withValues(alpha: 0.2))
              : AppColors.surfaceContainerDark,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isConnected
                ? (isWarning ? AppColors.danger : AppColors.accentCyan)
                : Colors.white12,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isConnected ? Icons.check_box : Icons.check_box_outline_blank,
              size: 16,
              color: isConnected
                  ? (isWarning ? AppColors.danger : AppColors.accentCyan)
                  : Colors.white54,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isConnected ? FontWeight.bold : FontWeight.normal,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                address,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 10,
                  color: AppColors.energyAmber,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusWire({required String label, required Color color}) {
    return Row(
      children: [
        SizedBox(
          width: 130,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontFamily: 'monospace',
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 3,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBusNode(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 10,
            fontFamily: 'monospace',
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }
}
