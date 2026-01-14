String resolveHouseVibeAssetPath({
  required String mappingVersion,
  required String imageKey,
  String? labelId,
}) {
  final resolvedKey =
      imageKey.isNotEmpty ? imageKey : _fallbackImageKeyForLabel(labelId);
  final safeKey =
      (resolvedKey?.isNotEmpty ?? false)
          ? resolvedKey
          : _fallbackImageKeyForLabel('default_home');
  return 'assets/house_vibes/$mappingVersion/$safeKey.webp';
}

String? _fallbackImageKeyForLabel(String? labelId) {
  switch (labelId) {
    case 'insufficient_data':
      return 'vibe_insufficient_v1';
    case 'mixed_home':
      return 'vibe_mixed_v1';
    case 'default_home':
      return 'vibe_default_v1';
    case 'quiet_care_home':
      return 'vibe_quiet_care_v1';
    case 'social_home':
      return 'vibe_social_v1';
    case 'structured_home':
      return 'vibe_structured_v1';
    case 'easygoing_home':
      return 'vibe_easygoing_v1';
    case 'independent_home':
      return 'vibe_independent_v1';
  }
  return null;
}
