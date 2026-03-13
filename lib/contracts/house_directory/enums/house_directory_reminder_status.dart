enum HouseDirectoryReminderStatus {
  active('active'),
  dismissed('dismissed'),
  retired('retired');

  const HouseDirectoryReminderStatus(this.wireValue);

  final String wireValue;

  static HouseDirectoryReminderStatus fromWire(String? value) {
    return HouseDirectoryReminderStatus.values.firstWhere(
      (entry) => entry.wireValue == value,
      orElse: () => HouseDirectoryReminderStatus.active,
    );
  }
}
