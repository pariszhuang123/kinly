import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_route_names.dart';
import '../../../../generated/l10n.dart';
import 'join_home_blocked_surface_contract.dart';
import 'join_home_blocked_surface_registry.dart';
import '../../../../core/ui/kinly_scaffold.dart';

class JoinHomeBlockedScreen extends StatelessWidget {
  const JoinHomeBlockedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    JoinHomeBlockedRegistry.bootstrap();

    final actions = JoinHomeBlockedSurfaceActions(
      onBack: () => context.goNamed(AppRouteNames.start),
    );
    final scope = JoinHomeBlockedSurfaceScope(
      context: context,
      strings: s,
      actions: actions,
    );
    final slots = JoinHomeBlockedSurfaceSlots(
      body: _buildJoinHomeBlockedSections(scope),
    );
    return KinlyScaffold(body: SafeArea(child: slots.body));
  }

  Widget _buildJoinHomeBlockedSections(JoinHomeBlockedSurfaceScope scope) {
    final entries = JoinHomeBlockedRegistry.bodySections;
    if (entries.length == 1) {
      return entries.first.builder(scope);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: entries
          .map((entry) => entry.builder(scope))
          .toList(growable: false),
    );
  }
}
