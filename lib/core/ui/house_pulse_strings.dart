import 'package:kinly/generated/l10n.dart';

String resolveHousePulseTitle(S s, String key) {
  switch (key) {
    case 'pulse.forming.title':
      return s.pulseFormingTitle;
    case 'pulse.sunny_calm.title':
      return s.pulseSunnyCalmTitle;
    case 'pulse.sunny_bumpy.title':
      return s.pulseSunnyBumpyTitle;
    case 'pulse.partly_supported.title':
      return s.pulsePartlySupportedTitle;
    case 'pulse.cloudy_steady.title':
      return s.pulseCloudySteadyTitle;
    case 'pulse.cloudy_tense.title':
      return s.pulseCloudyTenseTitle;
    case 'pulse.rainy_supported.title':
      return s.pulseRainySupportedTitle;
    case 'pulse.rainy_unsupported.title':
      return s.pulseRainyUnsupportedTitle;
    case 'pulse.thunderstorm.title':
      return s.pulseThunderstormTitle;
  }
  return '';
}

String resolveHousePulseSummary(S s, String key) {
  switch (key) {
    case 'pulse.forming.summary':
      return s.pulseFormingSummary;
    case 'pulse.sunny_calm.summary':
      return s.pulseSunnyCalmSummary;
    case 'pulse.sunny_bumpy.summary':
      return s.pulseSunnyBumpySummary;
    case 'pulse.partly_supported.summary':
      return s.pulsePartlySupportedSummary;
    case 'pulse.cloudy_steady.summary':
      return s.pulseCloudySteadySummary;
    case 'pulse.cloudy_tense.summary':
      return s.pulseCloudyTenseSummary;
    case 'pulse.rainy_supported.summary':
      return s.pulseRainySupportedSummary;
    case 'pulse.rainy_unsupported.summary':
      return s.pulseRainyUnsupportedSummary;
    case 'pulse.thunderstorm.summary':
      return s.pulseThunderstormSummary;
  }
  return '';
}
