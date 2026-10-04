import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

class BreadboardTestScenario {
  final String id;
  final String title;
  final String probeALabel;
  final String probeBLabel;
  final bool isConnected;
  final String explanation;
  final IconData icon;

  const BreadboardTestScenario({
    required this.id,
    required this.title,
    required this.probeALabel,
    required this.probeBLabel,
    required this.isConnected,
    required this.explanation,
    required this.icon,
  });
}

/// Interactive breadboard internal bus and spring metal clip inspector.
/// Demonstrates horizontal 5-hole tie-points (a-b-c-d-e, f-g-h-i-j),
/// the center ravine divider, and vertical continuous power buses.
class BreadboardInternalBusInspectorWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const BreadboardInternalBusInspectorWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<BreadboardInternalBusInspectorWidget> createState() =>
      _BreadboardInternalBusInspectorWidgetState();
}

class _BreadboardInternalBusInspectorWidgetState
    extends State<BreadboardInternalBusInspectorWidget> {
  static const List<BreadboardTestScenario> _scenarios = [
    BreadboardTestScenario(
      id: 'same_row',
      title: 'Same 5-Hole Strip (Row 10: a & d)',
      probeALabel: 'Hole 10a',
      probeBLabel: 'Hole 10d',
      isConnected: true,
      explanation:
          'CONTINUOUS (0.00 Ω - BEEP!): Holes a-b-c-d-e are internally joined by a single spring metal clip beneath the plastic.',
      icon: Icons.link,
    ),
    BreadboardTestScenario(
      id: 'across_divider',
      title: 'Across Center Trench (Row 10: c & h)',
      probeALabel: 'Hole 10c (Left)',
      probeBLabel: 'Hole 10h (Right)',
      isConnected: false,
      explanation:
          'OPEN CIRCUIT (∞ MΩ): The center ravine splits the board into two independent strips, allowing Dual-Inline-Package (DIP) IC chips to sit without bridging pins.',
      icon: Icons.link_off,
    ),
    BreadboardTestScenario(
      id: 'power_rail',
      title: 'Power Bus Rail (+ Rail: Top & Bottom)',
      probeALabel: 'Red Rail (+) Row 1',
      probeBLabel: 'Red Rail (+) Row 20',
      isConnected: true,
      explanation:
          'CONTINUOUS (0.00 Ω - BEEP!): Power rails run vertically top-to-bottom so 5V can be tapped anywhere along the board length.',
      icon: Icons.power,
    ),
    BreadboardTestScenario(
      id: 'different_rows',
      title: 'Adjacent Rows (Row 10a & Row 11a)',
      probeALabel: 'Hole 10a',
      probeBLabel: 'Hole 11a',
      isConnected: false,
      explanation:
          'OPEN CIRCUIT (∞ MΩ): Neighboring rows are completely insulated from each other so distinct circuit nodes do not short out.',
      icon: Icons.border_horizontal,
    ),
    BreadboardTestScenario(
      id: 'power_short_check',
      title: 'Power Rail to Ground Rail (+ and −)',
      probeALabel: 'Red Rail (+)',
      probeBLabel: 'Blue Rail (−)',
      isConnected: false,
      explanation:
          'OPEN CIRCUIT (∞ MΩ): The positive and ground rails are completely separated. Never bridge these with a bare wire or you cause a dead short!',
      icon: Icons.security,
    ),
  ];

  int _selectedScenarioIndex = 0;
  final Set<String> _testedScenarios = {};
  bool _hasCompleted = false;

  void _selectScenario(int index) {
    setState(() {
      _selectedScenarioIndex = index;
      _testedScenarios.add(_scenarios[index].id);
      if (_testedScenarios.length >= 3 && !_hasCompleted) {
        _hasCompleted = true;
        widget.onComplete?.call();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _testedScenarios.add(_scenarios[0].id);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        'Breadboard Internal Bus & Clip Inspector';

    final active = _scenarios[_selectedScenarioIndex];

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
                  color: active.isConnected
                      ? AppColors.success.withValues(alpha: 0.2)
                      : AppColors.surfaceContainerDark,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: active.isConnected
                        ? AppColors.success
                        : AppColors.textSecondaryDark,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      active.isConnected ? Icons.volume_up : Icons.volume_off,
                      color: active.isConnected
                          ? AppColors.success
                          : AppColors.textSecondaryDark,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      active.isConnected
                          ? 'CONTINUOUS (0.00 Ω)'
                          : 'OPEN CIRCUIT (∞ MΩ)',
                      style: TextStyle(
                        color: active.isConnected
                            ? AppColors.success
                            : AppColors.textSecondaryDark,
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
          const SizedBox(height: 12),

          Text(
            'Underneath the plastic faceplate, solderless breadboards contain stamped nickel-silver spring clips. '
            'Test probe continuity between holes to discover how current flows!',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondaryDark,
            ),
          ),
          const SizedBox(height: 16),

          // Breadboard Cutaway Visual Representation
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.backgroundDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.surfaceContainerDark),
            ),
            child: Column(
              children: [
                // Multimeter Probe Readout Bar
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: active.isConnected
                          ? AppColors.success
                          : Colors.grey.shade800,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Red Probe
                      const CircleAvatar(
                        radius: 8,
                        backgroundColor: AppColors.wirePower5V,
                        child: Text('A',
                            style: TextStyle(
                                fontSize: 9,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        active.probeALabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        active.isConnected ? Icons.swap_horiz : Icons.close,
                        color: active.isConnected
                            ? AppColors.success
                            : AppColors.danger,
                        size: 18,
                      ),
                      const Spacer(),
                      // Black Probe
                      const CircleAvatar(
                        radius: 8,
                        backgroundColor: Colors.white,
                        child: Text('B',
                            style: TextStyle(
                                fontSize: 9,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        active.probeBLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Cutaway Breadboard Diagram
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Power Rails (+ and -)
                    _buildRailColumn(
                      label: '+',
                      color: AppColors.wirePower5V,
                      isHighlighted: active.id == 'power_rail' ||
                          active.id == 'power_short_check',
                    ),
                    const SizedBox(width: 4),
                    _buildRailColumn(
                      label: '−',
                      color: AppColors.wireGround,
                      isHighlighted: active.id == 'power_short_check',
                    ),
                    const SizedBox(width: 12),

                    // Terminal Block Left (a b c d e)
                    _buildTerminalStripColumn(
                      columns: ['a', 'b', 'c', 'd', 'e'],
                      isHighlightedRow10: active.id == 'same_row' ||
                          active.id == 'across_divider',
                      isRow11Highlighted: active.id == 'different_rows',
                    ),

                    // Center Ravine
                    Container(
                      width: 14,
                      height: 120,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.grey.shade900),
                      ),
                      child: const Center(
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Text(
                            'DIVIDER',
                            style: TextStyle(
                              color: Colors.white30,
                              fontSize: 7,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Terminal Block Right (f g h i j)
                    _buildTerminalStripColumn(
                      columns: ['f', 'g', 'h', 'i', 'j'],
                      isHighlightedRow10: active.id == 'across_divider',
                      isRow11Highlighted: false,
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Diagnostic Result Box
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerDark,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: active.isConnected
                          ? AppColors.success.withValues(alpha: 0.5)
                          : AppColors.surfaceContainerDark,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        active.isConnected
                            ? Icons.check_circle_outline
                            : Icons.info_outline,
                        color: active.isConnected
                            ? AppColors.success
                            : AppColors.accentCyan,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          active.explanation,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textPrimaryDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Probe Test Scenario Selection
          const Text(
            'Select Probe Continuity Test:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildScenarioButton(
                keyStr: 'probe_same_row',
                index: 0,
                label: '1. Same Row (10a & 10d)',
              ),
              _buildScenarioButton(
                keyStr: 'probe_across_divider',
                index: 1,
                label: '2. Across Divider (10c & 10h)',
              ),
              _buildScenarioButton(
                keyStr: 'probe_power_rail',
                index: 2,
                label: '3. Power Rail (+ Top & Bottom)',
              ),
              _buildScenarioButton(
                keyStr: 'probe_different_rows',
                index: 3,
                label: '4. Different Rows (10a & 11a)',
              ),
              _buildScenarioButton(
                keyStr: 'probe_power_short_check',
                index: 4,
                label: '5. Rail Isolation (+ & −)',
              ),
            ],
          ),

          if (_hasCompleted) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.success),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle,
                      color: AppColors.success, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Breadboard Mastery Verified! Tested ${_testedScenarios.length} connection paths.',
                      style: const TextStyle(
                        color: AppColors.success,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildScenarioButton({
    required String keyStr,
    required int index,
    required String label,
  }) {
    final isSelected = _selectedScenarioIndex == index;
    final isTested = _testedScenarios.contains(_scenarios[index].id);

    return ActionChip(
      key: Key(keyStr),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isTested) ...[
            const Icon(Icons.check, size: 14, color: AppColors.success),
            const SizedBox(width: 4),
          ],
          Text(label),
        ],
      ),
      backgroundColor:
          isSelected ? AppColors.primaryViolet.withValues(alpha: 0.3) : null,
      side: BorderSide(
        color: isSelected
            ? AppColors.primaryViolet
            : AppColors.surfaceContainerDark,
      ),
      onPressed: () => _selectScenario(index),
    );
  }

  Widget _buildRailColumn({
    required String label,
    required Color color,
    required bool isHighlighted,
  }) {
    return Container(
      width: 22,
      height: 120,
      decoration: BoxDecoration(
        color: isHighlighted
            ? color.withValues(alpha: 0.3)
            : AppColors.surfaceContainerDark,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isHighlighted ? color : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(label,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.bold, fontSize: 12)),
          for (int i = 0; i < 4; i++)
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: isHighlighted ? color : Colors.black,
                shape: BoxShape.circle,
              ),
            ),
          Text(label,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildTerminalStripColumn({
    required List<String> columns,
    required bool isHighlightedRow10,
    required bool isRow11Highlighted,
  }) {
    return Column(
      children: [
        // Column Letters
        Row(
          children: [
            for (final col in columns)
              SizedBox(
                width: 18,
                child: Center(
                  child: Text(col,
                      style: const TextStyle(
                          color: AppColors.textSecondaryDark, fontSize: 10)),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),

        // Row 9 (inactive)
        _buildHoleRow(columns.length, false),
        const SizedBox(height: 4),

        // Row 10
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          decoration: BoxDecoration(
            color: isHighlightedRow10
                ? AppColors.energyAmber.withValues(alpha: 0.25)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: isHighlightedRow10
                  ? AppColors.energyAmber
                  : Colors.transparent,
            ),
          ),
          child: _buildHoleRow(columns.length, isHighlightedRow10),
        ),
        const SizedBox(height: 4),

        // Row 11
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          decoration: BoxDecoration(
            color: isRow11Highlighted
                ? AppColors.accentCyan.withValues(alpha: 0.25)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: isRow11Highlighted
                  ? AppColors.accentCyan
                  : Colors.transparent,
            ),
          ),
          child: _buildHoleRow(columns.length, isRow11Highlighted),
        ),
        const SizedBox(height: 4),

        // Row 12 (inactive)
        _buildHoleRow(columns.length, false),
      ],
    );
  }

  Widget _buildHoleRow(int count, bool highlighted) {
    return Row(
      children: [
        for (int i = 0; i < count; i++)
          Container(
            width: 12,
            height: 12,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              color: highlighted ? AppColors.energyAmber : Colors.black87,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade700, width: 0.5),
            ),
          ),
      ],
    );
  }
}
