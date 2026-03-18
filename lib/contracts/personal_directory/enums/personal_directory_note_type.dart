enum PersonalDirectoryNoteType {
  emergencyContact('emergency_contact'),
  allergy('allergy'),
  other('other');

  const PersonalDirectoryNoteType(this.wireValue);

  final String wireValue;

  static PersonalDirectoryNoteType fromWire(String? value) {
    return values.firstWhere(
      (entry) => entry.wireValue == value,
      orElse: () => PersonalDirectoryNoteType.other,
    );
  }
}
