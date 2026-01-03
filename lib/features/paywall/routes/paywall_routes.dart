import 'package:go_router/go_router.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/app/router/app_route_paths.dart';
import 'package:kinly/features/paywall/ui/paywall_route_args.dart';
import 'package:kinly/features/paywall/ui/paywall_screen.dart';

List<GoRoute> buildPaywallRoutes() {
  return [
    GoRoute(
      path: AppRoutePaths.paywall,
      name: AppRouteNames.paywall,
      builder: (_, state) {
        final args = state.extra as PaywallRouteArgs?;
        if (args == null) {
          throw StateError('Paywall requires args.');
        }
        return KinlyPaywallScreen(
          homeId: args.homeId,
          strings: args.strings,
          source: args.source,
          placementId: args.placementId,
          triggers: args.triggers,
        );
      },
    ),
  ];
}
