import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_route_names.dart';
import '../../../../core/ui/snackbars/kinly_snackbar.dart';
import '../../../../generated/l10n.dart';
import '../../../../../core/auth/bloc/auth_bloc.dart';
import '../../../../../core/auth/widgets/auth_error_listener.dart';
import '../../../../../core/auth/user_context_cubit.dart';
import 'package:kinly/contracts/auth/ports/user_context_repository.dart';
import '../../../../../core/di/locator.dart';
import '../bloc/start_home_bloc.dart';
import 'start_home_surface_contract.dart';
import 'start_home_surface_registry.dart';
import '../../../../core/ui/kinly_scaffold.dart';
import '../../../../core/ui/kinly_app_bar.dart';
import '../../../../core/ui/kinly_theme_access.dart';
import '../../../../core/ui/personal_profile_sheet.dart';
import '../../../../core/ui/kinly_circle_avatar.dart';
import '../../../../core/ui/kinly_tap_target.dart';
import '../../../../core/ui/enums/personal_profile_entry_source.dart';

class StartHomeScreen extends StatelessWidget {
  const StartHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = KinlyThemeAccess.of(context);
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

    return BlocProvider(
      create:
          (_) =>
              UserContextCubit(repository: sl<UserContextRepository>())
                ..refresh(),
      child: AuthErrorListener(
        child: KinlyScaffold(
          appBar: KinlyAppBar(
            title: Text(s.app_title, style: theme.textTheme.titleLarge),
            actions: const [
              _PersonalProfileAction(
                entrySource: PersonalProfileEntrySource.start,
              ),
            ],
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
      children: entries
          .map((entry) => entry.builder(scope))
          .toList(growable: false),
    );
  }
}

class _PersonalProfileAction extends StatelessWidget {
  const _PersonalProfileAction({required this.entrySource});

  final PersonalProfileEntrySource entrySource;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserContextCubit, UserContextState>(
      builder: (context, state) {
        if (!state.hasArtifacts) return const SizedBox.shrink();
        final strings = S.of(context);
        final fallbackInitial =
            strings.personalProfileTitle.isNotEmpty
                ? strings.personalProfileTitle.substring(0, 1).toUpperCase()
                : 'Y';
        return Semantics(
          label: strings.personalProfileTitle,
          button: true,
          child: KinlyTapTarget(
            onTap: () => showPersonalProfileSheet(
              context: context,
              userContextCubit: context.read<UserContextCubit>(),
              entrySource: entrySource,
            ),
            borderRadius: BorderRadius.circular(20),
            child: KinlyCircleAvatar(
              avatarUrl: state.context?.avatarUrl,
              radius: 20,
              fallbackInitial: fallbackInitial,
            ),
          ),
        );
      },
    );
  }
}
