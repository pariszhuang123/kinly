enum PlanStatus {
  free,
  premium,
  unknown;

  static PlanStatus fromString(String? value) {
    if (value == null) return unknown;
    switch (value.toLowerCase()) {
      case 'free':
        return free;
      case 'premium':
        return premium;
      default:
        return unknown;
    }
  }

  bool get isPremium => this == premium;
  bool get isFree => this == free;
}
