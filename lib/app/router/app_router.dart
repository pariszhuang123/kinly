import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/app/router/app_route_paths.dart';
import 'package:kinly/core/logging/logger.dart';
import 'package:kinly/features/flow/routes/flow_routes.dart';
import 'package:kinly/features/share/routes/share_routes.dart';
import 'package:kinly/core/auth/bloc/auth_bloc.dart';
import 'package:kinly/features/version_gating/bloc/app_version_cubit.dart';
import 'package:kinly/features/harmony/routes/harmony_routes.dart';
import 'package:kinly/features/house_directory/routes/house_directory_routes.dart';
import 'package:kinly/features/home_membership/routes/home_membership_routes.dart';
import 'package:kinly/features/personal_directory/routes/personal_directory_routes.dart';
import 'package:kinly/foundation/surfaces/explore/routes/explore_routes.dart';
import 'package:kinly/foundation/surfaces/hub/routes/hub_routes.dart';
import 'package:kinly/features/nps/routes/nps_routes.dart';
import 'package:kinly/features/paywall/routes/paywall_routes.dart';
import 'package:kinly/features/splash/routes/splash_routes.dart';
import 'package:kinly/foundation/surfaces/profile/routes/profile_settings_routes.dart';
import 'package:kinly/features/profile_settings/routes/profile_settings_routes.dart';
import 'package:kinly/foundation/surfaces/today/routes/today_routes.dart';
import 'package:kinly/foundation/surfaces/profile/routes/profile_routes.dart';
import 'package:kinly/features/version_gating/routes/version_gating_routes.dart';
import 'package:kinly/features/welcome/routes/welcome_routes.dart';
import 'package:kinly/features/preferences/routes/preferences_routes.dart';
import 'package:kinly/features/house_norms/routes/house_norm_routes.dart';
import 'package:kinly/features/fit_check/routes/fit_check_routes.dart';
import 'package:kinly/features/harmony/routes/personal_routes.dart';

import 'navigation_intents.dart';

part 'app_router_redirects.dart';
part 'app_router_routes.dart';

class AppRoutes {
  static const splash = AppRoutePaths.splash;
  static const forceUpdate = AppRoutePaths.forceUpdate;
  static const welcome = AppRoutePaths.welcome;
  static const demoAccess = AppRoutePaths.demoAccess;
  static const start = AppRoutePaths.start;
  static const join = AppRoutePaths.join;
  static const joinBlocked = AppRoutePaths.joinBlocked;
  static const infoHub = AppRoutePaths.infoHub;
  static const today = AppRoutePaths.today;
  static const hub = AppRoutePaths.hub;
  static const houseDirectory = AppRoutePaths.houseDirectory;
  static const houseDirectoryDetails = AppRoutePaths.houseDirectoryDetails;
  static const personalDirectory = AppRoutePaths.personalDirectory;
  static const personalDirectoryBank = AppRoutePaths.personalDirectoryBank;
  static const personalDirectoryNote = AppRoutePaths.personalDirectoryNote;
  static const explore = AppRoutePaths.explore;
  static const flow = AppRoutePaths.flow;
  static const flowChoreCreate = AppRoutePaths.flowChoreCreate;
  static const flowChoreEdit = AppRoutePaths.flowChoreEdit;
  static const flowChoreDetail = AppRoutePaths.flowChoreDetail;
  static const flowChorePhoto = AppRoutePaths.flowChorePhoto;
  static const shareCreate = AppRoutePaths.shareCreate;
  static const shareDraftEdit = AppRoutePaths.shareDraftEdit;
  static const shareCreatedList = AppRoutePaths.shareCreatedList;
  static const shareOwedDetail = AppRoutePaths.shareOwedDetail;
  static const sharePaidToMeDetail = AppRoutePaths.sharePaidToMeDetail;
  static const profileSettings = AppRoutePaths.profileSettings;
  static const profileSharedUnitHub = AppRoutePaths.profileSharedUnitHub;
  static const profileSharedUnitCreate = AppRoutePaths.profileSharedUnitCreate;
  static const profileSharedUnitJoin = AppRoutePaths.profileSharedUnitJoin;
  static const profileSharedUnitRename = AppRoutePaths.profileSharedUnitRename;
  static const profileIdentity = AppRoutePaths.profileIdentity;
  static const connectionSettings = AppRoutePaths.connectionSettings;
  static const harmony = AppRoutePaths.harmony;
  static const gratitudeWall = AppRoutePaths.gratitudeWall;
  static const nps = AppRoutePaths.nps;
  static const paywall = AppRoutePaths.paywall;
  static const preferenceOnboarding = AppRoutePaths.preferenceOnboarding;
  static const preferenceReport = AppRoutePaths.preferenceReport;
  static const preferenceReportEdit = AppRoutePaths.preferenceReportEdit;
  static const preferenceReportSectionEdit =
      AppRoutePaths.preferenceReportSectionEdit;
  static const houseNormsOnboarding = AppRoutePaths.houseNormsOnboarding;
  static const houseNormsReport = AppRoutePaths.houseNormsReport;
  static const houseNormsEdit = AppRoutePaths.houseNormsEdit;
  static const houseNormsSectionEdit = AppRoutePaths.houseNormsSectionEdit;
  static const fitCheckClaim = AppRoutePaths.fitCheckClaim;
  static const fitCheckAttach = AppRoutePaths.fitCheckAttach;
  static const fitCheckInbox = AppRoutePaths.fitCheckInbox;
  static const fitCheckBriefing = AppRoutePaths.fitCheckBriefing;
  static const personalMentions = AppRoutePaths.personalMentions;

  static String flowChoreEditPath(String choreId) =>
      '${AppRoutePaths.flow}/chore/$choreId';
  static String flowChoreDetailPath(String choreId) =>
      '${AppRoutePaths.flow}/chore/$choreId/detail';
  static String shareDraftEditPath(String expenseId) =>
      '${AppRoutePaths.shareCreate.replaceAll('/new', '')}/$expenseId/edit';
}

GoRouter createRouter({
  required AuthBloc authBloc,
  required AppVersionCubit appVersionCubit,
  required Listenable refreshListenable,
  required Logger logger,
}) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    restorationScopeId: 'kinly_router',
    refreshListenable: refreshListenable,
    redirect:
        (context, state) => _redirect(
          state: state,
          authBloc: authBloc,
          appVersionCubit: appVersionCubit,
          logger: logger,
        ),
    routes: _buildRoutes(authBloc),
    errorBuilder: (context, state) {
      final error = state.error;
      logger.error(
        'Routing failed; attempting recovery. '
        'uri=${state.uri} '
        'name=${state.name} '
        'pathParams=${state.pathParameters} '
        'query=${state.uri.queryParameters} '
        'extraType=${state.extra?.runtimeType} '
        'scheme=${state.uri.scheme}',
        error: error,
      );
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _recoverFromRoutingFailure(
          context: context,
          state: state,
          logger: logger,
        ),
      );
      return const SizedBox.shrink();
    },
  );
}

void _recoverFromRoutingFailure({
  required BuildContext context,
  required GoRouterState state,
  required Logger logger,
}) {
  final router = GoRouter.of(context);
  final path = state.uri.path;
  final query = state.uri.queryParameters;
  if (_isJoinPath(path)) {
    _redirectToJoinWithCode(router: router, uri: state.uri, logger: logger);
    return;
  }
  if (path.startsWith(AppRoutePaths.todayShoppingList)) {
    _redirectToShoppingList(router: router, query: query, uri: state.uri, logger: logger);
    return;
  }
  if (path.startsWith(AppRoutePaths.flow)) {
    _redirectToFlowList(router: router, query: query, uri: state.uri, logger: logger);
    return;
  }
  if (router.canPop()) {
    logger.warn(
      'Routing failure recovered by popping route. uri=${state.uri}',
      tag: 'Router',
    );
    router.pop();
    return;
  }
  logger.warn(
    'Routing failure has no back stack; redirecting to Today. '
    'uri=${state.uri}',
    tag: 'Router',
  );
  router.goNamed(AppRouteNames.today);
}

void _redirectToJoinWithCode({
  required GoRouter router,
  required Uri uri,
  required Logger logger,
}) {
  final segments = uri.pathSegments;
  final normalizedSegments =
      segments.map((segment) => segment.trim().toLowerCase()).toList();
  final joinIndex = normalizedSegments.indexOf('join');
  final code =
      (joinIndex >= 0 && joinIndex < segments.length - 1)
          ? segments[joinIndex + 1]
          : null;
  logger.warn(
    'Routing failure recovered by redirecting to Join. '
    'uri=$uri',
    tag: 'Router',
  );
  if (code != null && code.trim().isNotEmpty) {
    router.goNamed(
      AppRouteNames.joinWithCode,
      pathParameters: {'code': code},
    );
    return;
  }
  router.goNamed(AppRouteNames.join);
}

bool _isJoinPath(String path) =>
    path.toLowerCase().startsWith('${AppRoutePaths.join}/') ||
    path.toLowerCase().startsWith('/kinly/join/');

void _redirectToShoppingList({
  required GoRouter router,
  required Map<String, String> query,
  required Uri uri,
  required Logger logger,
}) {
  final homeId = query['homeId'];
  logger.warn(
    'Routing failure has no back stack; redirecting to Shopping list. '
    'uri=$uri',
    tag: 'Router',
  );
  if (homeId != null && homeId.isNotEmpty) {
    router.goNamed(
      AppRouteNames.todayShoppingList,
      queryParameters: {'homeId': homeId},
    );
    return;
  }
  router.goNamed(AppRouteNames.todayShoppingList);
}

void _redirectToFlowList({
  required GoRouter router,
  required Map<String, String> query,
  required Uri uri,
  required Logger logger,
}) {
  final flowQuery = _buildFlowQuery(query);
  logger.warn(
    'Routing failure has no back stack; redirecting to Flow list. '
    'uri=$uri',
    tag: 'Router',
  );
  if (flowQuery.isEmpty) {
    router.goNamed(AppRouteNames.flow);
    return;
  }
  router.goNamed(AppRouteNames.flow, queryParameters: flowQuery);
}

Map<String, String> _buildFlowQuery(Map<String, String> query) {
  final flowQuery = <String, String>{};
  final homeId = query['homeId'];
  final userId = query['userId'];
  final filter = query['filter'];
  final scope = query['scope'];
  if (homeId != null && homeId.isNotEmpty) {
    flowQuery['homeId'] = homeId;
  }
  if (userId != null && userId.isNotEmpty) {
    flowQuery['userId'] = userId;
  }
  if (filter != null && filter.isNotEmpty) {
    flowQuery['filter'] = filter;
  }
  if (scope != null && scope.isNotEmpty) {
    flowQuery['scope'] = scope;
  }
  return flowQuery;
}
