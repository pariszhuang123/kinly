import 'package:flutter_test/flutter_test.dart';

import 'package:kinly/contracts/expenses/enums/expense_recurrence_unit.dart';
import 'package:kinly/features/share/domain/share_create_form.dart';
import 'package:kinly/features/share/domain/share_split_mode.dart';

void main() {
  group('ShareCreateForm', () {
    group('initial', () {
      test('initial startDate is date-only', () {
        final form = ShareCreateForm.initial();

        expect(form.startDate.hour, 0);
        expect(form.startDate.minute, 0);
        expect(form.startDate.second, 0);
        expect(form.startDate.millisecond, 0);
        expect(form.startDate.microsecond, 0);
      });

      test('initial form has empty description', () {
        final form = ShareCreateForm.initial();
        expect(form.description, '');
      });

      test('initial form has empty amountInput', () {
        final form = ShareCreateForm.initial();
        expect(form.amountInput, '');
      });

      test('initial form has null splitMode', () {
        final form = ShareCreateForm.initial();
        expect(form.splitMode, isNull);
      });

      test('initial form has empty participant selection', () {
        final form = ShareCreateForm.initial();
        expect(form.selectedParticipantIds, isEmpty);
      });

      test('initial form has empty customAmountInputs', () {
        final form = ShareCreateForm.initial();
        expect(form.customAmountInputs, isEmpty);
      });

      test('initial form has no recurrence', () {
        final form = ShareCreateForm.initial();
        expect(form.recurrenceEvery, isNull);
        expect(form.recurrenceUnit, isNull);
        expect(form.isRecurring, isFalse);
      });

      test('initial form has empty evidencePhotoPath', () {
        final form = ShareCreateForm.initial();
        expect(form.evidencePhotoPath, '');
      });
    });

    group('copyWith', () {
      test('copyWith normalizes startDate to date-only', () {
        final form = ShareCreateForm.initial();
        final updated = form.copyWith(
          startDate: DateTime(2025, 12, 31, 23, 59, 59),
        );

        expect(updated.startDate, DateTime(2025, 12, 31));
      });

      test('copyWith updates description', () {
        final form = ShareCreateForm.initial();
        final updated = form.copyWith(description: 'Groceries');

        expect(updated.description, 'Groceries');
      });

      test('copyWith clears splitMode when clearSplitMode is true', () {
        final form = ShareCreateForm.initial().copyWith(
          splitMode: ShareSplitMode.equal,
        );

        final cleared = form.copyWith(clearSplitMode: true);

        expect(cleared.splitMode, isNull);
      });

      test('copyWith clears recurrence when flags are true', () {
        final form = ShareCreateForm.initial().copyWith(
          recurrenceEvery: 2,
          recurrenceUnit: ExpenseRecurrenceUnit.week,
        );

        final cleared = form.copyWith(
          clearRecurrenceEvery: true,
          clearRecurrenceUnit: true,
        );

        expect(cleared.recurrenceEvery, isNull);
        expect(cleared.recurrenceUnit, isNull);
      });

      test('copyWith preserves other fields when updating one', () {
        final form = ShareCreateForm.initial().copyWith(
          description: 'Rent',
          amountInput: '500.00',
          notes: 'Monthly rent',
        );

        final updated = form.copyWith(description: 'Utilities');

        expect(updated.description, 'Utilities');
        expect(updated.amountInput, '500.00');
        expect(updated.notes, 'Monthly rent');
      });

      test('copyWith updates evidencePhotoPath', () {
        final form = ShareCreateForm.initial();
        final updated = form.copyWith(
          evidencePhotoPath: 'households/home-1/share/photo.jpg',
        );

        expect(updated.evidencePhotoPath, 'households/home-1/share/photo.jpg');
      });
    });

    group('hasValidDescription', () {
      test('returns false for empty string', () {
        final form = ShareCreateForm.initial();
        expect(form.hasValidDescription, isFalse);
      });

      test('returns false for whitespace-only string', () {
        final form = ShareCreateForm.initial().copyWith(description: '   ');
        expect(form.hasValidDescription, isFalse);
      });

      test('returns true for non-empty trimmed string', () {
        final form = ShareCreateForm.initial().copyWith(
          description: 'Groceries',
        );
        expect(form.hasValidDescription, isTrue);
      });

      test('returns true for string with leading/trailing spaces', () {
        final form = ShareCreateForm.initial().copyWith(
          description: '  Groceries  ',
        );
        expect(form.hasValidDescription, isTrue);
      });
    });

    group('parseCurrency', () {
      test('returns null for empty string', () {
        expect(ShareCreateForm.parseCurrency(''), isNull);
      });

      test('returns null for whitespace-only string', () {
        expect(ShareCreateForm.parseCurrency('   '), isNull);
      });

      test('parses whole number to cents', () {
        expect(ShareCreateForm.parseCurrency('100'), 10000);
      });

      test('parses decimal to cents', () {
        expect(ShareCreateForm.parseCurrency('10.50'), 1050);
      });

      test('parses single decimal digit with padding', () {
        expect(ShareCreateForm.parseCurrency('10.5'), 1050);
      });

      test('handles comma separators', () {
        expect(ShareCreateForm.parseCurrency('1,000.00'), 100000);
      });

      test('returns null for invalid format', () {
        expect(ShareCreateForm.parseCurrency('abc'), isNull);
      });

      test('returns null for negative numbers', () {
        expect(ShareCreateForm.parseCurrency('-10.00'), isNull);
      });

      test('returns null for more than 2 decimal places', () {
        expect(ShareCreateForm.parseCurrency('10.123'), isNull);
      });

      test('handles zero', () {
        expect(ShareCreateForm.parseCurrency('0'), 0);
      });

      test('handles zero with decimals', () {
        expect(ShareCreateForm.parseCurrency('0.00'), 0);
      });
    });

    group('amountCents', () {
      test('returns parsed cents from amountInput', () {
        final form = ShareCreateForm.initial().copyWith(amountInput: '25.50');
        expect(form.amountCents, 2550);
      });

      test('returns null for invalid amountInput', () {
        final form = ShareCreateForm.initial().copyWith(amountInput: 'invalid');
        expect(form.amountCents, isNull);
      });
    });

    group('updateSelection', () {
      test('adds user to selection when isSelected is true', () {
        final form = ShareCreateForm.initial();
        final updated = form.updateSelection('user-1', true);

        expect(updated.selectedParticipantIds, contains('user-1'));
      });

      test('removes user from selection when isSelected is false', () {
        final form = ShareCreateForm.initial().copyWith(
          selectedParticipantIds: {'user-1', 'user-2'},
        );
        final updated = form.updateSelection('user-1', false);

        expect(updated.selectedParticipantIds, isNot(contains('user-1')));
        expect(updated.selectedParticipantIds, contains('user-2'));
      });

      test('preserves insertion order (LinkedHashSet)', () {
        var form = ShareCreateForm.initial();
        form = form.updateSelection('user-3', true);
        form = form.updateSelection('user-1', true);
        form = form.updateSelection('user-2', true);

        expect(form.selectedParticipantIds.toList(), [
          'user-3',
          'user-1',
          'user-2',
        ]);
      });
    });

    group('updateCustomAmount', () {
      test('adds custom amount for user', () {
        final form = ShareCreateForm.initial();
        final updated = form.updateCustomAmount('user-1', '25.00');

        expect(updated.customAmountInputs['user-1'], '25.00');
      });

      test('removes custom amount when empty string provided', () {
        final form = ShareCreateForm.initial().copyWith(
          customAmountInputs: {'user-1': '25.00'},
        );
        final updated = form.updateCustomAmount('user-1', '');

        expect(updated.customAmountInputs, isNot(contains('user-1')));
      });

      test('updates existing custom amount', () {
        final form = ShareCreateForm.initial().copyWith(
          customAmountInputs: {'user-1': '25.00'},
        );
        final updated = form.updateCustomAmount('user-1', '50.00');

        expect(updated.customAmountInputs['user-1'], '50.00');
      });
    });

    group('selectAll', () {
      test('sets all provided participant IDs', () {
        final form = ShareCreateForm.initial();
        final updated = form.selectAll(['user-1', 'user-2', 'user-3']);

        expect(updated.selectedParticipantIds, {'user-1', 'user-2', 'user-3'});
      });

      test('replaces existing selection', () {
        final form = ShareCreateForm.initial().copyWith(
          selectedParticipantIds: {'old-user'},
        );
        final updated = form.selectAll(['new-user']);

        expect(updated.selectedParticipantIds, {'new-user'});
        expect(updated.selectedParticipantIds, isNot(contains('old-user')));
      });
    });

    group('isRecurring', () {
      test('returns false when recurrenceEvery is null', () {
        final form = ShareCreateForm.initial().copyWith(
          recurrenceUnit: ExpenseRecurrenceUnit.month,
        );
        expect(form.isRecurring, isFalse);
      });

      test('returns false when recurrenceUnit is null', () {
        final form = ShareCreateForm.initial().copyWith(recurrenceEvery: 1);
        expect(form.isRecurring, isFalse);
      });

      test('returns true when both recurrence fields are set', () {
        final form = ShareCreateForm.initial().copyWith(
          recurrenceEvery: 2,
          recurrenceUnit: ExpenseRecurrenceUnit.week,
        );
        expect(form.isRecurring, isTrue);
      });
    });

    group('customAmountFor', () {
      test('returns amount for existing user', () {
        final form = ShareCreateForm.initial().copyWith(
          customAmountInputs: {'user-1': '15.00'},
        );
        expect(form.customAmountFor('user-1'), '15.00');
      });

      test('returns empty string for non-existent user', () {
        final form = ShareCreateForm.initial();
        expect(form.customAmountFor('unknown'), '');
      });
    });
  });
}
