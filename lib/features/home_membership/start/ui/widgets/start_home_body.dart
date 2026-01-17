import 'package:flutter/widgets.dart';

import '../../../../../core/theme/spacing.dart';
import '../../../../../core/ui/buttons/kinly_filled_button.dart';
import '../start_home_surface_contract.dart';
import '../../../../../core/ui/kinly_theme_access.dart';

class StartHomeBody extends StatelessWidget {
  const StartHomeBody({super.key, required this.scope});

  final StartHomeSurfaceScope scope;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>();
    final s = scope.strings;
    final isPersonalized = scope.isPersonalized;
    final title = scope.personalizedTitle ?? s.welcome_title;
    final subtitle =
        scope.personalizedSubtitle ?? scope.membershipMessage;
    final crossAxisAlignment =
        isPersonalized ? CrossAxisAlignment.start : CrossAxisAlignment.stretch;
    final textAlign = isPersonalized ? TextAlign.start : TextAlign.center;

    return Padding(
      padding: EdgeInsetsDirectional.all(spacing?.lg ?? 16),
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          const Spacer(),
          Text(
            title,
            style: theme.textTheme.headlineMedium,
            textAlign: textAlign,
          ),
          SizedBox(height: spacing?.m ?? 12),
          Text(
            subtitle,
            textAlign: textAlign,
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
