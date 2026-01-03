import 'package:go_router/go_router.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/app/router/app_route_paths.dart';
import 'package:kinly/foundation/surfaces/profile/profile_info_hub_webview.dart';

List<GoRoute> buildProfileRoutes() {
  return [
    GoRoute(
      path: AppRoutePaths.infoHub,
      name: AppRouteNames.infoHub,
      builder: (_, __) => const InfoHubWebViewScreen(),
    ),
  ];
}
