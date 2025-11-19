import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../design_system/kinly_button.dart';
import '../../../../generated/l10n.dart';
import '../../../auth/bloc/auth_bloc.dart';
import '../../../auth/widgets/auth_error_listener.dart';
import '../../../auth/widgets/auth_sign_out_button.dart';
import '../bloc/start_home_bloc.dart';

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
        body: BlocConsumer<StartHomeBloc, StartHomeState>(
          listener: (context, state) {
            if (state.status == StartHomeStatus.failure &&
                state.errorMessage != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            }

            if (state.status == StartHomeStatus.success) {
              // 1️⃣ Refresh membership in AuthBloc
              context.read<AuthBloc>().add(
                const AuthMembershipRefreshRequested(),
              );

              // 2️⃣ Navigate to Today
              context.go(AppRoutes.today);
            }
          },
          builder: (context, state) {
            final isLoading = state.status == StartHomeStatus.loading;

            return Padding(
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
                    builder: (context, authState) {
                      final message = switch (authState.membershipStatus) {
                        AuthMembershipStatus.unknown =>
                          s.membership_status_checking,
                        AuthMembershipStatus.none => s.membership_status_none,
                        AuthMembershipStatus.active =>
                          s.membership_status_active,
                      };
                      return Text(
                        message,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    s.create_subtitle,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall,
                  ),
                  const Spacer(),
                  KinlyButton.primary(
                    onPressed:
                        isLoading
                            ? null
                            : () {
                              context.read<StartHomeBloc>().add(
                                const StartHomeCreateRequested(),
                              );
                            },
                    label:
                        isLoading
                            ? s
                                .membership_status_checking // or a dedicated "Creating home..."
                            : s.welcome_create,
                  ),
                  const SizedBox(height: 12),
                  KinlyButton.primary(
                    onPressed:
                        isLoading ? null : () => context.go(AppRoutes.join),
                    label: s.welcome_join,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
