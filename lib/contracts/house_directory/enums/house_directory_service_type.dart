enum HouseDirectoryServiceType {
  rent('rent'),
  internet('internet'),
  electricity('electricity'),
  gas('gas'),
  water('water'),
  other('other');

  const HouseDirectoryServiceType(this.wireValue);

  final String wireValue;

  static HouseDirectoryServiceType fromWire(String? value) {
    return HouseDirectoryServiceType.values.firstWhere(
      (entry) => entry.wireValue == value,
      orElse: () => HouseDirectoryServiceType.other,
    );
  }
}
