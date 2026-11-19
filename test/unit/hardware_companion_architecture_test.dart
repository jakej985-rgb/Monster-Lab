import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:monster_lab/core/services/hardware/adapters/serial_port_adapter.dart';
import 'package:monster_lab/core/services/hardware/hardware_protocol.dart';
import 'package:monster_lab/core/services/hardware/hardware_safety_interlock.dart';
import 'package:monster_lab/core/services/hardware/virtual_simulation_bridge.dart';
import 'package:monster_lab/domain/models/hardware_board_model.dart';
import 'package:monster_lab/domain/models/hardware_connection_model.dart';
import 'package:monster_lab/domain/models/hardware_device_capability_registry.dart';

void main() {
  group('Hardware Companion Architecture Suite (Issues #22-#28)', () {
    // --- Issue #24: Hardware Device Capability Registry ---
    group('Issue #24: Hardware Device Capability Registry', () {
      test('all registered boards have valid and complete capability profiles',
          () {
        final issues = HardwareDeviceCapabilityRegistry.validateRegistry();
        expect(issues, isEmpty,
            reason: 'Capability registry had validation issues: $issues');

        final all = HardwareDeviceCapabilityRegistry.getAll();
        expect(all.length, greaterThanOrEqualTo(6));
      });

      test('resolves capabilities correctly for Uno R3 and ESP32', () {
        final unoCaps = HardwareDeviceCapabilityRegistry.findForBoard(
            SupportedBoards.unoR3);
        expect(unoCaps.operatingVoltage, equals(5.0));
        expect(unoCaps.maxDigitalPins, equals(14));
        expect(unoCaps.supportsCommand('PING'), isTrue);
        expect(unoCaps.supportsCommand('LED:ON'), isTrue);
        expect(unoCaps.isBaudRateSupported(9600), isTrue);
        expect(unoCaps.isPinValid(13), isTrue);
        expect(unoCaps.isPinValid(14), isFalse);

        final espCaps = HardwareDeviceCapabilityRegistry.findForBoard(
            SupportedBoards.esp32);
        expect(espCaps.operatingVoltage, equals(3.3));
        expect(espCaps.isVoltageSafe(3.3), isTrue);
        expect(espCaps.isVoltageSafe(5.0), isFalse);
        expect(espCaps.features, contains(DeviceFeature.wifi));
        expect(espCaps.features, contains(DeviceFeature.ble));
      });
    });

    // --- Issue #25: Hardware Connection State Machine ---
    group('Issue #25: Hardware Connection State Machine', () {
      test('models all required connection states and reports display names',
          () {
        final expectedStates = [
          HardwareConnectionState.disconnected,
          HardwareConnectionState.connecting,
          HardwareConnectionState.connected,
          HardwareConnectionState.simulation,
          HardwareConnectionState.unavailable,
          HardwareConnectionState.unsupported,
          HardwareConnectionState.safetyLocked,
          HardwareConnectionState.error,
        ];

        for (final state in expectedStates) {
          expect(state.displayName, isNotEmpty);
        }
      });

      test('validates legal transitions through connection lifecycle', () {
        final sm = HardwareConnectionStateMachine();
        expect(sm.state, equals(HardwareConnectionState.disconnected));

        // disconnected -> connecting
        expect(sm.canTransitionTo(HardwareConnectionState.connecting), isTrue);
        sm.transitionTo(HardwareConnectionState.connecting);
        expect(sm.state, equals(HardwareConnectionState.connecting));

        // connecting -> connected
        expect(sm.canTransitionTo(HardwareConnectionState.connected), isTrue);
        sm.transitionTo(HardwareConnectionState.connected);
        expect(sm.state, equals(HardwareConnectionState.connected));

        // connected -> safetyLocked
        expect(
            sm.canTransitionTo(HardwareConnectionState.safetyLocked), isTrue);
        sm.transitionTo(HardwareConnectionState.safetyLocked);
        expect(sm.state, equals(HardwareConnectionState.safetyLocked));

        // safetyLocked -> disconnected
        expect(
            sm.canTransitionTo(HardwareConnectionState.disconnected), isTrue);
        sm.transitionTo(HardwareConnectionState.disconnected);
        expect(sm.state, equals(HardwareConnectionState.disconnected));
      });

      test(
          'rejects illegal transitions and throws IllegalStateTransitionException',
          () {
        final sm = HardwareConnectionStateMachine(
            HardwareConnectionState.disconnected);

        // Cannot jump directly from disconnected to safetyLocked or connected
        expect(
            sm.canTransitionTo(HardwareConnectionState.safetyLocked), isFalse);
        expect(
          () => sm.transitionTo(HardwareConnectionState.safetyLocked),
          throwsA(isA<IllegalStateTransitionException>()),
        );

        // Cannot jump directly from safetyLocked to connected without clearing lock
        final lockedSm = HardwareConnectionStateMachine(
            HardwareConnectionState.safetyLocked);
        expect(lockedSm.canTransitionTo(HardwareConnectionState.connected),
            isFalse);
        expect(
          () => lockedSm.transitionTo(HardwareConnectionState.connected),
          throwsA(isA<IllegalStateTransitionException>()),
        );
      });
    });

    // --- Issue #26: Protocol Versioning and Handshake ---
    group('Issue #26: Protocol Versioning & Handshake Negotiation', () {
      test('parses and compares protocol versions correctly', () {
        final v1 = ProtocolVersion.parse('v1.0');
        final v1_1 = ProtocolVersion.parse('1.1');
        final v2 = ProtocolVersion.parse('2.0');

        expect(v1.major, equals(1));
        expect(v1.minor, equals(0));
        expect(v1_1 > v1, isTrue);
        expect(v1.isCompatibleWith(v1_1), isTrue);
        expect(v1.isCompatibleWith(v2), isFalse);
      });

      test('negotiates compatible handshake successfully', () {
        const negotiator = HardwareProtocolNegotiator();
        final result =
            negotiator.parseDeviceResponse('ACK:HANDSHAKE:v1.0:uno_r3:SIG123');

        expect(result.isSuccess, isTrue);
        expect(result.negotiatedVersion, equals(ProtocolVersion.v1_0));
        expect(result.boardId, equals('uno_r3'));
        expect(result.capabilitiesSignature, equals('SIG123'));
      });

      test(
          'rejects incompatible protocol version with IncompatibleProtocolException',
          () {
        const negotiator = HardwareProtocolNegotiator();

        expect(
          () => negotiator.parseDeviceResponse('ACK:HANDSHAKE:v9.0:uno_r3:SIG'),
          throwsA(isA<IncompatibleProtocolException>()),
        );

        expect(
          () => negotiator.parseDeviceResponse('ERR:VERSION_MISMATCH:v3.0'),
          throwsA(isA<IncompatibleProtocolException>()),
        );
      });

      test('rejects malformed response frames with MalformedHandshakeException',
          () {
        const negotiator = HardwareProtocolNegotiator();

        expect(
          () => negotiator.parseDeviceResponse('MALFORMED_GARBAGE_FRAME'),
          throwsA(isA<MalformedHandshakeException>()),
        );

        expect(
          () => negotiator.parseDeviceResponse('ACK:HANDSHAKE:INCOMPLETE'),
          throwsA(isA<MalformedHandshakeException>()),
        );
      });

      test(
          'retries on timeout and throws HandshakeTimeoutException after maxRetries',
          () async {
        const negotiator = HardwareProtocolNegotiator(
          timeout: Duration(milliseconds: 50),
          maxRetries: 2,
        );

        const emptyStream = Stream<String>.empty();
        int commandCount = 0;

        await expectLater(
          negotiator.performHandshake(
            sendCommand: (cmd) async {
              commandCount++;
            },
            responseStream: emptyStream,
          ),
          throwsA(isA<HandshakeTimeoutException>()
              .having((e) => e.attempts, 'attempts', 2)),
        );

        expect(commandCount, equals(2));
      });
    });

    // --- Issue #27: Hardware Safety Interlocks and Safe State ---
    group('Issue #27: Hardware Safety Interlocks & Safe State Enforcement', () {
      test('protects dedicated hardware UART pins 0 and 1 from direct mutation',
          () {
        final interlock = HardwareSafetyInterlock(board: SupportedBoards.unoR3);

        expect(
          () => interlock.validateCommand('PIN:0:HIGH'),
          throwsA(isA<SafetyViolationException>().having(
            (e) => e.reason,
            'reason',
            contains('RX/TX'),
          )),
        );
        expect(interlock.isLocked, isTrue);

        // When locked, subsequent commands are blocked
        expect(
          () => interlock.validateCommand('LED:ON'),
          throwsA(isA<SafetyViolationException>().having(
            (e) => e.reason,
            'reason',
            contains('safety-locked'),
          )),
        );
      });

      test('prevents 5V logic signals on 3.3V boards', () {
        final espInterlock =
            HardwareSafetyInterlock(board: SupportedBoards.esp32);

        expect(
          () => espInterlock.validateCommand('SET:VOLTAGE:5.0V'),
          throwsA(isA<SafetyViolationException>().having(
            (e) => e.reason,
            'reason',
            contains('3.3V'),
          )),
        );
        expect(espInterlock.isLocked, isTrue);
      });

      test(
          'rate-limits rapid toggle oscillations to prevent thermal/inductive stress',
          () {
        final interlock = HardwareSafetyInterlock(
          board: SupportedBoards.unoR3,
          maxTogglesPerWindow: 3,
          toggleWindow: const Duration(seconds: 1),
        );

        interlock.validateCommand('LED:ON');
        interlock.validateCommand('LED:OFF');
        interlock.validateCommand('LED:ON');

        // 4th toggle within window trips thermal lock
        expect(
          () => interlock.validateCommand('LED:OFF'),
          throwsA(isA<SafetyViolationException>().having(
            (e) => e.reason,
            'reason',
            contains('Rapid switching rate exceeded'),
          )),
        );
        expect(interlock.isLocked, isTrue);
      });

      test('enterSafeState resets all pins and clears thermal toggles', () {
        final interlock = HardwareSafetyInterlock(board: SupportedBoards.unoR3);
        final safe = interlock.enterSafeState();

        expect(safe.digitalPins.values.every((v) => v == false), isTrue);
        expect(safe.pwmDuty.values.every((v) => v == 0), isTrue);
        expect(safe.buzzerActive, isFalse);
        expect(safe.relayActive, isFalse);
      });
    });

    // --- Issue #22 & #23: Physical & Web Serial Adapters ---
    group('Issue #22 & #23: Serial Hardware Adapters', () {
      test(
          'MockUsbSerialAdapter opens, exchanges data, and simulates disconnect',
          () async {
        final adapter = MockUsbSerialAdapter(
          portName: '/dev/ttyUSB0',
          boardModel: SupportedBoards.unoR3,
        );
        addTearDown(adapter.dispose);

        expect(adapter.isOpen, isFalse);
        await adapter.open(baudRate: 115200);
        expect(adapter.isOpen, isTrue);
        expect(adapter.baudRate, equals(115200));

        final received = <String>[];
        final sub = adapter.lineStream.listen(received.add);
        addTearDown(sub.cancel);

        await adapter.writeLine('HELLO:MONSTER_LAB:v1.0');
        await adapter.writeLine('PING');

        expect(received.any((l) => l.startsWith('ACK:HANDSHAKE:')), isTrue);
        expect(received, contains('PONG:MONSTER_UNO_V1'));

        adapter.simulateDisconnect();
        expect(adapter.isOpen, isFalse);
        expect(received, contains('SYSTEM:DEVICE_DISCONNECTED'));

        expect(
          () => adapter.writeLine('PING'),
          throwsA(isA<StateError>()),
        );
      });

      test(
          'WebSerialAdapter gates unsupported environments with WebSerialUnsupportedException',
          () async {
        final webAdapter = WebSerialAdapter(
          isSupportedChecker: () =>
              false, // Simulate non-web or unsupported browser
        );
        addTearDown(webAdapter.dispose);

        expect(webAdapter.isSupported, isFalse);
        expect(
          () => webAdapter.open(baudRate: 9600),
          throwsA(isA<WebSerialUnsupportedException>()),
        );
        expect(
          () => webAdapter.writeLine('PING'),
          throwsA(isA<WebSerialUnsupportedException>()),
        );
      });

      test('WebSerialAdapter opens and writes when supported', () async {
        final webAdapter = WebSerialAdapter(
          isSupportedChecker: () =>
              true, // Simulate supported Web Serial browser
        );
        addTearDown(webAdapter.dispose);

        expect(webAdapter.isSupported, isTrue);
        final lines = <String>[];
        final sub = webAdapter.lineStream.listen(lines.add);
        addTearDown(sub.cancel);

        await webAdapter.open(baudRate: 9600);
        expect(webAdapter.isOpen, isTrue);
        expect(lines, contains('SYSTEM:WEB_SERIAL_READY'));

        await webAdapter.writeLine('PING');
        expect(lines, contains('ACK:WEB_SERIAL:PING'));

        await webAdapter.close();
        expect(webAdapter.isOpen, isFalse);
        expect(lines, contains('SYSTEM:WEB_SERIAL_CLOSED'));
      });
    });

    // --- Issue #28: Hardware Simulation & Integration Coverage ---
    group('Issue #28: Hardware Simulation & End-to-End Integration', () {
      test(
          'VirtualSimulationBridge handles complete lifecycle with safety lock and safe state',
          () async {
        final bridge = VirtualSimulationBridge(enableTelemetryTimer: false);
        addTearDown(bridge.dispose);

        expect(
            bridge.currentState, equals(HardwareConnectionState.disconnected));

        // 1. Scan devices
        final devices = await bridge.scanDevices();
        expect(devices.length, greaterThanOrEqualTo(2));

        // 2. Connect
        final ok =
            await bridge.connect(board: DiscoveredBoard.virtualSimulator());
        expect(ok, isTrue);
        expect(bridge.currentState,
            equals(HardwareConnectionState.connectedVirtual));

        // 3. Protocol handshake
        final logs = <String>[];
        final sub = bridge.serialStream.listen((entry) => logs.add(entry.text));
        addTearDown(sub.cancel);

        await bridge.sendCommand('HELLO:MONSTER_LAB:v1.0');
        expect(logs.any((l) => l.startsWith('ACK:HANDSHAKE:v1.0:virtual_uno')),
            isTrue);

        // 4. Drive LED
        await bridge.sendCommand('LED:ON');
        expect(bridge.currentTelemetry.pin13Led, isTrue);

        // 5. Emergency Stop engages safe state and safety lock
        await bridge.sendCommand('EMERGENCY_STOP');
        expect(
            bridge.currentState, equals(HardwareConnectionState.safetyLocked));
        expect(bridge.currentTelemetry.pin13Led, isFalse);
        expect(logs, contains('ACK:EMERGENCY_STOP:SAFE_STATE_ENGAGED'));

        // 6. Commands rejected while locked
        await bridge.sendCommand('LED:ON');
        expect(bridge.currentTelemetry.pin13Led, isFalse); // Did not turn on!

        // 7. Reset safety lock
        await bridge.sendCommand('RESET_SAFETY_LOCK');
        expect(bridge.currentState,
            equals(HardwareConnectionState.connectedVirtual));

        // 8. Disconnect safely
        await bridge.disconnect();
        expect(
            bridge.currentState, equals(HardwareConnectionState.disconnected));
      });
    });
  });
}
