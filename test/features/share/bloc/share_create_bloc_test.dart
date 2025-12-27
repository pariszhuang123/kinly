import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/core/expenses/models.dart';
import 'package:kinly/core/homes/models.dart';
import 'package:kinly/core/supabase/supabase_error_mapper.dart';
import 'package:kinly/data/repositories/expenses_repository.dart';
import 'package:kinly/data/repositories/home_repository.dart';
import 'package:kinly/features/share/bloc/share_create_bloc/share_create_bloc.dart';
import 'package:kinly/features/share/domain/share_create_form.dart';
import 'package:kinly/features/share/domain/share_participant.dart';
import 'package:kinly/features/share/domain/share_split_mode.dart';

class _MockExpensesRepository extends Mock implements ExpensesRepository {}

class _MockHomeRepository extends Mock implements HomeRepository {}

void main() {
  late _MockExpensesRepository expensesRepository;
  late _MockHomeRepository homeRepository;

  ShareCreateBloc buildBloc({
    ShareCreateForm? initialForm,
    String? editingExpenseId,
    bool isAmountLocked = false,
  }) {
    return ShareCreateBloc(
      homeId: 'home-1',
      expensesRepository: expensesRepository,
      homeRepository: homeRepository,
      initialForm: initialForm,
      editingExpenseId: editingExpenseId,
      amountLocked: isAmountLocked,
    );
  }

  final members = <HomeMemberSummary>[
    HomeMemberSummary(
      userId: 'member_a',
      username: 'Alex',
      role: 'member',
      validFrom: DateTime(2024, 1, 1),
      avatarUrl: 'https://example.com/a.png',
      canTransferTo: false,
    ),
    HomeMemberSummary(
      userId: 'member_b',
      username: 'Sam',
      role: 'member',
      validFrom: DateTime(2024, 1, 1),
      avatarUrl: 'https://example.com/b.png',
      canTransferTo: false,
    ),
    HomeMemberSummary(
      userId: 'member_self',
      username: 'Taylor',
      role: 'owner',
      validFrom: DateTime(2024, 1, 1),
      avatarUrl: 'https://example.com/me.png',
      canTransferTo: false,
    ),
  ];

  ShareCreateState seededState({
    ShareCreateForm? form,
    List<ShareParticipant>? participants,
    bool isEditing = false,
    String? editingExpenseId,
    bool isAmountLocked = false,
  }) {
    final baseParticipants =
        participants ??
        members
            .map(
              (m) => ShareParticipant(
                userId: m.userId,
                displayName: m.username,
                avatarUrl: m.avatarUrl,
                isOwner: m.isOwner,
              ),
            )
            .toList(growable: false);
    final baseForm =
        form ??
        ShareCreateForm.initial().copyWith(
          description: 'Dinner',
          amountInput: '42.00',
          splitMode: ShareSplitMode.equal,
          selectedParticipantIds: {'member_a', 'member_b', 'member_self'},
        );
    return ShareCreateState.initial(
      isEditing: isEditing,
      editingExpenseId: editingExpenseId,
      isAmountLocked: isAmountLocked,
    ).copyWith(
      isLoading: false,
      participants: baseParticipants,
      form: baseForm,
    );
  }

  setUpAll(() {
    registerFallbackValue(ExpenseSplitType.equal);
    registerFallbackValue(<String>[]);
    registerFallbackValue(<ExpenseCustomSplitInput>[]);
    registerFallbackValue(ExpenseRecurrenceInterval.none);
  });

  setUp(() {
    expensesRepository = _MockExpensesRepository();
    homeRepository = _MockHomeRepository();
  });

  blocTest<ShareCreateBloc, ShareCreateState>(
    'loads participants on request',
    build: () => buildBloc(),
    setUp: () {
      when(
        () => homeRepository.listActiveMembers(
          any(),
          excludeSelf: any(named: 'excludeSelf'),
        ),
      ).thenAnswer((_) async => members);
    },
    act: (bloc) => bloc.add(const ShareCreateParticipantsRequested()),
    expect: () {
      final request = ShareCreateState.initial().copyWith(
        isLoading: true,
        clearLoadError: true,
      );
      final loadedForm = ShareCreateForm.initial().copyWith(
        selectedParticipantIds: {'member_a', 'member_b', 'member_self'},
      );
      final loadedParticipants = members
          .map(
            (m) => ShareParticipant(
              userId: m.userId,
              displayName: m.username,
              avatarUrl: m.avatarUrl,
              isOwner: m.isOwner,
            ),
          )
          .toList(growable: false);
      final loaded = request.copyWith(
        isLoading: false,
        participants: loadedParticipants,
        form: loadedForm,
        clearLoadError: true,
      );
      return [request, loaded];
    },
    verify: (_) {
      verify(
        () => homeRepository.listActiveMembers('home-1', excludeSelf: false),
      ).called(1);
    },
  );

  late ShareCreateState draftSeed;
  blocTest<ShareCreateBloc, ShareCreateState>(
    'submits draft without split when no mode chosen',
    build: () => buildBloc(),
    seed: () {
      final form = ShareCreateForm.initial().copyWith(
        description: 'Draft expense',
        amountInput: '',
        selectedParticipantIds: {'member_a', 'member_self'},
      );
      draftSeed = seededState(form: form);
      return draftSeed;
    },
    setUp: () {
      when(
        () => expensesRepository.create(
          homeId: any(named: 'homeId'),
          amountCents: any<int?>(named: 'amountCents'),
          description: any(named: 'description'),
          notes: any(named: 'notes'),
          splitType: any(named: 'splitType'),
          memberIds: any(named: 'memberIds'),
          customSplits: any(named: 'customSplits'),
          recurrence: any(named: 'recurrence'),
          startDate: any(named: 'startDate'),
        ),
      ).thenAnswer(
        (_) async => Expense(
          id: 'expense-draft',
          homeId: 'home-1',
          createdByUserId: 'user-1',
          status: ExpenseStatus.draft,
          splitType: null,
          amountCents: 1200,
          description: 'Draft expense',
          notes: null,
          createdAt: DateTime.now().toUtc(),
          updatedAt: DateTime.now().toUtc(),
          recurrenceInterval: ExpenseRecurrenceInterval.none,
          startDate: DateTime(2024, 1, 1),
          planId: null,
          fullyPaidAt: null,
        ),
      );
    },
    act: (bloc) => bloc.add(const ShareCreateSubmitted()),
    expect: () {
      final submitting = draftSeed.copyWith(
        isSubmitting: true,
        showValidationErrors: true,
        clearSubmissionError: true,
        clearSuccess: true,
      );
      final success = submitting.copyWith(
        isSubmitting: false,
        showValidationErrors: false,
        successExpenseId: 'expense-draft',
      );
      return [submitting, success];
    },
    verify: (_) {
      verify(
        () => expensesRepository.create(
          homeId: 'home-1',
          amountCents: null,
          description: 'Draft expense',
          notes: null,
          splitType: null,
          memberIds: null,
          customSplits: null,
          recurrence: ExpenseRecurrenceInterval.none,
          startDate: any(named: 'startDate'),
        ),
      ).called(1);
    },
  );

  late ShareCreateState emptySeed;
  blocTest<ShareCreateBloc, ShareCreateState>(
    'sets validation flag when inputs missing',
    build: () => buildBloc(),
    seed: () {
      emptySeed = seededState(form: ShareCreateForm.initial());
      return emptySeed;
    },
    act: (bloc) => bloc.add(const ShareCreateSubmitted()),
    expect: () => [emptySeed.copyWith(showValidationErrors: true)],
  );

  late ShareCreateState recurringDraftSeed;
  blocTest<ShareCreateBloc, ShareCreateState>(
    'blocks recurrence selection without split mode',
    build: () => buildBloc(),
    seed: () {
      final form = ShareCreateForm.initial().copyWith(
        description: 'Weekly draft',
        amountInput: '10.00',
        recurrence: ExpenseRecurrenceInterval.weekly,
        splitMode: null,
      );
      recurringDraftSeed = seededState(form: form);
      return recurringDraftSeed;
    },
    act: (bloc) => bloc.add(const ShareCreateSubmitted()),
    expect: () => [recurringDraftSeed.copyWith(showValidationErrors: true)],
    verify: (_) {
      verifyNever(
        () => expensesRepository.create(
          homeId: any(named: 'homeId'),
          amountCents: any<int?>(named: 'amountCents'),
          description: any(named: 'description'),
          notes: any(named: 'notes'),
          splitType: any(named: 'splitType'),
          memberIds: any(named: 'memberIds'),
          customSplits: any(named: 'customSplits'),
          recurrence: any(named: 'recurrence'),
          startDate: any(named: 'startDate'),
        ),
      );
    },
  );

  late ShareCreateState equalSeed;
  blocTest<ShareCreateBloc, ShareCreateState>(
    'submits equal split successfully',
    build: () => buildBloc(),
    seed: () {
      equalSeed = seededState();
      return equalSeed;
    },
    setUp: () {
      when(
        () => expensesRepository.create(
          homeId: any(named: 'homeId'),
          amountCents: any<int?>(named: 'amountCents'),
          description: any(named: 'description'),
          notes: any(named: 'notes'),
          splitType: any(named: 'splitType'),
          memberIds: any(named: 'memberIds'),
          customSplits: any(named: 'customSplits'),
          recurrence: any(named: 'recurrence'),
          startDate: any(named: 'startDate'),
        ),
      ).thenAnswer(
        (_) async => Expense(
          id: 'expense-1',
          homeId: 'home-1',
          createdByUserId: 'user-1',
          status: ExpenseStatus.active,
          splitType: ExpenseSplitType.equal,
          amountCents: 4200,
          description: 'Dinner',
          notes: null,
          createdAt: DateTime.now().toUtc(),
          updatedAt: DateTime.now().toUtc(),
          recurrenceInterval: ExpenseRecurrenceInterval.none,
          startDate: DateTime(2024, 1, 1),
          planId: null,
          fullyPaidAt: null,
        ),
      );
    },
    act: (bloc) => bloc.add(const ShareCreateSubmitted()),
    expect: () {
      final submitting = equalSeed.copyWith(
        isSubmitting: true,
        showValidationErrors: true,
        clearSubmissionError: true,
        clearSuccess: true,
      );
      final success = submitting.copyWith(
        isSubmitting: false,
        showValidationErrors: false,
        successExpenseId: 'expense-1',
      );
      return [submitting, success];
    },
    verify: (_) {
      verify(
        () => expensesRepository.create(
          homeId: 'home-1',
          amountCents: 4200,
          description: 'Dinner',
          notes: null,
          splitType: ExpenseSplitType.equal,
          memberIds: ['member_a', 'member_b', 'member_self'],
          customSplits: null,
          recurrence: ExpenseRecurrenceInterval.none,
          startDate: any(named: 'startDate'),
        ),
      ).called(1);
    },
  );

  late ShareCreateState customSeed;
  blocTest<ShareCreateBloc, ShareCreateState>(
    'prevents submitting when custom split sum mismatches',
    build: () => buildBloc(),
    seed: () {
      final form = ShareCreateForm.initial().copyWith(
        description: 'Supplies',
        amountInput: '10.00',
        splitMode: ShareSplitMode.custom,
        selectedParticipantIds: {'member_a', 'member_b'},
        customAmountInputs: const {'member_a': '4', 'member_b': '3'},
      );
      customSeed = seededState(form: form);
      return customSeed;
    },
    act: (bloc) => bloc.add(const ShareCreateSubmitted()),
    expect: () => [customSeed.copyWith(showValidationErrors: true)],
    verify: (_) {
      verifyNever(
        () => expensesRepository.create(
          homeId: any(named: 'homeId'),
          amountCents: any<int?>(named: 'amountCents'),
          description: any(named: 'description'),
          notes: any(named: 'notes'),
          splitType: any(named: 'splitType'),
          memberIds: any(named: 'memberIds'),
          customSplits: any(named: 'customSplits'),
          recurrence: any(named: 'recurrence'),
          startDate: any(named: 'startDate'),
        ),
      );
    },
  );

  late ShareCreateState errorSeed;
  blocTest<ShareCreateBloc, ShareCreateState>(
    'emits submission error when repository throws',
    build: () => buildBloc(),
    seed: () {
      errorSeed = seededState();
      return errorSeed;
    },
    setUp: () {
      when(
        () => expensesRepository.create(
          homeId: any(named: 'homeId'),
          amountCents: any<int?>(named: 'amountCents'),
          description: any(named: 'description'),
          notes: any(named: 'notes'),
          splitType: any(named: 'splitType'),
          memberIds: any(named: 'memberIds'),
          customSplits: any(named: 'customSplits'),
          recurrence: any(named: 'recurrence'),
          startDate: any(named: 'startDate'),
        ),
      ).thenThrow(
        const ExpenseException(ExpenseErrorCode.invalidAmount, 'invalid'),
      );
    },
    act: (bloc) => bloc.add(const ShareCreateSubmitted()),
    expect: () {
      final submitting = errorSeed.copyWith(
        isSubmitting: true,
        showValidationErrors: true,
        clearSubmissionError: true,
        clearSuccess: true,
      );
      final failure = submitting.copyWith(
        isSubmitting: false,
        submissionErrorCode: ExpenseErrorCode.invalidAmount,
        submissionErrorMessage: 'invalid',
        submissionErrorTick: submitting.submissionErrorTick + 1,
      );
      return [submitting, failure];
    },
  );

  late ShareCreateState editSeed;
  blocTest<ShareCreateBloc, ShareCreateState>(
    'requires split selection when editing',
    build: () => buildBloc(editingExpenseId: 'expense-draft'),
    seed: () {
      final form = ShareCreateForm.initial().copyWith(
        description: 'Draft expense',
        amountInput: '15.00',
      );
      editSeed = seededState(
        form: form,
        isEditing: true,
        editingExpenseId: 'expense-draft',
      );
      return editSeed;
    },
    act: (bloc) => bloc.add(const ShareCreateSubmitted()),
    expect: () => [editSeed.copyWith(showValidationErrors: true)],
  );

  late ShareCreateState editSuccessSeed;
  blocTest<ShareCreateBloc, ShareCreateState>(
    'submits edit via repository when split provided',
    build: () => buildBloc(editingExpenseId: 'expense-draft'),
    seed: () {
      final form = ShareCreateForm.initial().copyWith(
        description: 'Draft expense',
        amountInput: '30.00',
        splitMode: ShareSplitMode.equal,
        selectedParticipantIds: {'member_a', 'member_b'},
      );
      editSuccessSeed = seededState(
        form: form,
        isEditing: true,
        editingExpenseId: 'expense-draft',
      );
      return editSuccessSeed;
    },
    setUp: () {
      when(
        () => expensesRepository.edit(
          expenseId: any(named: 'expenseId'),
          amountCents: any(named: 'amountCents'),
          description: any(named: 'description'),
          notes: any(named: 'notes'),
          splitType: any(named: 'splitType'),
          memberIds: any(named: 'memberIds'),
          customSplits: any(named: 'customSplits'),
          recurrence: any(named: 'recurrence'),
          startDate: any(named: 'startDate'),
        ),
      ).thenAnswer(
        (_) async => Expense(
          id: 'expense-draft',
          homeId: 'home-1',
          createdByUserId: 'user-1',
          status: ExpenseStatus.active,
          splitType: ExpenseSplitType.equal,
          amountCents: 3000,
          description: 'Draft expense',
          notes: null,
          createdAt: DateTime.now().toUtc(),
          updatedAt: DateTime.now().toUtc(),
          recurrenceInterval: ExpenseRecurrenceInterval.none,
          startDate: DateTime(2024, 1, 1),
          planId: null,
          fullyPaidAt: null,
        ),
      );
    },
    act: (bloc) => bloc.add(const ShareCreateSubmitted()),
    expect: () {
      final submitting = editSuccessSeed.copyWith(
        isSubmitting: true,
        showValidationErrors: true,
        clearSubmissionError: true,
        clearSuccess: true,
      );
      final success = submitting.copyWith(
        isSubmitting: false,
        showValidationErrors: false,
        successExpenseId: 'expense-draft',
      );
      return [submitting, success];
    },
    verify: (_) {
    verify(
      () => expensesRepository.edit(
        expenseId: 'expense-draft',
        amountCents: 3000,
        description: 'Draft expense',
          notes: null,
          splitType: ExpenseSplitType.equal,
          memberIds: ['member_a', 'member_b'],
          customSplits: null,
          recurrence: ExpenseRecurrenceInterval.none,
          startDate: any(named: 'startDate'),
        ),
      ).called(1);
    },
  );

  late ShareCreateState deleteSeed;
  blocTest<ShareCreateBloc, ShareCreateState>(
    'deletes draft via repository when requested',
    build: () => buildBloc(editingExpenseId: 'expense-draft'),
    seed: () {
      final form = ShareCreateForm.initial().copyWith(
        description: 'Draft expense',
        amountInput: '0',
      );
      deleteSeed = seededState(
        form: form,
        isEditing: true,
        editingExpenseId: 'expense-draft',
      );
      return deleteSeed;
    },
    setUp: () {
      when(() => expensesRepository.cancel(any())).thenAnswer(
        (_) async => Expense(
          id: 'expense-draft',
          homeId: 'home-1',
          createdByUserId: 'user-1',
          status: ExpenseStatus.draft,
          splitType: null,
          amountCents: 0,
          description: 'Draft expense',
          notes: null,
          createdAt: DateTime.now().toUtc(),
          updatedAt: DateTime.now().toUtc(),
          recurrenceInterval: ExpenseRecurrenceInterval.none,
          startDate: DateTime.now(),
          planId: null,
          fullyPaidAt: null,
        ),
      );
    },
    act: (bloc) => bloc.add(const ShareCreateDeleted()),
    expect: () {
      final deleting = deleteSeed.copyWith(
        isDeleting: true,
        clearDeletionError: true,
      );
      final success = deleting.copyWith(
        isDeleting: false,
        deletionSuccessTick: deleting.deletionSuccessTick + 1,
      );
      return [deleting, success];
    },
    verify: (_) {
      verify(() => expensesRepository.cancel('expense-draft')).called(1);
    },
  );

  late ShareCreateState terminateSeed;
  blocTest<ShareCreateBloc, ShareCreateState>(
    'terminates plan via repository',
    build: () => buildBloc(editingExpenseId: 'expense-plan', initialForm: null),
    seed: () {
      final form = ShareCreateForm.initial().copyWith(
        description: 'Recurring bill',
        amountInput: '30.00',
        splitMode: ShareSplitMode.equal,
        selectedParticipantIds: {'member_a', 'member_b'},
        recurrence: ExpenseRecurrenceInterval.monthly,
      );
      terminateSeed = seededState(
        form: form,
        isEditing: true,
        editingExpenseId: 'expense-plan',
      ).copyWith(planId: 'plan-1', planStatus: 'active');
      return terminateSeed;
    },
    setUp: () {
      when(() => expensesRepository.terminatePlan(any())).thenAnswer(
        (_) async => ExpensePlan(
          id: 'plan-1',
          homeId: 'home-1',
          createdByUserId: 'user-1',
          splitType: ExpenseSplitType.equal,
          amountCents: 3000,
          description: 'Recurring bill',
          recurrenceInterval: ExpenseRecurrenceInterval.monthly,
          startDate: DateTime(2024, 1, 1),
          status: 'terminated',
          terminatedAt: DateTime.now(),
        ),
      );
    },
    act: (bloc) => bloc.add(const ShareCreatePlanTerminationRequested()),
    expect: () {
      final terminating = terminateSeed.copyWith(
        isTerminatingPlan: true,
        clearPlanTerminationError: true,
      );
      final success = terminating.copyWith(
        isTerminatingPlan: false,
        planStatus: 'terminated',
        planTerminationSuccessTick: terminating.planTerminationSuccessTick + 1,
      );
      return [terminating, success];
    },
    verify: (_) {
      verify(() => expensesRepository.terminatePlan('plan-1')).called(1);
    },
  );

  late ShareCreateState lockedSeed;
  blocTest<ShareCreateBloc, ShareCreateState>(
    'allows editing description when amount is locked',
    build:
        () => buildBloc(editingExpenseId: 'expense-paid', isAmountLocked: true),
    seed: () {
      final form = ShareCreateForm.initial().copyWith(
        description: 'Paid expense',
        amountInput: '30.00',
        splitMode: ShareSplitMode.equal,
        selectedParticipantIds: {'member_a', 'member_b'},
      );
      lockedSeed = seededState(
        form: form,
        isEditing: true,
        editingExpenseId: 'expense-paid',
        isAmountLocked: true,
      );
      return lockedSeed;
    },
    setUp: () {
      when(
        () => expensesRepository.edit(
          expenseId: any(named: 'expenseId'),
          amountCents: any(named: 'amountCents'),
          description: any(named: 'description'),
          notes: any(named: 'notes'),
          splitType: any(named: 'splitType'),
          memberIds: any(named: 'memberIds'),
          customSplits: any(named: 'customSplits'),
          recurrence: any(named: 'recurrence'),
          startDate: any(named: 'startDate'),
        ),
      ).thenAnswer(
        (_) async => Expense(
          id: 'expense-paid',
          homeId: 'home-1',
          createdByUserId: 'user-1',
          status: ExpenseStatus.active,
          splitType: ExpenseSplitType.equal,
          amountCents: 3000,
          description: 'Paid expense updated',
          notes: 'note',
          createdAt: DateTime.now().toUtc(),
          updatedAt: DateTime.now().toUtc(),
          recurrenceInterval: ExpenseRecurrenceInterval.none,
          startDate: DateTime(2024, 1, 1),
          planId: null,
          fullyPaidAt: null,
        ),
      );
    },
    act: (bloc) => bloc.add(const ShareCreateSubmitted()),
    expect: () {
      final submitting = lockedSeed.copyWith(
        isSubmitting: true,
        showValidationErrors: true,
        clearSubmissionError: true,
        clearSuccess: true,
      );
      final success = submitting.copyWith(
        isSubmitting: false,
        showValidationErrors: false,
        successExpenseId: 'expense-paid',
      );
      return [submitting, success];
    },
    verify: (_) {
      verify(
        () => expensesRepository.edit(
          expenseId: 'expense-paid',
          amountCents: 3000,
          description: 'Paid expense',
          notes: null,
          splitType: null,
          memberIds: null,
          customSplits: null,
          recurrence: ExpenseRecurrenceInterval.none,
          startDate: any(named: 'startDate'),
        ),
      ).called(1);
    },
  );
}
