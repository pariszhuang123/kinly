import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/ui/buttons/kinly_filled_button.dart';
import '../../../../generated/l10n.dart';

class JoinHomeBlockedScreen extends StatelessWidget {
  const JoinHomeBlockedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>();
    return Scaffold(
      appBar: AppBar(
        title: Text(s.join_blocked_title, style: theme.textTheme.titleLarge),
      ),
      body: SafeArea(
        child: Padding(
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
                onPressed: () => context.go(AppRoutes.start),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
