/// Recurrence unit for expenses.
enum ExpenseRecurrenceUnit { day, week, month, year }

extension ExpenseRecurrenceUnitWire on ExpenseRecurrenceUnit {
  String get wireValue {
    switch (this) {
      case ExpenseRecurrenceUnit.day:
        return 'day';
      case ExpenseRecurrenceUnit.week:
        return 'week';
      case ExpenseRecurrenceUnit.month:
        return 'month';
      case ExpenseRecurrenceUnit.year:
        return 'year';
    }
  }

  static ExpenseRecurrenceUnit? fromWire(String? wire) {
    switch (wire) {
      case 'day':
        return ExpenseRecurrenceUnit.day;
      case 'week':
        return ExpenseRecurrenceUnit.week;
      case 'month':
        return ExpenseRecurrenceUnit.month;
      case 'year':
        return ExpenseRecurrenceUnit.year;
      default:
        return null;
    }
  }
}
