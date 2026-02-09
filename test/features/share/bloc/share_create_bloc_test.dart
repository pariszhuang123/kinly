import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/contracts/expenses/models.dart';
import 'package:kinly/contracts/homes/models.dart';
import 'package:kinly/features/paywall/paywall.dart';
import 'package:kinly/contracts/paywall/enums/paywall_retry_action.dart';
import 'package:kinly/contracts/paywall/enums/paywall_gate_status.dart';
import 'package:kinly/contracts/paywall/enums/paywall_trigger.dart';
import 'package:kinly/core/supabase/supabase_error_mapper.dart';
import 'package:kinly/features/share/share.dart';
import 'package:kinly/features/home/home.dart';
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
    registerFallbackValue(ExpenseRecurrenceUnit.week);
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
          recurrenceEvery: any(named: 'recurrenceEvery'),
          recurrenceUnit: any(named: 'recurrenceUnit'),
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
          recurrenceEvery: null,
          recurrenceUnit: null,
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
          recurrenceEvery: null,
          recurrenceUnit: null,
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

  blocTest<ShareCreateBloc, ShareCreateState>(
    'defaults recurrence when toggled on',
    build: () => buildBloc(),
    seed: seededState,
    act: (bloc) => bloc.add(const ShareCreateRecurrenceToggled(true)),
    expect:
        () => [
          seededState().copyWith(
            form: seededState().form.copyWith(
              recurrenceEvery: 1,
              recurrenceUnit: ExpenseRecurrenceUnit.week,
            ),
            hasUserEdits: true,
          ),
        ],
  );

  blocTest<ShareCreateBloc, ShareCreateState>(
    'clears recurrence when toggled off',
    build: () => buildBloc(),
    seed: () {
      return seededState(
        form: ShareCreateForm.initial().copyWith(
          description: 'Recurring',
          amountInput: '10.00',
          splitMode: ShareSplitMode.equal,
          selectedParticipantIds: {'member_a', 'member_self'},
          recurrenceEvery: 2,
          recurrenceUnit: ExpenseRecurrenceUnit.month,
        ),
      );
    },
    act: (bloc) => bloc.add(const ShareCreateRecurrenceToggled(false)),
    expect:
        () => [
          seededState(
            form: ShareCreateForm.initial().copyWith(
              description: 'Recurring',
              amountInput: '10.00',
              splitMode: ShareSplitMode.equal,
              selectedParticipantIds: {'member_a', 'member_self'},
              recurrenceEvery: null,
              recurrenceUnit: null,
            ),
          ).copyWith(hasUserEdits: true),
        ],
  );

  blocTest<ShareCreateBloc, ShareCreateState>(
    'drops recurrence every when input is invalid',
    build: () => buildBloc(),
    seed: () {
      return seededState(
        form: ShareCreateForm.initial().copyWith(
          description: 'Recurring',
          amountInput: '10.00',
          splitMode: ShareSplitMode.equal,
          selectedParticipantIds: {'member_a', 'member_self'},
          recurrenceEvery: 1,
          recurrenceUnit: ExpenseRecurrenceUnit.week,
        ),
      );
    },
    act: (bloc) => bloc.add(const ShareCreateRecurrenceEveryChanged('0')),
    expect:
        () => [
          seededState(
            form: ShareCreateForm.initial().copyWith(
              description: 'Recurring',
              amountInput: '10.00',
              splitMode: ShareSplitMode.equal,
              selectedParticipantIds: {'member_a', 'member_self'},
              recurrenceEvery: null,
              recurrenceUnit: ExpenseRecurrenceUnit.week,
            ),
          ).copyWith(hasUserEdits: true),
        ],
  );

  late ShareCreateState recurringDraftSeed;
  blocTest<ShareCreateBloc, ShareCreateState>(
    'blocks recurrence selection without split mode',
    build: () => buildBloc(),
    seed: () {
      final form = ShareCreateForm.initial().copyWith(
        description: 'Weekly draft',
        amountInput: '10.00',
        recurrenceEvery: 1,
        recurrenceUnit: ExpenseRecurrenceUnit.week,
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
          recurrenceEvery: any(named: 'recurrenceEvery'),
          recurrenceUnit: any(named: 'recurrenceUnit'),
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
          recurrenceEvery: any(named: 'recurrenceEvery'),
          recurrenceUnit: any(named: 'recurrenceUnit'),
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
          recurrenceEvery: null,
          recurrenceUnit: null,
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
          recurrenceEvery: null,
          recurrenceUnit: null,
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
          recurrenceEvery: any(named: 'recurrenceEvery'),
          recurrenceUnit: any(named: 'recurrenceUnit'),
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
          recurrenceEvery: any(named: 'recurrenceEvery'),
          recurrenceUnit: any(named: 'recurrenceUnit'),
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
          recurrenceEvery: any(named: 'recurrenceEvery'),
          recurrenceUnit: any(named: 'recurrenceUnit'),
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
          recurrenceEvery: null,
          recurrenceUnit: null,
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
          recurrenceEvery: null,
          recurrenceUnit: null,
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
          recurrenceEvery: null,
          recurrenceUnit: null,
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
        recurrenceEvery: 1,
        recurrenceUnit: ExpenseRecurrenceUnit.month,
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
          recurrenceEvery: 1,
          recurrenceUnit: ExpenseRecurrenceUnit.month,
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
          recurrenceEvery: any(named: 'recurrenceEvery'),
          recurrenceUnit: any(named: 'recurrenceUnit'),
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
          recurrenceEvery: null,
          recurrenceUnit: null,
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
          recurrenceEvery: null,
          recurrenceUnit: null,
          startDate: any(named: 'startDate'),
        ),
      ).called(1);
    },
  );

  blocTest<ShareCreateBloc, ShareCreateState>(
    'emits paywall gate request on expenses cap error',
    build: () => buildBloc(),
    seed: seededState,
    setUp: () {
      when(
        () => expensesRepository.create(
          homeId: any(named: 'homeId'),
          amountCents: any(named: 'amountCents'),
          description: any(named: 'description'),
          notes: any(named: 'notes'),
          splitType: any(named: 'splitType'),
          memberIds: any(named: 'memberIds'),
          customSplits: any(named: 'customSplits'),
          recurrenceEvery: any(named: 'recurrenceEvery'),
          recurrenceUnit: any(named: 'recurrenceUnit'),
          startDate: any(named: 'startDate'),
        ),
      ).thenThrow(
        ExpenseException(ExpenseErrorCode.paywallActiveExpensesCap, 'cap'),
      );
    },
    act: (bloc) => bloc.add(const ShareCreateSubmitted()),
    expect:
        () => [
          isA<ShareCreateState>().having(
            (s) => s.isSubmitting,
            'isSubmitting',
            true,
          ),
          isA<ShareCreateState>()
              .having((s) => s.paywallRequestTick, 'paywallRequestTick', 1)
              .having(
                (s) => s.paywallRequest?.action,
                'action',
                PaywallRetryAction.submit,
              )
              .having((s) => s.paywallRequest?.homeId, 'homeId', 'home-1')
              .having(
                (s) => s.paywallRequest?.triggers,
                'triggers',
                contains(PaywallTrigger.expenseActiveCap),
              ),
        ],
  );

  blocTest<ShareCreateBloc, ShareCreateState>(
    'retries submission after paywall resolved',
    build: () => buildBloc(),
    seed: seededState,
    setUp: () {
      var callCount = 0;
      when(
        () => expensesRepository.create(
          homeId: any(named: 'homeId'),
          amountCents: any(named: 'amountCents'),
          description: any(named: 'description'),
          notes: any(named: 'notes'),
          splitType: any(named: 'splitType'),
          memberIds: any(named: 'memberIds'),
          customSplits: any(named: 'customSplits'),
          recurrenceEvery: any(named: 'recurrenceEvery'),
          recurrenceUnit: any(named: 'recurrenceUnit'),
          startDate: any(named: 'startDate'),
        ),
      ).thenAnswer((_) async {
        callCount += 1;
        if (callCount == 1) {
          throw ExpenseException(
            ExpenseErrorCode.paywallActiveExpensesCap,
            'cap',
          );
        }
        return Expense(
          id: 'expense-123',
          homeId: 'home-1',
          createdByUserId: 'creator',
          status: ExpenseStatus.active,
          splitType: ExpenseSplitType.equal,
          amountCents: 4200,
          description: 'Dinner',
          notes: null,
          createdAt: DateTime.now().toUtc(),
          updatedAt: DateTime.now().toUtc(),
          recurrenceEvery: null,
          recurrenceUnit: null,
          startDate: DateTime(2024, 1, 1),
          planId: null,
          fullyPaidAt: null,
        );
      });
    },
    act: (bloc) async {
      bloc.add(const ShareCreateSubmitted());
      await Future<void>.delayed(const Duration(milliseconds: 10));
      final req = bloc.state.paywallRequest!;
      bloc.add(ShareCreatePaywallOpened(req.requestId));
      bloc.add(
        ShareCreatePaywallResolved(
          PaywallGateOutcome(
            requestId: req.requestId,
            action: PaywallRetryAction.submit,
            status: PaywallGateStatus.granted,
          ),
        ),
      );
    },
    expect:
        () => [
          isA<ShareCreateState>().having(
            (s) => s.isSubmitting,
            'isSubmitting',
            true,
          ),
          isA<ShareCreateState>().having(
            (s) => s.paywallRequest?.action,
            'paywall request emitted',
            PaywallRetryAction.submit,
          ),
          isA<ShareCreateState>().having(
            (s) => s.paywallInFlightRequestId,
            'in-flight set',
            isNotNull,
          ),
          isA<ShareCreateState>().having(
            (s) => s.isSubmitting,
            'isSubmitting on retry',
            true,
          ),
          isA<ShareCreateState>().having(
            (s) => s.successExpenseId,
            'success after retry',
            'expense-123',
          ),
        ],
  );

  blocTest<ShareCreateBloc, ShareCreateState>(
    'emits load error when participants fail to load',
    build: () => buildBloc(),
    setUp: () {
      when(
        () => homeRepository.listActiveMembers(
          any(),
          excludeSelf: any(named: 'excludeSelf'),
        ),
      ).thenThrow(Exception('Network error'));
    },
    act: (bloc) => bloc.add(const ShareCreateParticipantsRequested()),
    expect:
        () => [
          isA<ShareCreateState>().having((s) => s.isLoading, 'loading', true),
          isA<ShareCreateState>()
              .having((s) => s.isLoading, 'loading', false)
              .having(
                (s) => s.loadErrorMessage,
                'error',
                contains('Network error'),
              ),
        ],
  );

  blocTest<ShareCreateBloc, ShareCreateState>(
    'updates notes field',
    build: () => buildBloc(),
    seed: seededState,
    act:
        (bloc) => bloc.add(const ShareCreateNotesChanged('Payment for dinner')),
    expect:
        () => [
          seededState().copyWith(
            form: seededState().form.copyWith(notes: 'Payment for dinner'),
            hasUserEdits: true,
          ),
        ],
  );

  blocTest<ShareCreateBloc, ShareCreateState>(
    'updates start date',
    build: () => buildBloc(),
    seed: seededState,
    act: (bloc) => bloc.add(ShareCreateStartDateChanged(DateTime(2024, 6, 15))),
    expect:
        () => [
          seededState().copyWith(
            form: seededState().form.copyWith(startDate: DateTime(2024, 6, 15)),
            hasUserEdits: true,
          ),
        ],
  );

  blocTest<ShareCreateBloc, ShareCreateState>(
    'updates recurrence unit',
    build: () => buildBloc(),
    seed: () {
      return seededState(
        form: ShareCreateForm.initial().copyWith(
          description: 'Recurring',
          amountInput: '10.00',
          splitMode: ShareSplitMode.equal,
          selectedParticipantIds: {'member_a', 'member_self'},
          recurrenceEvery: 1,
          recurrenceUnit: ExpenseRecurrenceUnit.week,
        ),
      );
    },
    act:
        (bloc) => bloc.add(
          const ShareCreateRecurrenceUnitChanged(ExpenseRecurrenceUnit.month),
        ),
    expect:
        () => [
          seededState(
            form: ShareCreateForm.initial().copyWith(
              description: 'Recurring',
              amountInput: '10.00',
              splitMode: ShareSplitMode.equal,
              selectedParticipantIds: {'member_a', 'member_self'},
              recurrenceEvery: 1,
              recurrenceUnit: ExpenseRecurrenceUnit.month,
            ),
          ).copyWith(hasUserEdits: true),
        ],
  );

  blocTest<ShareCreateBloc, ShareCreateState>(
    'emits deletion error when repository throws ExpenseException',
    build: () => buildBloc(editingExpenseId: 'expense-draft'),
    seed: () {
      final form = ShareCreateForm.initial().copyWith(description: 'Draft');
      return seededState(
        form: form,
        isEditing: true,
        editingExpenseId: 'expense-draft',
      );
    },
    setUp: () {
      when(() => expensesRepository.cancel(any())).thenThrow(
        const ExpenseException(ExpenseErrorCode.notFound, 'Not found'),
      );
    },
    act: (bloc) => bloc.add(const ShareCreateDeleted()),
    expect:
        () => [
          isA<ShareCreateState>().having((s) => s.isDeleting, 'deleting', true),
          isA<ShareCreateState>()
              .having((s) => s.isDeleting, 'deleting', false)
              .having(
                (s) => s.deletionErrorMessage,
                'error',
                contains('Not found'),
              )
              .having((s) => s.deletionErrorTick, 'tick', 1),
        ],
  );

  blocTest<ShareCreateBloc, ShareCreateState>(
    'emits deletion error when repository throws generic error',
    build: () => buildBloc(editingExpenseId: 'expense-draft'),
    seed: () {
      final form = ShareCreateForm.initial().copyWith(description: 'Draft');
      return seededState(
        form: form,
        isEditing: true,
        editingExpenseId: 'expense-draft',
      );
    },
    setUp: () {
      when(
        () => expensesRepository.cancel(any()),
      ).thenThrow(Exception('Delete failed'));
    },
    act: (bloc) => bloc.add(const ShareCreateDeleted()),
    expect:
        () => [
          isA<ShareCreateState>().having((s) => s.isDeleting, 'deleting', true),
          isA<ShareCreateState>()
              .having((s) => s.isDeleting, 'deleting', false)
              .having(
                (s) => s.deletionErrorMessage,
                'error',
                contains('Delete failed'),
              ),
        ],
  );

  blocTest<ShareCreateBloc, ShareCreateState>(
    'does nothing on delete when not editing',
    build: () => buildBloc(),
    seed: seededState,
    act: (bloc) => bloc.add(const ShareCreateDeleted()),
    expect: () => <ShareCreateState>[],
  );

  blocTest<ShareCreateBloc, ShareCreateState>(
    'emits plan termination error when repository throws ExpenseException',
    build: () => buildBloc(editingExpenseId: 'expense-plan'),
    seed: () {
      return seededState(
        isEditing: true,
        editingExpenseId: 'expense-plan',
      ).copyWith(planId: 'plan-1', planStatus: 'active');
    },
    setUp: () {
      when(() => expensesRepository.terminatePlan(any())).thenThrow(
        const ExpenseException(ExpenseErrorCode.notFound, 'Plan not found'),
      );
    },
    act: (bloc) => bloc.add(const ShareCreatePlanTerminationRequested()),
    expect:
        () => [
          isA<ShareCreateState>().having(
            (s) => s.isTerminatingPlan,
            'terminating',
            true,
          ),
          isA<ShareCreateState>()
              .having((s) => s.isTerminatingPlan, 'terminating', false)
              .having(
                (s) => s.planTerminationErrorMessage,
                'error',
                contains('Plan not found'),
              )
              .having((s) => s.planTerminationErrorTick, 'tick', 1),
        ],
  );

  blocTest<ShareCreateBloc, ShareCreateState>(
    'emits plan termination error when repository throws generic error',
    build: () => buildBloc(editingExpenseId: 'expense-plan'),
    seed: () {
      return seededState(
        isEditing: true,
        editingExpenseId: 'expense-plan',
      ).copyWith(planId: 'plan-1', planStatus: 'active');
    },
    setUp: () {
      when(
        () => expensesRepository.terminatePlan(any()),
      ).thenThrow(Exception('Terminate failed'));
    },
    act: (bloc) => bloc.add(const ShareCreatePlanTerminationRequested()),
    expect:
        () => [
          isA<ShareCreateState>().having(
            (s) => s.isTerminatingPlan,
            'terminating',
            true,
          ),
          isA<ShareCreateState>()
              .having((s) => s.isTerminatingPlan, 'terminating', false)
              .having(
                (s) => s.planTerminationErrorMessage,
                'error',
                contains('Terminate failed'),
              ),
        ],
  );

  blocTest<ShareCreateBloc, ShareCreateState>(
    'does nothing on plan termination when no planId',
    build: () => buildBloc(editingExpenseId: 'expense-1'),
    seed: () {
      return seededState(isEditing: true, editingExpenseId: 'expense-1');
    },
    act: (bloc) => bloc.add(const ShareCreatePlanTerminationRequested()),
    expect: () => <ShareCreateState>[],
  );

  blocTest<ShareCreateBloc, ShareCreateState>(
    'does not submit when canEdit is false',
    build: () {
      return ShareCreateBloc(
        homeId: 'home-1',
        expensesRepository: expensesRepository,
        homeRepository: homeRepository,
        editingExpenseId: 'expense-1',
        canEdit: false,
        editDisabledReason: 'Already paid',
      );
    },
    seed: () {
      return seededState(
        isEditing: true,
        editingExpenseId: 'expense-1',
      ).copyWith(canEdit: false, editDisabledReason: 'Already paid');
    },
    act: (bloc) => bloc.add(const ShareCreateSubmitted()),
    expect: () => <ShareCreateState>[],
    verify: (_) {
      verifyNever(
        () => expensesRepository.edit(
          expenseId: any(named: 'expenseId'),
          amountCents: any(named: 'amountCents'),
          description: any(named: 'description'),
          notes: any(named: 'notes'),
          splitType: any(named: 'splitType'),
          memberIds: any(named: 'memberIds'),
          customSplits: any(named: 'customSplits'),
          recurrenceEvery: any(named: 'recurrenceEvery'),
          recurrenceUnit: any(named: 'recurrenceUnit'),
          startDate: any(named: 'startDate'),
        ),
      );
    },
  );

  blocTest<ShareCreateBloc, ShareCreateState>(
    'emits submission error when repository throws generic error',
    build: () => buildBloc(),
    seed: seededState,
    setUp: () {
      when(
        () => expensesRepository.create(
          homeId: any(named: 'homeId'),
          amountCents: any(named: 'amountCents'),
          description: any(named: 'description'),
          notes: any(named: 'notes'),
          splitType: any(named: 'splitType'),
          memberIds: any(named: 'memberIds'),
          customSplits: any(named: 'customSplits'),
          recurrenceEvery: any(named: 'recurrenceEvery'),
          recurrenceUnit: any(named: 'recurrenceUnit'),
          startDate: any(named: 'startDate'),
        ),
      ).thenThrow(Exception('Unexpected error'));
    },
    act: (bloc) => bloc.add(const ShareCreateSubmitted()),
    expect:
        () => [
          isA<ShareCreateState>().having(
            (s) => s.isSubmitting,
            'submitting',
            true,
          ),
          isA<ShareCreateState>()
              .having((s) => s.isSubmitting, 'submitting', false)
              .having(
                (s) => s.submissionErrorCode,
                'code',
                ExpenseErrorCode.unknown,
              )
              .having(
                (s) => s.submissionErrorMessage,
                'message',
                contains('Unexpected error'),
              ),
        ],
  );

  blocTest<ShareCreateBloc, ShareCreateState>(
    'toggles participant selection',
    build: () => buildBloc(),
    seed: seededState,
    act:
        (bloc) =>
            bloc.add(const ShareCreateParticipantToggled('member_a', false)),
    expect:
        () => [
          isA<ShareCreateState>()
              .having(
                (s) => s.form.selectedParticipantIds.contains('member_a'),
                'member_a selected',
                false,
              )
              .having((s) => s.hasUserEdits, 'hasUserEdits', true),
        ],
  );

  blocTest<ShareCreateBloc, ShareCreateState>(
    'updates custom amount for participant',
    build: () => buildBloc(),
    seed: () {
      final form = ShareCreateForm.initial().copyWith(
        description: 'Supplies',
        amountInput: '10.00',
        splitMode: ShareSplitMode.custom,
        selectedParticipantIds: {'member_a', 'member_b'},
      );
      return seededState(form: form);
    },
    act:
        (bloc) =>
            bloc.add(const ShareCreateCustomAmountChanged('member_a', '6.00')),
    expect:
        () => [
          isA<ShareCreateState>()
              .having(
                (s) => s.form.customAmountInputs['member_a'],
                'custom amount',
                '6.00',
              )
              .having((s) => s.hasUserEdits, 'hasUserEdits', true),
        ],
  );

  blocTest<ShareCreateBloc, ShareCreateState>(
    'auto-selects participant when custom amount is entered',
    build: () => buildBloc(),
    seed: () {
      final form = ShareCreateForm.initial().copyWith(
        description: 'Supplies',
        amountInput: '10.00',
        splitMode: ShareSplitMode.custom,
        selectedParticipantIds: <String>{},
      );
      return seededState(form: form);
    },
    act:
        (bloc) =>
            bloc.add(const ShareCreateCustomAmountChanged('member_a', '6.00')),
    expect:
        () => [
          isA<ShareCreateState>()
              .having(
                (s) => s.form.customAmountInputs['member_a'],
                'custom amount',
                '6.00',
              )
              .having(
                (s) => s.form.selectedParticipantIds.contains('member_a'),
                'member_a auto-selected',
                true,
              )
              .having((s) => s.hasUserEdits, 'hasUserEdits', true),
        ],
  );

  blocTest<ShareCreateBloc, ShareCreateState>(
    'auto-deselects participant when custom amount is blanked',
    build: () => buildBloc(),
    seed: () {
      final form = ShareCreateForm.initial().copyWith(
        description: 'Supplies',
        amountInput: '10.00',
        splitMode: ShareSplitMode.custom,
        selectedParticipantIds: {'member_a', 'member_b'},
        customAmountInputs: {'member_a': '6.00', 'member_b': '4.00'},
      );
      return seededState(form: form);
    },
    act:
        (bloc) =>
            bloc.add(const ShareCreateCustomAmountChanged('member_a', '')),
    expect:
        () => [
          isA<ShareCreateState>()
              .having(
                (s) => s.form.selectedParticipantIds.contains('member_a'),
                'member_a auto-deselected',
                false,
              )
              .having(
                (s) => s.form.selectedParticipantIds.contains('member_b'),
                'member_b still selected',
                true,
              )
              .having((s) => s.hasUserEdits, 'hasUserEdits', true),
        ],
  );

  blocTest<ShareCreateBloc, ShareCreateState>(
    'auto-deselects participant when custom amount is set to zero',
    build: () => buildBloc(),
    seed: () {
      final form = ShareCreateForm.initial().copyWith(
        description: 'Supplies',
        amountInput: '10.00',
        splitMode: ShareSplitMode.custom,
        selectedParticipantIds: {'member_a', 'member_b'},
        customAmountInputs: {'member_a': '6.00', 'member_b': '4.00'},
      );
      return seededState(form: form);
    },
    act:
        (bloc) =>
            bloc.add(const ShareCreateCustomAmountChanged('member_a', '0')),
    expect:
        () => [
          isA<ShareCreateState>()
              .having(
                (s) => s.form.selectedParticipantIds.contains('member_a'),
                'member_a auto-deselected',
                false,
              )
              .having((s) => s.hasUserEdits, 'hasUserEdits', true),
        ],
  );

  blocTest<ShareCreateBloc, ShareCreateState>(
    'clears selection when switching to custom mode with blank amounts',
    build: () => buildBloc(),
    seed: () {
      final form = ShareCreateForm.initial().copyWith(
        description: 'Test',
        amountInput: '20.00',
        splitMode: ShareSplitMode.equal,
        selectedParticipantIds: {'member_a', 'member_b', 'member_self'},
      );
      return seededState(form: form);
    },
    act:
        (bloc) =>
            bloc.add(const ShareCreateSplitModeChanged(ShareSplitMode.custom)),
    expect:
        () => [
          isA<ShareCreateState>()
              .having(
                (s) => s.form.splitMode,
                'splitMode',
                ShareSplitMode.custom,
              )
              .having(
                (s) => s.form.selectedParticipantIds.isEmpty,
                'no one selected',
                true,
              )
              .having((s) => s.hasUserEdits, 'hasUserEdits', true),
        ],
  );

  blocTest<ShareCreateBloc, ShareCreateState>(
    'keeps participants with amounts when switching to custom mode',
    build: () => buildBloc(),
    seed: () {
      final form = ShareCreateForm.initial().copyWith(
        description: 'Test',
        amountInput: '20.00',
        splitMode: ShareSplitMode.equal,
        selectedParticipantIds: {'member_a', 'member_b', 'member_self'},
        customAmountInputs: {'member_a': '10.00'},
      );
      return seededState(form: form);
    },
    act:
        (bloc) =>
            bloc.add(const ShareCreateSplitModeChanged(ShareSplitMode.custom)),
    expect:
        () => [
          isA<ShareCreateState>()
              .having(
                (s) => s.form.splitMode,
                'splitMode',
                ShareSplitMode.custom,
              )
              .having(
                (s) => s.form.selectedParticipantIds,
                'only member_a selected',
                {'member_a'},
              )
              .having((s) => s.hasUserEdits, 'hasUserEdits', true),
        ],
  );

  blocTest<ShareCreateBloc, ShareCreateState>(
    'selects all participants when switching to equal mode with empty selection',
    build: () => buildBloc(),
    seed: () {
      final form = ShareCreateForm.initial().copyWith(
        description: 'Test',
        amountInput: '20.00',
        splitMode: null,
        selectedParticipantIds: <String>{},
      );
      return seededState(form: form);
    },
    act:
        (bloc) =>
            bloc.add(const ShareCreateSplitModeChanged(ShareSplitMode.equal)),
    expect:
        () => [
          isA<ShareCreateState>()
              .having(
                (s) => s.form.splitMode,
                'splitMode',
                ShareSplitMode.equal,
              )
              .having(
                (s) => s.form.selectedParticipantIds.length,
                'all selected',
                3,
              )
              .having((s) => s.hasUserEdits, 'hasUserEdits', true),
        ],
  );

  blocTest<ShareCreateBloc, ShareCreateState>(
    'clears recurrence fields when split mode is set to null',
    build: () => buildBloc(),
    seed: () {
      final form = ShareCreateForm.initial().copyWith(
        description: 'Recurring',
        amountInput: '10.00',
        splitMode: ShareSplitMode.equal,
        selectedParticipantIds: {'member_a', 'member_self'},
        recurrenceEvery: 2,
        recurrenceUnit: ExpenseRecurrenceUnit.month,
      );
      return seededState(form: form);
    },
    act: (bloc) => bloc.add(const ShareCreateSplitModeChanged(null)),
    expect:
        () => [
          isA<ShareCreateState>()
              .having((s) => s.form.recurrenceEvery, 'recurrenceEvery', isNull)
              .having((s) => s.form.recurrenceUnit, 'recurrenceUnit', isNull)
              .having((s) => s.hasUserEdits, 'hasUserEdits', true),
        ],
  );

  blocTest<ShareCreateBloc, ShareCreateState>(
    'paywall resolved does not retry submission when status is not granted',
    build: () => buildBloc(),
    seed: () {
      return seededState().copyWith(paywallInFlightRequestId: 'req-123');
    },
    act:
        (bloc) => bloc.add(
          ShareCreatePaywallResolved(
            PaywallGateOutcome(
              requestId: 'req-123',
              action: PaywallRetryAction.submit,
              status: PaywallGateStatus.cancelled,
            ),
          ),
        ),
    verify: (_) {
      verifyNever(
        () => expensesRepository.create(
          homeId: any(named: 'homeId'),
          amountCents: any(named: 'amountCents'),
          description: any(named: 'description'),
          notes: any(named: 'notes'),
          splitType: any(named: 'splitType'),
          memberIds: any(named: 'memberIds'),
          customSplits: any(named: 'customSplits'),
          recurrenceEvery: any(named: 'recurrenceEvery'),
          recurrenceUnit: any(named: 'recurrenceUnit'),
          startDate: any(named: 'startDate'),
        ),
      );
    },
  );

  group('ShareCreateEvent props equality', () {
    test('ShareCreateParticipantsRequested equality', () {
      expect(
        const ShareCreateParticipantsRequested(),
        equals(const ShareCreateParticipantsRequested()),
      );
      expect(const ShareCreateParticipantsRequested().props, isEmpty);
    });

    test('ShareCreateDescriptionChanged equality', () {
      const e1 = ShareCreateDescriptionChanged('A');
      const e2 = ShareCreateDescriptionChanged('A');
      const e3 = ShareCreateDescriptionChanged('B');
      expect(e1, equals(e2));
      expect(e1, isNot(equals(e3)));
      expect(e1.props, equals(['A']));
    });

    test('ShareCreateAmountChanged equality', () {
      const e1 = ShareCreateAmountChanged('100');
      const e2 = ShareCreateAmountChanged('100');
      const e3 = ShareCreateAmountChanged('200');
      expect(e1, equals(e2));
      expect(e1, isNot(equals(e3)));
      expect(e1.props, equals(['100']));
    });

    test('ShareCreateSplitModeChanged equality', () {
      const e1 = ShareCreateSplitModeChanged(ShareSplitMode.equal);
      const e2 = ShareCreateSplitModeChanged(ShareSplitMode.equal);
      const e3 = ShareCreateSplitModeChanged(ShareSplitMode.custom);
      const e4 = ShareCreateSplitModeChanged(null);
      expect(e1, equals(e2));
      expect(e1, isNot(equals(e3)));
      expect(e1, isNot(equals(e4)));
      expect(e1.props, equals([ShareSplitMode.equal]));
      expect(e4.props, equals([null]));
    });

    test('ShareCreateNotesChanged equality', () {
      const e1 = ShareCreateNotesChanged('note');
      const e2 = ShareCreateNotesChanged('note');
      const e3 = ShareCreateNotesChanged('other');
      expect(e1, equals(e2));
      expect(e1, isNot(equals(e3)));
      expect(e1.props, equals(['note']));
    });

    test('ShareCreateStartDateChanged equality', () {
      final date1 = DateTime(2024, 1, 15);
      final date2 = DateTime(2024, 1, 15);
      final date3 = DateTime(2024, 2, 20);
      final e1 = ShareCreateStartDateChanged(date1);
      final e2 = ShareCreateStartDateChanged(date2);
      final e3 = ShareCreateStartDateChanged(date3);
      expect(e1, equals(e2));
      expect(e1, isNot(equals(e3)));
      expect(e1.props, equals([date1]));
    });

    test('ShareCreateRecurrenceToggled equality', () {
      const e1 = ShareCreateRecurrenceToggled(true);
      const e2 = ShareCreateRecurrenceToggled(true);
      const e3 = ShareCreateRecurrenceToggled(false);
      expect(e1, equals(e2));
      expect(e1, isNot(equals(e3)));
      expect(e1.props, equals([true]));
    });

    test('ShareCreateRecurrenceEveryChanged equality', () {
      const e1 = ShareCreateRecurrenceEveryChanged('2');
      const e2 = ShareCreateRecurrenceEveryChanged('2');
      const e3 = ShareCreateRecurrenceEveryChanged('3');
      expect(e1, equals(e2));
      expect(e1, isNot(equals(e3)));
      expect(e1.props, equals(['2']));
    });

    test('ShareCreateRecurrenceUnitChanged equality', () {
      const e1 = ShareCreateRecurrenceUnitChanged(ExpenseRecurrenceUnit.week);
      const e2 = ShareCreateRecurrenceUnitChanged(ExpenseRecurrenceUnit.week);
      const e3 = ShareCreateRecurrenceUnitChanged(ExpenseRecurrenceUnit.month);
      expect(e1, equals(e2));
      expect(e1, isNot(equals(e3)));
      expect(e1.props, equals([ExpenseRecurrenceUnit.week]));
    });

    test('ShareCreateParticipantToggled equality', () {
      const e1 = ShareCreateParticipantToggled('user-1', true);
      const e2 = ShareCreateParticipantToggled('user-1', true);
      const e3 = ShareCreateParticipantToggled('user-1', false);
      const e4 = ShareCreateParticipantToggled('user-2', true);
      expect(e1, equals(e2));
      expect(e1, isNot(equals(e3)));
      expect(e1, isNot(equals(e4)));
      expect(e1.props, equals(['user-1', true]));
    });

    test('ShareCreateCustomAmountChanged equality', () {
      const e1 = ShareCreateCustomAmountChanged('user-1', '50');
      const e2 = ShareCreateCustomAmountChanged('user-1', '50');
      const e3 = ShareCreateCustomAmountChanged('user-1', '75');
      const e4 = ShareCreateCustomAmountChanged('user-2', '50');
      expect(e1, equals(e2));
      expect(e1, isNot(equals(e3)));
      expect(e1, isNot(equals(e4)));
      expect(e1.props, equals(['user-1', '50']));
    });

    test('ShareCreateSubmitted equality', () {
      expect(
        const ShareCreateSubmitted(),
        equals(const ShareCreateSubmitted()),
      );
      expect(const ShareCreateSubmitted().props, isEmpty);
    });

    test('ShareCreateDeleted equality', () {
      expect(const ShareCreateDeleted(), equals(const ShareCreateDeleted()));
      expect(const ShareCreateDeleted().props, isEmpty);
    });

    test('ShareCreatePlanTerminationRequested equality', () {
      expect(
        const ShareCreatePlanTerminationRequested(),
        equals(const ShareCreatePlanTerminationRequested()),
      );
      expect(const ShareCreatePlanTerminationRequested().props, isEmpty);
    });

    test('ShareCreatePaywallOpened equality', () {
      const e1 = ShareCreatePaywallOpened('req-1');
      const e2 = ShareCreatePaywallOpened('req-1');
      const e3 = ShareCreatePaywallOpened('req-2');
      expect(e1, equals(e2));
      expect(e1, isNot(equals(e3)));
      expect(e1.props, equals(['req-1']));
    });

    test('ShareCreatePaywallResolved equality', () {
      const outcome1 = PaywallGateOutcome(
        requestId: 'req-1',
        action: PaywallRetryAction.submit,
        status: PaywallGateStatus.granted,
      );
      const outcome2 = PaywallGateOutcome(
        requestId: 'req-2',
        action: PaywallRetryAction.submit,
        status: PaywallGateStatus.cancelled,
      );
      final e1 = ShareCreatePaywallResolved(outcome1);
      final e2 = ShareCreatePaywallResolved(outcome1);
      final e3 = ShareCreatePaywallResolved(outcome2);
      expect(e1, equals(e2));
      expect(e1, isNot(equals(e3)));
      expect(e1.props, equals([outcome1]));
    });
  });
}
