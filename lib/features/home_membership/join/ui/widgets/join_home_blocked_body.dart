import 'package:flutter/widgets.dart';

import '../../../../../core/theme/spacing.dart';
import '../../../../../core/ui/buttons/kinly_filled_button.dart';
import '../join_home_blocked_surface_contract.dart';
import '../../../../../core/ui/kinly_theme_access.dart';

class JoinHomeBlockedBody extends StatelessWidget {
  const JoinHomeBlockedBody({super.key, required this.scope});

  final JoinHomeBlockedSurfaceScope scope;

  @override
  Widget build(BuildContext context) {
    final s = scope.strings;
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>();

    return Padding(
      padding: EdgeInsetsDirectional.all(spacing?.lg ?? 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          Text(
            s.join_blocked_title,
            style: theme.textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing?.m ?? 12),
          Text(
            s.join_blocked_body,
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          KinlyFilledButton.text(
            fullWidth: true,
            label: s.join_blocked_cta,
            onPressed: scope.actions.onBack,
          ),
        ],
      ),
    );
  }
}
