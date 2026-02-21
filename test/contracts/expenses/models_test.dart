import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/contracts/expenses/models.dart';

void main() {
  group('Expense.fromJson', () {
    test('parses complete expense with snake_case keys', () {
      final json = {
        'id': 'exp-123',
        'home_id': 'home-456',
        'created_by_user_id': 'user-789',
        'status': 'active',
        'split_type': 'equal',
        'amount_cents': 5000,
        'description': 'Groceries',
        'notes': 'Weekly shopping',
        'created_at': '2024-01-15T10:30:00Z',
        'updated_at': '2024-01-16T10:30:00Z',
        'start_date': '2024-01-15',
        'recurrence_every': 1,
        'recurrence_unit': 'week',
        'plan_id': 'plan-111',
        'fully_paid_at': '2024-01-20T10:30:00Z',
        'evidence_photo_path': 'households/home-456/share/photo.jpg',
      };
      final result = Expense.fromJson(json);

      expect(result.id, 'exp-123');
      expect(result.homeId, 'home-456');
      expect(result.createdByUserId, 'user-789');
      expect(result.status, ExpenseStatus.active);
      expect(result.splitType, ExpenseSplitType.equal);
      expect(result.amountCents, 5000);
      expect(result.description, 'Groceries');
      expect(result.notes, 'Weekly shopping');
      expect(result.recurrenceEvery, 1);
      expect(result.recurrenceUnit, ExpenseRecurrenceUnit.week);
      expect(result.planId, 'plan-111');
      expect(result.fullyPaidAt, isNotNull);
      expect(
        result.evidencePhotoPath,
        'households/home-456/share/photo.jpg',
      );
    });

    test('parses with camelCase keys', () {
      final json = {
        'id': 'exp-123',
        'homeId': 'home-456',
        'createdByUserId': 'user-789',
        'status': 'draft',
        'splitType': 'custom',
        'amountCents': 3000,
        'description': 'Utilities',
        'createdAt': '2024-01-15T10:30:00Z',
        'updatedAt': '2024-01-16T10:30:00Z',
        'startDate': '2024-01-15',
        'recurrenceEvery': 2,
        'recurrenceUnit': 'month',
        'planId': 'plan-222',
        'evidencePhotoPath': 'households/home-456/share/photo-2.jpg',
      };
      final result = Expense.fromJson(json);

      expect(result.homeId, 'home-456');
      expect(result.createdByUserId, 'user-789');
      expect(result.status, ExpenseStatus.draft);
      expect(result.splitType, ExpenseSplitType.custom);
      expect(result.amountCents, 3000);
      expect(result.recurrenceEvery, 2);
      expect(result.recurrenceUnit, ExpenseRecurrenceUnit.month);
      expect(result.planId, 'plan-222');
      expect(
        result.evidencePhotoPath,
        'households/home-456/share/photo-2.jpg',
      );
    });

    test('handles null split_type', () {
      final json = {
        'id': 'exp-123',
        'home_id': 'home-456',
        'created_by_user_id': 'user-789',
        'status': 'draft',
        'split_type': null,
        'amount_cents': 1000,
        'description': 'Test',
        'created_at': '2024-01-15T10:30:00Z',
        'updated_at': '2024-01-16T10:30:00Z',
        'start_date': '2024-01-15',
      };
      final result = Expense.fromJson(json);

      expect(result.splitType, isNull);
    });

    test('handles missing amount_cents defaults to 0', () {
      final json = {
        'id': 'exp-123',
        'home_id': 'home-456',
        'created_by_user_id': 'user-789',
        'status': 'draft',
        'description': 'Test',
        'created_at': '2024-01-15T10:30:00Z',
        'updated_at': '2024-01-16T10:30:00Z',
        'start_date': '2024-01-15',
      };
      final result = Expense.fromJson(json);

      expect(result.amountCents, 0);
    });

    test('parses recurrence from legacy interval field', () {
      final json = {
        'id': 'exp-123',
        'home_id': 'home-456',
        'created_by_user_id': 'user-789',
        'status': 'active',
        'amount_cents': 1000,
        'description': 'Test',
        'created_at': '2024-01-15T10:30:00Z',
        'updated_at': '2024-01-16T10:30:00Z',
        'start_date': '2024-01-15',
        'recurrence_interval': 'monthly',
      };
      final result = Expense.fromJson(json);

      expect(result.recurrenceEvery, 1);
      expect(result.recurrenceUnit, ExpenseRecurrenceUnit.month);
    });
  });

  group('ExpenseSplit.fromJson', () {
    test('parses complete split', () {
      final json = {
        'expense_id': 'exp-123',
        'debtor_user_id': 'user-456',
        'amount_cents': 2500,
        'status': 'unpaid',
        'marked_paid_at': null,
      };
      final result = ExpenseSplit.fromJson(json);

      expect(result.expenseId, 'exp-123');
      expect(result.debtorUserId, 'user-456');
      expect(result.amountCents, 2500);
      expect(result.status, ExpenseShareStatus.unpaid);
      expect(result.markedPaidAt, isNull);
    });

    test('parses paid split', () {
      final json = {
        'expense_id': 'exp-123',
        'debtor_user_id': 'user-456',
        'amount_cents': 2500,
        'status': 'paid',
        'marked_paid_at': '2024-01-20T10:30:00Z',
      };
      final result = ExpenseSplit.fromJson(json);

      expect(result.status, ExpenseShareStatus.paid);
      expect(result.markedPaidAt, isNotNull);
    });

    test('parses with camelCase keys', () {
      final json = {
        'expenseId': 'exp-123',
        'debtorUserId': 'user-456',
        'amountCents': 1500,
        'status': 'unpaid',
        'markedPaidAt': null,
      };
      final result = ExpenseSplit.fromJson(json);

      expect(result.expenseId, 'exp-123');
      expect(result.debtorUserId, 'user-456');
      expect(result.amountCents, 1500);
    });
  });

  group('ExpenseForEdit.fromJson', () {
    test('parses expense with splits', () {
      final json = {
        'id': 'exp-123',
        'home_id': 'home-456',
        'created_by_user_id': 'user-789',
        'status': 'active',
        'split_type': 'equal',
        'amount_cents': 6000,
        'description': 'Rent',
        'created_at': '2024-01-15T10:30:00Z',
        'updated_at': '2024-01-16T10:30:00Z',
        'start_date': '2024-01-15',
        'splits': [
          {
            'expense_id': 'exp-123',
            'debtor_user_id': 'user-111',
            'amount_cents': 2000,
            'status': 'unpaid',
          },
          {
            'expense_id': 'exp-123',
            'debtor_user_id': 'user-222',
            'amount_cents': 2000,
            'status': 'paid',
            'marked_paid_at': '2024-01-18T10:30:00Z',
          },
        ],
        'amount_locked': true,
        'canEdit': false,
        'editDisabledReason': 'Has paid splits',
        'planStatus': 'active',
      };
      final result = ExpenseForEdit.fromJson(json);

      expect(result.expense.id, 'exp-123');
      expect(result.splits.length, 2);
      expect(result.splits[0].amountCents, 2000);
      expect(result.splits[1].status, ExpenseShareStatus.paid);
      expect(result.amountLocked, true);
      expect(result.canEdit, false);
      expect(result.editDisabledReason, 'Has paid splits');
      expect(result.planStatus, 'active');
    });

    test('handles null splits', () {
      final json = {
        'id': 'exp-123',
        'home_id': 'home-456',
        'created_by_user_id': 'user-789',
        'status': 'draft',
        'amount_cents': 1000,
        'description': 'Test',
        'created_at': '2024-01-15T10:30:00Z',
        'updated_at': '2024-01-16T10:30:00Z',
        'start_date': '2024-01-15',
        'splits': null,
      };
      final result = ExpenseForEdit.fromJson(json);

      expect(result.splits, isEmpty);
      expect(result.amountLocked, false);
      expect(result.canEdit, true);
    });
  });

  group('ExpenseOwedGroup.fromJson', () {
    test('parses group with items', () {
      final json = {
        'payerUserId': 'user-123',
        'payerDisplay': 'Alice',
        'payerAvatarUrl': 'https://example.com/avatar.png',
        'totalOwedCents': 5000,
        'items': [
          {
            'expenseId': 'exp-111',
            'description': 'Groceries',
            'amountCents': 2500,
            'startDate': '2024-01-15',
            'evidencePhotoPath': 'households/home-1/share/expenses/exp-111.jpg',
          },
          {
            'expenseId': 'exp-222',
            'description': 'Utilities',
            'amountCents': 2500,
            'startDate': '2024-01-20',
          },
        ],
      };
      final result = ExpenseOwedGroup.fromJson(json);

      expect(result.payerUserId, 'user-123');
      expect(result.payerDisplay, 'Alice');
      expect(result.payerAvatarUrl, 'https://example.com/avatar.png');
      expect(result.totalOwedCents, 5000);
      expect(result.items.length, 2);
      expect(result.items[0].description, 'Groceries');
      expect(
        result.items[0].evidencePhotoPath,
        'households/home-1/share/expenses/exp-111.jpg',
      );
    });

    test('handles missing items', () {
      final json = {
        'payerUserId': 'user-123',
        'payerDisplay': 'Bob',
        'totalOwedCents': 0,
      };
      final result = ExpenseOwedGroup.fromJson(json);

      expect(result.items, isEmpty);
    });
  });

  group('ExpensePaidToMeDebtor.fromJson', () {
    test('parses complete debtor', () {
      final json = {
        'debtorUserId': 'user-123',
        'debtorUsername': 'alice',
        'debtorAvatarUrl': 'https://example.com/avatar.png',
        'isOwner': true,
        'totalPaidCents': 5000,
        'unseenCount': 2,
        'latestPaidAt': '2024-01-20T10:30:00Z',
      };
      final result = ExpensePaidToMeDebtor.fromJson(json);

      expect(result.debtorUserId, 'user-123');
      expect(result.debtorUsername, 'alice');
      expect(result.debtorAvatarUrl, 'https://example.com/avatar.png');
      expect(result.isOwner, true);
      expect(result.totalPaidCents, 5000);
      expect(result.unseenCount, 2);
      expect(result.latestPaidAt, isNotNull);
    });

    test('handles missing optional fields', () {
      final json = {'debtorUserId': 'user-123'};
      final result = ExpensePaidToMeDebtor.fromJson(json);

      expect(result.debtorUsername, '');
      expect(result.debtorAvatarUrl, isNull);
      expect(result.isOwner, false);
      expect(result.totalPaidCents, 0);
      expect(result.unseenCount, 0);
      expect(result.latestPaidAt, isNull);
    });
  });

  group('ExpensePaidToMeItem.fromJson', () {
    test('parses notes and evidence photo path', () {
      final json = {
        'expenseId': 'exp-1',
        'description': 'Dinner',
        'amountCents': 1800,
        'markedPaidAt': '2024-01-20T10:30:00Z',
        'recurrenceEvery': 1,
        'recurrenceUnit': 'week',
        'startDate': '2024-01-15',
        'notes': 'Paid in cash',
        'evidencePhotoPath': 'households/home-1/share/expenses/exp-1.jpg',
      };
      final result = ExpensePaidToMeItem.fromJson(json);

      expect(result.expenseId, 'exp-1');
      expect(result.notes, 'Paid in cash');
      expect(
        result.evidencePhotoPath,
        'households/home-1/share/expenses/exp-1.jpg',
      );
    });
  });

  group('ExpensesPayMyDueResult.fromJson', () {
    test('parses complete result', () {
      final json = {
        'recipientUserId': 'user-123',
        'splitsPaid': 3,
        'expensesTouched': 2,
        'expensesNewlyFullyPaid': 1,
      };
      final result = ExpensesPayMyDueResult.fromJson(json);

      expect(result.recipientUserId, 'user-123');
      expect(result.splitsPaid, 3);
      expect(result.expensesTouched, 2);
      expect(result.expensesNewlyFullyPaid, 1);
    });

    test('handles missing counts', () {
      final json = {'recipientUserId': 'user-123'};
      final result = ExpensesPayMyDueResult.fromJson(json);

      expect(result.splitsPaid, 0);
      expect(result.expensesTouched, 0);
      expect(result.expensesNewlyFullyPaid, 0);
    });
  });
}
