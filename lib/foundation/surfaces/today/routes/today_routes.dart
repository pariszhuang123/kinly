import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/app/router/app_route_paths.dart';
import 'package:kinly/app/router/route_fallback.dart';
import 'package:kinly/contracts/flow/ports/chores_repository.dart';
import 'package:kinly/contracts/homes/ports/home_repository.dart';
import 'package:kinly/contracts/mood/ports/mood_repository.dart';
import 'package:kinly/contracts/mood/ports/house_pulse_repository.dart';
import 'package:kinly/contracts/onboarding/ports/onboarding_repository.dart';
import 'package:kinly/contracts/profile/ports/profile_repository.dart';
import 'package:kinly/contracts/share/ports/expenses_repository.dart';
import 'package:kinly/contracts/homes/ports/shopping_list_repository.dart';
import 'package:kinly/contracts/preferences/ports/preference_reports_repository.dart';
import 'package:kinly/core/di/locator.dart';
import 'package:kinly/core/notifications/profile_update_notifier.dart';
import 'package:kinly/foundation/surfaces/today/routes/today_house_pulse_route_args.dart';
import 'package:kinly/foundation/surfaces/today/routes/today_shopping_item_detail_route_args.dart';
import 'package:kinly/foundation/surfaces/today/routes/today_shopping_photo_route_args.dart';
import 'package:kinly/foundation/surfaces/today/routes/today_shopping_route_args.dart';
import 'package:kinly/foundation/surfaces/today/shopping/shopping_photo_viewer_screen.dart';
import 'package:kinly/foundation/surfaces/today/shopping/today_shopping_item_detail_screen.dart';
import 'package:kinly/foundation/surfaces/today/shopping/today_shopping_item_provider.dart';
import 'package:kinly/foundation/surfaces/today/shopping/today_shopping_list_provider.dart';
import 'package:kinly/foundation/surfaces/today/today_provider.dart';
import 'package:kinly/foundation/surfaces/today/widgets/today_house_pulse_detail_screen.dart';

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
          housePulseRepository: sl<HousePulseRepository>(),
          onboardingRepository: sl<OnboardingRepository>(),
          preferenceReportsRepository: sl<PreferenceReportsRepository>(),
          profileUpdateNotifier: sl<ProfileUpdateNotifier>(),
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.todayHousePulse,
      name: AppRouteNames.todayHousePulse,
      builder: (_, state) {
        final args = state.extra as TodayHousePulseRouteArgs?;
        if (args == null) {
          return routeFallback('todayHousePulse');
        }
        return BlocProvider.value(
          value: args.todayBloc,
          child: TodayHousePulseDetailScreen(pulse: args.pulse),
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.todayShoppingList,
      name: AppRouteNames.todayShoppingList,
      builder: (_, state) {
        final membership = resolveContext();
        final args = state.extra as TodayShoppingRouteArgs?;
        return TodayShoppingListProvider(
          homeId: args?.homeId ?? membership.homeId,
          shoppingListRepository: sl<ShoppingListRepository>(),
          expensesRepository: sl<ExpensesRepository>(),
          actor: args?.actor,
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.todayShoppingCreate,
      name: AppRouteNames.todayShoppingCreate,
      builder: (_, state) {
        final membership = resolveContext();
        final args = state.extra as TodayShoppingRouteArgs?;
        return TodayShoppingItemProvider(
          homeId: args?.homeId ?? membership.homeId,
          shoppingListRepository: sl<ShoppingListRepository>(),
          item: args?.item,
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.todayShoppingEdit,
      name: AppRouteNames.todayShoppingEdit,
      builder: (_, state) {
        final membership = resolveContext();
        final args = state.extra as TodayShoppingRouteArgs?;
        if (args?.item == null) {
          return routeFallback('todayShoppingEdit');
        }
        return TodayShoppingItemProvider(
          homeId: args?.homeId ?? membership.homeId,
          shoppingListRepository: sl<ShoppingListRepository>(),
          item: args?.item,
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.todayShoppingDetail,
      name: AppRouteNames.todayShoppingDetail,
      builder: (_, state) {
        final args = state.extra as TodayShoppingItemDetailRouteArgs?;
        if (args == null) {
          return routeFallback('todayShoppingDetail');
        }
        return TodayShoppingItemDetailScreen(
          item: args.item,
          photoUrl: args.photoUrl,
          onMarkComplete: args.onMarkComplete,
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.todayShoppingPhoto,
      name: AppRouteNames.todayShoppingPhoto,
      builder: (_, state) {
        final args = state.extra as TodayShoppingPhotoRouteArgs?;
        if (args == null) {
          return routeFallback('todayShoppingPhoto');
        }
        return ShoppingPhotoViewerScreen(
          photoUrl: args.photoUrl,
          title: args.title,
        );
      },
    ),
  ];
}
