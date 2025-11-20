import 'enums/log_level.dart';

export 'enums/log_level.dart';

/// Small abstraction around log output so we can swap sinks later
/// (Crashlytics, remote logging, etc.) without updating every call site.
abstract class Logger {
  void log(
    LogLevel level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  });

  void debug(String message, {String? tag}) =>
      log(LogLevel.debug, message, tag: tag);

  void info(String message, {String? tag}) =>
      log(LogLevel.info, message, tag: tag);

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
}
