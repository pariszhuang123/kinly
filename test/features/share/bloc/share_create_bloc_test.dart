import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/core/expenses/models.dart';
import 'package:kinly/core/homes/models.dart';
import 'package:kinly/core/supabase/supabase_error_mapper.dart';
import 'package:kinly/data/repositories/expenses_repository.dart';
import 'package:kinly/data/repositories/home_repository.dart';
import 'package:kinly/features/share/bloc/share_create_bloc.dart';
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

  late ShareCreateState _draftSeed;
  blocTest<ShareCreateBloc, ShareCreateState>(
    'submits draft without split when no mode chosen',
    build: () => buildBloc(),
    seed: () {
      final form = ShareCreateForm.initial().copyWith(
        description: 'Draft expense',
        amountInput: '12.00',
        selectedParticipantIds: {'member_a', 'member_self'},
      );
      _draftSeed = seededState(form: form);
      return _draftSeed;
    },
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
        ),
      );
    },
    act: (bloc) => bloc.add(const ShareCreateSubmitted()),
    expect: () {
      final submitting = _draftSeed.copyWith(
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
          amountCents: 1200,
          description: 'Draft expense',
          notes: null,
          splitType: null,
          memberIds: null,
          customSplits: null,
        ),
      ).called(1);
    },
  );

  late ShareCreateState _emptySeed;
  blocTest<ShareCreateBloc, ShareCreateState>(
    'sets validation flag when inputs missing',
    build: () => buildBloc(),
    seed: () {
      _emptySeed = seededState(form: ShareCreateForm.initial());
      return _emptySeed;
    },
    act: (bloc) => bloc.add(const ShareCreateSubmitted()),
    expect: () => [_emptySeed.copyWith(showValidationErrors: true)],
  );

  late ShareCreateState _equalSeed;
  blocTest<ShareCreateBloc, ShareCreateState>(
    'submits equal split successfully',
    build: () => buildBloc(),
    seed: () {
      _equalSeed = seededState();
      return _equalSeed;
    },
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
        ),
      );
    },
    act: (bloc) => bloc.add(const ShareCreateSubmitted()),
    expect: () {
      final submitting = _equalSeed.copyWith(
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
        ),
      ).called(1);
    },
  );

  late ShareCreateState _customSeed;
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
      _customSeed = seededState(form: form);
      return _customSeed;
    },
    act: (bloc) => bloc.add(const ShareCreateSubmitted()),
    expect: () => [_customSeed.copyWith(showValidationErrors: true)],
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
        ),
      );
    },
  );

  late ShareCreateState _errorSeed;
  blocTest<ShareCreateBloc, ShareCreateState>(
    'emits submission error when repository throws',
    build: () => buildBloc(),
    seed: () {
      _errorSeed = seededState();
      return _errorSeed;
    },
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
        ),
      ).thenThrow(
        const ExpenseException(ExpenseErrorCode.invalidAmount, 'invalid'),
      );
    },
    act: (bloc) => bloc.add(const ShareCreateSubmitted()),
    expect: () {
      final submitting = _errorSeed.copyWith(
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

  late ShareCreateState _editSeed;
  blocTest<ShareCreateBloc, ShareCreateState>(
    'requires split selection when editing',
    build: () => buildBloc(editingExpenseId: 'expense-draft'),
    seed: () {
      final form = ShareCreateForm.initial().copyWith(
        description: 'Draft expense',
        amountInput: '15.00',
      );
      _editSeed = seededState(
        form: form,
        isEditing: true,
        editingExpenseId: 'expense-draft',
      );
      return _editSeed;
    },
    act: (bloc) => bloc.add(const ShareCreateSubmitted()),
    expect: () => [_editSeed.copyWith(showValidationErrors: true)],
  );

  late ShareCreateState _editSuccessSeed;
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
      _editSuccessSeed = seededState(
        form: form,
        isEditing: true,
        editingExpenseId: 'expense-draft',
      );
      return _editSuccessSeed;
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
        ),
      );
    },
    act: (bloc) => bloc.add(const ShareCreateSubmitted()),
    expect: () {
      final submitting = _editSuccessSeed.copyWith(
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
        ),
      ).called(1);
    },
  );

  late ShareCreateState _lockedSeed;
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
      _lockedSeed = seededState(
        form: form,
        isEditing: true,
        editingExpenseId: 'expense-paid',
        isAmountLocked: true,
      );
      return _lockedSeed;
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
        ),
      );
    },
    act: (bloc) => bloc.add(const ShareCreateSubmitted()),
    expect: () {
      final submitting = _lockedSeed.copyWith(
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
        ),
      ).called(1);
    },
  );
}
