import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/app/router/app_route_paths.dart';
import 'package:kinly/core/di/locator.dart';
import 'package:kinly/core/logging/logger.dart';

/// Returns a widget that logs the error and redirects to Today.
///
/// Use this in route builders when required args are missing,
/// instead of throwing a [StateError].
Widget routeFallback(
  String routeName, {
  GoRouterState? state,
  String? reason,
}) {
  final uri = state?.uri.toString() ?? 'unknown';
  final pathParams = state?.pathParameters;
  final queryParams = state?.uri.queryParameters;
  final extraType = state?.extra?.runtimeType.toString();
  final detail = reason ?? 'missing required args';
  final message = 'Missing required args for "$routeName", redirecting to Today';
  sl<Logger>().error(
    message,
    error: StateError(
      'Route "$routeName" fallback: reason=$detail uri=$uri '
      'pathParams=$pathParams query=$queryParams extraType=$extraType',
    ),
  );
  return _RedirectToToday(routeName: routeName, fromUri: uri);
}

class _RedirectToToday extends StatefulWidget {
  const _RedirectToToday({required this.routeName, required this.fromUri});

  final String routeName;
  final String fromUri;

  @override
  State<_RedirectToToday> createState() => _RedirectToTodayState();
}

class _RedirectToTodayState extends State<_RedirectToToday> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _recoverFallbackRoute(context, widget.routeName, widget.fromUri);
    });
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

void _recoverFallbackRoute(
  BuildContext context,
  String routeName,
  String fromUri,
) {
  final logger = sl<Logger>();
  final router = GoRouter.of(context);
  final uri = Uri.tryParse(fromUri);
  final path = uri?.path ?? '';
  final query = uri?.queryParameters ?? const <String, String>{};
  if (path.startsWith(AppRoutePaths.todayShoppingList)) {
    _recoverFallbackToShoppingList(
      logger: logger,
      router: router,
      routeName: routeName,
      fromUri: fromUri,
      query: query,
    );
    return;
  }
  if (path.startsWith(AppRoutePaths.flow)) {
    _recoverFallbackToFlowList(
      logger: logger,
      router: router,
      routeName: routeName,
      fromUri: fromUri,
      query: query,
    );
    return;
  }
  if (router.canPop()) {
    logger.warn(
      'Fallback recovered by popping route="$routeName" '
      'uri=$fromUri',
      tag: 'Router',
    );
    router.pop();
    return;
  }
  logger.warn(
    'Executing fallback redirect to Today from route="$routeName" '
    'uri=$fromUri (no back stack)',
    tag: 'Router',
  );
  router.goNamed(AppRouteNames.today);
}

void _recoverFallbackToShoppingList({
  required Logger logger,
  required GoRouter router,
  required String routeName,
  required String fromUri,
  required Map<String, String> query,
}) {
  final homeId = query['homeId'];
  logger.warn(
    'Fallback recovered by redirecting to Shopping list '
    'from route="$routeName" uri=$fromUri',
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

void _recoverFallbackToFlowList({
  required Logger logger,
  required GoRouter router,
  required String routeName,
  required String fromUri,
  required Map<String, String> query,
}) {
  final flowQuery = _buildFallbackFlowQuery(query);
  logger.warn(
    'Fallback recovered by redirecting to Flow list '
    'from route="$routeName" uri=$fromUri',
    tag: 'Router',
  );
  if (flowQuery.isEmpty) {
    router.goNamed(AppRouteNames.flow);
    return;
  }
  router.goNamed(AppRouteNames.flow, queryParameters: flowQuery);
}

Map<String, String> _buildFallbackFlowQuery(Map<String, String> query) {
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
