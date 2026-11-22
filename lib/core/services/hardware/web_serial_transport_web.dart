import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:typed_data';

import 'serial_transport.dart';

/// Real Web Serial API transport for Chromium browsers.
SerialTransport createWebSerialTransport() => WebSerialTransport();

/// Minimal typed bindings for the parts of the Web Serial API we use.
extension type _SerialApi._(JSObject _) implements JSObject {
  external JSPromise<JSArray<_SerialPort>> getPorts();
  external JSPromise<_SerialPort> requestPort();
}

extension type _SerialPort._(JSObject _) implements JSObject {
  external _SerialPortInfo getInfo();
  external JSPromise<JSAny?> open(JSObject options);
  external JSPromise<JSAny?> close();
  external _ReadableStream get readable;
  external _WritableStream get writable;
  external void addEventListener(JSString type, JSFunction listener);
}

extension type _SerialPortInfo._(JSObject _) implements JSObject {
  external int? get usbVendorId;
  external int? get usbProductId;
}

extension type _ReadableStream._(JSObject _) implements JSObject {
  external _Reader getReader();
}

extension type _Reader._(JSObject _) implements JSObject {
  external JSPromise<_ReadResult> read();
  external JSPromise<JSAny?> cancel();
  external void releaseLock();
}

extension type _ReadResult._(JSObject _) implements JSObject {
  external bool get done;
  external JSUint8Array? get value;
}

extension type _WritableStream._(JSObject _) implements JSObject {
  external _Writer getWriter();
}

extension type _Writer._(JSObject _) implements JSObject {
  external JSPromise<JSAny?> write(JSAny data);
  external JSPromise<JSAny?> close();
  external void releaseLock();
}

_SerialApi? _serialApi() {
  final navigator = globalContext.getProperty('navigator'.toJS);
  if (navigator == null) return null;
  final serial = (navigator as JSObject).getProperty('serial'.toJS);
  if (serial == null) return null;
  return _SerialApi._(serial as JSObject);
}

class WebSerialTransport implements SerialTransport {
  final Map<String, _SerialPort> _handles = {};
  int _nextId = 0;

  @override
  bool get isSupported => _serialApi() != null;

  @override
  String get unsupportedReason =>
      'Web Serial is not available in this browser. Use Chrome or Edge on '
      'desktop, served over HTTPS or localhost.';

  @override
  Future<List<SerialPortInfo>> listPorts() async {
    final api = _serialApi();
    if (api == null) return const [];

    try {
      final ports = await api.getPorts().toDart;
      _handles.clear();
      final result = <SerialPortInfo>[];
      var index = 0;
      for (final port in ports.toDart) {
        index++;
        final id = 'web-serial-$index-${_nextId++}';
        _handles[id] = port;
        result.add(_describe(port, id, index));
      }
      return result;
    } catch (error) {
      _throwTransportError(error);
    }
  }

  @override
  Future<SerialPortInfo?> requestPort() async {
    final api = _serialApi();
    if (api == null) {
      throw const SerialTransportException(
        'Web Serial is not available in this browser.',
      );
    }

    try {
      final port = await api.requestPort().toDart;
      final id = 'web-serial-request-${_nextId++}';
      _handles[id] = port;
      return _describe(port, id, _nextId);
    } catch (error) {
      final message = _errorMessage(error);
      if (message.toLowerCase().contains('no port selected')) {
        throw const SerialPermissionDeniedException();
      }
      _throwTransportError(error);
    }
  }

  @override
  Future<SerialPortConnection> open(
    SerialPortInfo port, {
    required int baudRate,
  }) async {
    final handle = _handles[port.id];
    if (handle == null) {
      throw const SerialTransportException(
        'That USB serial port is no longer available. Scan again and '
        'reselect the device.',
      );
    }

    final connection = _WebSerialConnection(handle);
    try {
      await connection.open(baudRate: baudRate);
      return connection;
    } catch (error) {
      await connection.close();
      _throwTransportError(error);
    }
  }

  SerialPortInfo _describe(_SerialPort port, String id, int index) {
    final info = port.getInfo();
    final vendorId = info.usbVendorId;
    final productId = info.usbProductId;

    final details = <String>[];
    if (vendorId != null && productId != null) {
      final vid = vendorId.toRadixString(16).padLeft(4, '0').toUpperCase();
      final pid = productId.toRadixString(16).padLeft(4, '0').toUpperCase();
      details.add('VID 0x$vid / PID 0x$pid');
    }

    final label = details.isEmpty
        ? 'USB Serial #$index'
        : 'USB Serial #$index (${details.join(' • ')})';

    return SerialPortInfo(
      id: id,
      label: label,
      vendorId: vendorId,
      productId: productId,
    );
  }
}

class _WebSerialConnection implements SerialPortConnection {
  _WebSerialConnection(this._port);

  final _SerialPort _port;
  final _inputController = StreamController<List<int>>.broadcast(sync: true);
  final _disconnectController = StreamController<void>.broadcast(sync: true);

  _Reader? _reader;
  _Writer? _writer;
  bool _closed = false;

  @override
  Stream<List<int>> get input => _inputController.stream;

  @override
  Stream<void> get disconnected => _disconnectController.stream;

  Future<void> open({required int baudRate}) async {
    final options = JSObject();
    options.setProperty('baudRate'.toJS, baudRate.toJS);
    options.setProperty('dataBits'.toJS, 8.toJS);
    options.setProperty('stopBits'.toJS, 1.toJS);
    options.setProperty('parity'.toJS, 'none'.toJS);
    options.setProperty('bufferSize'.toJS, 255.toJS);
    options.setProperty('flowControl'.toJS, 'none'.toJS);

    await _port.open(options).toDart;
    _reader = _port.readable.getReader();
    _writer = _port.writable.getWriter();
    _port.addEventListener(
      'disconnect'.toJS,
      (() => _notifyDisconnected()).toJS,
    );
    unawaited(_pump());
  }

  @override
  Future<void> writeLine(String line) async {
    final writer = _writer;
    if (_closed || writer == null) {
      throw const SerialTransportException('USB serial port is not open.');
    }

    final bytes = Uint8List.fromList(utf8.encode('$line\n'));
    try {
      await writer.write(bytes.toJS).toDart;
    } catch (error) {
      _throwTransportError(error);
    }
  }

  Future<void> _pump() async {
    try {
      while (!_closed) {
        final result = await _reader!.read().toDart;
        if (result.done) break;

        final chunk = result.value;
        if (chunk != null && !_inputController.isClosed) {
          _inputController.add(chunk.toDart);
        }
      }
    } catch (error) {
      if (!_closed && !_inputController.isClosed) {
        _inputController.addError(
          SerialTransportException(_errorMessage(error)),
        );
      }
    } finally {
      if (!_closed) _notifyDisconnected();
    }
  }

  void _notifyDisconnected() {
    if (_closed) return;
    if (!_disconnectController.isClosed) {
      _disconnectController.add(null);
    }
    if (!_inputController.isClosed) {
      unawaited(_inputController.close());
    }
  }

  @override
  Future<void> close() async {
    if (_closed) return;
    _closed = true;

    try {
      await _reader?.cancel().toDart;
    } catch (_) {
      // The reader may already be errored after a physical disconnect.
    }
    try {
      _reader?.releaseLock();
    } catch (_) {
      // Lock is already released.
    }
    try {
      await _writer?.close().toDart;
    } catch (_) {
      // Closing the port can race with the OS detaching the device.
    }
    try {
      _writer?.releaseLock();
    } catch (_) {
      // Lock is already released.
    }
    try {
      await _port.close().toDart;
    } catch (_) {
      // The port may already be gone.
    }

    if (!_inputController.isClosed) await _inputController.close();
    if (!_disconnectController.isClosed) await _disconnectController.close();
  }
}

String _errorMessage(Object error) {
  // JS exceptions cross the boundary as objects. String() (used by
  // toString) includes the DOMException name and message in Chromium.
  return error.toString();
}

Never _throwTransportError(Object error) {
  final message = _errorMessage(error);
  if (message.toLowerCase().contains('no port selected')) {
    throw const SerialPermissionDeniedException();
  }
  throw SerialTransportException(message);
}
