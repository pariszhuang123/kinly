import 'package:go_router/go_router.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/app/router/app_route_paths.dart';
import 'package:kinly/core/di/locator.dart';
import 'package:kinly/contracts/homes/ports/home_repository.dart';
import 'package:kinly/features/harmony/harmony.dart';

class HarmonyRouteContext {
  const HarmonyRouteContext({required this.homeId});

  final String homeId;
}

typedef HarmonyRouteContextResolver = HarmonyRouteContext Function();

List<GoRoute> buildHarmonyRoutes({
  required HarmonyRouteContextResolver resolveContext,
}) {
  return [
    GoRoute(
      path: AppRoutePaths.harmony,
      name: AppRouteNames.harmony,
      builder: (_, __) {
        final membership = resolveContext();
        return HarmonyProvider(
          homeId: membership.homeId,
          moodRepository: sl<MoodRepository>(),
          child: HarmonyPage(homeId: membership.homeId),
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.gratitudeWall,
      name: AppRouteNames.gratitudeWall,
      builder: (_, __) {
        final membership = resolveContext();
        return GratitudeWallProvider(
          homeId: membership.homeId,
          moodRepository: sl<MoodRepository>(),
          homeRepository: sl<HomeRepository>(),
        );
      },
    ),
  ];
}
