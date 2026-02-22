import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/app/router/app_route_paths.dart';
import 'package:kinly/app/router/route_fallback.dart';
import 'package:kinly/contracts/profile_settings/profile_settings_route_args.dart';
import 'package:kinly/foundation/surfaces/profile/profile_provider.dart';

class ProfileSettingsRouteContext {
  const ProfileSettingsRouteContext({required this.homeId});

  final String homeId;
}

typedef ProfileSettingsRouteContextResolver =
    ProfileSettingsRouteContext? Function();
typedef ProfileSettingsMembershipRefresh = void Function();
typedef ProfileSettingsSignOut = void Function();

List<GoRoute> buildProfileSettingsRoutes({
  required ProfileSettingsRouteContextResolver resolveContext,
  required ProfileSettingsMembershipRefresh onMembershipRefresh,
  required ProfileSettingsSignOut onSignOut,
}) {
  return [
    GoRoute(
      path: AppRoutePaths.profileSettings,
      name: AppRouteNames.profileSettings,
      pageBuilder: (_, state) {
        final args = state.extra as ProfileSettingsRouteArgs?;
        final routeContext = resolveContext();
        final homeId = args?.homeId ?? routeContext?.homeId;
        if (homeId == null) {
          return CustomTransitionPage<void>(
            key: state.pageKey,
            child: routeFallback(
              'profileSettings',
              state: state,
              reason:
                  'active membership missing while Profile settings is restoring',
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) => child,
          );
        }
        return CustomTransitionPage<void>(
          key: state.pageKey,
          child: ProfileSettingsProvider(
            homeId: homeId,
            initialDisplayName: args?.displayName,
            initialAvatarUrl: args?.avatarUrl,
            onMembershipRefresh: onMembershipRefresh,
            onSignOut: onSignOut,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(
                Tween<Offset>(
                  begin: const Offset(1, -1),
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.easeOutCubic)),
              ),
              child: child,
            );
          },
        );
      },
    ),
  ];
}
