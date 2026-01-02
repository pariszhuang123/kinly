import 'package:intl/intl.dart';

import '../../../contracts/expenses/models.dart';

class TodaySharePaidItem {
  TodaySharePaidItem({
    required this.expenseId,
    required this.description,
    required this.amountCents,
    required this.markedPaidAt,
    required this.recurrenceInterval,
    required this.startDate,
    this.notes,
  });

  final String expenseId;
  final String description;
  final int amountCents;
  final DateTime? markedPaidAt;
  final ExpenseRecurrenceInterval recurrenceInterval;
  final DateTime startDate;
  final String? notes;

  factory TodaySharePaidItem.fromModel(ExpensePaidToMeItem model) {
    return TodaySharePaidItem(
      expenseId: model.expenseId,
      description: model.description,
      amountCents: model.amountCents,
      markedPaidAt: model.markedPaidAt,
      recurrenceInterval: model.recurrenceInterval,
      startDate: model.startDate,
      notes: model.notes,
    );
  }

  String get formattedAmount {
    return NumberFormat.simpleCurrency(
      decimalDigits: 2,
    ).format(amountCents / 100.0);
  }
}
