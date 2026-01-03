import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../contracts/expenses/models.dart';
import '../../../core/supabase/supabase_error_mapper.dart';
import '../../../core/ui/kinly_loader.dart';
import '../../../core/ui/buttons/kinly_filled_button.dart';
import '../../../generated/l10n.dart';
import 'package:kinly/contracts/share/ports/expenses_repository.dart';
import 'package:kinly/contracts/homes/ports/home_repository.dart';
import '../bloc/share_create_bloc/share_create_bloc.dart';
import '../domain/share_create_form.dart';
import '../domain/share_split_mode.dart';
import 'share_create/share_create_screen.dart';
import '../../../core/ui/kinly_scaffold.dart';
import '../../../core/ui/kinly_app_bar.dart';

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
          return const KinlyScaffold(body: Center(child: KinlyLoader(size: 32)));
        }
        if (snapshot.hasError || !snapshot.hasData) {
          final s = S.of(context);
          final error = snapshot.error;
          final isEditNotAllowed =
              error is ExpenseException &&
              error.code == ExpenseErrorCode.editNotAllowed;
          final message =
              isEditNotAllowed ? s.shareEditNotAllowed : s.shareEditLoadError;
          return KinlyScaffold(
            appBar: KinlyAppBar(title: Text(s.shareEditTitle)),
            body: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 24,
                        ),
                        child: Text(message, textAlign: TextAlign.center),
                      ),
                  const SizedBox(height: 16),
                  KinlyFilledButton.text(
                    fullWidth: true,
                    onPressed: () => Navigator.of(context).pop(),
                    label: s.shareEditClose,
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
        final allPaid =
            detail.splits.isNotEmpty &&
            detail.splits
                .every((split) => split.status == ExpenseShareStatus.paid);
        final paidByOther = detail.splits.any(
          (split) =>
              split.status == ExpenseShareStatus.paid &&
              split.debtorUserId != expense.createdByUserId,
        );
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
          startDate: expense.startDate,
          recurrence: expense.recurrenceInterval,
        );
        final canEdit = detail.canEdit;
        return BlocProvider(
          create:
              (_) => ShareCreateBloc(
                homeId: homeId,
                expensesRepository: expensesRepository,
                homeRepository: homeRepository,
                planStatus: detail.planStatus,
                planId: expense.planId,
                initialForm: initialForm,
                editingExpenseId: expense.id,
                amountLocked: detail.amountLocked,
                allPaid: allPaid,
                paidByOther: paidByOther,
                canEdit: canEdit,
                editDisabledReason: detail.editDisabledReason,
              )..add(const ShareCreateParticipantsRequested()),
          child: ShareCreateScreen(
            homeId: homeId,
            allowDelete: allowDelete && canEdit,
          ),
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




