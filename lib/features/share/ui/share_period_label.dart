import 'package:intl/intl.dart';

import '../../../contracts/expenses/enums/expense_recurrence_unit.dart';
import '../../../generated/l10n.dart';

String sharePeriodLabel({
  required int? recurrenceEvery,
  required ExpenseRecurrenceUnit? recurrenceUnit,
  required DateTime startDate,
  required S strings,
}) {
  if (recurrenceEvery == null || recurrenceUnit == null) {
    return strings.flowChoreRecurrenceNone;
  }

  final endDate = _periodEndDate(startDate, recurrenceEvery, recurrenceUnit);
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
  int recurrenceEvery,
  ExpenseRecurrenceUnit recurrenceUnit,
) {
  switch (recurrenceUnit) {
    case ExpenseRecurrenceUnit.day:
      return startDate.add(Duration(days: recurrenceEvery - 1));
    case ExpenseRecurrenceUnit.week:
      return startDate.add(Duration(days: (recurrenceEvery * 7) - 1));
    case ExpenseRecurrenceUnit.month:
      return DateTime(
        startDate.year,
        startDate.month + recurrenceEvery,
        startDate.day,
      ).subtract(const Duration(days: 1));
    case ExpenseRecurrenceUnit.year:
      return DateTime(
        startDate.year + recurrenceEvery,
        startDate.month,
        startDate.day,
      ).subtract(const Duration(days: 1));
  }
}
