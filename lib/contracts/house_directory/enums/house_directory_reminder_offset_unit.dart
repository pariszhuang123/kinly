enum HouseDirectoryReminderOffsetUnit {
  day('day'),
  week('week'),
  month('month');

  const HouseDirectoryReminderOffsetUnit(this.wireValue);

  final String wireValue;

  static HouseDirectoryReminderOffsetUnit? fromWireNullable(String? value) {
    if (value == null || value.isEmpty) return null;
    for (final unit in HouseDirectoryReminderOffsetUnit.values) {
      if (unit.wireValue == value) return unit;
    }
    return null;
  }
}
