import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/contracts/chores/enums/chore_recurrence.dart';

void main() {
  group('ChoreRecurrence', () {
    group('wireValue', () {
      test('none has wireValue "none"', () {
        expect(ChoreRecurrence.none.wireValue, 'none');
      });

      test('daily has wireValue "daily"', () {
        expect(ChoreRecurrence.daily.wireValue, 'daily');
      });

      test('weekly has wireValue "weekly"', () {
        expect(ChoreRecurrence.weekly.wireValue, 'weekly');
      });

      test('every2Weeks has wireValue "every_2_weeks"', () {
        expect(ChoreRecurrence.every2Weeks.wireValue, 'every_2_weeks');
      });

      test('monthly has wireValue "monthly"', () {
        expect(ChoreRecurrence.monthly.wireValue, 'monthly');
      });

      test('every2Months has wireValue "every_2_months"', () {
        expect(ChoreRecurrence.every2Months.wireValue, 'every_2_months');
      });

      test('annual has wireValue "annual"', () {
        expect(ChoreRecurrence.annual.wireValue, 'annual');
      });
    });

    group('fromWire', () {
      test('parses "none" to ChoreRecurrence.none', () {
        expect(ChoreRecurrenceWire.fromWire('none'), ChoreRecurrence.none);
      });

      test('parses "daily" to ChoreRecurrence.daily', () {
        expect(ChoreRecurrenceWire.fromWire('daily'), ChoreRecurrence.daily);
      });

      test('parses "weekly" to ChoreRecurrence.weekly', () {
        expect(ChoreRecurrenceWire.fromWire('weekly'), ChoreRecurrence.weekly);
      });

      test('parses "every_2_weeks" to ChoreRecurrence.every2Weeks', () {
        expect(
          ChoreRecurrenceWire.fromWire('every_2_weeks'),
          ChoreRecurrence.every2Weeks,
        );
      });

      test('parses "monthly" to ChoreRecurrence.monthly', () {
        expect(
          ChoreRecurrenceWire.fromWire('monthly'),
          ChoreRecurrence.monthly,
        );
      });

      test('parses "every_2_months" to ChoreRecurrence.every2Months', () {
        expect(
          ChoreRecurrenceWire.fromWire('every_2_months'),
          ChoreRecurrence.every2Months,
        );
      });

      test('parses "annual" to ChoreRecurrence.annual', () {
        expect(ChoreRecurrenceWire.fromWire('annual'), ChoreRecurrence.annual);
      });

      test('returns none for null', () {
        expect(ChoreRecurrenceWire.fromWire(null), ChoreRecurrence.none);
      });

      test('returns none for unknown value', () {
        expect(ChoreRecurrenceWire.fromWire('unknown'), ChoreRecurrence.none);
      });
    });

    group('round-trip', () {
      test('all values survive round-trip', () {
        for (final recurrence in ChoreRecurrence.values) {
          final wireValue = recurrence.wireValue;
          final parsed = ChoreRecurrenceWire.fromWire(wireValue);
          expect(parsed, recurrence);
        }
      });
    });
  });
}
