import 'package:go_router/go_router.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/app/router/app_route_paths.dart';
import 'package:kinly/features/splash/splash.dart';

List<GoRoute> buildSplashRoutes() {
  return [
    GoRoute(
      path: AppRoutePaths.splash,
      name: AppRouteNames.splash,
      builder: (_, __) => const SplashScreen(),
    ),
  ];
}
