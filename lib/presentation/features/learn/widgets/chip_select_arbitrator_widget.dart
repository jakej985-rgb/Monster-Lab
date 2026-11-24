import 'package:material_ui/material_ui.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

/// Interactive SPI multi-device bus arbitrator demonstrating dedicated active-low Chip Select
/// lines, High-Impedance (Hi-Z) tri-state standby, and bus contention prevention.
class ChipSelectArbitratorWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const ChipSelectArbitratorWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<ChipSelectArbitratorWidget> createState() =>
      _ChipSelectArbitratorWidgetState();
}

class _ChipSelectArbitratorWidgetState
    extends State<ChipSelectArbitratorWidget> {
  // false = HIGH (Inactive / Tri-state), true = LOW (Active)
  bool _isCs1Active = true; // Pin 10: RFID
  bool _isCs2Active = false; // Pin 9: 8x8 Matrix

  bool _hasTestedRfid = true;
  bool _hasTestedMatrix = false;
  bool _hasCompleted = false;

  bool get _hasBusContention => _isCs1Active && _isCs2Active;

  void _toggleCs1() {
    setState(() {
      _isCs1Active = !_isCs1Active;
      if (_isCs1Active) _hasTestedRfid = true;
      _checkCompletion();
    });
  }

  void _toggleCs2() {
    setState(() {
      _isCs2Active = !_isCs2Active;
      if (_isCs2Active) _hasTestedMatrix = true;
      _checkCompletion();
    });
  }

  void _checkCompletion() {
    if (_hasTestedRfid && _hasTestedMatrix && !_hasCompleted) {
      _hasCompleted = true;
      widget.onComplete?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        'SPI Chip Select Arbitrator & Tri-State Standby';

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
                        'ARBITRATION MASTERED',
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
            'Unlike I2C, SPI uses dedicated Chip Select (CS) pins instead of software addresses. '
            'Pulling a CS line LOW awakens that chip and enables its MISO output. Deselected chips float in High-Impedance (Hi-Z) tri-state.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),

          // Chip Select Switch Controls
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  key: const Key('toggle_cs1_button'),
                  onPressed: _toggleCs1,
                  icon: Icon(
                    _isCs1Active ? Icons.check_circle : Icons.cancel,
                    size: 18,
                    color: Colors.black,
                  ),
                  label: Text(
                    _isCs1Active
                        ? 'CS1 (Pin 10): LOW [ACTIVE]'
                        : 'CS1 (Pin 10): HIGH [STANDBY]',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isCs1Active
                        ? AppColors.energyAmber
                        : AppColors.surfaceContainerDark,
                    foregroundColor: _isCs1Active ? Colors.black : Colors.white,
                    side: BorderSide(
                      color:
                          _isCs1Active ? AppColors.energyAmber : Colors.white24,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  key: const Key('toggle_cs2_button'),
                  onPressed: _toggleCs2,
                  icon: Icon(
                    _isCs2Active ? Icons.check_circle : Icons.cancel,
                    size: 18,
                    color: Colors.black,
                  ),
                  label: Text(
                    _isCs2Active
                        ? 'CS2 (Pin 9): LOW [ACTIVE]'
                        : 'CS2 (Pin 9): HIGH [STANDBY]',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isCs2Active
                        ? AppColors.primaryViolet
                        : AppColors.surfaceContainerDark,
                    foregroundColor: _isCs2Active ? Colors.white : Colors.white,
                    side: BorderSide(
                      color: _isCs2Active
                          ? AppColors.primaryViolet
                          : Colors.white24,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Bus Diagram Visualizer
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _hasBusContention
                    ? AppColors.danger
                    : AppColors.wireSPI.withValues(alpha: 0.5),
                width: _hasBusContention ? 2 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Shared Lines Banner
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerDark,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Wrap(
                    alignment: WrapAlignment.spaceAround,
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      Text('MOSI (Pin 11)',
                          style: TextStyle(
                              fontSize: 10,
                              fontFamily: 'monospace',
                              color: AppColors.energyAmber,
                              fontWeight: FontWeight.bold)),
                      Text('MISO (Pin 12)',
                          style: TextStyle(
                              fontSize: 10,
                              fontFamily: 'monospace',
                              color: AppColors.accentCyan,
                              fontWeight: FontWeight.bold)),
                      Text('SCK (Pin 13)',
                          style: TextStyle(
                              fontSize: 10,
                              fontFamily: 'monospace',
                              color: AppColors.energyGold,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Peripherals Grid
                Row(
                  children: [
                    // Device 1: RFID
                    Expanded(
                      child: _buildDeviceCard(
                        name: 'RC522 RFID (comp_23)',
                        csPin: 'Pin 10 (CS1)',
                        isActive: _isCs1Active,
                        accentColor: AppColors.energyAmber,
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Device 2: 8x8 Matrix
                    Expanded(
                      child: _buildDeviceCard(
                        name: '8x8 Dot Matrix (comp_15)',
                        csPin: 'Pin 9 (CS2)',
                        isActive: _isCs2Active,
                        accentColor: AppColors.primaryViolet,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Diagnostic / Contention Warning
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (_hasBusContention ? AppColors.danger : AppColors.success)
                  .withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color:
                    (_hasBusContention ? AppColors.danger : AppColors.success)
                        .withValues(alpha: 0.4),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  _hasBusContention ? Icons.flash_on : Icons.verified,
                  color:
                      _hasBusContention ? AppColors.danger : AppColors.success,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _hasBusContention
                        ? 'BUS CONTENTION HAZARD: Both CS1 and CS2 are LOW! Both peripheral chips are simultaneously trying to drive the shared MISO line. This causes signal collisions, erratic telemetry, and high current draw. Only ONE CS pin may be LOW at any time!'
                        : (_isCs1Active
                            ? 'Device 1 Active: RFID reader is listening to MOSI and driving MISO. Dot matrix is safely in High-Impedance (Hi-Z) tri-state standby.'
                            : (_isCs2Active
                                ? 'Device 2 Active: 8x8 Dot Matrix is receiving graphics data. RFID reader is safely in High-Impedance (Hi-Z) tri-state standby.'
                                : 'Bus Idle: Both CS pins are HIGH. Both peripherals are in high-impedance standby; MISO bus is quiescent.')),
                    style: TextStyle(
                      fontSize: 11,
                      color: _hasBusContention
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

  Widget _buildDeviceCard({
    required String name,
    required String csPin,
    required bool isActive,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isActive
            ? accentColor.withValues(alpha: 0.2)
            : AppColors.surfaceContainerDark,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive ? accentColor : Colors.white12,
          width: isActive ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isActive ? accentColor : Colors.white70,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            csPin,
            style: const TextStyle(
              fontSize: 10,
              fontFamily: 'monospace',
              color: AppColors.textSecondaryDark,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              isActive ? 'MISO: DRIVING DATA' : 'MISO: TRI-STATE (Hi-Z)',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
                color: isActive ? AppColors.success : Colors.white38,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
