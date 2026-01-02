import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_route_names.dart';
import '../../../../core/ui/snackbars/kinly_snackbar.dart';
import '../../../../generated/l10n.dart';
import '../../../../../core/auth/bloc/auth_bloc.dart';
import '../../../../../core/auth/widgets/auth_error_listener.dart';
import '../bloc/start_home_bloc.dart';
import 'start_home_surface_contract.dart';
import 'start_home_surface_registry.dart';

class StartHomeScreen extends StatelessWidget {
  const StartHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final membershipStatus = context.select(
      (AuthBloc bloc) => bloc.state.membershipStatus,
    );
    final isProfileDeactivated = context.select(
      (AuthBloc bloc) => bloc.state.isProfileDeactivated,
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
                  membershipStatus == AuthMembershipStatus.none &&
                  !isProfileDeactivated;

              final canPress = !isCreating && canManageHome;
              StartHomeRegistry.bootstrap();

              final actions = StartHomeSurfaceActions(
                onCreate: () {
                  context.read<StartHomeBloc>().add(
                    const StartHomeCreateRequested(),
                  );
                },
                onJoin: () => context.goNamed(AppRouteNames.join),
              );
              final scope = StartHomeSurfaceScope(
                context: context,
                strings: s,
                membershipMessage: membershipMessage,
                isCreating: isCreating,
                canPress: canPress,
                actions: actions,
              );
              final slots = StartHomeSurfaceSlots(
                body: _buildStartHomeSections(scope),
              );
              return slots.body;
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStartHomeSections(StartHomeSurfaceScope scope) {
    final entries = StartHomeRegistry.bodySections;
    if (entries.length == 1) {
      return entries.first.builder(scope);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children:
          entries.map((entry) => entry.builder(scope)).toList(growable: false),
    );
  }
}
