import 'package:intl/intl.dart';

import '../../../contracts/expenses/enums/expense_recurrence_interval.dart';
import '../../../generated/l10n.dart';

String sharePeriodLabel({
  required ExpenseRecurrenceInterval recurrence,
  required DateTime startDate,
  required S strings,
}) {
  if (recurrence == ExpenseRecurrenceInterval.none) {
    return strings.flowChoreRecurrenceNone;
  }

  final endDate = _periodEndDate(startDate, recurrence);
  final sameMonth =
      startDate.month == endDate.month && startDate.year == endDate.year;
  final formatter = DateFormat.MMMMd();
  final startLabel = formatter.format(startDate);
  final endLabel =
      sameMonth ? DateFormat.d().format(endDate) : formatter.format(endDate);

  final period =
      startDate.year == endDate.year
          ? '$startLabel - $endLabel, ${startDate.year}'
          : '$startLabel, ${startDate.year} - $endLabel, ${endDate.year}';
  return strings.shareCreateCyclePeriod(period);
}

DateTime _periodEndDate(
  DateTime startDate,
  ExpenseRecurrenceInterval recurrence,
) {
  switch (recurrence) {
    case ExpenseRecurrenceInterval.weekly:
      return startDate.add(const Duration(days: 6));
    case ExpenseRecurrenceInterval.every2Weeks:
      return startDate.add(const Duration(days: 13));
    case ExpenseRecurrenceInterval.monthly:
      return DateTime(
        startDate.year,
        startDate.month + 1,
        startDate.day,
      ).subtract(const Duration(days: 1));
    case ExpenseRecurrenceInterval.every2Months:
      return DateTime(
        startDate.year,
        startDate.month + 2,
        startDate.day,
      ).subtract(const Duration(days: 1));
    case ExpenseRecurrenceInterval.annual:
      return DateTime(
        startDate.year + 1,
        startDate.month,
        startDate.day,
      ).subtract(const Duration(days: 1));
    case ExpenseRecurrenceInterval.none:
      return startDate;
  }
}
