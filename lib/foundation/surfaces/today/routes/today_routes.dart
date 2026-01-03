import 'package:go_router/go_router.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/app/router/app_route_paths.dart';
import 'package:kinly/contracts/flow/ports/chores_repository.dart';
import 'package:kinly/contracts/homes/ports/home_repository.dart';
import 'package:kinly/contracts/mood/ports/mood_repository.dart';
import 'package:kinly/contracts/onboarding/ports/onboarding_repository.dart';
import 'package:kinly/contracts/profile/ports/profile_repository.dart';
import 'package:kinly/contracts/share/ports/expenses_repository.dart';
import 'package:kinly/core/di/locator.dart';
import 'package:kinly/core/notifications/profile_update_notifier.dart';
import 'package:kinly/foundation/surfaces/today/today_provider.dart';

class TodayRouteContext {
  const TodayRouteContext({required this.homeId});

  final String homeId;
}

typedef TodayRouteContextResolver = TodayRouteContext Function();

List<GoRoute> buildTodayRoutes({
  required TodayRouteContextResolver resolveContext,
}) {
  return [
    GoRoute(
      path: AppRoutePaths.today,
      name: AppRouteNames.today,
      builder: (_, __) {
        final membership = resolveContext();
        return TodayProvider(
          homeId: membership.homeId,
          choresRepository: sl<ChoresRepository>(),
          profileRepository: sl<ProfileRepository>(),
          expensesRepository: sl<ExpensesRepository>(),
          homeRepository: sl<HomeRepository>(),
          moodRepository: sl<MoodRepository>(),
          onboardingRepository: sl<OnboardingRepository>(),
          profileUpdateNotifier: sl<ProfileUpdateNotifier>(),
        );
      },
    ),
  ];
}
