import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../../auth/widgets/auth_error_listener.dart';
import '../../auth/widgets/auth_sign_out_button.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    return AuthErrorListener(
      child: Scaffold(
        appBar: AppBar(
          title: Text(s.today_title, style: theme.textTheme.titleLarge),
          actions: const [AuthSignOutButton()],
        ),
        body: Center(
          child: Text(s.today_title, style: theme.textTheme.titleLarge),
        ),
      ),
    );
  }
}
