import 'package:material_ui/material_ui.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

class LibraryConceptDiagramWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const LibraryConceptDiagramWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<LibraryConceptDiagramWidget> createState() =>
      _LibraryConceptDiagramWidgetState();
}

class _LibraryConceptDiagramWidgetState
    extends State<LibraryConceptDiagramWidget> {
  int _selectedTabIndex = 0; // 0: Without Library, 1: With Library
  final Set<int> _exploredTabs = {0};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        'The Power of Libraries: Raw Registers vs Clean Abstraction';
    final hasExploredBoth = _exploredTabs.length >= 2;

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
              if (hasExploredBoth)
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
                        'CONCEPT MASTERED',
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
            'Why do we use libraries? Toggle between the two approaches below to see what a library does for you behind the scenes.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),

          // Segmented Toggle Tabs
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ChoiceChip(
                key: const Key('library_tab_without'),
                label: const Text('Without Library (Raw Registers)'),
                selected: _selectedTabIndex == 0,
                onSelected: (val) {
                  if (val) {
                    setState(() {
                      _selectedTabIndex = 0;
                      _exploredTabs.add(0);
                      if (_exploredTabs.length >= 2) {
                        widget.onComplete?.call();
                      }
                    });
                  }
                },
              ),
              ChoiceChip(
                key: const Key('library_tab_with'),
                label: const Text('With Library (Abstraction)'),
                selected: _selectedTabIndex == 1,
                onSelected: (val) {
                  if (val) {
                    setState(() {
                      _selectedTabIndex = 1;
                      _exploredTabs.add(1);
                      if (_exploredTabs.length >= 2) {
                        widget.onComplete?.call();
                      }
                    });
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Mode Content Display
          if (_selectedTabIndex == 0)
            _buildWithoutLibraryView()
          else
            _buildWithLibraryView(),

          const SizedBox(height: 14),

          // Summary Metric Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: _buildMetricColumn(
                      'Lines of Code',
                      _selectedTabIndex == 0 ? '540+ lines' : '3 lines',
                      _selectedTabIndex == 0
                          ? AppColors.danger
                          : AppColors.success),
                ),
                Expanded(
                  child: _buildMetricColumn(
                      'Development Time',
                      _selectedTabIndex == 0
                          ? 'Weeks of debugging'
                          : '30 seconds',
                      _selectedTabIndex == 0
                          ? AppColors.energyAmber
                          : AppColors.accentCyan),
                ),
                Expanded(
                  child: _buildMetricColumn(
                      'Bug Probability',
                      _selectedTabIndex == 0 ? 'Extremely High' : 'Near Zero',
                      _selectedTabIndex == 0
                          ? AppColors.danger
                          : AppColors.success),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWithoutLibraryView() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: AppColors.danger.withValues(alpha: 0.6), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.warning, color: AppColors.danger, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Without Library: Raw I2C Bit-Banging & Timing Delays',
                  style: TextStyle(
                    color: AppColors.danger,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'You must manually toggle CPU clock registers (TWCR, TWDR), manage microsecond setup times, split each letter into two 4-bit nibbles, and pulse enable lines:',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white24),
            ),
            child: const Text(
              '''// 500+ lines of low-level hardware register code:
void i2c_start() {
  TWCR = (1 << TWINT) | (1 << TWSTA) | (1 << TWEN);
  while (!(TWCR & (1 << TWINT))); // wait for clock
}
void i2c_write(uint8_t data) {
  TWDR = data;
  TWCR = (1 << TWINT) | (1 << TWEN);
  while (!(TWCR & (1 << TWINT)));
}
void lcd_send_nibble(uint8_t nibble, uint8_t mode) {
  uint8_t packet = (nibble << 4) | mode | 0x04; // En=1
  i2c_write(packet);
  _delay_us(1); // pulse delay
  packet &= ~0x04; // En=0
  i2c_write(packet);
  _delay_us(50);
}
// ... 520 more lines of manual timing ...''',
              style: TextStyle(
                color: Color(0xFFE2E8F0),
                fontFamily: 'monospace',
                fontSize: 11,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWithLibraryView() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: AppColors.success.withValues(alpha: 0.8), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.verified, color: AppColors.success, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'With Library: 2 Clean Function Calls',
                  style: TextStyle(
                    color: AppColors.success,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'The LiquidCrystal_I2C library encapsulates all 500 lines of timing pulses inside high-level class methods:',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white24),
            ),
            child: const Text(
              '''#include <LiquidCrystal_I2C.h>

LiquidCrystal_I2C lcd(0x27, 16, 2);

void setup() {
  lcd.init();      // Library handles all 500 lines of I2C init!
  lcd.backlight(); // Powers LED backlight automatically
  lcd.print("Monster Online!");
}''',
              style: TextStyle(
                color: Color(0xFF55EFC4),
                fontFamily: 'monospace',
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricColumn(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white60, fontSize: 10),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
