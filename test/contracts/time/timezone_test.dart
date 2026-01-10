import 'package:flutter_test/flutter_test.dart';

import 'package:kinly/contracts/time/timezone.dart';

void main() {
  group('parseTimestampToLocal', () {
    test('returns null for null input', () {
      expect(parseTimestampToLocal(null), isNull);
    });

    test('parses ISO string and converts to local', () {
      final result = parseTimestampToLocal('2025-06-15T12:30:00.000Z');

      expect(result, isNotNull);
      final nonNull = result!;
      expect(nonNull.isUtc, isFalse);
    });

    test('accepts DateTime directly and converts to local', () {
      final utcTime = DateTime.utc(2025, 6, 15, 12, 30);

      final result = parseTimestampToLocal(utcTime);

      expect(result, isNotNull);
      final nonNull = result!;
      expect(nonNull.isUtc, isFalse);
    });

    test('preserves already-local DateTime', () {
      final localTime = DateTime(2025, 6, 15, 12, 30);

      final result = parseTimestampToLocal(localTime);

      expect(result, isNotNull);
      final nonNull = result!;
      expect(nonNull.isUtc, isFalse);
    });

    test('parses timestamp with timezone offset', () {
      final result = parseTimestampToLocal('2025-06-15T12:30:00.000+05:00');

      expect(result, isNotNull);
      final nonNull = result!;
      expect(nonNull.isUtc, isFalse);
    });

    test('parses timestamp without milliseconds', () {
      final result = parseTimestampToLocal('2025-06-15T12:30:00Z');

      expect(result, isNotNull);
      final nonNull = result!;
      expect(nonNull.isUtc, isFalse);
    });
  });

  group('parseDateToLocal', () {
    test('returns null for null input', () {
      expect(parseDateToLocal(null), isNull);
    });

    test('parses date-only string to midnight local', () {
      final result = parseDateToLocal('2025-06-15');

      expect(result, isNotNull);
      final nonNull = result!;
      expect(nonNull.hour, 0);
      expect(nonNull.minute, 0);
      expect(nonNull.second, 0);
      expect(nonNull.millisecond, 0);
    });

    test('parses ISO timestamp with T separator', () {
      final result = parseDateToLocal('2025-06-15T14:30:00.000Z');

      expect(result, isNotNull);
      final nonNull = result!;
      expect(nonNull.isUtc, isFalse);
    });

    test('date-only result has correct year/month/day', () {
      final result = parseDateToLocal('2025-12-25');

      expect(result, isNotNull);
      final nonNull = result!;
      expect(nonNull.year, 2025);
      expect(nonNull.month, 12);
      expect(nonNull.day, 25);
    });
  });

  group('toUtcIsoString', () {
    test('converts local DateTime to UTC ISO string', () {
      final local = DateTime(2025, 6, 15, 12, 30, 45);

      final result = toUtcIsoString(local);

      expect(result, contains('T'));
      expect(result, endsWith('Z'));
    });

    test('converts UTC DateTime to ISO string', () {
      final utc = DateTime.utc(2025, 6, 15, 12, 30, 45, 123);

      final result = toUtcIsoString(utc);

      expect(result, '2025-06-15T12:30:45.123Z');
    });

    test('result is parseable back to DateTime', () {
      final original = DateTime.utc(2025, 6, 15, 12, 30, 45);

      final isoString = toUtcIsoString(original);
      final parsed = DateTime.parse(isoString);

      expect(parsed, original);
    });
  });

  group('localDayBoundsUtc', () {
    test('returns start of day in UTC', () {
      final localNow = DateTime(2025, 6, 15, 14, 30, 45);

      final bounds = localDayBoundsUtc(localNow);

      final expectedLocalStart = DateTime(2025, 6, 15);
      expect(bounds.startUtc, expectedLocalStart.toUtc());
    });

    test('returns end of day (next day start) in UTC', () {
      final localNow = DateTime(2025, 6, 15, 14, 30, 45);

      final bounds = localDayBoundsUtc(localNow);

      final expectedLocalEnd = DateTime(2025, 6, 16);
      expect(bounds.endUtc, expectedLocalEnd.toUtc());
    });

    test('start and end are exactly 24 hours apart', () {
      final localNow = DateTime(2025, 6, 15, 14, 30, 45);

      final bounds = localDayBoundsUtc(localNow);

      final difference = bounds.endUtc.difference(bounds.startUtc);
      expect(difference, const Duration(days: 1));
    });

    test('handles midnight edge case', () {
      final localMidnight = DateTime(2025, 6, 15);

      final bounds = localDayBoundsUtc(localMidnight);

      expect(bounds.startUtc, localMidnight.toUtc());
      expect(bounds.endUtc, DateTime(2025, 6, 16).toUtc());
    });

    test('handles end of year', () {
      final localNow = DateTime(2025, 12, 31, 23, 59, 59);

      final bounds = localDayBoundsUtc(localNow);

      expect(bounds.startUtc, DateTime(2025, 12, 31).toUtc());
      expect(bounds.endUtc, DateTime(2026, 1, 1).toUtc());
    });

    test('both bounds are in UTC', () {
      final localNow = DateTime(2025, 6, 15, 14, 30);

      final bounds = localDayBoundsUtc(localNow);

      expect(bounds.startUtc.isUtc, isTrue);
      expect(bounds.endUtc.isUtc, isTrue);
    });
  });
}
