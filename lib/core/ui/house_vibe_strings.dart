import 'package:kinly/generated/l10n.dart';

String resolveHouseVibeTitle(S s, String key) {
  switch (key) {
    case 'vibe.insufficient.title':
      return s.vibeInsufficientTitle;
    case 'vibe.mixed.title':
      return s.vibeMixedTitle;
    case 'vibe.default.title':
      return s.vibeDefaultTitle;
    case 'vibe.quietCare.title':
      return s.vibeQuietCareTitle;
    case 'vibe.social.title':
      return s.vibeSocialTitle;
    case 'vibe.structured.title':
      return s.vibeStructuredTitle;
    case 'vibe.easygoing.title':
      return s.vibeEasygoingTitle;
    case 'vibe.independent.title':
      return s.vibeIndependentTitle;
    case 'vibe.warmSocial.title':
      return s.vibeWarmSocialTitle;
    case 'vibe.cozySocial.title':
      return s.vibeCozySocialTitle;
    case 'vibe.steady.title':
      return s.vibeSteadyTitle;
  }
  return '';
}

String resolveHouseVibeSummary(S s, String key) {
  switch (key) {
    case 'vibe.insufficient.summary':
      return s.vibeInsufficientSummary;
    case 'vibe.mixed.summary':
      return s.vibeMixedSummary;
    case 'vibe.default.summary':
      return s.vibeDefaultSummary;
    case 'vibe.quietCare.summary':
      return s.vibeQuietCareSummary;
    case 'vibe.social.summary':
      return s.vibeSocialSummary;
    case 'vibe.structured.summary':
      return s.vibeStructuredSummary;
    case 'vibe.easygoing.summary':
      return s.vibeEasygoingSummary;
    case 'vibe.independent.summary':
      return s.vibeIndependentSummary;
    case 'vibe.warmSocial.summary':
      return s.vibeWarmSocialSummary;
    case 'vibe.cozySocial.summary':
      return s.vibeCozySocialSummary;
    case 'vibe.steady.summary':
      return s.vibeSteadySummary;
  }
  return '';
}
