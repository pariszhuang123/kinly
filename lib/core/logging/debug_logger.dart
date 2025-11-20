import 'dart:developer' as developer;

import 'logger.dart';

/// Default logger that writes to `dart:developer.log`, which surfaces in the
/// Flutter console and can be captured by observatory tools.
class DebugLogger implements Logger {
  const DebugLogger({this.defaultTag = 'Kinly'});

  final String defaultTag;

  @override
  void debug(String message, {String? tag}) =>
      log(LogLevel.debug, message, tag: tag);

  @override
  void info(String message, {String? tag}) =>
      log(LogLevel.info, message, tag: tag);

  @override
  void warn(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      log(
        LogLevel.warning,
        message,
        tag: tag,
        error: error,
        stackTrace: stackTrace,
      );

  @override
  void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      log(
        LogLevel.error,
        message,
        tag: tag,
        error: error,
        stackTrace: stackTrace,
      );

  @override
  void log(
    LogLevel level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message,
      level: level.priority,
      name: tag ?? defaultTag,
      error: error,
      stackTrace: stackTrace,
    );
  }
}

extension on LogLevel {
  int get priority => switch (this) {
        LogLevel.debug => 500,
        LogLevel.info => 800,
        LogLevel.warning => 900,
        LogLevel.error => 1000,
      };
}
