import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/contracts/expenses/models.dart';
import 'package:kinly/contracts/share/ports/expenses_repository.dart';
import 'package:kinly/features/share/bloc/share_created_list_bloc/share_created_list_bloc.dart';

class _MockExpensesRepository extends Mock implements ExpensesRepository {}

void main() {
  late _MockExpensesRepository expensesRepository;

  const homeId = 'home-123';

  ExpenseCreatedSummary createSummary({
    required String id,
    required ExpenseStatus status,
    required DateTime createdAt,
  }) {
    return ExpenseCreatedSummary(
      expenseId: id,
      homeId: homeId,
      createdByUserId: 'user-1',
      description: 'Expense $id',
      amountCents: 1000,
      status: status,
      totalShares: 2,
      paidShares: 1,
      paidAmountCents: 500,
      allPaid: false,
      createdAt: createdAt,
      recurrenceEvery: null,
      recurrenceUnit: null,
      startDate: DateTime(2024, 1, 1),
    );
  }

  ShareCreatedListBloc buildBloc({bool draftsOnly = false}) {
    return ShareCreatedListBloc(
      expensesRepository: expensesRepository,
      homeId: homeId,
      draftsOnly: draftsOnly,
    );
  }

  setUp(() {
    expensesRepository = _MockExpensesRepository();
    when(
      () => expensesRepository.listCreatedByMe(homeId: any(named: 'homeId')),
    ).thenAnswer((_) async => []);
  });

  group('ShareCreatedListBloc', () {
    test('initial state is ShareCreatedListStatus.initial', () {
      final bloc = buildBloc();
      expect(bloc.state.status, ShareCreatedListStatus.initial);
      expect(bloc.state.entries, isEmpty);
      expect(bloc.state.isRefreshing, isFalse);
      expect(bloc.state.errorMessage, isNull);
      bloc.close();
    });

    group('ShareCreatedListRequested', () {
      blocTest<ShareCreatedListBloc, ShareCreatedListState>(
        'emits loading then success with entries',
        build: () {
          when(
            () => expensesRepository.listCreatedByMe(homeId: homeId),
          ).thenAnswer(
            (_) async => [
              createSummary(
                id: '1',
                status: ExpenseStatus.active,
                createdAt: DateTime(2024, 1, 1),
              ),
              createSummary(
                id: '2',
                status: ExpenseStatus.draft,
                createdAt: DateTime(2024, 1, 2),
              ),
            ],
          );
          return buildBloc();
        },
        act: (bloc) => bloc.add(const ShareCreatedListRequested()),
        expect:
            () => [
              isA<ShareCreatedListState>().having(
                (s) => s.status,
                'status',
                ShareCreatedListStatus.loading,
              ),
              isA<ShareCreatedListState>()
                  .having(
                    (s) => s.status,
                    'status',
                    ShareCreatedListStatus.success,
                  )
                  .having((s) => s.entries.length, 'entries.length', 2)
                  .having((s) => s.isRefreshing, 'isRefreshing', false),
            ],
        verify: (_) {
          verify(
            () => expensesRepository.listCreatedByMe(homeId: homeId),
          ).called(1);
        },
      );

      blocTest<ShareCreatedListBloc, ShareCreatedListState>(
        'filters out cancelled expenses',
        build: () {
          when(
            () => expensesRepository.listCreatedByMe(homeId: homeId),
          ).thenAnswer(
            (_) async => [
              createSummary(
                id: '1',
                status: ExpenseStatus.active,
                createdAt: DateTime(2024, 1, 1),
              ),
              createSummary(
                id: '2',
                status: ExpenseStatus.cancelled,
                createdAt: DateTime(2024, 1, 2),
              ),
            ],
          );
          return buildBloc();
        },
        act: (bloc) => bloc.add(const ShareCreatedListRequested()),
        expect:
            () => [
              isA<ShareCreatedListState>(),
              isA<ShareCreatedListState>()
                  .having((s) => s.entries.length, 'entries.length', 1)
                  .having(
                    (s) => s.entries.first.expenseId,
                    'first.expenseId',
                    '1',
                  ),
            ],
      );

      blocTest<ShareCreatedListBloc, ShareCreatedListState>(
        'draftsOnly filters to drafts only',
        build: () {
          when(
            () => expensesRepository.listCreatedByMe(homeId: homeId),
          ).thenAnswer(
            (_) async => [
              createSummary(
                id: '1',
                status: ExpenseStatus.active,
                createdAt: DateTime(2024, 1, 1),
              ),
              createSummary(
                id: '2',
                status: ExpenseStatus.draft,
                createdAt: DateTime(2024, 1, 2),
              ),
            ],
          );
          return buildBloc(draftsOnly: true);
        },
        act: (bloc) => bloc.add(const ShareCreatedListRequested()),
        expect:
            () => [
              isA<ShareCreatedListState>(),
              isA<ShareCreatedListState>()
                  .having((s) => s.entries.length, 'entries.length', 1)
                  .having(
                    (s) => s.entries.first.expenseId,
                    'first.expenseId',
                    '2',
                  ),
            ],
      );

      blocTest<ShareCreatedListBloc, ShareCreatedListState>(
        'sorts entries by createdAt descending',
        build: () {
          when(
            () => expensesRepository.listCreatedByMe(homeId: homeId),
          ).thenAnswer(
            (_) async => [
              createSummary(
                id: '1',
                status: ExpenseStatus.active,
                createdAt: DateTime(2024, 1, 1),
              ),
              createSummary(
                id: '3',
                status: ExpenseStatus.active,
                createdAt: DateTime(2024, 1, 3),
              ),
              createSummary(
                id: '2',
                status: ExpenseStatus.active,
                createdAt: DateTime(2024, 1, 2),
              ),
            ],
          );
          return buildBloc();
        },
        act: (bloc) => bloc.add(const ShareCreatedListRequested()),
        expect:
            () => [
              isA<ShareCreatedListState>(),
              isA<ShareCreatedListState>().having(
                (s) => s.entries.map((e) => e.expenseId).toList(),
                'sorted order',
                ['3', '2', '1'],
              ),
            ],
      );

      blocTest<ShareCreatedListBloc, ShareCreatedListState>(
        'emits failure on repository error',
        build: () {
          when(
            () => expensesRepository.listCreatedByMe(homeId: homeId),
          ).thenThrow(Exception('Network error'));
          return buildBloc();
        },
        act: (bloc) => bloc.add(const ShareCreatedListRequested()),
        expect:
            () => [
              isA<ShareCreatedListState>().having(
                (s) => s.status,
                'status',
                ShareCreatedListStatus.loading,
              ),
              isA<ShareCreatedListState>()
                  .having(
                    (s) => s.status,
                    'status',
                    ShareCreatedListStatus.failure,
                  )
                  .having(
                    (s) => s.errorMessage,
                    'errorMessage',
                    contains('Network error'),
                  ),
            ],
      );
    });

    group('ShareCreatedListRefreshed', () {
      blocTest<ShareCreatedListBloc, ShareCreatedListState>(
        'emits isRefreshing then success',
        build: () {
          when(
            () => expensesRepository.listCreatedByMe(homeId: homeId),
          ).thenAnswer(
            (_) async => [
              createSummary(
                id: '1',
                status: ExpenseStatus.active,
                createdAt: DateTime(2024, 1, 1),
              ),
            ],
          );
          return buildBloc();
        },
        act: (bloc) => bloc.add(const ShareCreatedListRefreshed()),
        expect:
            () => [
              isA<ShareCreatedListState>().having(
                (s) => s.isRefreshing,
                'isRefreshing',
                true,
              ),
              isA<ShareCreatedListState>()
                  .having(
                    (s) => s.status,
                    'status',
                    ShareCreatedListStatus.success,
                  )
                  .having((s) => s.isRefreshing, 'isRefreshing', false),
            ],
      );

      blocTest<ShareCreatedListBloc, ShareCreatedListState>(
        'does not emit refreshing if already refreshing',
        build: buildBloc,
        seed: () => const ShareCreatedListState(isRefreshing: true),
        act: (bloc) => bloc.add(const ShareCreatedListRefreshed()),
        expect:
            () => [
              isA<ShareCreatedListState>()
                  .having(
                    (s) => s.status,
                    'status',
                    ShareCreatedListStatus.success,
                  )
                  .having((s) => s.isRefreshing, 'isRefreshing', false),
            ],
      );

      blocTest<ShareCreatedListBloc, ShareCreatedListState>(
        'emits failure on refresh error',
        build: () {
          when(
            () => expensesRepository.listCreatedByMe(homeId: homeId),
          ).thenThrow(Exception('Refresh failed'));
          return buildBloc();
        },
        act: (bloc) => bloc.add(const ShareCreatedListRefreshed()),
        expect:
            () => [
              isA<ShareCreatedListState>().having(
                (s) => s.isRefreshing,
                'isRefreshing',
                true,
              ),
              isA<ShareCreatedListState>()
                  .having(
                    (s) => s.status,
                    'status',
                    ShareCreatedListStatus.failure,
                  )
                  .having((s) => s.isRefreshing, 'isRefreshing', false)
                  .having(
                    (s) => s.errorMessage,
                    'errorMessage',
                    contains('Refresh failed'),
                  ),
            ],
      );
    });
  });

  group('ShareCreatedListState', () {
    test('copyWith clearError removes errorMessage', () {
      const state = ShareCreatedListState(errorMessage: 'Some error');
      final cleared = state.copyWith(clearError: true);
      expect(cleared.errorMessage, isNull);
    });

    test('copyWith preserves other values', () {
      const state = ShareCreatedListState(
        status: ShareCreatedListStatus.success,
        isRefreshing: true,
      );
      final copied = state.copyWith(status: ShareCreatedListStatus.failure);
      expect(copied.status, ShareCreatedListStatus.failure);
      expect(copied.isRefreshing, isTrue);
    });
  });

  group('ShareCreatedListEntry', () {
    final testDate = DateTime(2024, 1, 1);

    test('isActive returns true for active status', () {
      final entry = ShareCreatedListEntry(
        expenseId: '1',
        description: 'Test',
        amountCents: 1000,
        totalShares: 2,
        paidShares: 1,
        paidAmountCents: 500,
        status: ExpenseStatus.active,
        createdAt: testDate,
        recurrenceEvery: null,
        recurrenceUnit: null,
        startDate: testDate,
      );
      expect(entry.isActive, isTrue);
      expect(entry.isDraft, isFalse);
    });

    test('isDraft returns true for draft status', () {
      final entry = ShareCreatedListEntry(
        expenseId: '1',
        description: 'Test',
        amountCents: 1000,
        totalShares: 2,
        paidShares: 1,
        paidAmountCents: 500,
        status: ExpenseStatus.draft,
        createdAt: testDate,
        recurrenceEvery: null,
        recurrenceUnit: null,
        startDate: testDate,
      );
      expect(entry.isDraft, isTrue);
      expect(entry.isActive, isFalse);
    });

    test('isRecurring returns true when both recurrence fields set', () {
      final entry = ShareCreatedListEntry(
        expenseId: '1',
        description: 'Test',
        amountCents: 1000,
        totalShares: 2,
        paidShares: 1,
        paidAmountCents: 500,
        status: ExpenseStatus.active,
        createdAt: testDate,
        recurrenceEvery: 1,
        recurrenceUnit: ExpenseRecurrenceUnit.month,
        startDate: testDate,
      );
      expect(entry.isRecurring, isTrue);
    });

    test('isRecurring returns false when recurrenceEvery is null', () {
      final entry = ShareCreatedListEntry(
        expenseId: '1',
        description: 'Test',
        amountCents: 1000,
        totalShares: 2,
        paidShares: 1,
        paidAmountCents: 500,
        status: ExpenseStatus.active,
        createdAt: testDate,
        recurrenceEvery: null,
        recurrenceUnit: ExpenseRecurrenceUnit.month,
        startDate: testDate,
      );
      expect(entry.isRecurring, isFalse);
    });
  });
}
