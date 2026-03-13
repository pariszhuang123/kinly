enum HouseDirectoryLinkTag {
  rent('rent'),
  bond('bond'),
  utilities('utilities'),
  other('other');

  const HouseDirectoryLinkTag(this.wireValue);

  final String wireValue;

  static HouseDirectoryLinkTag fromWire(String? value) {
    return HouseDirectoryLinkTag.values.firstWhere(
      (entry) => entry.wireValue == value,
      orElse: () => HouseDirectoryLinkTag.other,
    );
  }
}
