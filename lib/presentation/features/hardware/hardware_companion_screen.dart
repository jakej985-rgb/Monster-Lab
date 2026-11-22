import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/models/hardware_board_model.dart';
import '../../../domain/models/hardware_connection_model.dart';
import '../../shared/providers.dart';
import '../../shared/widgets/monster_button.dart';
import '../../shared/widgets/monster_card.dart';
import 'widgets/hardware_status_badge.dart';

class HardwareCompanionScreen extends ConsumerStatefulWidget {
  const HardwareCompanionScreen({super.key});

  @override
  ConsumerState<HardwareCompanionScreen> createState() =>
      _HardwareCompanionScreenState();
}

class _HardwareCompanionScreenState
    extends ConsumerState<HardwareCompanionScreen> {
  final TextEditingController _commandController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _autoScroll = true;

  List<DiscoveredBoard> _availableBoards = [
    DiscoveredBoard.virtualSimulator(),
  ];
  DiscoveredBoard? _selectedBoard;
  int _selectedBaud = 9600;

  @override
  void initState() {
    super.initState();
    _selectedBoard = _availableBoards.first;
    _refreshDiscoveredBoards();
  }

  @override
  void dispose() {
    _commandController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refreshDiscoveredBoards() async {
    final bridge = ref.read(hardwareBridgeProvider);
    final boards = await bridge.scanDevices();
    if (mounted) {
      setState(() {
        _availableBoards =
            boards.isNotEmpty ? boards : [DiscoveredBoard.virtualSimulator()];
        if (!_availableBoards.contains(_selectedBoard)) {
          _selectedBoard = _availableBoards.first;
        }
      });
    }
  }

  void _scrollToBottom() {
    if (_autoScroll && _scrollController.hasClients) {
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
  }

  @override
  Widget build(BuildContext context) {
    final bridge = ref.watch(hardwareBridgeProvider);
    final stateAsync = ref.watch(hardwareStateStreamProvider);
    final state = stateAsync.value ?? bridge.currentState;
    final telemetryAsync = ref.watch(hardwareTelemetryStreamProvider);
    final telemetry = telemetryAsync.value ?? bridge.currentTelemetry;
    final logs = ref.watch(hardwareSerialLogsProvider);

    _scrollToBottom();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hardware Companion',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: Center(child: HardwareStatusBadge(showLabel: true)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 1. Philosophy Banner: Hardware is Optional
          _buildInfoBanner(),
          const SizedBox(height: 16),

          // Linux Dialout Group Permission Helper
          _buildLinuxDialoutInfoBar(),

          // 2. Hardware Connection Control Card
          _buildConnectionControlCard(bridge, state),
          const SizedBox(height: 20),

          // 3. Live Hardware Telemetry Scope
          const Text(
            'Live Hardware Telemetry Scope',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildTelemetryScopeCard(bridge, state, telemetry),
          const SizedBox(height: 20),

          // 4. Interactive Serial Monitor Terminal
          const Text(
            'Interactive Serial Monitor',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildSerialMonitorCard(bridge, state, logs),
          const SizedBox(height: 20),

          // 5. Supported Arduino Boards Guide
          const Text(
            'Supported Microcontroller Boards',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildSupportedBoardsGuide(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildInfoBanner() {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryViolet.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: AppColors.primaryViolet.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.hub_outlined,
              color: AppColors.primaryViolet, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hardware Companion (Simulation)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppColors.primaryViolet,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Monster Lab includes a built-in Virtual Hardware Bridge. You can build projects, verify wiring, and test serial commands with zero physical hardware attached.',
                  style: TextStyle(
                      fontSize: 13,
                      color: colorScheme.onSurfaceVariant,
                      height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinuxDialoutInfoBar() {
    if (kIsWeb || !Platform.isLinux) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: isDark ? 0.14 : 0.08),
        borderRadius: BorderRadius.circular(6),
        border:
            Border.all(color: AppColors.info.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.info, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Linux Serial USB Permissions',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'To connect directly to /dev/ttyACM* or /dev/ttyUSB*, your user must belong to the dialout group.',
                  style: TextStyle(
                      fontSize: 11, color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton.icon(
            onPressed: () {
              Clipboard.setData(const ClipboardData(
                  text: 'sudo usermod -a -G dialout \$USER'));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Copied "sudo usermod -a -G dialout \$USER" to clipboard. Run it in terminal, then re-login.'),
                  duration: Duration(seconds: 4),
                ),
              );
            },
            icon: const Icon(Icons.copy, size: 14),
            label:
                const Text('Copy Fix Command', style: TextStyle(fontSize: 11)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: const Size(60, 28),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionControlCard(
    dynamic bridge,
    HardwareConnectionState state,
  ) {
    final isConnected = state.isConnected;
    final colorScheme = Theme.of(context).colorScheme;

    return MonsterCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.settings_input_composite,
                  color: AppColors.primaryViolet),
              const SizedBox(width: 8),
              const Text(
                'Connection Station',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: (isConnected ? AppColors.success : colorScheme.outline)
                      .withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        (isConnected ? AppColors.success : colorScheme.outline)
                            .withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  state.displayName,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isConnected
                        ? AppColors.success
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 24),

          // Port selector
          const Text('Select Target Port / Adapter:',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: colorScheme.outlineVariant),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<DiscoveredBoard>(
                key: const Key('hardware_port_dropdown'),
                isExpanded: true,
                value: _availableBoards.contains(_selectedBoard)
                    ? _selectedBoard
                    : _availableBoards.first,
                items: _availableBoards.map((board) {
                  return DropdownMenuItem<DiscoveredBoard>(
                    value: board,
                    child: Text(
                      board.displayTitle,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: board.isVirtual
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: isConnected
                    ? null
                    : (newBoard) {
                        if (newBoard != null) {
                          setState(() {
                            _selectedBoard = newBoard;
                            _selectedBaud = newBoard.boardModel.defaultBaudRate;
                          });
                        }
                      },
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Baud Rate Selector
          Row(
            children: [
              const Text('Baud Rate: ',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(width: 8),
              Wrap(
                spacing: 8,
                children: [9600, 19200, 57600, 115200].map((baud) {
                  final isSelected = _selectedBaud == baud;
                  return ChoiceChip(
                    label: Text('$baud', style: const TextStyle(fontSize: 12)),
                    selected: isSelected,
                    onSelected: isConnected
                        ? null
                        : (val) {
                            if (val) setState(() => _selectedBaud = baud);
                          },
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: MonsterButton(
                  key: const Key('hardware_connect_toggle_button'),
                  label:
                      isConnected ? 'Disconnect Hardware' : 'Connect to Board',
                  variant: isConnected
                      ? MonsterButtonVariant.secondary
                      : MonsterButtonVariant.primary,
                  icon: isConnected ? Icons.link_off : Icons.link,
                  onPressed: () async {
                    if (isConnected) {
                      await bridge.disconnect();
                    } else {
                      await bridge.connect(
                        board: _selectedBoard,
                        baudRate: _selectedBaud,
                      );
                    }
                  },
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton.icon(
                key: const Key('hardware_scan_ports_button'),
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Scan Ports'),
                onPressed: isConnected ? null : _refreshDiscoveredBoards,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTelemetryScopeCard(
    dynamic bridge,
    HardwareConnectionState state,
    PinTelemetry telemetry,
  ) {
    final isConnected = state.isConnected;
    final colorScheme = Theme.of(context).colorScheme;

    return MonsterCard(
      child: Column(
        children: [
          Row(
            children: [
              // Built-in LED Visualizer
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colorScheme.outlineVariant),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.lightbulb,
                        size: 32,
                        color: telemetry.pin13Led
                            ? AppColors.energyAmber
                            : colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Pin 13 LED: ${telemetry.pin13Led ? "HIGH (ON)" : "LOW (OFF)"}',
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      ElevatedButton(
                        key: const Key('telemetry_led_toggle_button'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(88, 48),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                        ),
                        onPressed: isConnected
                            ? () {
                                final cmd =
                                    telemetry.pin13Led ? 'LED:OFF' : 'LED:ON';
                                bridge.sendCommand(cmd);
                              }
                            : null,
                        child:
                            Text(telemetry.pin13Led ? 'Turn OFF' : 'Turn ON'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Free SRAM & Health
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colorScheme.outlineVariant),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.memory,
                          size: 32, color: AppColors.primaryViolet),
                      const SizedBox(height: 6),
                      Text(
                        'Free SRAM: ${telemetry.freeSramBytes} B',
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Rail: 5.02V • Clock: 16MHz',
                        style: TextStyle(
                            fontSize: 11, color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // A0 Potentiometer Voltage Bar
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('A0 Analog Voltage Divider:',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                    Text(
                      '${telemetry.a0Voltage.toStringAsFixed(2)}V (ADC: ${telemetry.a0Raw} / 1023)',
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryViolet),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (telemetry.a0Raw / 1023.0).clamp(0.0, 1.0),
                    minHeight: 8,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.accentCyanDark),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Sonar Distance Meter
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.radar, size: 20, color: AppColors.energyAmber),
                    SizedBox(width: 8),
                    Text('HC-SR04 Sonar Echo Distance:',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
                Text(
                  '${telemetry.sonarDistanceCm.toStringAsFixed(1)} cm',
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.energyAmber),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSerialMonitorCard(
    dynamic bridge,
    HardwareConnectionState state,
    List<SerialLogEntry> logs,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return MonsterCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.terminal, color: AppColors.accentCyanDark),
              const SizedBox(width: 8),
              const Text('Serial Terminal',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const Spacer(),
              TextButton.icon(
                key: const Key('serial_clear_button'),
                icon: const Icon(Icons.clear_all, size: 16),
                label: const Text('Clear'),
                onPressed: () {
                  ref.read(hardwareSerialLogsProvider.notifier).clearLogs();
                },
              ),
              IconButton(
                icon: Icon(
                  _autoScroll
                      ? Icons.vertical_align_bottom
                      : Icons.pause_circle_outline,
                  size: 20,
                  color: _autoScroll
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
                tooltip: _autoScroll ? 'Autoscroll On' : 'Autoscroll Paused',
                onPressed: () => setState(() => _autoScroll = !_autoScroll),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Terminal Output Window
          Container(
            height: 220,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF181824),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black26),
            ),
            child: logs.isEmpty
                ? const Center(
                    child: Text(
                      'Terminal ready. Connect hardware or send command to see output.',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontFamily: 'monospace'),
                    ),
                  )
                : ListView.builder(
                    key: const Key('serial_log_list'),
                    controller: _scrollController,
                    itemCount: logs.length,
                    itemBuilder: (context, index) {
                      final log = logs[index];
                      Color textColor;
                      String prefix;

                      switch (log.direction) {
                        case SerialLogDirection.rx:
                          textColor = const Color(0xFF55EFC4); // green
                          prefix = '← ';
                          break;
                        case SerialLogDirection.tx:
                          textColor = const Color(0xFF00CEC9); // cyan
                          prefix = '→ ';
                          break;
                        case SerialLogDirection.system:
                          textColor = const Color(0xFFFDCB6E); // amber
                          prefix = 'ℹ ';
                          break;
                      }

                      final timeStr =
                          '${log.timestamp.hour.toString().padLeft(2, '0')}:${log.timestamp.minute.toString().padLeft(2, '0')}:${log.timestamp.second.toString().padLeft(2, '0')}';

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Text(
                          '[$timeStr] $prefix${log.text}',
                          style: TextStyle(
                            color: textColor,
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 10),

          // Quick Command Action Chips
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _buildCommandChip(bridge, 'PING'),
              _buildCommandChip(bridge, 'STATUS'),
              _buildCommandChip(bridge, 'LED:ON'),
              _buildCommandChip(bridge, 'LED:OFF'),
              _buildCommandChip(bridge, 'ANALOG:READ'),
              _buildCommandChip(bridge, 'HELP'),
            ],
          ),
          const SizedBox(height: 10),

          // Interactive Command Input Line
          Row(
            children: [
              Expanded(
                child: TextField(
                  key: const Key('serial_command_input'),
                  controller: _commandController,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
                  decoration: const InputDecoration(
                    labelText: 'Terminal Command',
                    hintText: 'Enter command (e.g. PING, STATUS)...',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  onSubmitted: (cmd) => _handleSendCommand(bridge),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                key: const Key('serial_send_button'),
                icon: const Icon(Icons.send, size: 16),
                label: const Text('Send'),
                onPressed: () => _handleSendCommand(bridge),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommandChip(dynamic bridge, String cmd) {
    return ActionChip(
      label: Text(cmd,
          style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
      onPressed: () => bridge.sendCommand(cmd),
      materialTapTargetSize: MaterialTapTargetSize.padded,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }

  void _handleSendCommand(dynamic bridge) {
    final text = _commandController.text.trim();
    if (text.isNotEmpty) {
      bridge.sendCommand(text);
      _commandController.clear();
    }
  }

  Widget _buildSupportedBoardsGuide() {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: SupportedBoards.all.map((board) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: ExpansionTile(
            title: Text(
              board.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            subtitle: Text(
              '${board.microcontroller} • ${board.operatingVoltage}',
              style:
                  TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12),
            ),
            leading: Icon(
              board.isVirtual ? Icons.developer_board : Icons.memory,
              color: AppColors.primaryViolet,
            ),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(board.description,
                        style: const TextStyle(fontSize: 13, height: 1.3)),
                    const SizedBox(height: 8),
                    Text(
                      'Pins: ${board.digitalPins} Digital (${board.pwmPins} PWM) • ${board.analogPins} Analog Inputs',
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Default Serial Baud: ${board.defaultBaudRate} baud',
                      style: const TextStyle(fontSize: 12),
                    ),
                    if (board.supportedVidsPids.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Known Hardware USB Identifiers: ${board.supportedVidsPids.join(", ")}',
                        style: TextStyle(
                            fontSize: 11, color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
