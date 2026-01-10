import 'package:go_router/go_router.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/app/router/app_route_paths.dart';
import 'package:kinly/contracts/homes/ports/home_repository.dart';
import 'package:kinly/contracts/preferences/ports/preference_reports_repository.dart';
import 'package:kinly/core/di/locator.dart';
import 'package:kinly/foundation/surfaces/hub/hub_provider.dart';
import 'package:kinly/foundation/surfaces/hub/routes/hub_preferences_list_route_args.dart';
import 'package:kinly/foundation/surfaces/hub/widget/hub_preferences_section.dart';

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
      builder: (_, __) {
        final membership = resolveContext();
        return HubProvider(
          homeId: membership.homeId,
          homeRepository: sl<HomeRepository>(),
          preferenceReportsRepository: sl<PreferenceReportsRepository>(),
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.hubPreferencesList,
      name: AppRouteNames.hubPreferencesList,
      builder: (_, state) {
        final args = state.extra as HubPreferencesListArgs?;
        if (args == null) {
          throw StateError('Hub preferences list requires args.');
        }
        return HubPreferencesListScreen(
          members: args.members,
          palette: args.palette,
        );
      },
    ),
  ];
}
