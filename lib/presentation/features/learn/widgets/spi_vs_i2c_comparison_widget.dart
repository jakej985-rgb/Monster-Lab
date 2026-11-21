import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

/// Interactive comparison matrix highlighting engineering trade-offs between SPI and I2C:
/// Wire counts, speeds, duplex modes, and addressing overhead with interactive design challenges.
class SpiVsI2cComparisonWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const SpiVsI2cComparisonWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<SpiVsI2cComparisonWidget> createState() =>
      _SpiVsI2cComparisonWidgetState();
}

class _SpiVsI2cComparisonWidgetState extends State<SpiVsI2cComparisonWidget> {
  int _activeScenario = 0; // 0, 1, 2
  final Map<int, String> _userChoices = {}; // scenarioIndex -> 'SPI' or 'I2C'
  final Set<int> _solvedScenarios = {};
  bool _hasCompleted = false;

  final List<Map<String, dynamic>> _scenarios = [
    {
      'title': 'Scenario 1: High-Speed MicroSD Card Logger',
      'description':
          'Writing 500 KB/s of accelerometer data during a high-g rocket launch.',
      'correct': 'SPI',
      'explanation':
          'Correct! SPI runs at 8–20 MHz, providing the massive megabyte throughput required for real-time flash storage. I2C caps out at 400 kHz and would drop data.',
    },
    {
      'title': 'Scenario 2: Weather Station (5 Environmental Sensors)',
      'description':
          'Connecting Temp, Humidity, Pressure, UV, and RTC modules to an Arduino Uno with few spare pins.',
      'correct': 'I2C',
      'explanation':
          'Correct! I2C connects all 5 sensors over just 2 shared wires (A4 & A5) using unique 7-bit addresses, saving precious pins for other functions.',
    },
    {
      'title': 'Scenario 3: 320x240 Color TFT Graphics Display',
      'description':
          'Rendering animated UI graphics and graphs at 30 frames per second.',
      'correct': 'SPI',
      'explanation':
          'Correct! Refreshing 76,800 RGB pixels requires multi-megahertz pixel clock rates. Over I2C, redrawing one full screen would take over 1.5 seconds!',
    },
  ];

  void _selectScenario(int index) {
    setState(() {
      _activeScenario = index;
    });
  }

  void _chooseProtocol(String protocol) {
    setState(() {
      _userChoices[_activeScenario] = protocol;
      if (protocol == _scenarios[_activeScenario]['correct']) {
        _solvedScenarios.add(_activeScenario);
      }

      if (_solvedScenarios.length >= 2 && !_hasCompleted) {
        _hasCompleted = true;
        widget.onComplete?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        'SPI vs. I2C Engineering Trade-Off Matrix';

    final scenario = _scenarios[_activeScenario];
    final currentChoice = _userChoices[_activeScenario];
    final isCorrect = currentChoice == scenario['correct'];
    final hasAnswered = currentChoice != null;

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
                        'DECISION MATRIX MASTERED',
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
            'Both protocols solve pin limitations, but they optimize for different engineering trade-offs: '
            'I2C minimizes wire count; SPI maximizes raw communication bandwidth.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),

          // Comparison Table
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              children: [
                _buildTableRow('Feature', 'I2C Bus', 'SPI Protocol',
                    isHeader: true),
                const Divider(height: 1, color: Colors.white12),
                _buildTableRow(
                    'Signal Wires', '2 (SDA, SCL)', '4+ (MOSI, MISO, SCK, CS)'),
                _buildTableRow(
                    'Maximum Speed', '400 kHz / 1 MHz', '8 MHz - 20+ MHz'),
                _buildTableRow('Duplex Mode', 'Half-Duplex', 'Full-Duplex'),
                _buildTableRow(
                    'Addressing', '7-bit Address Byte', 'Dedicated CS Pin'),
                _buildTableRow(
                    'Best For', 'Low-Speed Sensors', 'Displays, Storage, RFID'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Interactive Design Decision Challenge
          Text(
            'Engineering Design Challenge:',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.energyAmber,
            ),
          ),
          const SizedBox(height: 8),

          // Scenario Tabs
          Row(
            children: [
              Expanded(
                child: _buildScenarioTab(
                  key: const Key('scenario_select_1'),
                  label: '1. Storage',
                  index: 0,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _buildScenarioTab(
                  key: const Key('scenario_select_2'),
                  label: '2. Sensors',
                  index: 1,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _buildScenarioTab(
                  key: const Key('scenario_select_3'),
                  label: '3. Display',
                  index: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Active Scenario Card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerDark,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  scenario['title'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  scenario['description'] as String,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondaryDark,
                  ),
                ),
                const SizedBox(height: 10),

                // Choice Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        key: const Key('choose_i2c_button'),
                        onPressed: () => _chooseProtocol('I2C'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: currentChoice == 'I2C'
                              ? (isCorrect
                                  ? AppColors.success
                                  : AppColors.danger)
                              : AppColors.surfaceDark,
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white24),
                        ),
                        child: const Text('Choose I2C Bus'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        key: const Key('choose_spi_button'),
                        onPressed: () => _chooseProtocol('SPI'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: currentChoice == 'SPI'
                              ? (isCorrect
                                  ? AppColors.success
                                  : AppColors.danger)
                              : AppColors.surfaceDark,
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white24),
                        ),
                        child: const Text('Choose SPI Protocol'),
                      ),
                    ),
                  ],
                ),

                if (hasAnswered) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (isCorrect ? AppColors.success : AppColors.danger)
                          .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isCorrect ? AppColors.success : AppColors.danger,
                      ),
                    ),
                    child: Text(
                      isCorrect
                          ? scenario['explanation'] as String
                          : 'Incorrect: Try analyzing the bandwidth vs wire count requirements for this specific task!',
                      style: TextStyle(
                        fontSize: 11,
                        color: isCorrect ? AppColors.success : AppColors.danger,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(String col1, String col2, String col3,
      {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              col1,
              style: TextStyle(
                fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                fontSize: 11,
                color: isHeader ? AppColors.accentCyan : Colors.white70,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              col2,
              style: TextStyle(
                fontWeight: isHeader ? FontWeight.bold : FontWeight.w500,
                fontSize: 11,
                color: isHeader ? AppColors.energyGold : Colors.white,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              col3,
              style: TextStyle(
                fontWeight: isHeader ? FontWeight.bold : FontWeight.w500,
                fontSize: 11,
                color: isHeader ? AppColors.accentCyan : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScenarioTab({
    required Key key,
    required String label,
    required int index,
  }) {
    final isSelected = _activeScenario == index;
    final isSolved = _solvedScenarios.contains(index);

    return InkWell(
      key: key,
      onTap: () => _selectScenario(index),
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accentCyan.withValues(alpha: 0.2)
              : AppColors.surfaceContainerDark,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? AppColors.accentCyan : Colors.white12,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSolved)
              const Padding(
                padding: EdgeInsets.only(right: 2),
                child: Icon(Icons.check, color: AppColors.success, size: 12),
              ),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? AppColors.accentCyan : Colors.white70,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
