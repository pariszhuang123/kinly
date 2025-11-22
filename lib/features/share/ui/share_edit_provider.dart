import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/expenses/models.dart';
import '../../../core/supabase/supabase_error_mapper.dart';
import '../../../core/ui/kinly_loader.dart';
import '../../../generated/l10n.dart';
import '../../../data/repositories/expenses_repository.dart';
import '../../../data/repositories/home_repository.dart';
import '../bloc/share_create_bloc.dart';
import '../domain/share_create_form.dart';
import '../domain/share_split_mode.dart';
import 'share_create_screen.dart';

class ShareEditProvider extends StatelessWidget {
  const ShareEditProvider({
    super.key,
    required this.homeId,
    required this.expenseId,
    required this.expensesRepository,
    required this.homeRepository,
    this.allowDelete = false,
  });

  final String homeId;
  final String expenseId;
  final ExpensesRepository expensesRepository;
  final HomeRepository homeRepository;
  final bool allowDelete;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ExpenseForEdit>(
      future: expensesRepository.getForEdit(expenseId),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(body: Center(child: KinlyLoader(size: 32)));
        }
        if (snapshot.hasError || !snapshot.hasData) {
          final s = S.of(context);
          final error = snapshot.error;
          final isEditNotAllowed =
              error is ExpenseException &&
              error.code == ExpenseErrorCode.editNotAllowed;
          final message =
              isEditNotAllowed ? s.shareEditNotAllowed : s.shareEditLoadError;
          return Scaffold(
            appBar: AppBar(title: Text(s.shareEditTitle)),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(message, textAlign: TextAlign.center),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(s.shareEditClose),
                  ),
                ],
              ),
            ),
          );
        }
        final detail = snapshot.data!;
        final expense = detail.expense;
        final splitMode = _splitModeFromExpense(expense.splitType);
        final selectedIds =
            detail.splits.map((split) => split.debtorUserId).toSet();
        final customInputs =
            splitMode == ShareSplitMode.custom
                ? {
                  for (final split in detail.splits)
                    split.debtorUserId: _formatAmount(split.amountCents),
                }
                : const <String, String>{};

        final initialForm = ShareCreateForm.initial().copyWith(
          description: expense.description,
          amountInput: _formatAmount(expense.amountCents),
          notes: expense.notes ?? '',
          splitMode: splitMode,
          selectedParticipantIds: selectedIds,
          customAmountInputs: customInputs,
        );
        return BlocProvider(
          create:
              (_) => ShareCreateBloc(
                homeId: homeId,
                expensesRepository: expensesRepository,
                homeRepository: homeRepository,
                initialForm: initialForm,
                editingExpenseId: expense.id,
                amountLocked: detail.amountLocked,
              )..add(const ShareCreateParticipantsRequested()),
          child: ShareCreateScreen(allowDelete: allowDelete),
        );
      },
    );
  }
}

String _formatAmount(int amountCents) {
  final value = amountCents / 100.0;
  return value.toStringAsFixed(2);
}

ShareSplitMode? _splitModeFromExpense(ExpenseSplitType? type) {
  switch (type) {
    case ExpenseSplitType.equal:
      return ShareSplitMode.equal;
    case ExpenseSplitType.custom:
      return ShareSplitMode.custom;
    default:
      return null;
  }
}
