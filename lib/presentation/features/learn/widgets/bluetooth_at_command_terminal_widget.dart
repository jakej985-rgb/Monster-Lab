import 'dart:async';
import 'package:material_ui/material_ui.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

/// Simulated HC-05 Bluetooth Module (comp_29) AT Command Console.
/// Learners can toggle AT Command Mode (KEY/EN pin held HIGH), observe LED blink timing,
/// send standard Hayes AT commands (AT, AT+NAME, AT+PSWD, AT+ROLE), and receive responses.
class BluetoothAtCommandTerminalWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const BluetoothAtCommandTerminalWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<BluetoothAtCommandTerminalWidget> createState() =>
      _BluetoothAtCommandTerminalWidgetState();
}

class _BluetoothAtCommandTerminalWidgetState
    extends State<BluetoothAtCommandTerminalWidget> {
  // AT Mode vs Transparent Data Mode (Key/EN pin state)
  bool _isAtMode = true;

  // LED blink timer
  Timer? _ledTimer;
  bool _ledOn = false;

  // Terminal history
  final List<_TerminalLine> _log = [];
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Configured parameters on HC-05
  String _moduleName = 'HC-05';
  String _modulePin = '1234';
  int _moduleRole = 0; // 0 = Slave, 1 = Master

  final Set<String> _executedCommands = {};
  bool _hasCompleted = false;

  @override
  void initState() {
    super.initState();
    _startLedBlink();
    // Initial welcome banner
    _log.add(const _TerminalLine(
      text: '=== HC-05 AT Command Mode Terminal (38400 baud) ===',
      isSystem: true,
    ));
    _log.add(const _TerminalLine(
      text: 'EN / KEY Pin held HIGH. Ready for configuration.',
      isSystem: true,
    ));
  }

  @override
  void dispose() {
    _ledTimer?.cancel();
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _startLedBlink() {
    _ledTimer?.cancel();
    final interval = _isAtMode
        ? const Duration(milliseconds: 1000) // Slow 1s/2s cycle in AT mode
        : const Duration(milliseconds: 200); // Fast flicker in data mode

    _ledTimer = Timer.periodic(interval, (timer) {
      if (!mounted) return;
      setState(() {
        _ledOn = !_ledOn;
      });
    });
  }

  void _toggleMode(bool atMode) {
    setState(() {
      _isAtMode = atMode;
      _log.add(_TerminalLine(
        text: _isAtMode
            ? '--- Switched to AT Command Mode (KEY Pin = HIGH, 38400 baud) ---'
            : '--- Switched to Transparent Data Mode (KEY Pin = LOW) ---',
        isSystem: true,
      ));
    });
    _startLedBlink();
    _scrollToBottom();
  }

  void _sendCommand(String rawCmd) {
    final cmd = rawCmd.trim();
    if (cmd.isEmpty) return;

    setState(() {
      _log.add(_TerminalLine(text: '> $cmd', isInput: true));

      if (!_isAtMode) {
        _log.add(const _TerminalLine(
          text:
              'ERROR: Module in Data Mode! Pull KEY/EN HIGH to enter AT command mode.',
          isError: true,
        ));
      } else {
        final upper = cmd.toUpperCase();
        if (upper == 'AT') {
          _log.add(const _TerminalLine(text: 'OK', isResponse: true));
          _executedCommands.add('AT');
        } else if (upper.startsWith('AT+NAME=')) {
          final newName = cmd.substring(8).trim();
          _moduleName = newName.isNotEmpty ? newName : 'MonsterLab';
          _log.add(const _TerminalLine(text: 'OK', isResponse: true));
          _executedCommands.add('NAME');
        } else if (upper == 'AT+NAME?') {
          _log.add(_TerminalLine(text: '+NAME:$_moduleName', isResponse: true));
          _log.add(const _TerminalLine(text: 'OK', isResponse: true));
        } else if (upper.startsWith('AT+PSWD=') ||
            upper.startsWith('AT+PIN=')) {
          final idx = cmd.indexOf('=');
          _modulePin = cmd.substring(idx + 1).trim();
          _log.add(const _TerminalLine(text: 'OK', isResponse: true));
          _executedCommands.add('PSWD');
        } else if (upper == 'AT+PSWD?' || upper == 'AT+PIN?') {
          _log.add(_TerminalLine(text: '+PIN:$_modulePin', isResponse: true));
          _log.add(const _TerminalLine(text: 'OK', isResponse: true));
        } else if (upper.startsWith('AT+ROLE=')) {
          final val = int.tryParse(cmd.substring(8).trim()) ?? 0;
          _moduleRole = val;
          _log.add(const _TerminalLine(text: 'OK', isResponse: true));
          _executedCommands.add('ROLE');
        } else if (upper == 'AT+ROLE?') {
          _log.add(_TerminalLine(text: '+ROLE:$_moduleRole', isResponse: true));
          _log.add(const _TerminalLine(text: 'OK', isResponse: true));
        } else if (upper == 'AT+VERSION' || upper == 'AT+VERSION?') {
          _log.add(const _TerminalLine(
              text: '+VERSION:2.0-20100601\nOK', isResponse: true));
          _executedCommands.add('VERSION');
        } else if (upper.startsWith('AT+UART=')) {
          _log.add(const _TerminalLine(text: 'OK', isResponse: true));
          _executedCommands.add('UART');
        } else {
          _log.add(const _TerminalLine(
            text:
                'ERROR:(0) Unknown command. Use AT, AT+NAME=..., AT+PSWD=..., AT+ROLE=0',
            isError: true,
          ));
        }
      }

      _inputController.clear();
      _checkCompletion();
    });

    _scrollToBottom();
  }

  void _checkCompletion() {
    if (_executedCommands.length >= 2 && !_hasCompleted) {
      _hasCompleted = true;
      widget.onComplete?.call();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        'HC-05 Bluetooth AT Command Terminal';

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
                        'AT MASTERED',
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
            'The HC-05 module has two operating modes: AT Command Mode (configure name, baud, pin) '
            'and Data Mode (transmit wireless bytes). Hold KEY/EN pin HIGH to send Hayes AT commands.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondaryDark,
            ),
          ),
          const SizedBox(height: 14),

          // Hardware Module Indicator Bar
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color:
                      _isAtMode ? AppColors.accentCyan : AppColors.energyAmber),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    // Animated LED
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _ledOn
                            ? (_isAtMode
                                ? const Color(0xFFFF3838)
                                : const Color(0xFF00E676))
                            : Colors.black45,
                        boxShadow: _ledOn
                            ? [
                                BoxShadow(
                                  color: (_isAtMode
                                          ? const Color(0xFFFF3838)
                                          : const Color(0xFF00E676))
                                      .withValues(alpha: 0.8),
                                  blurRadius: 6,
                                  spreadRadius: 2,
                                )
                              ]
                            : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _isAtMode
                            ? 'HC-05 [AT MODE] (38400 baud)'
                            : 'HC-05 [DATA MODE] (9600 baud)',
                        style: TextStyle(
                          color: _isAtMode
                              ? AppColors.accentCyan
                              : AppColors.energyAmber,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    OutlinedButton(
                      key: const Key('toggle_at_mode'),
                      onPressed: () => _toggleMode(!_isAtMode),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(
                          color: _isAtMode
                              ? AppColors.accentCyan
                              : AppColors.energyAmber,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        _isAtMode ? 'To DATA' : 'To AT',
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 12,
                  runSpacing: 4,
                  children: [
                    Text(
                      'LED: ${_isAtMode ? "2s Slow Pulse" : "Fast Blink"}',
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 10,
                        fontFamily: 'monospace',
                      ),
                    ),
                    Text(
                      'Name: $_moduleName',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontFamily: 'monospace',
                      ),
                    ),
                    Text(
                      'PIN: $_modulePin',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontFamily: 'monospace',
                      ),
                    ),
                    Text(
                      'Role: ${_moduleRole == 0 ? "0 (Slave)" : "1 (Master)"}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Quick Preset AT Command Buttons
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              ActionChip(
                key: const Key('preset_at_test'),
                avatar: const Icon(Icons.flash_on,
                    size: 14, color: AppColors.accentCyan),
                label: const Text('AT (Test)', style: TextStyle(fontSize: 11)),
                backgroundColor: AppColors.surfaceDark,
                onPressed: () => _sendCommand('AT'),
              ),
              ActionChip(
                key: const Key('preset_at_name'),
                avatar: const Icon(Icons.label,
                    size: 14, color: AppColors.energyAmber),
                label: const Text('AT+NAME=MonsterLab',
                    style: TextStyle(fontSize: 11)),
                backgroundColor: AppColors.surfaceDark,
                onPressed: () => _sendCommand('AT+NAME=MonsterLab'),
              ),
              ActionChip(
                key: const Key('preset_at_pswd'),
                avatar: const Icon(Icons.lock,
                    size: 14, color: AppColors.syntaxString),
                label:
                    const Text('AT+PSWD=1234', style: TextStyle(fontSize: 11)),
                backgroundColor: AppColors.surfaceDark,
                onPressed: () => _sendCommand('AT+PSWD=1234'),
              ),
              ActionChip(
                key: const Key('preset_at_role'),
                avatar: const Icon(Icons.hub,
                    size: 14, color: AppColors.primaryViolet),
                label: const Text('AT+ROLE=0', style: TextStyle(fontSize: 11)),
                backgroundColor: AppColors.surfaceDark,
                onPressed: () => _sendCommand('AT+ROLE=0'),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Terminal Output Window
          Container(
            height: 170,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF090D16),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _log.length,
              itemBuilder: (context, index) {
                final line = _log[index];
                Color color = Colors.white70;
                if (line.isSystem) color = AppColors.syntaxComment;
                if (line.isInput) color = AppColors.accentCyan;
                if (line.isResponse) color = AppColors.syntaxFunction;
                if (line.isError) color = AppColors.danger;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    line.text,
                    style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontFamily: 'monospace',
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),

          // Command Input & Submit
          Row(
            children: [
              Expanded(
                child: TextField(
                  key: const Key('at_command_input'),
                  controller: _inputController,
                  onSubmitted: _sendCommand,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'monospace',
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter command (e.g. AT+NAME? or AT+VERSION)...',
                    hintStyle: const TextStyle(
                      color: Colors.white38,
                      fontSize: 11,
                    ),
                    filled: true,
                    fillColor: AppColors.surfaceDark,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: Colors.white24),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                key: const Key('send_command_button'),
                onPressed: () => _sendCommand(_inputController.text),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryViolet,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                child: const Text('Send'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TerminalLine {
  final String text;
  final bool isInput;
  final bool isResponse;
  final bool isSystem;
  final bool isError;

  const _TerminalLine({
    required this.text,
    this.isInput = false,
    this.isResponse = false,
    this.isSystem = false,
    this.isError = false,
  });
}
