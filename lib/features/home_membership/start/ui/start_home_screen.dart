import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/ui/buttons/kinly_filled_button.dart';
import '../../../../core/ui/snackbars/kinly_snackbar.dart';
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
    final membershipStatus = context.select(
      (AuthBloc bloc) => bloc.state.membershipStatus,
    );
    final membershipMessage = switch (membershipStatus) {
      AuthMembershipStatus.unknown => s.membership_status_checking,
      AuthMembershipStatus.none => s.membership_status_none,
      AuthMembershipStatus.active => s.membership_status_active,
    };

    return AuthErrorListener(
      child: Scaffold(
        appBar: AppBar(
          title: Text(s.app_title, style: theme.textTheme.titleLarge),
          actions: const [AuthSignOutButton()],
        ),
        body: SafeArea(
          child: BlocConsumer<StartHomeBloc, StartHomeState>(
            listener: (context, state) {
              if (state.status == StartHomeStatus.failure) {
                KinlySnackBar.showError(
                  context,
                  state.errorMessage ?? s.create_failed_generic,
                );
              }

              if (state.status == StartHomeStatus.success) {
                // Refresh membership; router redirects handle navigation.
                context.read<AuthBloc>().add(
                  const AuthMembershipRefreshRequested(),
                );
              }
            },
            builder: (context, state) {
              final isCreating =
                  state.status == StartHomeStatus.loading ||
                  state.status == StartHomeStatus.success;

              final canManageHome =
                  membershipStatus == AuthMembershipStatus.none;

              final canPress = !isCreating && canManageHome;
              final spacing = theme.extension<Spacing>();

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
                      membershipMessage,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium,
                    ),
                    SizedBox(height: spacing?.s ?? 8),
                    Text(
                      s.create_subtitle,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall,
                    ),
                    const Spacer(),

                    // Create Home button
                    KinlyFilledButton.text(
                      fullWidth: true,
                      label:
                          isCreating
                              ? s.membership_status_checking
                              : s.welcome_create,
                      onPressed:
                          canPress
                              ? () {
                                context.read<StartHomeBloc>().add(
                                  const StartHomeCreateRequested(),
                                );
                              }
                              : null, // disable when not allowed
                    ),
                    SizedBox(height: spacing?.m ?? 12),

                    // Join Home button
                    KinlyFilledButton.text(
                      fullWidth: true,
                      label: s.welcome_join,
                      onPressed:
                          canPress ? () => context.go(AppRoutes.join) : null,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
