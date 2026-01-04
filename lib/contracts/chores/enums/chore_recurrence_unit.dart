/// Recurrence cadence unit for chore scheduling.
enum ChoreRecurrenceUnit {
  day('day'),
  week('week'),
  month('month'),
  year('year');

  const ChoreRecurrenceUnit(this.wireValue);
  final String wireValue;
}

extension ChoreRecurrenceUnitWire on ChoreRecurrenceUnit {
  static ChoreRecurrenceUnit? fromWire(dynamic wire) {
    if (wire == null) return null;
    final value = wire.toString();
    for (final unit in ChoreRecurrenceUnit.values) {
      if (unit.wireValue == value) return unit;
    }
    return null;
  }
}
