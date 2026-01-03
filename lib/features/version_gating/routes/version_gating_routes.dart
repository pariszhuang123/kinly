import 'package:go_router/go_router.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/app/router/app_route_paths.dart';
import 'package:kinly/features/version_gating/version_gating.dart';

List<GoRoute> buildVersionGatingRoutes() {
  return [
    GoRoute(
      path: AppRoutePaths.forceUpdate,
      name: AppRouteNames.forceUpdate,
      builder: (_, __) => const ForceUpdateScreen(),
    ),
  ];
}
