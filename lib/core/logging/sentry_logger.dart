import 'dart:async';

import 'package:sentry_flutter/sentry_flutter.dart';

import 'enums/log_level.dart';
import 'logger.dart';

/// Logger that forwards messages to a fallback sink and mirrors warnings/errors
/// into Sentry when the SDK is enabled.
class SentryLogger extends Logger {
  SentryLogger({required Logger fallback}) : _fallback = fallback;

  final Logger _fallback;

  @override
  void log(
    LogLevel level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _fallback.log(
      level,
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );

    if (!Sentry.isEnabled) return;

    switch (level) {
      case LogLevel.error:
        if (error != null) {
          unawaited(
            Sentry.captureException(
              error,
              stackTrace: stackTrace,
              withScope: (scope) => _configureScope(scope, tag),
            ),
          );
        } else {
          unawaited(
            Sentry.captureMessage(
              message,
              level: SentryLevel.error,
              withScope: (scope) => _configureScope(scope, tag),
            ),
          );
        }
        break;
      case LogLevel.warning:
        unawaited(
          Sentry.captureMessage(
            message,
            level: SentryLevel.warning,
            withScope: (scope) {
              _configureScope(scope, tag);
              if (error != null) {
                scope.setExtra('warning_error', error.toString());
              }
              if (stackTrace != null) {
                scope.setExtra('warning_stacktrace', stackTrace.toString());
              }
            },
          ),
        );
        break;
      case LogLevel.info:
      case LogLevel.debug:
        break;
    }
  }

  void _configureScope(Scope scope, String? tag) {
    if (tag != null && tag.isNotEmpty) {
      scope.setTag('logger_tag', tag);
    }
  }
}
