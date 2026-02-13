import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/app/router/app_route_paths.dart';
import 'package:kinly/app/router/home_tab_navigation.dart';
import 'package:kinly/app/router/route_fallback.dart';
import 'package:kinly/contracts/homes/ports/home_repository.dart';
import 'package:kinly/contracts/preferences/ports/preference_reports_repository.dart';
import 'package:kinly/contracts/preferences/ports/house_vibe_repository.dart';
import 'package:kinly/core/di/locator.dart';
import 'package:kinly/foundation/surfaces/hub/hub_provider.dart';
import 'package:kinly/foundation/surfaces/hub/routes/hub_house_vibe_share_route_args.dart';
import 'package:kinly/foundation/surfaces/hub/routes/hub_preferences_list_route_args.dart';
import 'package:kinly/foundation/surfaces/hub/widget/hub_preferences_list_screen.dart';

class HubRouteContext {
  const HubRouteContext({required this.homeId});

  final String homeId;
}

typedef HubRouteContextResolver = HubRouteContext Function();

List<GoRoute> buildHubRoutes({
  required HubRouteContextResolver resolveContext,
}) {
  return [
    GoRoute(
      path: AppRoutePaths.hub,
      name: AppRouteNames.hub,
      pageBuilder: (_, state) {
        final membership = resolveContext();
        final navExtra = homeTabNavExtraFrom(state.extra);
        final begin = homeTabEntryOffset(
          targetIndex: homeTabIndexHub,
          navExtra: navExtra,
        );
        return CustomTransitionPage<void>(
          key: state.pageKey,
          child: HubProvider(
            homeId: membership.homeId,
            homeRepository: sl<HomeRepository>(),
            preferenceReportsRepository: sl<PreferenceReportsRepository>(),
            houseVibeRepository: sl<HouseVibeRepository>(),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            if (begin == Offset.zero) {
              return child;
            }
            return SlideTransition(
              position: animation.drive(
                Tween<Offset>(
                  begin: begin,
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.easeOutCubic)),
              ),
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.hubPreferencesList,
      name: AppRouteNames.hubPreferencesList,
      builder: (_, state) {
        final args = state.extra as HubPreferencesListArgs?;
        if (args == null) {
          return routeFallback('hubPreferencesList');
        }
        return HubPreferencesListScreen(
          members: args.members,
          palette: args.palette,
          currentUserId: args.currentUserId,
          houseVibe: args.houseVibe,
          hubBloc: args.hubBloc,
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.hubHouseVibeShare,
      name: AppRouteNames.hubHouseVibeShare,
      builder: (_, state) {
        final args = state.extra as HubHouseVibeShareArgs?;
        if (args == null) {
          return routeFallback('hubHouseVibeShare');
        }
        return HouseVibeShareScreen(
          vibe: args.vibe,
          palette: args.palette,
          hubBloc: args.hubBloc,
        );
      },
    ),
  ];
}
