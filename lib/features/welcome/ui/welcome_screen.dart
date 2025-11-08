import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../design_system/kinly_button.dart';
import '../../../generated/l10n.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(s.app_title, style: theme.textTheme.titleLarge),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            Text(
              s.welcome_title,
              style: theme.textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            KinlyButton.primary(
              onPressed: () => context.go(AppRoutes.create),
              label: s.welcome_create,
            ),
            const SizedBox(height: 12),
            KinlyButton.primary(
              onPressed: () => context.go(AppRoutes.join),
              label: s.welcome_join,
            ),
          ],
        ),
      ),
    );
  }
}
