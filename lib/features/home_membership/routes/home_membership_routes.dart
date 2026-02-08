import 'package:go_router/go_router.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/app/router/app_route_paths.dart';
import 'package:kinly/features/home_membership/join/ui/join_home_blocked_screen.dart';
import 'package:kinly/features/home_membership/join/ui/join_home_screen.dart';
import 'package:kinly/features/home_membership/start/ui/start_home_provider.dart';

List<GoRoute> buildHomeMembershipRoutes() {
  return [
    GoRoute(
      path: AppRoutePaths.start,
      name: AppRouteNames.start,
      builder: (_, __) => const StartHomeProvider(),
    ),
    GoRoute(
      path: AppRoutePaths.join,
      name: AppRouteNames.join,
      builder: (_, __) => const JoinHomeScreen(),
    ),
    GoRoute(
      path: AppRoutePaths.joinBlocked,
      name: AppRouteNames.joinBlocked,
      builder: (_, __) => const JoinHomeBlockedScreen(),
    ),
    GoRoute(
      path: AppRoutePaths.joinWithCode,
      name: AppRouteNames.joinWithCode,
      builder:
          (context, state) =>
              JoinHomeScreen(initialCode: state.pathParameters['code']),
    ),
    GoRoute(
      path: AppRoutePaths.webJoinWithCode,
      name: AppRouteNames.webJoinWithCode,
      builder:
          (context, state) =>
              JoinHomeScreen(initialCode: state.pathParameters['code']),
    ),
  ];
}
