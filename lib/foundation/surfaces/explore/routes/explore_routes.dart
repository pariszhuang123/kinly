import 'package:go_router/go_router.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/app/router/app_route_paths.dart';
import 'package:kinly/foundation/surfaces/explore/explore_surface.dart';

class ExploreRouteContext {
  const ExploreRouteContext();
}

typedef ExploreRouteContextResolver = ExploreRouteContext Function();

List<GoRoute> buildExploreRoutes({
  required ExploreRouteContextResolver resolveContext,
}) {
  return [
    GoRoute(
      path: AppRoutePaths.explore,
      name: AppRouteNames.explore,
      builder: (_, __) => const ExploreScreen(),
    ),
  ];
}
