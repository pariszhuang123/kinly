import 'package:go_router/go_router.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/app/router/app_route_paths.dart';
import 'package:kinly/contracts/mood/ports/mood_repository.dart';
import 'package:kinly/core/di/locator.dart';
import 'package:kinly/features/nps/nps.dart';

class NpsRouteContext {
  const NpsRouteContext({required this.homeId});

  final String homeId;
}

typedef NpsRouteContextResolver = NpsRouteContext Function();

List<GoRoute> buildNpsRoutes({
  required NpsRouteContextResolver resolveContext,
}) {
  return [
    GoRoute(
      path: AppRoutePaths.nps,
      name: AppRouteNames.nps,
      builder: (_, __) {
        final membership = resolveContext();
        return NpsProvider(
          homeId: membership.homeId,
          moodRepository: sl<MoodRepository>(),
        );
      },
    ),
  ];
}
