import 'dart:async';
import 'package:material_ui/material_ui.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

class PortSelectorBenchWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const PortSelectorBenchWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<PortSelectorBenchWidget> createState() =>
      _PortSelectorBenchWidgetState();
}

class _PortSelectorBenchWidgetState extends State<PortSelectorBenchWidget> {
  static const List<String> _boards = [
    'Arduino Uno',
    'Arduino Mega 2560',
    'ESP32 Dev Module',
  ];

  static const List<String> _ports = [
    'COM3 (Arduino Uno)',
    'COM1 (Internal Serial)',
    '/dev/ttyUSB0 (UART Bridge)',
  ];

  late String _selectedBoard;
  late String _selectedPort;
  bool _isConnecting = false;
  bool _isConnected = false;
  bool _txLed = false;
  bool _rxLed = false;
  String _statusMessage = 'Select board and port, then tap Connect & Test.';
  final List<String> _consoleLogs = [];
  Timer? _ledTimer;

  @override
  void initState() {
    super.initState();
    _selectedBoard = _boards[0];
    _selectedPort = _ports[0];
  }

  @override
  void dispose() {
    _ledTimer?.cancel();
    super.dispose();
  }

  void _connectAndTest() {
    if (_isConnecting) return;

    setState(() {
      _isConnecting = true;
      _isConnected = false;
      _consoleLogs.clear();
      _statusMessage = 'Initiating serial handshake...';
      _consoleLogs.add('[IDE] Scanning communication bus on $_selectedPort...');
    });

    _ledTimer?.cancel();
    int tick = 0;
    _ledTimer = Timer.periodic(const Duration(milliseconds: 180), (timer) {
      tick++;
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _txLed = tick % 2 == 1;
        _rxLed = tick % 2 == 0;
      });

      if (tick == 2) {
        setState(() {
          _consoleLogs.add('[TX] Sending sync ping (0x7E 0x01)...');
        });
      } else if (tick == 4) {
        setState(() {
          _consoleLogs.add('[RX] Acknowledge received from bootloader.');
        });
      } else if (tick >= 6) {
        timer.cancel();
        _txLed = false;
        _rxLed = false;

        final bool isBoardCorrect = _selectedBoard == 'Arduino Uno';
        final bool isPortCorrect = _selectedPort.contains('COM3') ||
            _selectedPort.contains('/dev/ttyUSB0');

        setState(() {
          _isConnecting = false;
          if (isBoardCorrect && isPortCorrect) {
            _isConnected = true;
            _statusMessage =
                'Connection verified! ATmega328P on $_selectedPort ready.';
            _consoleLogs
                .add('[SUCCESS] Hardware handshaking verified: 115200 baud.');
            widget.onComplete?.call();
          } else if (!isBoardCorrect) {
            _statusMessage =
                'Board mismatch! Expected Arduino Uno, got $_selectedBoard.';
            _consoleLogs.add('[ERROR] Device signature mismatch for target.');
          } else {
            _statusMessage =
                'Port error! $_selectedPort has no responding microcontroller.';
            _consoleLogs
                .add('[ERROR] Timeout: No response from selected port.');
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title =
        widget.config?['title'] as String? ?? 'Virtual IDE Port Selector Bench';

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
              if (_isConnected)
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
                        'VERIFIED',
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
            'The Arduino IDE needs to know which board model you are programming and which serial communication port connects to it.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),

          // Menu Bar Simulation Container
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.settings_input_composite,
                        color: AppColors.accentCyan, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Tools > Board & Port Configuration',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Board Selection
                const Text(
                  'Select Board Model:',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _boards.map((b) {
                    final selected = b == _selectedBoard;
                    return ChoiceChip(
                      label: Text(b),
                      selected: selected,
                      onSelected: (val) {
                        if (val) {
                          setState(() {
                            _selectedBoard = b;
                            _isConnected = false;
                          });
                        }
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),

                // Port Selection
                const Text(
                  'Select Communication Port:',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _ports.map((p) {
                    final selected = p == _selectedPort;
                    return ChoiceChip(
                      label: Text(p),
                      selected: selected,
                      onSelected: (val) {
                        if (val) {
                          setState(() {
                            _selectedPort = p;
                            _isConnected = false;
                          });
                        }
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Hardware Simulation Display (Board LEDs)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    _isConnected ? AppColors.success : const Color(0xFF475569),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLedIndicator(
                  label: 'ON (5V Power)',
                  color: const Color(0xFF00E676),
                  isActive: true,
                  icon: Icons.power,
                ),
                _buildLedIndicator(
                  label: 'TX (Transmit)',
                  color: AppColors.energyAmber,
                  isActive: _txLed,
                  icon: Icons.upload,
                ),
                _buildLedIndicator(
                  label: 'RX (Receive)',
                  color: AppColors.energyGold,
                  isActive: _rxLed,
                  icon: Icons.download,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Action Button
          ElevatedButton.icon(
            key: const Key('port_selector_test_button'),
            onPressed: _isConnecting ? null : _connectAndTest,
            icon: _isConnecting
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.flash_on),
            label: Text(
              _isConnecting ? 'TESTING LINK...' : 'CONNECT & TEST LINK',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryViolet,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Console Output
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'STATUS: $_statusMessage',
                  style: TextStyle(
                    color: _isConnected
                        ? AppColors.success
                        : (_statusMessage.contains('error') ||
                                _statusMessage.contains('mismatch')
                            ? AppColors.danger
                            : AppColors.accentCyan),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                ),
                if (_consoleLogs.isNotEmpty) ...[
                  const Divider(color: Colors.white24, height: 12),
                  ..._consoleLogs.map((log) => Text(
                        log,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          fontFamily: 'monospace',
                        ),
                      )),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLedIndicator({
    required String label,
    required Color color,
    required bool isActive,
    required IconData icon,
  }) {
    return Column(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? color : const Color(0xFF334155),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.8),
                      blurRadius: 12,
                      spreadRadius: 2,
                    )
                  ]
                : null,
            border: Border.all(color: Colors.white38),
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
