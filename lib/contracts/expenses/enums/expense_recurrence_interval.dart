/// Recurrence cadence for expenses.
enum ExpenseRecurrenceInterval {
  none,
  weekly,
  every2Weeks,
  monthly,
  every2Months,
  annual,
}

extension ExpenseRecurrenceIntervalWire on ExpenseRecurrenceInterval {
  String get wireValue {
    switch (this) {
      case ExpenseRecurrenceInterval.none:
        return 'none';
      case ExpenseRecurrenceInterval.weekly:
        return 'weekly';
      case ExpenseRecurrenceInterval.every2Weeks:
        return 'every_2_weeks';
      case ExpenseRecurrenceInterval.monthly:
        return 'monthly';
      case ExpenseRecurrenceInterval.every2Months:
        return 'every_2_months';
      case ExpenseRecurrenceInterval.annual:
        return 'annual';
    }
  }

  static ExpenseRecurrenceInterval fromWire(String? wire) {
    switch (wire) {
      case 'weekly':
        return ExpenseRecurrenceInterval.weekly;
      case 'every_2_weeks':
        return ExpenseRecurrenceInterval.every2Weeks;
      case 'monthly':
        return ExpenseRecurrenceInterval.monthly;
      case 'every_2_months':
        return ExpenseRecurrenceInterval.every2Months;
      case 'annual':
        return ExpenseRecurrenceInterval.annual;
      case 'none':
      default:
        return ExpenseRecurrenceInterval.none;
    }
  }
}
