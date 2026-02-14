import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/contracts/expenses/models.dart';
import 'package:kinly/features/share/ui/share_edit_provider.dart';

void main() {
  ExpenseForEdit buildDetail({
    required ExpenseStatus status,
    String? planId,
    int? recurrenceEvery,
    ExpenseRecurrenceUnit? recurrenceUnit,
    bool canEdit = true,
    bool amountLocked = false,
    String? editDisabledReason,
  }) {
    final now = DateTime(2026, 1, 1);
    return ExpenseForEdit(
      expense: Expense(
        id: 'expense-1',
        homeId: 'home-1',
        createdByUserId: 'user-1',
        status: status,
        splitType: ExpenseSplitType.equal,
        amountCents: 1200,
        description: 'Lunch',
        notes: 'Context',
        createdAt: now,
        updatedAt: now,
        planId: planId,
        recurrenceEvery: recurrenceEvery,
        recurrenceUnit: recurrenceUnit,
        startDate: now,
      ),
      splits: const <ExpenseSplit>[],
      amountLocked: amountLocked,
      canEdit: canEdit,
      editDisabledReason: editDisabledReason,
      planStatus: null,
    );
  }

  group('resolveShareEditConstraints', () {
    test('allows active one-off edit for name and context only', () {
      final detail = buildDetail(
        status: ExpenseStatus.active,
        canEdit: false,
        amountLocked: false,
        editDisabledReason: 'ACTIVE_IMMUTABLE',
      );

      final result = resolveShareEditConstraints(detail);

      expect(result.canEdit, isTrue);
      expect(result.amountLocked, isTrue);
      expect(result.editDisabledReason, isNull);
    });

    test('blocks active recurring edits entirely', () {
      final detail = buildDetail(
        status: ExpenseStatus.active,
        planId: 'plan-1',
        recurrenceEvery: 1,
        recurrenceUnit: ExpenseRecurrenceUnit.week,
        canEdit: true,
      );

      final result = resolveShareEditConstraints(detail);

      expect(result.canEdit, isFalse);
      expect(result.amountLocked, isTrue);
      expect(result.editDisabledReason, 'RECURRING_CYCLE_IMMUTABLE');
    });

    test('keeps server constraints for non-active records', () {
      final detail = buildDetail(
        status: ExpenseStatus.draft,
        canEdit: true,
        amountLocked: false,
        editDisabledReason: null,
      );

      final result = resolveShareEditConstraints(detail);

      expect(result.canEdit, isTrue);
      expect(result.amountLocked, isFalse);
      expect(result.editDisabledReason, isNull);
    });
  });
}
