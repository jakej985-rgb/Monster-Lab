import 'serial_transport.dart';
import 'web_serial_transport_stub.dart'
    if (dart.library.js_interop) 'web_serial_transport_web.dart';

/// Returns the real Web Serial transport in a browser and an unsupported
/// implementation on native platforms.
SerialTransport createSerialTransport() => createWebSerialTransport();
