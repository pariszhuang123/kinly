import 'package:go_router/go_router.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/app/router/app_route_paths.dart';
import 'package:kinly/features/welcome/ui/welcome_screen.dart';

List<GoRoute> buildWelcomeRoutes() {
  return [
    GoRoute(
      path: AppRoutePaths.welcome,
      name: AppRouteNames.welcome,
      builder: (_, __) => const WelcomeScreen(),
    ),
  ];
}
