import 'package:go_router/go_router.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/app/router/app_route_paths.dart';
import 'package:kinly/contracts/homes/ports/home_repository.dart';
import 'package:kinly/contracts/mood/ports/mood_repository.dart';
import 'package:kinly/core/di/locator.dart';
import 'package:kinly/features/harmony/ui/gratitude_wall/personal_mentions_screen.dart';

List<GoRoute> buildPersonalRoutes() {
  return [
    GoRoute(
      path: AppRoutePaths.personalMentions,
      name: AppRouteNames.personalMentions,
      builder: (_, state) {
        final extra = state.extra;
        final fromParam = state.uri.queryParameters['from'];
        final entrySource =
            extra is Map && extra['entrySource'] is String
                ? extra['entrySource'] as String
                : extra is String
                    ? extra
                    : fromParam;
        return PersonalMentionsProvider(
          moodRepository: sl<MoodRepository>(),
          homeRepository: sl<HomeRepository>(),
          homeId: null,
          entrySource: entrySource,
        );
      },
    ),
  ];
}
