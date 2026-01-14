import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/contracts/chores/enums/chore_completion_status.dart';

void main() {
  group('ChoreCompletionStatus', () {
    group('wireValue', () {
      test('nonRecurringCompleted has wireValue "non_recurring_completed"', () {
        expect(
          ChoreCompletionStatus.nonRecurringCompleted.wireValue,
          'non_recurring_completed',
        );
      });

      test(
        'alreadyCompletedForCycle has wireValue "already_completed_for_cycle"',
        () {
          expect(
            ChoreCompletionStatus.alreadyCompletedForCycle.wireValue,
            'already_completed_for_cycle',
          );
        },
      );

      test('recurringCompleted has wireValue "recurring completed"', () {
        expect(
          ChoreCompletionStatus.recurringCompleted.wireValue,
          'recurring completed',
        );
      });
    });

    group('fromWire', () {
      test('parses "non_recurring_completed" to nonRecurringCompleted', () {
        expect(
          ChoreCompletionStatus.fromWire('non_recurring_completed'),
          ChoreCompletionStatus.nonRecurringCompleted,
        );
      });

      test(
        'parses "already_completed_for_cycle" to alreadyCompletedForCycle',
        () {
          expect(
            ChoreCompletionStatus.fromWire('already_completed_for_cycle'),
            ChoreCompletionStatus.alreadyCompletedForCycle,
          );
        },
      );

      test('parses "recurring completed" to recurringCompleted', () {
        expect(
          ChoreCompletionStatus.fromWire('recurring completed'),
          ChoreCompletionStatus.recurringCompleted,
        );
      });

      test('returns nonRecurringCompleted for null', () {
        expect(
          ChoreCompletionStatus.fromWire(null),
          ChoreCompletionStatus.nonRecurringCompleted,
        );
      });

      test('returns nonRecurringCompleted for unknown value', () {
        expect(
          ChoreCompletionStatus.fromWire('unknown'),
          ChoreCompletionStatus.nonRecurringCompleted,
        );
      });
    });

    group('round-trip', () {
      test('all values survive round-trip', () {
        for (final status in ChoreCompletionStatus.values) {
          final wireValue = status.wireValue;
          final parsed = ChoreCompletionStatus.fromWire(wireValue);
          expect(parsed, status);
        }
      });
    });
  });
}
