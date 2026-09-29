import 'package:flutter/foundation.dart';

enum LogLevel { debug, info, warning, error }

/// Structured, local-only logger for Monster Lab
class AppLogger {
  static void debug(String message, [String? tag]) =>
      _log(LogLevel.debug, message, tag);
  static void info(String message, [String? tag]) =>
      _log(LogLevel.info, message, tag);
  static void warning(String message, [String? tag]) =>
      _log(LogLevel.warning, message, tag);
  static void error(String message,
      [Object? error, StackTrace? stackTrace, String? tag]) {
    _log(LogLevel.error, message, tag, error, stackTrace);
  }

  static void _log(
    LogLevel level,
    String message,
    String? tag, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    if (kDebugMode) {
      final prefix =
          '[${level.name.toUpperCase()}]${tag != null ? ' [$tag]' : ''}';
      debugPrint('$prefix $message');
      if (error != null) {
        debugPrint('  Error: $error');
      }
      if (stackTrace != null) {
        debugPrint('  StackTrace: $stackTrace');
      }
    }
  }
}
