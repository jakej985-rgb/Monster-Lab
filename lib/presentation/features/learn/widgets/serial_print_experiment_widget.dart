import 'package:material_ui/material_ui.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

class SerialPrintExperimentWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const SerialPrintExperimentWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<SerialPrintExperimentWidget> createState() =>
      _SerialPrintExperimentWidgetState();
}

class _SerialPrintExperimentWidgetState
    extends State<SerialPrintExperimentWidget> {
  // 0: Serial.print(), 1: Serial.println()
  int _selectedMode = 0;
  final Set<int> _testedModes = {0};
  final List<String> _terminalLines = [];
  bool _hasAwardedCompletion = false;

  @override
  void initState() {
    super.initState();
    _resetTerminalForMode(0);
  }

  void _resetTerminalForMode(int mode) {
    _terminalLines.clear();
    if (mode == 0) {
      // print(): everything on one concatenated line
      _terminalLines.add('MONSTERLABMONSTERLABMONSTERLAB');
    } else {
      // println(): separate lines
      _terminalLines.addAll(['MONSTER', 'LAB', 'MONSTER', 'LAB', 'ONLINE']);
    }
  }

  void _onModeChanged(int newMode) {
    setState(() {
      _selectedMode = newMode;
      _testedModes.add(newMode);
      _resetTerminalForMode(newMode);

      if (_testedModes.length >= 2 && !_hasAwardedCompletion) {
        _hasAwardedCompletion = true;
        widget.onComplete?.call();
      }
    });
  }

  void _sendBurst() {
    setState(() {
      if (_selectedMode == 0) {
        if (_terminalLines.isEmpty) {
          _terminalLines.add('DATA');
        } else {
          _terminalLines[0] = '${_terminalLines[0]}DATA';
        }
      } else {
        _terminalLines.add('DATA PING #${_terminalLines.length + 1}');
      }

      if (_testedModes.length >= 2 && !_hasAwardedCompletion) {
        _hasAwardedCompletion = true;
        widget.onComplete?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        'Serial.print() vs Serial.println() Telemetry Lab';

    final isPrint = _selectedMode == 0;

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
                        'FORMAT MASTERED',
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
            'The "ln" in println stands for "line". Toggle between print() and println() to see how newline characters format terminal logs:',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),

          // Selector Chips
          Row(
            children: [
              Expanded(
                child: ChoiceChip(
                  key: const Key('print_mode_chip'),
                  label: const Text('Serial.print() (No Newline)'),
                  selected: isPrint,
                  onSelected: (val) {
                    if (val) _onModeChanged(0);
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ChoiceChip(
                  key: const Key('println_mode_chip'),
                  label: const Text('Serial.println() (With Newline)'),
                  selected: !isPrint,
                  onSelected: (val) {
                    if (val) _onModeChanged(1);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Code Preview Block
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Arduino C++ Sketch',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 10,
                        fontFamily: 'monospace',
                      ),
                    ),
                    Text(
                      isPrint ? 'Same-Line Output' : 'Line Break (\\r\\n)',
                      style: TextStyle(
                        color: isPrint
                            ? AppColors.energyAmber
                            : AppColors.accentCyan,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.white24, height: 12),
                Text(
                  isPrint
                      ? '''void loop() {
  Serial.print("MONSTER");
  Serial.print("LAB");
  delay(1000);
}'''
                      : '''void loop() {
  Serial.println("MONSTER");
  Serial.println("LAB");
  delay(1000);
}''',
                  style: TextStyle(
                    color: isPrint
                        ? const Color(0xFFFDCB6E)
                        : const Color(0xFF55EFC4),
                    fontFamily: 'monospace',
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Terminal Output Screen
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isPrint ? AppColors.energyAmber : AppColors.success,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Live Serial Monitor Output:',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton.icon(
                      key: const Key('send_burst_button'),
                      onPressed: _sendBurst,
                      icon: const Icon(Icons.send, size: 14),
                      label: const Text('Send Data Ping',
                          style: TextStyle(fontSize: 11)),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.accentCyan,
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _terminalLines.map((line) {
                        return Text(
                          line,
                          style: TextStyle(
                            color: isPrint
                                ? AppColors.energyAmber
                                : const Color(0xFF00E676),
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isPrint
                      ? 'Note: print() keeps cursor on the exact same row. Repeated strings smash together horizontally!'
                      : 'Note: println() prints the text and then moves the cursor to line 2. Ideal for log streams and sensor readings.',
                  style: TextStyle(
                    color: isPrint ? AppColors.energyAmber : AppColors.success,
                    fontSize: 10,
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
