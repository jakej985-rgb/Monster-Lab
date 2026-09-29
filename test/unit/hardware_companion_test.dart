import 'package:flutter_test/flutter_test.dart';
import 'package:monster_lab/core/services/hardware/virtual_simulation_bridge.dart';
import 'package:monster_lab/domain/models/hardware_board_model.dart';
import 'package:monster_lab/domain/models/hardware_connection_model.dart';

void main() {
  group('Phase 13: Hardware Companion Unit Tests', () {
    test(
        'SupportedBoards registry correctly indexes models and matches USB VID/PID',
        () {
      expect(SupportedBoards.all.length, 6);

      final uno = SupportedBoards.findById('uno_r3');
      expect(uno.name, 'Arduino Uno R3');
      expect(uno.digitalPins, 14);
      expect(uno.analogPins, 6);
      expect(uno.operatingVoltage, '5.0V');

      final esp32 = SupportedBoards.findById('esp32');
      expect(esp32.name, 'ESP32 DevKit v1');
      expect(esp32.operatingVoltage, '3.3V');

      final virtualUno = SupportedBoards.findById('virtual_uno');
      expect(virtualUno.isVirtual, isTrue);

      // Match USB VID/PID
      final officialUnoMatch = SupportedBoards.matchUsb(0x2341, 0x0043);
      expect(officialUnoMatch?.id, 'uno_r3');

      final ch340Match = SupportedBoards.matchUsb(0x1A86, 0x7523);
      expect(ch340Match?.id, 'uno_r3');

      final unknownMatch = SupportedBoards.matchUsb(0xFFFF, 0xFFFF);
      expect(unknownMatch, isNull);
    });

    test('VirtualSimulationBridge connection lifecycle and commands', () async {
      final bridge = VirtualSimulationBridge();
      addTearDown(bridge.dispose);

      expect(bridge.currentState, HardwareConnectionState.disconnected);

      // Scan devices
      final devices = await bridge.scanDevices();
      expect(devices.isNotEmpty, isTrue);
      expect(devices.any((d) => d.isVirtual), isTrue);

      // Collect state changes and serial messages
      final states = <HardwareConnectionState>[];
      final serialLogs = <SerialLogEntry>[];
      final stateSub = bridge.stateStream.listen(states.add);
      final serialSub = bridge.serialStream.listen(serialLogs.add);
      addTearDown(stateSub.cancel);
      addTearDown(serialSub.cancel);

      // Connect
      final connected = await bridge.connect(
        board: DiscoveredBoard.virtualSimulator(),
        baudRate: 9600,
      );
      expect(connected, isTrue);
      expect(bridge.currentState, HardwareConnectionState.connectedVirtual);

      // Check welcome messages in serial stream
      expect(serialLogs.any((l) => l.text.contains('Monster Lab Companion')),
          isTrue);

      // Test PING
      await bridge.sendCommand('PING');
      expect(serialLogs.any((l) => l.text == 'PONG:MONSTER_UNO_V1'), isTrue);

      // Test LED:ON
      expect(bridge.currentTelemetry.pin13Led, isFalse);
      await bridge.sendCommand('LED:ON');
      expect(bridge.currentTelemetry.pin13Led, isTrue);
      expect(serialLogs.any((l) => l.text.contains('ACK:LED:1')), isTrue);

      // Test LED:OFF
      await bridge.sendCommand('LED:OFF');
      expect(bridge.currentTelemetry.pin13Led, isFalse);
      expect(serialLogs.any((l) => l.text.contains('ACK:LED:0')), isTrue);

      // Test STATUS
      await bridge.sendCommand('STATUS');
      expect(serialLogs.any((l) => l.text.contains('STATUS:OK')), isTrue);

      // Test ANALOG:READ
      await bridge.sendCommand('ANALOG:READ');
      expect(serialLogs.any((l) => l.text.startsWith('A0:')), isTrue);

      // Test HELP
      await bridge.sendCommand('HELP');
      expect(
          serialLogs.any(
              (l) => l.text.contains('=== Monster Lab Serial Commands ===')),
          isTrue);

      // Test Unknown Command
      await bridge.sendCommand('INVALID_ROBOT_COMMAND');
      expect(serialLogs.any((l) => l.text.contains('ERR: Unknown command')),
          isTrue);

      // Disconnect
      await bridge.disconnect();
      expect(bridge.currentState, HardwareConnectionState.disconnected);
    });
  });
}
