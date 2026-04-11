import 'package:go_router/go_router.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/app/router/app_route_paths.dart';
import 'package:kinly/app/router/route_fallback.dart';
import 'package:kinly/contracts/profile_settings/profile_identity_route_args.dart';
import 'package:kinly/contracts/profile_settings/profile_shared_unit_create_route_args.dart';
import 'package:kinly/contracts/profile_settings/profile_shared_unit_hub_route_args.dart';
import 'package:kinly/contracts/profile_settings/profile_shared_unit_rename_route_args.dart';
import 'package:kinly/features/profile_settings/connection/ui/connection_settings_provider.dart';
import 'package:kinly/features/profile_settings/edit/profile_identity_provider.dart';
import 'package:kinly/features/profile_settings/shared_unit_create/profile_shared_unit_create_provider.dart';
import 'package:kinly/features/profile_settings/shared_unit_hub/profile_shared_unit_hub_provider.dart';
import 'package:kinly/features/profile_settings/shared_unit_join/profile_shared_unit_join_provider.dart';
import 'package:kinly/features/profile_settings/shared_unit_rename/profile_shared_unit_rename_provider.dart';

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
          creatorMembershipId: args?.creatorMembershipId,
          initialUsername: args?.initialUsername,
          initialAvatarStoragePath: args?.initialAvatarStoragePath,
          initialAvatarUrl: args?.initialAvatarUrl,
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.profileSharedUnitHub,
      name: AppRouteNames.profileSharedUnitHub,
      builder: (_, state) {
        final args = state.extra as ProfileSharedUnitHubRouteArgs?;
        final routeContext = resolveContext();
        final homeId = args?.homeId ?? routeContext?.homeId;
        final creatorMembershipId = args?.creatorMembershipId;
        if (homeId == null ||
            creatorMembershipId == null ||
            creatorMembershipId.isEmpty) {
          return routeFallback(
            'profileSharedUnitHub',
            state: state,
            reason:
                'shared unit hub route is missing required membership context',
          );
        }
        return ProfileSharedUnitHubProvider(
          homeId: homeId,
          creatorMembershipId: creatorMembershipId,
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.profileSharedUnitCreate,
      name: AppRouteNames.profileSharedUnitCreate,
      builder: (_, state) {
        final args = state.extra as ProfileSharedUnitCreateRouteArgs?;
        if (args == null) {
          return routeFallback(
            'profileSharedUnitCreate',
            state: state,
            reason:
                'shared unit creation route is missing required membership context',
          );
        }
        return ProfileSharedUnitCreateProvider(
          homeId: args.homeId,
          creatorMembershipId: args.creatorMembershipId,
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.profileSharedUnitJoin,
      name: AppRouteNames.profileSharedUnitJoin,
      builder: (_, state) {
        final routeContext = resolveContext();
        final homeId = routeContext?.homeId;
        if (homeId == null) {
          return routeFallback(
            'profileSharedUnitJoin',
            state: state,
            reason:
                'active membership missing while shared unit join is restoring',
          );
        }
        return ProfileSharedUnitJoinProvider(homeId: homeId);
      },
    ),
    GoRoute(
      path: AppRoutePaths.profileSharedUnitRename,
      name: AppRouteNames.profileSharedUnitRename,
      builder: (_, state) {
        final args = state.extra as ProfileSharedUnitRenameRouteArgs?;
        if (args == null) {
          return routeFallback(
            'profileSharedUnitRename',
            state: state,
            reason:
                'shared unit rename route is missing required unit context',
          );
        }
        return ProfileSharedUnitRenameProvider(
          unitId: args.unitId,
          initialName: args.initialName,
        );
      },
    ),
  ];
}
