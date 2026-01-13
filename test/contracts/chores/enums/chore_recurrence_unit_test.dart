import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/contracts/chores/enums/chore_recurrence_unit.dart';

void main() {
  group('ChoreRecurrenceUnit', () {
    group('wireValue', () {
      test('day has wireValue "day"', () {
        expect(ChoreRecurrenceUnit.day.wireValue, 'day');
      });

      test('week has wireValue "week"', () {
        expect(ChoreRecurrenceUnit.week.wireValue, 'week');
      });

      test('month has wireValue "month"', () {
        expect(ChoreRecurrenceUnit.month.wireValue, 'month');
      });

      test('year has wireValue "year"', () {
        expect(ChoreRecurrenceUnit.year.wireValue, 'year');
      });
    });

    group('fromWire', () {
      test('parses "day" to ChoreRecurrenceUnit.day', () {
        expect(ChoreRecurrenceUnitWire.fromWire('day'), ChoreRecurrenceUnit.day);
      });

      test('parses "week" to ChoreRecurrenceUnit.week', () {
        expect(
          ChoreRecurrenceUnitWire.fromWire('week'),
          ChoreRecurrenceUnit.week,
        );
      });

      test('parses "month" to ChoreRecurrenceUnit.month', () {
        expect(
          ChoreRecurrenceUnitWire.fromWire('month'),
          ChoreRecurrenceUnit.month,
        );
      });

      test('parses "year" to ChoreRecurrenceUnit.year', () {
        expect(
          ChoreRecurrenceUnitWire.fromWire('year'),
          ChoreRecurrenceUnit.year,
        );
      });

      test('returns null for null', () {
        expect(ChoreRecurrenceUnitWire.fromWire(null), isNull);
      });

      test('returns null for unknown value', () {
        expect(ChoreRecurrenceUnitWire.fromWire('unknown'), isNull);
      });

      test('returns null for empty string', () {
        expect(ChoreRecurrenceUnitWire.fromWire(''), isNull);
      });
    });

    group('round-trip', () {
      test('all values survive round-trip through wireValue and fromWire', () {
        for (final unit in ChoreRecurrenceUnit.values) {
          final wireValue = unit.wireValue;
          final parsed = ChoreRecurrenceUnitWire.fromWire(wireValue);
          expect(parsed, unit);
        }
      });
    });
  });
}
