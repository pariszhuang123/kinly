class ProfileSettingsRouteArgs {
  const ProfileSettingsRouteArgs({
    required this.homeId,
    this.displayName,
    this.avatarUrl,
  });

  final String homeId;
  final String? displayName;
  final String? avatarUrl;
}
