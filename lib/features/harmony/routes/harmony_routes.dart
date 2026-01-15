import 'package:go_router/go_router.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/app/router/app_route_paths.dart';
import 'package:kinly/core/di/locator.dart';
import 'package:kinly/contracts/homes/ports/home_repository.dart';
import 'package:kinly/features/harmony/harmony.dart';
import 'package:kinly/features/harmony/ui/gratitude_wall/gratitude_wall_screen.dart';

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
          homeRepository: sl<HomeRepository>(),
          child: HarmonyPage(homeId: membership.homeId),
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.gratitudeWall,
      name: AppRouteNames.gratitudeWall,
      builder: (_, state) {
        final membership = resolveContext();
        final tabParam = state.uri.queryParameters['tab'];
        final initialTab =
            tabParam == 'personal'
                ? GratitudeTab.personal
                : GratitudeTab.house;
        return GratitudeWallProvider(
          homeId: membership.homeId,
          moodRepository: sl<MoodRepository>(),
          homeRepository: sl<HomeRepository>(),
          initialTab: initialTab,
        );
      },
    ),
  ];
}
