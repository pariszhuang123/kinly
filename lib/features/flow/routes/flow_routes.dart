import 'package:go_router/go_router.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/app/router/app_route_paths.dart';
import 'package:kinly/app/router/route_fallback.dart';
import 'package:kinly/contracts/flow/ports/chores_repository.dart';
import 'package:kinly/contracts/homes/ports/home_repository.dart';
import 'package:kinly/core/di/locator.dart';
import 'package:kinly/features/flow/ui/flow_chore_detail/widgets/flow_chore_expectation_photo_viewer.dart';
import 'package:kinly/features/flow/ui/flow_chore_detail/flow_chore_detail_provider.dart';
import 'package:kinly/features/flow/ui/flow_chore_provider.dart';
import 'package:kinly/features/flow/ui/flow_list_filter.dart';
import 'package:kinly/features/flow/ui/flow_list_provider.dart';

class FlowRouteContext {
  const FlowRouteContext({required this.homeId, required this.userId});

  final String homeId;
  final String userId;
}

typedef FlowRouteContextResolver = FlowRouteContext Function();

List<GoRoute> buildFlowRoutes({
  required FlowRouteContextResolver resolveContext,
}) {
  String resolveHomeId(GoRouterState state) {
    return state.uri.queryParameters['homeId'] ?? resolveContext().homeId;
  }

  String resolveUserId(GoRouterState state) {
    return state.uri.queryParameters['userId'] ?? resolveContext().userId;
  }

  return [
    GoRoute(
      path: AppRoutePaths.flow,
      name: AppRouteNames.flow,
      builder: (_, state) {
        final homeId = resolveHomeId(state);
        final userId = resolveUserId(state);
        final filter = FlowListFilter.fromQueryParam(
          state.uri.queryParameters['filter'],
        );
        final scope = state.uri.queryParameters['scope'];
        final showOnlyMine = scope == 'mine';
        return FlowListProvider(
          homeId: homeId,
          choresRepository: sl<ChoresRepository>(),
          homeRepository: sl<HomeRepository>(),
          filter: filter,
          currentUserId: userId,
          showOnlyCurrentUser: showOnlyMine,
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.flowChoreCreate,
      name: AppRouteNames.flowChoreCreate,
      builder: (_, state) {
        final homeId = resolveHomeId(state);
        return FlowChoreProvider(
          homeId: homeId,
          choresRepository: sl<ChoresRepository>(),
          homeRepository: sl<HomeRepository>(),
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.flowChorePhoto,
      name: AppRouteNames.flowChorePhoto,
      builder: (_, state) {
        final args = state.extra as FlowChorePhotoViewerArgs?;
        final photoUrl = args?.photoUrl ?? state.uri.queryParameters['photoUrl'];
        if (photoUrl == null || photoUrl.isEmpty) {
          return routeFallback(
            'flowChorePhoto',
            state: state,
            reason: 'photoUrl missing from extra and query',
          );
        }
        final title = args?.title ?? state.uri.queryParameters['title'];
        final heroTag =
            args?.heroTag ??
            state.uri.queryParameters['heroTag'] ??
            'flow-chore-photo-${photoUrl.hashCode}';
        return FlowChoreExpectationPhotoViewerPage(
          photoUrl: photoUrl,
          heroTag: heroTag,
          title: title,
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.flowChoreEdit,
      name: AppRouteNames.flowChoreEdit,
      builder: (_, state) {
        final homeId = resolveHomeId(state);
        final choreId = state.pathParameters['choreId']!;
        return FlowChoreProvider(
          homeId: homeId,
          choresRepository: sl<ChoresRepository>(),
          homeRepository: sl<HomeRepository>(),
          choreId: choreId,
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.flowChoreDetail,
      name: AppRouteNames.flowChoreDetail,
      builder: (_, state) {
        final homeId = resolveHomeId(state);
        final choreId = state.pathParameters['choreId']!;
        return FlowChoreDetailProvider(
          homeId: homeId,
          choreId: choreId,
          choresRepository: sl<ChoresRepository>(),
        );
      },
    ),
  ];
}
