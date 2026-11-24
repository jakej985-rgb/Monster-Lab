import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../../domain/models/hardware_board_model.dart';

abstract class ISerialPortAdapter {
  String get portName;
  bool get isOpen;
  Stream<String> get lineStream;

  Future<bool> open({required int baudRate});
  Future<void> writeLine(String line);
  Future<void> close();
  void dispose();
}

class MockUsbSerialAdapter implements ISerialPortAdapter {
  @override
  final String portName;
  final HardwareBoardModel boardModel;
  final int vendorId;
  final int productId;

  bool _isOpen = false;
  int _baudRate = 9600;
  final _lineController = StreamController<String>.broadcast(sync: true);
  Future<void> Function(String command, MockUsbSerialAdapter adapter)?
      onCommandReceived;

  MockUsbSerialAdapter({
    this.portName = '/dev/ttyUSB0',
    this.boardModel = SupportedBoards.unoR3,
    this.vendorId = 0x1A86,
    this.productId = 0x7523,
    this.onCommandReceived,
  });

  @override
  bool get isOpen => _isOpen;

  int get baudRate => _baudRate;

  @override
  Stream<String> get lineStream => _lineController.stream;

  void emitDeviceLine(String line) {
    if (_isOpen && !_lineController.isClosed) {
      _lineController.add(line);
    }
  }

  void simulateDisconnect() {
    emitDeviceLine('SYSTEM:DEVICE_DISCONNECTED');
    _isOpen = false;
  }

  @override
  Future<bool> open({required int baudRate}) async {
    _baudRate = baudRate;
    _isOpen = true;
    return true;
  }

  @override
  Future<void> writeLine(String line) async {
    if (!_isOpen) {
      throw StateError('Cannot write to closed serial port $portName');
    }
    if (onCommandReceived != null) {
      await onCommandReceived!(line, this);
    } else {
      // Default companion firmware mock responses
      final upper = line.trim().toUpperCase();
      if (upper.startsWith('HELLO:MONSTER_LAB:')) {
        emitDeviceLine('ACK:HANDSHAKE:v1.0:${boardModel.id}:MOCK_USB_SIG');
      } else if (upper == 'PING') {
        emitDeviceLine('PONG:MONSTER_UNO_V1');
      } else if (upper == 'STATUS') {
        emitDeviceLine('STATUS:OK | USB_PHY:CONNECTED | BAUD:$_baudRate');
      } else if (upper == 'LED:ON' || upper == 'LED:1') {
        emitDeviceLine('ACK:LED:1');
      } else if (upper == 'LED:OFF' || upper == 'LED:0') {
        emitDeviceLine('ACK:LED:0');
      } else if (upper == 'ANALOG:READ') {
        emitDeviceLine('A0:512 (2.50V)');
      } else if (upper == 'SONAR:READ') {
        emitDeviceLine('SONAR:42.5 cm');
      } else if (upper == 'SAFE_STATE' || upper == 'EMERGENCY_STOP') {
        emitDeviceLine('ACK:SAFE_STATE:OK');
      } else {
        emitDeviceLine('ERR:UNKNOWN_COMMAND:$line');
      }
    }
  }

  @override
  Future<void> close() async {
    _isOpen = false;
  }

  @override
  void dispose() {
    _isOpen = false;
    _lineController.close();
  }
}

class WebSerialUnsupportedException implements Exception {
  final String message;
  const WebSerialUnsupportedException([
    this.message =
        'Web Serial API is not supported or permitted in this browser environment.',
  ]);

  @override
  String toString() => 'WebSerialUnsupportedException: $message';
}

class WebSerialAdapter implements ISerialPortAdapter {
  @override
  final String portName;
  bool _isOpen = false;
  final _lineController = StreamController<String>.broadcast(sync: true);
  final bool Function()? isSupportedChecker;

  WebSerialAdapter({
    this.portName = 'WebSerial://Port_0',
    this.isSupportedChecker,
  });

  bool get isSupported {
    if (isSupportedChecker != null) return isSupportedChecker!();
    return kIsWeb;
  }

  @override
  bool get isOpen => _isOpen;

  @override
  Stream<String> get lineStream => _lineController.stream;

  @override
  Future<bool> open({required int baudRate}) async {
    if (!isSupported) {
      throw const WebSerialUnsupportedException();
    }
    _isOpen = true;
    _lineController.add('SYSTEM:WEB_SERIAL_READY');
    return true;
  }

  @override
  Future<void> writeLine(String line) async {
    if (!isSupported) {
      throw const WebSerialUnsupportedException();
    }
    if (!_isOpen) {
      throw StateError('Web Serial port is not open');
    }
    // Echo command acknowledgement for Web Serial link
    final upper = line.trim().toUpperCase();
    if (upper.startsWith('HELLO:')) {
      _lineController.add('ACK:HANDSHAKE:v1.0:web_serial_board:WEB_SIG');
    } else {
      _lineController.add('ACK:WEB_SERIAL:$upper');
    }
  }

  @override
  Future<void> close() async {
    _isOpen = false;
    _lineController.add('SYSTEM:WEB_SERIAL_CLOSED');
  }

  @override
  void dispose() {
    _isOpen = false;
    _lineController.close();
  }
}
