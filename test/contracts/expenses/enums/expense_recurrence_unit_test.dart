import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/contracts/expenses/enums/expense_recurrence_unit.dart';

void main() {
  group('ExpenseRecurrenceUnit', () {
    group('wireValue', () {
      test('day has wireValue "day"', () {
        expect(ExpenseRecurrenceUnit.day.wireValue, 'day');
      });

      test('week has wireValue "week"', () {
        expect(ExpenseRecurrenceUnit.week.wireValue, 'week');
      });

      test('month has wireValue "month"', () {
        expect(ExpenseRecurrenceUnit.month.wireValue, 'month');
      });

      test('year has wireValue "year"', () {
        expect(ExpenseRecurrenceUnit.year.wireValue, 'year');
      });
    });

    group('fromWire', () {
      test('parses "day" to ExpenseRecurrenceUnit.day', () {
        expect(
          ExpenseRecurrenceUnitWire.fromWire('day'),
          ExpenseRecurrenceUnit.day,
        );
      });

      test('parses "week" to ExpenseRecurrenceUnit.week', () {
        expect(
          ExpenseRecurrenceUnitWire.fromWire('week'),
          ExpenseRecurrenceUnit.week,
        );
      });

      test('parses "month" to ExpenseRecurrenceUnit.month', () {
        expect(
          ExpenseRecurrenceUnitWire.fromWire('month'),
          ExpenseRecurrenceUnit.month,
        );
      });

      test('parses "year" to ExpenseRecurrenceUnit.year', () {
        expect(
          ExpenseRecurrenceUnitWire.fromWire('year'),
          ExpenseRecurrenceUnit.year,
        );
      });

      test('returns null for null', () {
        expect(ExpenseRecurrenceUnitWire.fromWire(null), isNull);
      });

      test('returns null for unknown value', () {
        expect(ExpenseRecurrenceUnitWire.fromWire('unknown'), isNull);
      });

      test('returns null for empty string', () {
        expect(ExpenseRecurrenceUnitWire.fromWire(''), isNull);
      });
    });

    group('round-trip', () {
      test('all values survive round-trip through wireValue and fromWire', () {
        for (final unit in ExpenseRecurrenceUnit.values) {
          final wireValue = unit.wireValue;
          final parsed = ExpenseRecurrenceUnitWire.fromWire(wireValue);
          expect(parsed, unit);
        }
      });
    });
  });
}
