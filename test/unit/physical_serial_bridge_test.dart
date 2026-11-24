import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:monster_lab/core/services/hardware/composite_hardware_bridge.dart';
import 'package:monster_lab/core/services/hardware/physical_serial_bridge.dart';
import 'package:monster_lab/core/services/hardware/serial_transport.dart';
import 'package:monster_lab/core/services/hardware/virtual_simulation_bridge.dart';
import 'package:monster_lab/domain/models/hardware_board_model.dart';
import 'package:monster_lab/domain/models/hardware_connection_model.dart';

class FakeSerialTransport implements SerialTransport {
  FakeSerialTransport({this.supported = true});

  bool supported;
  final List<SerialPortInfo> ports = [];
  SerialPortInfo? requestedPort;
  FakeSerialConnection? lastConnection;
  int permissionRequests = 0;

  @override
  bool get isSupported => supported;

  @override
  String get unsupportedReason => 'Fake transport is unsupported.';

  @override
  Future<List<SerialPortInfo>> listPorts() async => List.of(ports);

  @override
  Future<SerialPortInfo?> requestPort() async {
    permissionRequests++;
    final port = requestedPort;
    if (port != null && !ports.any((candidate) => candidate.id == port.id)) {
      ports.add(port);
    }
    return port;
  }

  @override
  Future<SerialPortConnection> open(
    SerialPortInfo targetPort, {
    required int baudRate,
  }) async {
    final connection = FakeSerialConnection(targetPort, baudRate);
    lastConnection = connection;
    return connection;
  }
}

class FakeSerialConnection implements SerialPortConnection {
  FakeSerialConnection(this.port, this.baudRate);

  final SerialPortInfo port;
  final int baudRate;
  final List<String> written = [];
  bool closed = false;

  final _input = StreamController<List<int>>.broadcast(sync: true);
  final _disconnected = StreamController<void>.broadcast(sync: true);

  @override
  Stream<List<int>> get input => _input.stream;

  @override
  Stream<void> get disconnected => _disconnected.stream;

  Completer<void>? writeCompleter;

  @override
  Future<void> writeLine(String line) async {
    written.add(line);
    final completer = writeCompleter;
    if (completer != null && !completer.isCompleted) {
      await completer.future;
    }
  }

  @override
  Future<void> close() async {
    closed = true;
    if (!_input.isClosed) await _input.close();
    if (!_disconnected.isClosed) await _disconnected.close();
  }

  void emitLine(String line) {
    if (!_input.isClosed) _input.add(utf8.encode('$line\n'));
  }

  void emitDisconnect() {
    if (!_disconnected.isClosed) _disconnected.add(null);
  }
}

const unoPort = SerialPortInfo(
  id: 'uno',
  label: 'Arduino Uno R3 (VID 0x2341 / PID 0x0043)',
  vendorId: 0x2341,
  productId: 0x0043,
);

const ch340Port = SerialPortInfo(
  id: 'ch340',
  label: 'Generic CH340 Bridge (VID 0x1A86 / PID 0x7523)',
  vendorId: 0x1A86,
  productId: 0x7523,
);

void main() {
  group('PhysicalSerialBridge', () {
    (FakeSerialTransport, PhysicalSerialBridge) createBridge({
      SerialPortInfo? initialPort,
    }) {
      final transport = FakeSerialTransport();
      if (initialPort != null) transport.ports.add(initialPort);
      final bridge = PhysicalSerialBridge(transport: transport);
      addTearDown(bridge.dispose);
      return (transport, bridge);
    }

    test('maps known USB identifiers and falls back to a safe profile',
        () async {
      final transport = FakeSerialTransport()
        ..ports.addAll(const [
          unoPort,
          ch340Port,
          SerialPortInfo(
            id: 'unknown',
            label: 'USB Serial #2 (VID 0xFFFF / PID 0xFFFF)',
            vendorId: 0xFFFF,
            productId: 0xFFFF,
          ),
        ]);
      final bridge = PhysicalSerialBridge(transport: transport);
      addTearDown(bridge.dispose);

      final boards = await bridge.scanDevices();

      expect(boards, hasLength(3));
      expect(boards[0].boardModel.id, 'uno_r3');
      expect(boards[1].boardModel.id, 'usb_serial');
      expect(boards[2].boardModel.id, 'usb_serial');
      expect(boards[1].boardModel.operatingVoltage, contains('3.3V'));
      expect(boards.every((board) => !board.isVirtual), isTrue);
    });

    test('reports unsupported platforms without pretending to open a port',
        () async {
      final bridge = PhysicalSerialBridge(
        transport: FakeSerialTransport(supported: false),
      );
      addTearDown(bridge.dispose);

      expect(bridge.supportsPhysicalPorts, isFalse);
      expect(bridge.transportNotice, isNotNull);
      expect(await bridge.scanDevices(), isEmpty);
      expect(await bridge.requestPhysicalPort(), isNull);
      final unsupportedConnect = await bridge.connect(
        board: const DiscoveredBoard(
          portName: 'USB Serial #1',
          boardModel: SupportedBoards.unoR3,
        ),
      );
      expect(unsupportedConnect, isFalse);
    });

    test('opens the port, sends the optional handshake, and parses output',
        () async {
      final (transport, bridge) = createBridge(initialPort: unoPort);

      final logs = <SerialLogEntry>[];
      final telemetry = <PinTelemetry>[];
      final logSub = bridge.serialStream.listen(logs.add);
      final telemetrySub = bridge.telemetryStream.listen(telemetry.add);
      addTearDown(logSub.cancel);
      addTearDown(telemetrySub.cancel);

      final boards = await bridge.scanDevices();
      final connected = await bridge.connect(
        board: boards.single,
        baudRate: 115200,
      );
      await Future<void>.delayed(Duration.zero);

      expect(connected, isTrue);
      expect(bridge.currentState, HardwareConnectionState.connectedPhysical);
      expect(bridge.currentBaudRate, 115200);

      final connection = transport.lastConnection!;
      expect(connection.baudRate, 115200);
      expect(connection.written, contains('HELLO:MONSTER_LAB:v1.0'));

      connection.emitLine('A0:700 (3.42V)');
      connection.emitLine('Distance: 33.5 cm');
      connection.emitLine('Pin 13: HIGH');
      connection.emitLine('Free SRAM: 1200 B');
      connection.emitLine('HELLO FROM SKETCH');
      await Future<void>.delayed(Duration.zero);

      expect(bridge.currentTelemetry.a0Raw, 700);
      expect(bridge.currentTelemetry.a0Voltage, closeTo(3.42, 0.001));
      expect(bridge.currentTelemetry.sonarDistanceCm, closeTo(33.5, 0.001));
      expect(bridge.currentTelemetry.pin13Led, isTrue);
      expect(bridge.currentTelemetry.freeSramBytes, 1200);
      expect(
        logs.any((entry) =>
            entry.direction == SerialLogDirection.rx &&
            entry.text == 'HELLO FROM SKETCH'),
        isTrue,
      );
      expect(telemetry, isNotEmpty);

      await bridge.sendCommand('PING');
      expect(connection.written, contains('PING'));
      expect(
        logs.any((entry) =>
            entry.direction == SerialLogDirection.tx && entry.text == 'PING'),
        isTrue,
      );

      await bridge.disconnect();
      expect(connection.written, contains('SAFE_STATE'));
      expect(connection.closed, isTrue);
      expect(bridge.currentState, HardwareConnectionState.disconnected);
    });

    test('surfaces a device removal as an error state', () async {
      final (transport, bridge) = createBridge(initialPort: unoPort);

      final logs = <SerialLogEntry>[];
      final logSub = bridge.serialStream.listen(logs.add);
      addTearDown(logSub.cancel);

      final boards = await bridge.scanDevices();
      await bridge.connect(board: boards.single);
      transport.lastConnection!.emitDisconnect();
      await Future<void>.delayed(Duration.zero);

      expect(bridge.currentState, HardwareConnectionState.error);
      expect(bridge.currentBoard, isNull);
      final hasDisconnectLog =
          logs.any((entry) => entry.text.contains('device disconnected'));
      expect(hasDisconnectLog, isTrue, reason: 'must log device disconnected');
    });

    test('requests a port through the transport and builds a board entry',
        () async {
      final transport = FakeSerialTransport()..requestedPort = unoPort;
      final bridge = PhysicalSerialBridge(transport: transport);
      addTearDown(bridge.dispose);

      final board = await bridge.requestPhysicalPort();

      expect(transport.permissionRequests, 1);
      expect(board, isNotNull);
      expect(board!.portName, unoPort.id);
      expect(board.displayName, unoPort.label);
      expect(board.boardModel.id, 'uno_r3');
    });

    test(
        'unconfirmed sketch stop keeps stopConfirmed false without forcing LED off',
        () async {
      final (transport, bridge) = createBridge(initialPort: unoPort);

      final boards = await bridge.scanDevices();
      await bridge.connect(board: boards.single);
      final connection = transport.lastConnection!;

      // Sketch reports LED HIGH once and keeps it HIGH
      connection.emitLine('LED:HIGH');
      await Future<void>.delayed(Duration.zero);
      expect(bridge.currentTelemetry.pin13Led, isTrue);
      expect(bridge.currentTelemetry.stopConfirmed, isTrue);

      // Send emergency stop to unconfirmed sketch
      await bridge.sendCommand('EMERGENCY_STOP');
      expect(connection.written, contains('EMERGENCY_STOP'));
      // Since no handshake or ACK received, stop status remains unconfirmed
      expect(bridge.currentTelemetry.stopConfirmed, isFalse);
      expect(bridge.currentTelemetry.pin13Led, isTrue);

      // Now sketch acknowledges the safe state
      connection.emitLine('ACK:SAFE_STATE');
      await Future<void>.delayed(Duration.zero);
      expect(bridge.currentTelemetry.stopConfirmed, isTrue);
      expect(bridge.currentTelemetry.pin13Led, isFalse);
    });

    test(
        'early stop acknowledgment while write future is unresolved preserves confirmed state',
        () async {
      final (transport, bridge) = createBridge(initialPort: unoPort);

      final boards = await bridge.scanDevices();
      await bridge.connect(board: boards.single);
      final connection = transport.lastConnection!;

      // Board is running with LED HIGH
      connection.emitLine('LED:HIGH');
      await Future<void>.delayed(Duration.zero);
      expect(bridge.currentTelemetry.pin13Led, isTrue);
      expect(bridge.currentTelemetry.stopConfirmed, isTrue);

      // Pause the write future to simulate asynchronous in-flight transmission
      final writeGate = Completer<void>();
      connection.writeCompleter = writeGate;

      final stopFuture = bridge.sendCommand('EMERGENCY_STOP');

      // Stop status is immediately published as pending before write completes
      expect(bridge.currentTelemetry.stopConfirmed, isFalse);

      // Device acknowledges stop while write future is still unresolved
      connection.emitLine('ACK:SAFE_STATE');
      await Future<void>.delayed(Duration.zero);
      expect(bridge.currentTelemetry.stopConfirmed, isTrue);
      expect(bridge.currentTelemetry.pin13Led, isFalse);

      // Now resolve the write future
      writeGate.complete();
      await stopFuture;

      // Ensure write completion does not overwrite the confirmed stop status
      expect(bridge.currentTelemetry.stopConfirmed, isTrue);
      expect(bridge.currentTelemetry.pin13Led, isFalse);
    });

    test(
        'reselection of known port reuses stable ID and selection of second adapter assigns new ID',
        () async {
      final transport = FakeSerialTransport()..ports.add(unoPort);
      final bridge = PhysicalSerialBridge(transport: transport);
      addTearDown(bridge.dispose);

      final initial = await bridge.scanDevices();
      expect(initial.first.portName, unoPort.id);

      // Reselect the same port
      transport.requestedPort = unoPort;
      final reselected = await bridge.requestPhysicalPort();
      expect(reselected!.portName, unoPort.id);

      // Select second adapter
      transport.requestedPort = ch340Port;
      final second = await bridge.requestPhysicalPort();
      expect(second!.portName, ch340Port.id);
      expect(second.portName, isNot(equals(reselected.portName)));
    });
  });

  group('CompositeHardwareBridge', () {
    (FakeSerialTransport, CompositeHardwareBridge) createCompositeHarness() {
      final transport = FakeSerialTransport()..ports.add(unoPort);
      final composite = CompositeHardwareBridge(
        virtual: VirtualSimulationBridge(enableTelemetryTimer: false),
        physical: PhysicalSerialBridge(transport: transport),
      );
      addTearDown(composite.dispose);
      return (transport, composite);
    }

    test('keeps the simulator and routes real devices to Web Serial', () async {
      final (transport, composite) = createCompositeHarness();

      expect(composite.supportsPhysicalPorts, isTrue);

      final boards = await composite.scanDevices();
      expect(boards.any((board) => board.isVirtual), isTrue);
      expect(boards.any((board) => board.boardModel.id == 'uno_r3'), isTrue);

      final physicalBoard = boards.firstWhere((board) => !board.isVirtual);
      expect(await composite.connect(board: physicalBoard), isTrue);
      expect(composite.currentState, HardwareConnectionState.connectedPhysical);
      expect(transport.lastConnection, isNotNull);

      final virtualBoard = boards.firstWhere((board) => board.isVirtual);
      expect(await composite.connect(board: virtualBoard), isTrue);
      expect(composite.currentState, HardwareConnectionState.connectedVirtual);
      expect(transport.lastConnection!.closed, isTrue);
    });

    test('clears previous simulator telemetry upon switching to physical board',
        () async {
      final (transport, composite) = createCompositeHarness();

      final boards = await composite.scanDevices();
      final virtualBoard = boards.firstWhere((board) => board.isVirtual);
      final physicalBoard = boards.firstWhere((board) => !board.isVirtual);

      // Connect to virtual and simulate LED ON
      await composite.connect(board: virtualBoard);
      await composite.sendCommand('LED:ON');
      expect(composite.currentTelemetry.pin13Led, isTrue);

      // Track telemetry stream emissions
      final emitted = <PinTelemetry>[];
      final sub = composite.telemetryStream.listen(emitted.add);
      addTearDown(sub.cancel);

      // Connect to physical board
      await composite.connect(board: physicalBoard);
      // Stale simulator LED ON must NOT persist
      expect(composite.currentTelemetry.pin13Led, isFalse);
      expect(emitted, isNotEmpty);
      expect(emitted.last.pin13Led, isFalse);
    });
  });
}
