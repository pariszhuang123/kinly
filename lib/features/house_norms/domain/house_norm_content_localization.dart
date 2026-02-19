import 'package:kinly/contracts/house_norms/models.dart';
import 'package:kinly/generated/l10n.dart';

String localizeHouseNormSummaryTitle(S s, HouseNormSummary summary) {
  if (summary.titleKey == 'house_norms_title') {
    return s.houseNormSummaryTitle;
  }
  if (_isDisplayText(summary.title)) {
    return summary.title;
  }
  return s.houseNormSummaryTitle;
}

String localizeHouseNormSummarySubtitle(S s, HouseNormSummary summary) {
  if (summary.subtitleKey == 'house_norms_subtitle') {
    return s.houseNormSummarySubtitle;
  }
  if (_isDisplayText(summary.subtitle)) {
    return summary.subtitle;
  }
  return s.houseNormSummarySubtitle;
}

String localizeHouseNormSectionTitle(S s, HouseNormSection section) {
  final titleKey = section.titleKey;
  if (titleKey != null && titleKey.isNotEmpty) {
    final localizedFromKey = _sectionTitleFromTitleKey(s, titleKey);
    if (localizedFromKey != null) {
      return localizedFromKey;
    }
  }
  if (_isDisplayText(section.title)) {
    return section.title;
  }
  return _sectionTitleFromSectionKey(s, section.sectionKey) ?? s.houseNormSectionFallbackTitle;
}

String? _sectionTitleFromTitleKey(S s, String titleKey) {
  switch (titleKey) {
    case 'house_norms_section_rhythm_quiet_title':
      return s.houseNormSectionRhythmQuietTitle;
    case 'house_norms_section_shared_spaces_title':
      return s.houseNormSectionSharedSpacesTitle;
    case 'house_norms_section_guests_social_title':
      return s.houseNormSectionGuestsSocialTitle;
    case 'house_norms_section_responsibility_flow_title':
      return s.houseNormSectionResponsibilityFlowTitle;
    case 'house_norms_section_repair_style_title':
      return s.houseNormSectionRepairStyleTitle;
    case 'house_norms_section_home_identity_title':
      return s.houseNormSectionHomeIdentityTitle;
  }
  return null;
}

String? _sectionTitleFromSectionKey(S s, String sectionKey) {
  switch (sectionKey) {
    case 'norms_rhythm_quiet':
      return s.houseNormSectionRhythmQuietTitle;
    case 'norms_shared_spaces':
      return s.houseNormSectionSharedSpacesTitle;
    case 'norms_guests_social':
      return s.houseNormSectionGuestsSocialTitle;
    case 'norms_responsibility_flow':
      return s.houseNormSectionResponsibilityFlowTitle;
    case 'norms_repair_style':
      return s.houseNormSectionRepairStyleTitle;
    case 'norms_home_identity':
      return s.houseNormSectionHomeIdentityTitle;
  }
  return null;
}

bool _isDisplayText(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return false;
  return !RegExp(r'^[a-z0-9_]+$').hasMatch(trimmed);
}
