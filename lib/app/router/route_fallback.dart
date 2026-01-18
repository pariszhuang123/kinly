import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/core/di/locator.dart';
import 'package:kinly/core/logging/logger.dart';

/// Returns a widget that logs the error and redirects to Today.
///
/// Use this in route builders when required args are missing,
/// instead of throwing a [StateError].
Widget routeFallback(String routeName) {
  sl<Logger>().error(
    'Missing required args for "$routeName", redirecting to Today',
    error: StateError('Route "$routeName" navigated without required args'),
  );
  return _RedirectToToday();
}

class _RedirectToToday extends StatefulWidget {
  @override
  State<_RedirectToToday> createState() => _RedirectToTodayState();
}

class _RedirectToTodayState extends State<_RedirectToToday> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        GoRouter.of(context).goNamed(AppRouteNames.today);
      }
    });
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
