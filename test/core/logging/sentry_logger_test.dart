import 'package:kinly/core/logging/logger.dart';
import 'package:kinly/core/logging/sentry_logger.dart';
import 'package:test/test.dart';

class _RecordedLog {
  _RecordedLog(
    this.level,
    this.message, {
    this.tag,
    this.error,
    this.stackTrace,
  });

  final LogLevel level;
  final String message;
  final String? tag;
  final Object? error;
  final StackTrace? stackTrace;
}

class _FakeLogger extends Logger {
  final List<_RecordedLog> logs = [];

  @override
  void log(
    LogLevel level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    logs.add(
      _RecordedLog(
        level,
        message,
        tag: tag,
        error: error,
        stackTrace: stackTrace,
      ),
    );
  }
}

void main() {
  group('SentryLogger', () {
    test('delegates to fallback when Sentry is disabled', () {
      final fake = _FakeLogger();
      final logger = SentryLogger(fallback: fake);

      logger.warn('warn-msg', tag: 'test-tag');
      logger.error('error-msg', tag: 'test-tag', error: Exception('boom'));

      expect(fake.logs, hasLength(2));
      expect(fake.logs.first.level, LogLevel.warning);
      expect(fake.logs.first.message, 'warn-msg');
      expect(fake.logs.last.level, LogLevel.error);
      expect(fake.logs.last.message, 'error-msg');
      expect(fake.logs.last.error.toString(), contains('boom'));
    });
  });
}
