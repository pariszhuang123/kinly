import 'package:flutter/material.dart';

import '../../../../../core/theme/spacing.dart';
import '../../../../../core/ui/buttons/kinly_filled_button.dart';
import '../start_home_surface_contract.dart';

class StartHomeBody extends StatelessWidget {
  const StartHomeBody({super.key, required this.scope});

  final StartHomeSurfaceScope scope;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>();
    final s = scope.strings;

    return Padding(
      padding: EdgeInsetsDirectional.all(spacing?.lg ?? 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          Text(
            s.welcome_title,
            style: theme.textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing?.m ?? 12),
          Text(
            scope.membershipMessage,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
          const Spacer(),
          KinlyFilledButton.text(
            fullWidth: true,
            label:
                scope.isCreating
                    ? s.membership_status_checking
                    : s.welcome_create,
            onPressed: scope.canPress ? scope.actions.onCreate : null,
          ),
          SizedBox(height: spacing?.m ?? 12),
          KinlyFilledButton.text(
            fullWidth: true,
            label: s.welcome_join,
            onPressed: scope.canPress ? scope.actions.onJoin : null,
          ),
        ],
      ),
    );
  }
}
