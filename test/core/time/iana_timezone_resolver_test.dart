import 'package:kinly/core/logging/logger.dart';
import 'package:kinly/core/time/iana_timezone_resolver.dart';
import 'package:test/test.dart';

class _FakeLogger implements Logger {
  final List<({LogLevel level, String message, String? tag, Object? error})>
      entries = [];

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
  }) => log(LogLevel.warning, message, tag: tag, error: error);

  @override
  void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) => log(LogLevel.error, message, tag: tag, error: error);

  @override
  void log(
    LogLevel level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    entries.add((level: level, message: message, tag: tag, error: error));
  }
}

void main() {
  group('IanaTimezoneResolver', () {
    test('returns IANA timezone and logs debug', () async {
      final logger = _FakeLogger();
      final resolver = IanaTimezoneResolver(
        logger: logger,
        loader: () async => 'America/Argentina/Buenos_Aires',
      );

      final timezone = await resolver.resolve();

      expect(timezone, 'America/Argentina/Buenos_Aires');
      expect(
        logger.entries.any(
          (entry) =>
              entry.level == LogLevel.debug &&
              entry.message.contains('resolvedTimezoneIana=America/Argentina'),
        ),
        isTrue,
      );
    });

    test('falls back to UTC when timezone is invalid', () async {
      final logger = _FakeLogger();
      final resolver = IanaTimezoneResolver(
        logger: logger,
        loader: () async => 'NZDT',
      );

      final timezone = await resolver.resolve();

      expect(timezone, 'UTC');
      expect(
        logger.entries.any(
          (entry) =>
              entry.level == LogLevel.warning &&
              entry.message.contains('Invalid timezone from platform'),
        ),
        isTrue,
      );
      expect(
        logger.entries.any(
          (entry) =>
              entry.level == LogLevel.debug &&
              entry.message.contains('resolvedTimezoneIana=UTC'),
        ),
        isTrue,
      );
    });

    test('falls back to UTC when resolution throws', () async {
      final logger = _FakeLogger();
      final resolver = IanaTimezoneResolver(
        logger: logger,
        loader: () => Future.error(Exception('boom')),
      );

      final timezone = await resolver.resolve();

      expect(timezone, 'UTC');
      expect(
        logger.entries.any(
          (entry) =>
              entry.level == LogLevel.warning &&
              entry.message.contains('Failed to resolve timezone'),
        ),
        isTrue,
      );
    });
  });
}
