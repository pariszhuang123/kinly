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
import '../../../../core/theme/spacing.dart';
import '../../../../core/links/join_intent_coordinator.dart';
import '../../../../core/ui/inputs/kinly_text_field.dart';
import '../../../../core/ui/buttons/kinly_filled_button.dart';
import '../../../../renderer/material/ui/bottom_sheet/kinly_bottom_sheet.dart';

class StartHomeScreen extends StatelessWidget {
  const StartHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              UserContextCubit(repository: sl<UserContextRepository>())
                ..refresh(),
      child: const _StartHomeView(),
    );
  }
}

class _StartHomeView extends StatelessWidget {
  const _StartHomeView();

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
    final userContextState = context.watch<UserContextCubit>().state;
    final userContext = userContextState.context;
    final membershipMessage = switch (membershipStatus) {
      AuthMembershipStatus.unknown => s.membership_status_checking,
      AuthMembershipStatus.none => s.membership_status_none,
      AuthMembershipStatus.active => s.membership_status_active,
    };
    final hasAvatar = (userContext?.avatarUrl?.isNotEmpty ?? false);
    final displayName =
        (userContext?.displayName?.trim().isNotEmpty ?? false)
            ? userContext!.displayName!.trim()
            : null;
    final personalizedTitle =
        (hasAvatar || displayName != null)
            ? s.startReturningTitle(displayName ?? s.friendDefaultName)
            : s.welcome_title;
    final personalizedSubtitle =
        hasAvatar
            ? s.startReturningSubtitle
            : membershipStatus == AuthMembershipStatus.none
            ? s.membership_status_none
            : null;

    return AuthErrorListener(
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
                personalizedTitle: personalizedTitle,
                personalizedSubtitle: personalizedSubtitle,
                isPersonalized: hasAvatar,
                supportsManualInvite: false,
              );
              final slots = StartHomeSurfaceSlots(
                body: _buildStartHomeSections(scope),
              );
              return _buildStartHomeLayout(context, slots);
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
      children: entries
          .map((entry) => entry.builder(scope))
          .toList(growable: false),
    );
  }

  Widget _buildStartHomeLayout(
    BuildContext context,
    StartHomeSurfaceSlots slots,
  ) {
    if (slots.header == null) return slots.body;
    final spacing = KinlyThemeAccess.of(context).extension<Spacing>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(
            spacing?.lg ?? 16,
            spacing?.lg ?? 16,
            spacing?.lg ?? 16,
            spacing?.m ?? 12,
          ),
          child: slots.header!,
        ),
        Expanded(child: slots.body),
      ],
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
        final theme = KinlyThemeAccess.of(context);
        final spacing = theme.extension<Spacing>();
        final strings = S.of(context);
        final displayName = state.context?.displayName?.trim();
        final fallbackInitial =
            displayName?.isNotEmpty == true
                ? displayName!.substring(0, 1).toUpperCase()
                : strings.personalProfileTitle.isNotEmpty
                ? strings.personalProfileTitle.substring(0, 1).toUpperCase()
                : 'Y';
        return Semantics(
          label: strings.personalProfileTitle,
          button: true,
          child: Padding(
            padding: EdgeInsetsDirectional.only(end: spacing?.md ?? 12),
            child: KinlyTapTarget(
              onTap:
                  () => showPersonalProfileSheet(
                    context: context,
                    userContextCubit: context.read<UserContextCubit>(),
                    entrySource: entrySource,
                  ),
              borderRadius: BorderRadius.circular(32),
              child: Padding(
                padding: EdgeInsetsDirectional.all((spacing?.xs ?? 4) / 2),
                child: KinlyCircleAvatar(
                  avatarUrl: state.context?.avatarUrl,
                  radius: 30,
                  fallbackInitial: fallbackInitial,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
