import 'package:go_router/go_router.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/app/router/app_route_paths.dart';
import 'package:kinly/contracts/homes/ports/home_repository.dart';
import 'package:kinly/core/di/locator.dart';
import 'package:kinly/foundation/surfaces/hub/hub_provider.dart';

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
        );
      },
    ),
  ];
}
