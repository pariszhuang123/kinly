import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/contracts/share/models.dart';
import 'package:kinly/contracts/expenses/models.dart';

void main() {
  group('TodayShareOwedItem', () {
    final expenseOwedItem = ExpenseOwedItem(
      expenseId: 'exp-1',
      description: 'Groceries',
      amountCents: 2500,
      recurrenceEvery: 1,
      recurrenceUnit: ExpenseRecurrenceUnit.month,
      startDate: DateTime.utc(2024, 6, 1),
      notes: 'Weekly shop',
      evidencePhotoPath: 'households/home-1/share/expenses/exp-1.jpg',
    );

    test('fromModel maps all fields', () {
      final result = TodayShareOwedItem.fromModel(expenseOwedItem);
      expect(result.expenseId, 'exp-1');
      expect(result.description, 'Groceries');
      expect(result.amountCents, 2500);
      expect(result.recurrenceEvery, 1);
      expect(result.recurrenceUnit, ExpenseRecurrenceUnit.month);
      expect(result.startDate, DateTime.utc(2024, 6, 1));
      expect(result.notes, 'Weekly shop');
      expect(
        result.evidencePhotoPath,
        'households/home-1/share/expenses/exp-1.jpg',
      );
    });

    test('fromModel handles null optional fields', () {
      final itemWithNulls = ExpenseOwedItem(
        expenseId: 'exp-2',
        description: 'One-time',
        amountCents: 1000,
        recurrenceEvery: null,
        recurrenceUnit: null,
        startDate: DateTime.utc(2024, 6, 1),
        notes: null,
        evidencePhotoPath: null,
      );
      final result = TodayShareOwedItem.fromModel(itemWithNulls);
      expect(result.recurrenceEvery, isNull);
      expect(result.recurrenceUnit, isNull);
      expect(result.notes, isNull);
      expect(result.evidencePhotoPath, isNull);
    });

    test('props contains all fields', () {
      final item = TodayShareOwedItem.fromModel(expenseOwedItem);
      expect(item.props, hasLength(16));
      expect(item.props, contains('exp-1'));
      expect(item.props, contains('Groceries'));
      expect(item.props, contains(2500));
    });

    test('equality works', () {
      final a = TodayShareOwedItem.fromModel(expenseOwedItem);
      final b = TodayShareOwedItem.fromModel(expenseOwedItem);
      expect(a, equals(b));
    });
  });

  group('TodayShareOwed', () {
    final owedItem = ExpenseOwedItem(
      expenseId: 'exp-1',
      description: 'Groceries',
      amountCents: 2500,
      recurrenceEvery: null,
      recurrenceUnit: null,
      startDate: DateTime.utc(2024, 6, 1),
      notes: null,
      evidencePhotoPath: null,
    );

    final owedGroup = ExpenseOwedGroup(
      payerUserId: 'user-a',
      payerDisplay: 'Alice',
      payerAvatarUrl: 'https://example.com/alice.png',
      totalOwedCents: 5000,
      items: [owedItem],
    );

    test('fromModel maps all fields', () {
      final result = TodayShareOwed.fromModel(owedGroup);
      expect(result.payerUserId, 'user-a');
      expect(result.displayName, 'Alice');
      expect(result.avatarUrl, 'https://example.com/alice.png');
      expect(result.totalOwedCents, 5000);
      expect(result.items, hasLength(1));
      expect(result.isOwner, isFalse);
    });

    test('fromModel sets isOwner true when matching ownerUserId', () {
      final result = TodayShareOwed.fromModel(owedGroup, ownerUserId: 'user-a');
      expect(result.isOwner, isTrue);
    });

    test('fromModel sets isOwner false when non-matching ownerUserId', () {
      final result = TodayShareOwed.fromModel(owedGroup, ownerUserId: 'user-b');
      expect(result.isOwner, isFalse);
    });

    test('props equality works', () {
      final a = TodayShareOwed.fromModel(owedGroup);
      final b = TodayShareOwed.fromModel(owedGroup);
      expect(a, equals(b));
    });
  });

  group('TodayShareDraft', () {
    final summary = ExpenseCreatedSummary(
      expenseId: 'exp-draft-1',
      homeId: 'home-1',
      createdByUserId: 'user-c',
      description: 'Draft expense',
      amountCents: 3000,
      status: ExpenseStatus.draft,
      totalShares: 2,
      paidShares: 0,
      paidAmountCents: 0,
      allPaid: false,
      createdAt: DateTime.utc(2024, 6, 15, 10, 30),
      recurrenceEvery: null,
      recurrenceUnit: null,
      startDate: DateTime.utc(2024, 6, 1),
    );

    test('fromSummary maps all fields', () {
      final result = TodayShareDraft.fromSummary(summary);
      expect(result.expenseId, 'exp-draft-1');
      expect(result.description, 'Draft expense');
      expect(result.amountCents, 3000);
      expect(result.createdAt, DateTime.utc(2024, 6, 15, 10, 30));
      expect(result.createdByUserId, 'user-c');
    });

    test('props equality works', () {
      final a = TodayShareDraft.fromSummary(summary);
      final b = TodayShareDraft.fromSummary(summary);
      expect(a, equals(b));
    });

    test('props contains all fields', () {
      final draft = TodayShareDraft.fromSummary(summary);
      expect(draft.props, hasLength(5));
    });
  });

  group('TodaySharePaidToMe', () {
    final paidModel = ExpensePaidToMeDebtor(
      debtorUserId: 'user-d',
      debtorUsername: 'David',
      debtorAvatarUrl: 'https://example.com/david.png',
      isOwner: true,
      totalPaidCents: 7500,
      unseenCount: 3,
      latestPaidAt: DateTime.utc(2024, 6, 20, 14, 0),
    );

    test('fromModel maps all fields', () {
      final result = TodaySharePaidToMe.fromModel(paidModel);
      expect(result.debtorUserId, 'user-d');
      expect(result.debtorUsername, 'David');
      expect(result.debtorAvatarUrl, 'https://example.com/david.png');
      expect(result.isOwner, isTrue);
      expect(result.totalPaidCents, 7500);
      expect(result.unseenCount, 3);
      expect(result.latestPaidAt, DateTime.utc(2024, 6, 20, 14, 0));
    });

    test('fromModel handles null optional fields', () {
      final modelWithNulls = ExpensePaidToMeDebtor(
        debtorUserId: 'user-e',
        debtorUsername: 'Eve',
        debtorAvatarUrl: null,
        isOwner: false,
        totalPaidCents: 1000,
        unseenCount: 0,
        latestPaidAt: null,
      );
      final result = TodaySharePaidToMe.fromModel(modelWithNulls);
      expect(result.debtorAvatarUrl, isNull);
      expect(result.latestPaidAt, isNull);
    });

    test('props equality works', () {
      final a = TodaySharePaidToMe.fromModel(paidModel);
      final b = TodaySharePaidToMe.fromModel(paidModel);
      expect(a, equals(b));
    });

    test('props contains all fields', () {
      final paid = TodaySharePaidToMe.fromModel(paidModel);
      expect(paid.props, hasLength(7));
    });
  });
}
