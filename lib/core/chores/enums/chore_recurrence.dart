/// Recurrence cadence exposed by chores RPCs.
enum ChoreRecurrence {
  none('none'),
  daily('daily'),
  weekly('weekly'),
  every2Weeks('every_2_weeks'),
  monthly('monthly'),
  every2Months('every_2_months'),
  annual('annual');

  const ChoreRecurrence(this.wireValue);
  final String wireValue;
}

extension ChoreRecurrenceWire on ChoreRecurrence {
  static ChoreRecurrence fromWire(String? wire) {
    if (wire == null) return ChoreRecurrence.none;
    return ChoreRecurrence.values.firstWhere(
      (value) => value.wireValue == wire,
      orElse: () => ChoreRecurrence.none,
    );
  }
}
