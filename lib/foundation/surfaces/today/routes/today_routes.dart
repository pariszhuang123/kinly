import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/app/router/app_route_paths.dart';
import 'package:kinly/app/router/home_tab_navigation.dart';
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
import 'package:kinly/contracts/house_norms/ports/house_norms_repository.dart';
import 'package:kinly/contracts/house_directory/ports/house_directory_repository.dart';
import 'package:kinly/contracts/personal_directory/ports/personal_directory_repository.dart';
import 'package:kinly/core/di/locator.dart';
import 'package:kinly/core/notifications/profile_update_notifier.dart';
import 'package:kinly/foundation/surfaces/today/routes/today_house_pulse_route_args.dart';
import 'package:kinly/foundation/surfaces/today/routes/today_shopping_photo_route_args.dart';
import 'package:kinly/foundation/surfaces/today/routes/today_shopping_route_args.dart';
import 'package:kinly/foundation/surfaces/today/shopping/shopping_photo_viewer_screen.dart';
import 'package:kinly/foundation/surfaces/today/shopping/today_shopping_item_detail_provider.dart';
import 'package:kinly/foundation/surfaces/today/shopping/today_shopping_item_provider.dart';
import 'package:kinly/foundation/surfaces/today/shopping/today_shopping_list_provider.dart';
import 'package:kinly/foundation/surfaces/today/today_provider.dart';
import 'package:kinly/foundation/surfaces/today/widgets/today_house_pulse_detail_screen.dart';

class TodayRouteContext {
  const TodayRouteContext({required this.homeId});

  final String homeId;
}

typedef TodayRouteContextResolver = TodayRouteContext? Function();

List<GoRoute> buildTodayRoutes({
  required TodayRouteContextResolver resolveContext,
}) {
  return [
    GoRoute(
      path: AppRoutePaths.today,
      name: AppRouteNames.today,
      pageBuilder: (_, state) {
        final membership = resolveContext();
        if (membership == null) {
          return CustomTransitionPage<void>(
            key: state.pageKey,
            child: routeFallback(
              'today',
              state: state,
              reason: 'active membership missing while Today is restoring',
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) => child,
          );
        }
        final navExtra = homeTabNavExtraFrom(state.extra);
        final begin = homeTabEntryOffset(
          targetIndex: homeTabIndexToday,
          navExtra: navExtra,
        );
        return CustomTransitionPage<void>(
          key: state.pageKey,
          child: TodayProvider(
            homeId: membership.homeId,
            choresRepository: sl<ChoresRepository>(),
            profileRepository: sl<ProfileRepository>(),
            expensesRepository: sl<ExpensesRepository>(),
            homeRepository: sl<HomeRepository>(),
            moodRepository: sl<MoodRepository>(),
            housePulseRepository: sl<HousePulseRepository>(),
            onboardingRepository: sl<OnboardingRepository>(),
            preferenceReportsRepository: sl<PreferenceReportsRepository>(),
            houseNormsRepository:
                sl.isRegistered<HouseNormsRepository>()
                    ? sl<HouseNormsRepository>()
                    : null,
            houseDirectoryRepository:
                sl.isRegistered<HouseDirectoryRepository>()
                    ? sl<HouseDirectoryRepository>()
                    : null,
            personalDirectoryRepository:
                sl.isRegistered<PersonalDirectoryRepository>()
                    ? sl<PersonalDirectoryRepository>()
                    : null,
            profileUpdateNotifier: sl<ProfileUpdateNotifier>(),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            if (begin == Offset.zero) {
              return child;
            }
            return SlideTransition(
              position: animation.drive(
                Tween<Offset>(
                  begin: begin,
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.easeOutCubic)),
              ),
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.todayHousePulse,
      name: AppRouteNames.todayHousePulse,
      builder: (_, state) {
        final args = state.extra as TodayHousePulseRouteArgs?;
        if (args == null) {
          return routeFallback(
            'todayHousePulse',
            state: state,
            reason: 'TodayHousePulseRouteArgs missing in state.extra',
          );
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
        final args = state.extra as TodayShoppingRouteArgs?;
        final routeContext = resolveContext();
        final homeId =
            args?.homeId ??
            state.uri.queryParameters['homeId'] ??
            routeContext?.homeId;
        if (homeId == null) {
          return routeFallback(
            'todayShoppingList',
            state: state,
            reason: 'homeId unavailable while active membership is unresolved',
          );
        }
        return TodayShoppingListProvider(
          homeId: homeId,
          shoppingListRepository: sl<ShoppingListRepository>(),
          actor: args?.actor,
          mode: args?.listMode ?? TodayShoppingListMode.purchase,
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.todayShoppingCreate,
      name: AppRouteNames.todayShoppingCreate,
      builder: (_, state) {
        final args = state.extra as TodayShoppingRouteArgs?;
        final routeContext = resolveContext();
        final homeId =
            args?.homeId ??
            state.uri.queryParameters['homeId'] ??
            routeContext?.homeId;
        if (homeId == null) {
          return routeFallback(
            'todayShoppingCreate',
            state: state,
            reason: 'homeId unavailable while active membership is unresolved',
          );
        }
        return TodayShoppingItemProvider(
          homeId: homeId,
          shoppingListRepository: sl<ShoppingListRepository>(),
          item: args?.item,
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.todayShoppingEdit,
      name: AppRouteNames.todayShoppingEdit,
      builder: (_, state) {
        final args = state.extra as TodayShoppingRouteArgs?;
        final routeContext = resolveContext();
        final homeId =
            args?.homeId ??
            state.uri.queryParameters['homeId'] ??
            routeContext?.homeId;
        if (homeId == null) {
          return routeFallback(
            'todayShoppingEdit',
            state: state,
            reason: 'homeId unavailable while active membership is unresolved',
          );
        }
        final itemId = state.pathParameters['itemId'];
        if (itemId == null || itemId.isEmpty) {
          return routeFallback(
            'todayShoppingEdit',
            state: state,
            reason: 'itemId path parameter missing',
          );
        }
        return TodayShoppingItemProvider(
          homeId: homeId,
          shoppingListRepository: sl<ShoppingListRepository>(),
          editItemId: itemId,
          item: args?.item,
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.todayShoppingDetail,
      name: AppRouteNames.todayShoppingDetail,
      builder: (_, state) {
        final routeContext = resolveContext();
        final homeId =
            state.uri.queryParameters['homeId'] ?? routeContext?.homeId;
        if (homeId == null) {
          return routeFallback(
            'todayShoppingDetail',
            state: state,
            reason: 'homeId unavailable while active membership is unresolved',
          );
        }
        final itemId = state.pathParameters['itemId'];
        if (itemId == null || itemId.isEmpty) {
          return routeFallback(
            'todayShoppingDetail',
            state: state,
            reason: 'itemId path parameter missing',
          );
        }
        return TodayShoppingItemDetailProvider(
          homeId: homeId,
          itemId: itemId,
          shoppingListRepository: sl<ShoppingListRepository>(),
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.todayShoppingPhoto,
      name: AppRouteNames.todayShoppingPhoto,
      builder: (_, state) {
        final args = state.extra as TodayShoppingPhotoRouteArgs?;
        final photoUrl = args?.photoUrl ?? state.uri.queryParameters['photoUrl'];
        if (photoUrl == null || photoUrl.isEmpty) {
          return routeFallback(
            'todayShoppingPhoto',
            state: state,
            reason: 'photoUrl missing from extra and query',
          );
        }
        return ShoppingPhotoViewerScreen(
          photoUrl: photoUrl,
          title:
              args?.title ??
              state.uri.queryParameters['title'] ??
              'Photo',
          heroTag:
              args?.heroTag ??
              state.uri.queryParameters['heroTag'] ??
              'shopping-photo-${photoUrl.hashCode}',
        );
      },
    ),
  ];
}
