enum HouseDirectoryNoteType {
  general('general'),
  tutorial('tutorial');

  const HouseDirectoryNoteType(this.wireValue);

  final String wireValue;

  static HouseDirectoryNoteType fromWire(String? value) {
    for (final entry in HouseDirectoryNoteType.values) {
      if (entry.wireValue == value) return entry;
    }
    return HouseDirectoryNoteType.general;
  }
}
