import 'package:flutter_test/flutter_test.dart';

import 'package:kinly/core/time/date_only.dart';

void main() {
  group('dateOnly', () {
    test('strips time components from DateTime', () {
      final input = DateTime(2025, 6, 15, 14, 30, 45, 123, 456);

      final result = dateOnly(input);

      expect(result.year, 2025);
      expect(result.month, 6);
      expect(result.day, 15);
      expect(result.hour, 0);
      expect(result.minute, 0);
      expect(result.second, 0);
      expect(result.millisecond, 0);
      expect(result.microsecond, 0);
    });

    test('preserves date when already at midnight', () {
      final input = DateTime(2025, 12, 25);

      final result = dateOnly(input);

      expect(result, DateTime(2025, 12, 25));
    });

    test('handles end of day', () {
      final input = DateTime(2025, 6, 15, 23, 59, 59, 999, 999);

      final result = dateOnly(input);

      expect(result, DateTime(2025, 6, 15));
    });

    test('handles leap year date', () {
      final input = DateTime(2024, 2, 29, 12, 0, 0);

      final result = dateOnly(input);

      expect(result, DateTime(2024, 2, 29));
    });

    test('handles year boundary', () {
      final input = DateTime(2025, 1, 1, 0, 0, 1);

      final result = dateOnly(input);

      expect(result, DateTime(2025, 1, 1));
    });
  });

  group('todayDateOnly', () {
    test('returns today at midnight when no argument provided', () {
      final before = DateTime.now();
      final result = todayDateOnly();
      final after = DateTime.now();

      expect(result.hour, 0);
      expect(result.minute, 0);
      expect(result.second, 0);
      expect(result.millisecond, 0);
      expect(result.microsecond, 0);
      expect(result.year, before.year);
      expect(result.month, before.month);
      expect(result.day, greaterThanOrEqualTo(before.day));
      expect(result.day, lessThanOrEqualTo(after.day));
    });

    test('returns date-only version of provided DateTime', () {
      final input = DateTime(2025, 8, 20, 16, 45, 30);

      final result = todayDateOnly(input);

      expect(result, DateTime(2025, 8, 20));
    });

    test('handles null argument same as no argument', () {
      final result = todayDateOnly(null);
      final now = DateTime.now();

      expect(result.year, now.year);
      expect(result.month, now.month);
      expect(result.day, now.day);
      expect(result.hour, 0);
    });
  });
}
