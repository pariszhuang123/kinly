enum MoodScale {
  sunny('sunny'),
  partiallySunny('partially_sunny'),
  cloudy('cloudy'),
  rainy('rainy'),
  thunderstorm('thunderstorm');

  const MoodScale(this.wireValue);
  final String wireValue;

  static MoodScale fromWire(String value) {
    return MoodScale.values.firstWhere(
      (e) => e.wireValue == value,
      orElse: () => throw ArgumentError('Unknown mood_scale: $value'),
    );
  }
}
