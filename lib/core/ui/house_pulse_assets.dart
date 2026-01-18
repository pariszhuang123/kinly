import 'package:kinly/contracts/mood/enums/house_pulse_state.dart';

String resolveHousePulseAssetPath({
  required String contractVersion,
  required String imageKey,
  HousePulseState? pulseState,
}) {
  final fallbackKey = _fallbackImageKey(pulseState);
  final safeKey =
      imageKey.isNotEmpty ? imageKey : (fallbackKey ?? _fallbackImageKey(null) ?? 'pulse_forming');
  final normalizedVersion = contractVersion.isNotEmpty ? contractVersion : 'v1';
  final sanitizedVersion = normalizedVersion.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '');
  return 'assets/house_pulse_$sanitizedVersion/$safeKey.webp';
}

String? _fallbackImageKey(HousePulseState? state) {
  switch (state) {
    case HousePulseState.sunnyCalm:
      return 'pulse_sunny_calm';
    case HousePulseState.sunnyBumpy:
      return 'pulse_sunny_bumpy';
    case HousePulseState.partlySupported:
      return 'pulse_partly_supported';
    case HousePulseState.cloudySteady:
      return 'pulse_cloudy_steady';
    case HousePulseState.cloudyTense:
      return 'pulse_cloudy_tense';
    case HousePulseState.rainySupported:
      return 'pulse_rainy_supported';
    case HousePulseState.rainyUnsupported:
      return 'pulse_rainy_unsupported';
    case HousePulseState.thunderstorm:
      return 'pulse_thunderstorm';
    case HousePulseState.forming:
    case null:
      return 'pulse_forming';
  }
}
