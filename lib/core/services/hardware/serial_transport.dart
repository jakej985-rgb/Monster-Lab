import 'dart:async';

/// A user-authorized serial port that can be opened by a [SerialTransport].
class SerialPortInfo {
  final String id;
  final String label;
  final int? vendorId;
  final int? productId;

  const SerialPortInfo({
    required this.id,
    required this.label,
    this.vendorId,
    this.productId,
  });
}

/// An open serial connection that exposes raw bytes from the device.
abstract class SerialPortConnection {
  /// Raw bytes received from the device.
  Stream<List<int>> get input;

  /// Emits once when the device is physically disconnected.
  Stream<void> get disconnected;

  /// Writes one newline-terminated ASCII/UTF-8 line to the device.
  Future<void> writeLine(String line);

  /// Releases the reader/writer locks and closes the underlying port.
  Future<void> close();
}

/// Platform boundary for real serial hardware.
///
/// Browsers can expose this through the Web Serial API. Native platforms can
/// provide their own implementation later without changing the hardware bridge.
abstract class SerialTransport {
  bool get isSupported;

  /// Human-readable explanation shown when [isSupported] is false.
  String get unsupportedReason;

  /// Ports already authorized by the user for this origin.
  Future<List<SerialPortInfo>> listPorts();

  /// Shows the browser/OS permission picker. Returns `null` when the user
  /// cancels.
  Future<SerialPortInfo?> requestPort();

  Future<SerialPortConnection> open(
    SerialPortInfo port, {
    required int baudRate,
  });
}

class SerialTransportException implements Exception {
  final String message;

  const SerialTransportException(this.message);

  @override
  String toString() => 'SerialTransportException: $message';
}

class SerialPermissionDeniedException extends SerialTransportException {
  const SerialPermissionDeniedException([
    super.message = 'No serial port was selected by the user.',
  ]);
}
