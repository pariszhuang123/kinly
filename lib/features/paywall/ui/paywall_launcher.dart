import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/locator.dart';
import 'package:kinly/contracts/paywall/enums/paywall_trigger.dart';
import 'package:kinly/core/ui/paywall/paywall_strings.dart';
import 'package:kinly/core/ui/paywall/ports/paywall_launcher.dart';
import '../domain/ports/paywall_repository.dart';
import 'paywall_route_args.dart';
import '../../../app/router/app_route_names.dart';

class PaywallLauncherImpl implements PaywallLauncher {
  const PaywallLauncherImpl();

  @override
  Future<bool?> showPaywall({
    required BuildContext context,
    required String homeId,
    required PaywallStrings strings,
    String? source,
    String? placementId,
    Set<PaywallTrigger> triggers = const {},
  }) {
    return _showAndRefresh(
      context: context,
      homeId: homeId,
      strings: strings,
      source: source,
      placementId: placementId,
      triggers: triggers,
    );
  }

  Future<bool?> _showAndRefresh({
    required BuildContext context,
    required String homeId,
    required PaywallStrings strings,
    String? source,
    String? placementId,
    Set<PaywallTrigger> triggers = const {},
  }) async {
    final result = await context.pushNamed<bool>(
      AppRouteNames.paywall,
      extra: PaywallRouteArgs(
        homeId: homeId,
        strings: strings,
        source: source,
        placementId: placementId,
        triggers: triggers,
      ),
    );

    if (result == true) {
      final repo = sl<PaywallRepository>();
      const backoff = [250, 500, 1000];
      for (final delayMs in backoff) {
        try {
          await repo.refreshStatus(homeId: homeId);
        } catch (_) {
          // Swallow: best-effort refresh
        }
        await Future<void>.delayed(Duration(milliseconds: delayMs));
      }
    }

    return result;
  }
}
