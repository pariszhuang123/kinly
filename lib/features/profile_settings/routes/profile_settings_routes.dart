import 'package:go_router/go_router.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/app/router/app_route_paths.dart';
import 'package:kinly/contracts/profile_settings/profile_identity_route_args.dart';
import 'package:kinly/features/profile_settings/connection/ui/connection_settings_provider.dart';
import 'package:kinly/features/profile_settings/edit/profile_identity_provider.dart';

class ProfileSettingsDetailRouteContext {
  const ProfileSettingsDetailRouteContext({required this.homeId});

  final String homeId;
}

typedef ProfileSettingsDetailRouteContextResolver =
    ProfileSettingsDetailRouteContext Function();

List<GoRoute> buildProfileSettingsDetailRoutes({
  required ProfileSettingsDetailRouteContextResolver resolveContext,
}) {
  return [
    GoRoute(
      path: AppRoutePaths.connectionSettings,
      name: AppRouteNames.connectionSettings,
      builder: (_, __) => ConnectionSettingsProvider(),
    ),
    GoRoute(
      path: AppRoutePaths.profileIdentity,
      name: AppRouteNames.profileIdentity,
      builder: (_, state) {
        final args = state.extra as ProfileIdentityRouteArgs?;
        final homeId = args?.homeId ?? resolveContext().homeId;
        return ProfileIdentityProvider(
          homeId: homeId,
          initialUsername: args?.initialUsername,
          initialAvatarStoragePath: args?.initialAvatarStoragePath,
          initialAvatarUrl: args?.initialAvatarUrl,
        );
      },
    ),
  ];
}
