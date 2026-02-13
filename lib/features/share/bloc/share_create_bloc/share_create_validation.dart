part of 'share_create_bloc.dart';

bool _hasBasicValidity(_ValidationContext ctx) {
  final recurrencePairOk =
      (ctx.recurrenceEvery == null && ctx.recurrenceUnit == null) ||
      (ctx.recurrenceEvery != null && ctx.recurrenceUnit != null);
  final recurrenceEveryOk =
      ctx.recurrenceEvery == null || ctx.recurrenceEvery! >= 1;
  final recurrenceOk =
      (ctx.splitMode != null || ctx.recurrenceEvery == null) &&
      recurrencePairOk &&
      recurrenceEveryOk;
  final hasEditInputs =
      ctx.isEditing
          ? ctx.amountLocked ||
              (ctx.splitMode != null && ctx.editingExpenseId != null)
          : true;

  return ctx.descriptionValid &&
      (!ctx.requiresAmount || ctx.amountValid) &&
      recurrenceOk &&
      hasEditInputs;
}
