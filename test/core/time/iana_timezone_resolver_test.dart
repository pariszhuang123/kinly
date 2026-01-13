import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/core/time/iana_timezone_resolver.dart';
import 'package:kinly/core/logging/logger.dart';

class _FakeLogger extends Logger {
  @override
  void log(
    LogLevel level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {}
}

void main() {
  late _FakeLogger logger;

  setUp(() {
    logger = _FakeLogger();
    IanaTimezoneResolver.debugOverride = null;
  });

  tearDown(() {
    IanaTimezoneResolver.debugOverride = null;
  });

  group('IanaTimezoneResolver', () {
    test('returns valid IANA timezone from loader', () async {
      final resolver = IanaTimezoneResolver(
        logger: logger,
        loader: () async => 'America/New_York',
      );
      final result = await resolver.resolve();
      expect(result, 'America/New_York');
    });

    test('trims whitespace from timezone', () async {
      final resolver = IanaTimezoneResolver(
        logger: logger,
        loader: () async => '  Europe/London  ',
      );
      final result = await resolver.resolve();
      expect(result, 'Europe/London');
    });

    test('returns UTC for empty timezone', () async {
      final resolver = IanaTimezoneResolver(
        logger: logger,
        loader: () async => '',
      );
      final result = await resolver.resolve();
      expect(result, 'UTC');
    });

    test('returns UTC for invalid timezone format', () async {
      final resolver = IanaTimezoneResolver(
        logger: logger,
        loader: () async => 'Invalid Timezone',
      );
      final result = await resolver.resolve();
      expect(result, 'UTC');
    });

    test('returns UTC when loader throws', () async {
      final resolver = IanaTimezoneResolver(
        logger: logger,
        loader: () async => throw Exception('Platform error'),
      );
      final result = await resolver.resolve();
      expect(result, 'UTC');
    });

    test('uses debugOverride when set', () async {
      IanaTimezoneResolver.debugOverride = 'Asia/Tokyo';
      final resolver = IanaTimezoneResolver(
        logger: logger,
        loader: () async => 'America/New_York',
      );
      final result = await resolver.resolve();
      expect(result, 'Asia/Tokyo');
    });

    test('ignores empty debugOverride', () async {
      IanaTimezoneResolver.debugOverride = '';
      final resolver = IanaTimezoneResolver(
        logger: logger,
        loader: () async => 'Europe/Paris',
      );
      final result = await resolver.resolve();
      expect(result, 'Europe/Paris');
    });

    test('accepts UTC as valid timezone', () async {
      final resolver = IanaTimezoneResolver(
        logger: logger,
        loader: () async => 'UTC',
      );
      final result = await resolver.resolve();
      expect(result, 'UTC');
    });

    test('accepts multi-level IANA timezone', () async {
      final resolver = IanaTimezoneResolver(
        logger: logger,
        loader: () async => 'America/Argentina/Buenos_Aires',
      );
      final result = await resolver.resolve();
      expect(result, 'America/Argentina/Buenos_Aires');
    });

    test('rejects timezone without slash', () async {
      final resolver = IanaTimezoneResolver(
        logger: logger,
        loader: () async => 'EST',
      );
      final result = await resolver.resolve();
      expect(result, 'UTC');
    });
  });
}
