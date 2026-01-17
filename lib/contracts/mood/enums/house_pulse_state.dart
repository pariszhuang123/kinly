enum HousePulseState {
  forming('forming'),
  sunnyCalm('sunny_calm'),
  sunnyBumpy('sunny_bumpy'),
  partlySupported('partly_supported'),
  cloudySteady('cloudy_steady'),
  cloudyTense('cloudy_tense'),
  rainySupported('rainy_supported'),
  rainyUnsupported('rainy_unsupported'),
  thunderstorm('thunderstorm');

  const HousePulseState(this.wireValue);

  final String wireValue;

  static HousePulseState? maybeFromWire(String? value) {
    if (value == null || value.isEmpty) return null;
    for (final state in HousePulseState.values) {
      if (state.wireValue == value) return state;
    }
    return null;
  }
}
