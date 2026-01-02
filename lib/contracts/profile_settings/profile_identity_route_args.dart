class ProfileIdentityRouteArgs {
  const ProfileIdentityRouteArgs({
    required this.homeId,
    this.initialUsername,
    this.initialAvatarStoragePath,
    this.initialAvatarUrl,
  });

  final String homeId;
  final String? initialUsername;
  final String? initialAvatarStoragePath;
  final String? initialAvatarUrl;
}
