import 'dart:async';

class ProtocolVersion implements Comparable<ProtocolVersion> {
  final int major;
  final int minor;

  const ProtocolVersion(this.major, this.minor);

  static const ProtocolVersion v1_0 = ProtocolVersion(1, 0);
  static const ProtocolVersion current = v1_0;
  static const ProtocolVersion minSupported = ProtocolVersion(1, 0);
  static const ProtocolVersion maxSupported = ProtocolVersion(1, 2);

  factory ProtocolVersion.parse(String versionStr) {
    final cleaned = versionStr.trim().replaceFirst(RegExp(r'^[vV]'), '');
    final parts = cleaned.split('.');
    if (parts.isEmpty) {
      throw FormatException('Invalid protocol version string: "$versionStr"');
    }
    final major = int.tryParse(parts[0]);
    final minor = parts.length > 1 ? int.tryParse(parts[1]) : 0;
    if (major == null || minor == null) {
      throw FormatException(
          'Malformed protocol version numbers: "$versionStr"');
    }
    return ProtocolVersion(major, minor);
  }

  bool isCompatibleWith(ProtocolVersion other) {
    // Same major version and device minor within supported boundary
    if (major != other.major) return false;
    return other >= minSupported && other <= maxSupported;
  }

  @override
  int compareTo(ProtocolVersion other) {
    if (major != other.major) return major.compareTo(other.major);
    return minor.compareTo(other.minor);
  }

  bool operator >=(ProtocolVersion other) => compareTo(other) >= 0;
  bool operator <=(ProtocolVersion other) => compareTo(other) <= 0;
  bool operator >(ProtocolVersion other) => compareTo(other) > 0;
  bool operator <(ProtocolVersion other) => compareTo(other) < 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProtocolVersion &&
          runtimeType == other.runtimeType &&
          major == other.major &&
          minor == other.minor;

  @override
  int get hashCode => Object.hash(major, minor);

  @override
  String toString() => 'v$major.$minor';
}

abstract class ProtocolException implements Exception {
  final String message;
  const ProtocolException(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

class IncompatibleProtocolException extends ProtocolException {
  final ProtocolVersion? deviceVersion;
  const IncompatibleProtocolException(super.message, {this.deviceVersion});
}

class MalformedHandshakeException extends ProtocolException {
  final String rawResponse;
  const MalformedHandshakeException(super.message, this.rawResponse);
}

class HandshakeTimeoutException extends ProtocolException {
  final int attempts;
  const HandshakeTimeoutException(super.message, {this.attempts = 1});
}

class HandshakeResult {
  final bool isSuccess;
  final ProtocolVersion negotiatedVersion;
  final String boardId;
  final String? capabilitiesSignature;

  const HandshakeResult({
    required this.isSuccess,
    required this.negotiatedVersion,
    required this.boardId,
    this.capabilitiesSignature,
  });

  @override
  String toString() =>
      'HandshakeResult(success: $isSuccess, version: $negotiatedVersion, board: $boardId)';
}

class HardwareProtocolNegotiator {
  final ProtocolVersion clientVersion;
  final Duration timeout;
  final int maxRetries;

  const HardwareProtocolNegotiator({
    this.clientVersion = ProtocolVersion.current,
    this.timeout = const Duration(milliseconds: 500),
    this.maxRetries = 3,
  });

  String buildClientHello() {
    return 'HELLO:MONSTER_LAB:${clientVersion.toString()}';
  }

  HandshakeResult parseDeviceResponse(String response) {
    final line = response.trim();
    if (line.isEmpty) {
      throw MalformedHandshakeException(
          'Empty response received during handshake', line);
    }

    if (line.startsWith('ERR:VERSION_MISMATCH:') ||
        line.startsWith('ERR:UNSUPPORTED_PROTOCOL:')) {
      final parts = line.split(':');
      final versionStr = parts.length > 2 ? parts[2] : '';
      ProtocolVersion? parsed;
      try {
        if (versionStr.isNotEmpty) parsed = ProtocolVersion.parse(versionStr);
      } catch (_) {}
      throw IncompatibleProtocolException(
        'Device rejected protocol version with response: "$line"',
        deviceVersion: parsed,
      );
    }

    // Expected handshake format:
    // ACK:HANDSHAKE:<version>:<board_id>[:<signature>]
    // OR legacy companion fallback:
    // PONG:MONSTER_UNO_V1
    if (line.startsWith('ACK:HANDSHAKE:')) {
      final parts = line.split(':');
      if (parts.length < 4) {
        throw MalformedHandshakeException(
          'Incomplete ACK:HANDSHAKE frame. Required at least 4 segments: "$line"',
          line,
        );
      }
      final versionStr = parts[2];
      final boardId = parts[3];
      final sig = parts.length > 4 ? parts[4] : null;

      final deviceVersion = ProtocolVersion.parse(versionStr);
      if (!clientVersion.isCompatibleWith(deviceVersion)) {
        throw IncompatibleProtocolException(
          'Device protocol $deviceVersion is incompatible with client $clientVersion (supported: ${ProtocolVersion.minSupported} to ${ProtocolVersion.maxSupported})',
          deviceVersion: deviceVersion,
        );
      }

      return HandshakeResult(
        isSuccess: true,
        negotiatedVersion: deviceVersion,
        boardId: boardId,
        capabilitiesSignature: sig,
      );
    }

    // Legacy fallback compatible response
    if (line == 'PONG:MONSTER_UNO_V1' ||
        line.contains('Monster Lab Companion')) {
      return const HandshakeResult(
        isSuccess: true,
        negotiatedVersion: ProtocolVersion.v1_0,
        boardId: 'virtual_uno',
        capabilitiesSignature: 'LEGACY_COMPAT_V1',
      );
    }

    throw MalformedHandshakeException(
      'Unexpected response frame during handshake: "$line"',
      line,
    );
  }

  Future<HandshakeResult> performHandshake({
    required Future<void> Function(String) sendCommand,
    required Stream<String> responseStream,
  }) async {
    int attempts = 0;
    while (attempts < maxRetries) {
      attempts++;
      final hello = buildClientHello();
      await sendCommand(hello);

      try {
        final firstValidResponse = await responseStream
            .where((msg) =>
                msg.startsWith('ACK:HANDSHAKE:') ||
                msg.startsWith('ERR:') ||
                msg.startsWith('PONG:') ||
                msg.contains('Monster Lab Companion'))
            .first
            .timeout(timeout);

        return parseDeviceResponse(firstValidResponse);
      } on TimeoutException {
        if (attempts >= maxRetries) {
          throw HandshakeTimeoutException(
            'Handshake timed out after $attempts attempts ($timeout timeout per attempt)',
            attempts: attempts,
          );
        }
      } on StateError {
        // Stream completed without emitting any elements
        if (attempts >= maxRetries) {
          throw HandshakeTimeoutException(
            'Handshake stream ended without response after $attempts attempts',
            attempts: attempts,
          );
        }
      }
    }

    throw HandshakeTimeoutException(
      'Handshake failed after $attempts attempts',
      attempts: attempts,
    );
  }
}
