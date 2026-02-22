import 'package:go_router/go_router.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/app/router/app_route_paths.dart';
import 'package:kinly/app/router/route_fallback.dart';
import 'package:kinly/contracts/profile_settings/profile_identity_route_args.dart';
import 'package:kinly/features/profile_settings/connection/ui/connection_settings_provider.dart';
import 'package:kinly/features/profile_settings/edit/profile_identity_provider.dart';

class ProfileSettingsDetailRouteContext {
  const ProfileSettingsDetailRouteContext({required this.homeId});

  final String homeId;
}

typedef ProfileSettingsDetailRouteContextResolver =
    ProfileSettingsDetailRouteContext? Function();

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
        final routeContext = resolveContext();
        final homeId = args?.homeId ?? routeContext?.homeId;
        if (homeId == null) {
          return routeFallback(
            'profileIdentity',
            state: state,
            reason:
                'active membership missing while Profile identity is restoring',
          );
        }
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
