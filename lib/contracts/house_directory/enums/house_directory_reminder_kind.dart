enum HouseDirectoryReminderKind {
  renewal('renewal');

  const HouseDirectoryReminderKind(this.wireValue);

  final String wireValue;

  static HouseDirectoryReminderKind fromWire(String? value) {
    return HouseDirectoryReminderKind.values.firstWhere(
      (entry) => entry.wireValue == value,
      orElse: () => HouseDirectoryReminderKind.renewal,
    );
  }
}
