import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../generated/l10n.dart';
import '../../../auth/widgets/auth_error_listener.dart';
import '../../../../core/router/app_router.dart';

class CreateHomeScreen extends StatelessWidget {
  const CreateHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    return AuthErrorListener(
      child: Scaffold(
        appBar: AppBar(
          title: Text(s.create_title, style: theme.textTheme.titleLarge),
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                context.go(AppRoutes.start);
              },
            ),
          ],
        ),

        body: Center(
          child: Text(s.create_title, style: theme.textTheme.titleLarge),
        ),
      ),
    );
  }
}
