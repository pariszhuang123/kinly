import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../design_system/kinly_button.dart';
import '../../../../generated/l10n.dart';
import '../../../auth/bloc/auth_bloc.dart';
import '../../../auth/widgets/auth_error_listener.dart';
import '../../../auth/widgets/auth_sign_out_button.dart';

class StartHomeScreen extends StatelessWidget {
  const StartHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    return AuthErrorListener(
      child: Scaffold(
        appBar: AppBar(
          title: Text(s.app_title, style: theme.textTheme.titleLarge),
          actions: const [AuthSignOutButton()],
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
              const SizedBox(height: 12),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  final message = switch (state.membershipStatus) {
                    AuthMembershipStatus.unknown =>
                      s.membership_status_checking,
                    AuthMembershipStatus.none => s.membership_status_none,
                    AuthMembershipStatus.active => s.membership_status_active,
                  };
                  return Text(
                    message,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium,
                  );
                },
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
      ),
    );
  }
}
