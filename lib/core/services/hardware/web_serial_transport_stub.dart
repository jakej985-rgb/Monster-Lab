import 'serial_transport.dart';

/// Non-web fallback selected by the conditional import in
/// `serial_transport_factory.dart`.
SerialTransport createWebSerialTransport() =>
    const UnsupportedSerialTransport();

class UnsupportedSerialTransport implements SerialTransport {
  const UnsupportedSerialTransport();

  @override
  bool get isSupported => false;

  @override
  String get unsupportedReason =>
      'Real USB serial is available in the web build using Chrome or Edge on '
      'desktop (HTTPS or localhost). This build uses the virtual simulator.';

  @override
  Future<List<SerialPortInfo>> listPorts() async => const [];

  @override
  Future<SerialPortInfo?> requestPort() async => null;

  @override
  Future<SerialPortConnection> open(
    SerialPortInfo port, {
    required int baudRate,
  }) async {
    throw const SerialTransportException(
      'Web Serial is not available on this platform.',
    );
  }
}
