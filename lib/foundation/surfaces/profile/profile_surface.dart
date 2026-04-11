import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:kinly/contracts/homes/models.dart';
import 'package:kinly/contracts/profile/models.dart';
import 'package:kinly/contracts/profile_settings/profile_identity_route_args.dart';
import 'package:kinly/contracts/profile_settings/profile_shared_unit_create_route_args.dart';
import 'package:kinly/contracts/profile_settings/profile_shared_unit_rename_route_args.dart';
import 'package:kinly/core/di/locator.dart';
import 'package:kinly/core/notifications/profile_update_notifier.dart';
import 'package:kinly/core/theme/kinly_sections.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/buttons/kinly_filled_button.dart';
import 'package:kinly/core/ui/buttons/kinly_outlined_button.dart';
import 'package:kinly/core/ui/dialogs/kinly_dialogs.dart';
import 'package:kinly/core/ui/kinly_bottom_sheet.dart';
import 'package:kinly/core/ui/kinly_loader.dart';
import 'package:kinly/core/ui/members/kinly_member_avatar_chip.dart';
import 'package:kinly/core/ui/profile/kinly_profile_header.dart';
import 'package:kinly/core/ui/scroll/kinly_scroll_fade.dart';
import 'package:kinly/core/ui/settings/kinly_settings_card.dart';
import 'package:kinly/core/ui/settings/kinly_settings_tile.dart';
import 'package:kinly/core/ui/snackbars/kinly_snackbar.dart';
import 'package:kinly/core/ui/support/kinly_support.dart';
import 'package:kinly/core/ui/paywall/paywall_sources.dart';
import 'package:kinly/core/ui/paywall/paywall_strings.dart';
import 'package:kinly/core/ui/paywall/ports/paywall_launcher.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'bloc/profile_settings_bloc.dart';
import '../../../core/ui/kinly_scaffold.dart';
import '../../../core/ui/kinly_app_bar.dart';
import '../../../core/ui/kinly_theme_access.dart';
import '../../../core/ui/kinly_icons.dart';
import '../../../core/ui/kinly_divider.dart';

part 'profile_surface_actions.dart';

class ProfileSettingsScreen extends StatelessWidget {
  const ProfileSettingsScreen({
    super.key,
    required this.onMembershipRefresh,
    required this.onSignOut,
  });

  final VoidCallback onMembershipRefresh;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    final spacing = KinlyThemeAccess.of(context).extension<Spacing>()!;
    final s = S.of(context);

    return KinlyScaffold(
      appBar: KinlyAppBar(
        title: Text(s.profileSettingsTitle),
        actions: [const _PlanButton()],
      ),
      body: BlocListener<ProfileSettingsBloc, ProfileSettingsState>(
        listenWhen: (previous, current) => previous.action != current.action,
        listener: _handleAction,
        child: BlocBuilder<ProfileSettingsBloc, ProfileSettingsState>(
          builder: (context, state) {
            final displayName =
                (state.user?.displayName.isNotEmpty ?? false)
                    ? state.user!.displayName
                    : s.friendDefaultName;

            return KinlyScrollFade(
              child: ListView(
                padding: EdgeInsetsDirectional.all(spacing.lg),
                children: [
                  KinlyProfileHeader(
                    displayName: displayName,
                    subtitle: s.profileSettingsSubtitle,
                    avatarUrl: state.user?.avatarUrl,
                    isOwner: state.isOwner,
                    isLoading: state.isLoadingUser,
                    onAvatarTap:
                        () => _openProfileIdentity(
                          context,
                          user: state.user,
                          membership: state.membership,
                        ),
                  ),
                  SizedBox(height: spacing.xl),
                  if (state.shouldShowSharedUnitSection) ...[
                    _SharedUnitSection(
                      state: state,
                      onCreate:
                          state.canCreateSharedUnit
                              ? () => _openCreateSharedUnit(context, state)
                              : null,
                      onJoin:
                          state.canJoinSharedUnit
                              ? () => _openJoinSharedUnit(context)
                              : null,
                      onRename:
                          state.homeUnitContext?.activeSharedUnit != null
                              ? () => _openRenameSharedUnit(context, state)
                              : null,
                      onLeave:
                          state.homeUnitContext?.activeSharedUnit != null &&
                                  !state.sharedUnitLeaveInProgress
                              ? () => _confirmLeaveSharedUnit(context, state)
                              : null,
                    ),
                    SizedBox(height: spacing.md),
                  ],

                  // ── General section: Info Hub + Contact ────────────────────
                  KinlySettingsCard(
                    children: [
                      KinlySettingsTile(
                        title: s.profileInfoHubTitle,
                        subtitle: s.profileInfoHubSubtitle,
                        icon: KinlyIcons.menuBookOutlined,
                        onTap: () => _openInfoHub(context),
                      ),
                      const KinlyDivider(height: 0),
                      KinlySettingsTile(
                        title: s.profileContactUsTitle,
                        subtitle: s.profileContactUsSubtitle,
                        icon: KinlyIcons.supportAgentOutlined,
                        // Shared support helper (with mounted check inside)
                        onTap: () => KinlySupport.contactSupport(context),
                      ),
                      const KinlyDivider(height: 0),
                      KinlySettingsTile(
                        title: s.profileConnectionSettingsTitle,
                        subtitle: s.profileConnectionSettingsSubtitle,
                        icon: KinlyIcons.notificationsActiveOutlined,
                        onTap:
                            () => context.pushNamed(
                              AppRouteNames.connectionSettings,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(height: spacing.md),

                  // ── Account section: Logout ────────────────────────────────
                  KinlySettingsCard(
                    children: [
                      KinlySettingsTile(
                        title: s.profileLogoutTitle,
                        subtitle: s.profileLogoutSubtitle,
                        icon: KinlyIcons.logout,
                        onTap: () => _confirmLogout(context),
                      ),
                    ],
                  ),
                  SizedBox(height: spacing.md),

                  // ── Danger zone: Leave / Kick / Delete account ────────────
                  KinlySettingsCard(
                    children: _buildDangerZoneTiles(context, state, s),
                  ),
                  SizedBox(height: spacing.xl),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildDangerZoneTiles(
    BuildContext context,
    ProfileSettingsState state,
    S s,
  ) {
    final tiles = <Widget>[
      KinlySettingsTile(
        title: s.profileLeaveHomeTitle,
        subtitle: s.profileLeaveHomeSubtitle,
        icon: KinlyIcons.exitToAppRounded,
        destructive: true,
        showProgress: state.isLeaveActionBusy,
        onTap: state.isLeaveActionBusy ? null : () => _handleLeaveTap(context),
      ),
    ];

    final hasKickTargets =
        state.isOwner && state.kickEligibleMembers.isNotEmpty;
    if (hasKickTargets) {
      tiles.addAll([
        const KinlyDivider(height: 0),
        KinlySettingsTile(
          title: s.profileKickMemberTitle,
          subtitle: s.profileKickMemberSubtitle,
          icon: KinlyIcons.personRemoveAlt1Rounded,
          destructive: true,
          showProgress: state.kickInProgress,
          onTap: state.kickInProgress ? null : () => _handleKickTap(context),
        ),
      ]);
    }

    tiles.addAll([
      const KinlyDivider(height: 0),
      KinlySettingsTile(
        title: s.profileDeleteAccountTitle,
        subtitle: s.profileDeleteAccountSubtitle,
        icon: KinlyIcons.deleteForeverOutlined,
        destructive: true,
        showProgress: state.deleteInProgress || state.transferInProgress,
        onTap:
            state.deleteInProgress ||
                    state.transferInProgress ||
                    state.leaveEligibilityLoading
                ? null
                : () => _handleDeleteTap(context),
      ),
    ]);

    return tiles;
  }

  void _handleAction(BuildContext context, ProfileSettingsState state) {
    handleProfileAction(
      context,
      state,
      onMembershipRefresh: onMembershipRefresh,
      onSignOut: onSignOut,
    );
  }

  Future<void> _handleDeleteTap(BuildContext context) async {
    await handleProfileDeleteTap(context);
  }

  Future<void> _handleLeaveTap(BuildContext context) async {
    await handleProfileLeaveTap(context);
  }

  Future<void> _handleKickTap(BuildContext context) async {
    await handleProfileKickTap(context);
  }

  Future<void> _confirmLogout(BuildContext context) async {
    await confirmProfileLogout(context, onSignOut: onSignOut);
  }

  Future<void> _openProfileIdentity(
    BuildContext context, {
    required ProfileSettingsUser? user,
    required CurrentMembership? membership,
  }) async {
    await openProfileIdentity(context, user: user, membership: membership);
  }

  Future<void> _openInfoHub(BuildContext context) async {
    await openInfoHub(context);
  }

  Future<void> _openCreateSharedUnit(
    BuildContext context,
    ProfileSettingsState state,
  ) async {
    final membershipId = state.membership?.membershipId;
    final homeId = state.membership?.homeId;
    if (membershipId == null ||
        membershipId.isEmpty ||
        homeId == null ||
        homeId.isEmpty) {
      return;
    }
    final created = await context.pushNamed<bool>(
      AppRouteNames.profileSharedUnitCreate,
      extra: ProfileSharedUnitCreateRouteArgs(
        homeId: homeId,
        creatorMembershipId: membershipId,
      ),
    );
    if (created == true && context.mounted) {
      KinlySnackBar.showSuccess(
        context,
        S.of(context).profileSharedUnitCreateSuccess,
      );
      context.read<ProfileSettingsBloc>().add(const ProfileSettingsStarted());
    }
  }

  Future<void> _openJoinSharedUnit(BuildContext context) async {
    final joined = await context.pushNamed<bool>(AppRouteNames.profileSharedUnitJoin);
    if (joined == true && context.mounted) {
      KinlySnackBar.showSuccess(
        context,
        S.of(context).profileSharedUnitJoinSuccess,
      );
      context.read<ProfileSettingsBloc>().add(const ProfileSettingsStarted());
    }
  }

  Future<void> _openRenameSharedUnit(
    BuildContext context,
    ProfileSettingsState state,
  ) async {
    final sharedUnit = state.homeUnitContext?.activeSharedUnit;
    if (sharedUnit == null) return;
    final renamed = await context.pushNamed<bool>(
      AppRouteNames.profileSharedUnitRename,
      extra: ProfileSharedUnitRenameRouteArgs(
        unitId: sharedUnit.unitId,
        initialName: sharedUnit.name,
      ),
    );
    if (renamed == true && context.mounted) {
      KinlySnackBar.showSuccess(
        context,
        S.of(context).profileSharedUnitRenameSuccess,
      );
      context.read<ProfileSettingsBloc>().add(const ProfileSettingsStarted());
    }
  }

  Future<void> _confirmLeaveSharedUnit(
    BuildContext context,
    ProfileSettingsState state,
  ) async {
    final sharedUnit = state.homeUnitContext?.activeSharedUnit;
    if (sharedUnit == null) return;
    final s = S.of(context);
    final confirmed = await showKinlyConfirmDialog(
      context,
      title: s.profileSharedUnitLeaveConfirmTitle,
      message: s.profileSharedUnitLeaveConfirmMessage,
      confirmLabel: s.profileSharedUnitLeaveCta,
      destructive: true,
    );
    if (!context.mounted || confirmed != true) return;
    context.read<ProfileSettingsBloc>().add(
      ProfileSettingsSharedUnitLeaveRequested(sharedUnit.unitId),
    );
  }
}

class _PlanButton extends StatelessWidget {
  const _PlanButton();

  @override
  Widget build(BuildContext context) {
    final spacing = KinlyThemeAccess.of(context).extension<Spacing>()!;

    return BlocBuilder<ProfileSettingsBloc, ProfileSettingsState>(
      buildWhen:
          (previous, current) =>
              previous.planStatus != current.planStatus ||
              previous.planStatusLoading != current.planStatusLoading,
      builder: (context, state) {
        if (state.planStatusLoading) {
          return Center(
            child: Padding(
              padding: EdgeInsetsDirectional.only(end: spacing.lg),
              child: KinlyLoader(size: spacing.xl),
            ),
          );
        }

        final s = S.of(context);
        final isPremium = state.planStatus.isPremium;
        final label = isPremium ? s.planPremiumLabel : s.planFreeLabel;

        return Padding(
          padding: EdgeInsetsDirectional.only(end: spacing.m),
          child: KinlyOutlinedButton.text(
            onPressed: () => openPlanAction(context, state),
            label: label,
          ),
        );
      },
    );
  }
}

class _SharedUnitSection extends StatelessWidget {
  const _SharedUnitSection({
    required this.state,
    required this.onCreate,
    required this.onJoin,
    required this.onRename,
    required this.onLeave,
  });

  final ProfileSettingsState state;
  final VoidCallback? onCreate;
  final VoidCallback? onJoin;
  final VoidCallback? onRename;
  final VoidCallback? onLeave;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final s = S.of(context);
    final sharedUnit = state.homeUnitContext?.activeSharedUnit;
    final title =
        sharedUnit == null
            ? s.profileSharedUnitSectionTitle
            : sharedUnit.name.trim().isEmpty
            ? s.profileSharedUnitActiveFallbackName
            : sharedUnit.name;
    final subtitle =
        sharedUnit == null
            ? s.profileSharedUnitSectionSubtitle
            : s.profileSharedUnitActiveSubtitle;

    return KinlySettingsCard(
      children: [
        Padding(
          padding: EdgeInsetsDirectional.all(spacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: spacing.xs),
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              if (sharedUnit == null && onCreate != null) ...[
                SizedBox(height: spacing.md),
                KinlyFilledButton.text(
                  onPressed: onCreate,
                  label: s.profileSharedUnitCreateCta,
                  fullWidth: true,
                ),
              ],
              if (sharedUnit == null && onJoin != null) ...[
                SizedBox(height: spacing.sm),
                KinlyOutlinedButton.text(
                  onPressed: onJoin,
                  label: s.profileSharedUnitJoinCta,
                  fullWidth: true,
                ),
              ],
              if (sharedUnit != null) ...[
                if (state.activeSharedUnitMembers.isNotEmpty) ...[
                  SizedBox(height: spacing.md),
                  Text(
                    s.profileSharedUnitMembersTitle,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: spacing.sm),
                  Wrap(
                    spacing: spacing.md,
                    runSpacing: spacing.md,
                    children: state.activeSharedUnitMembers
                        .map(
                          (member) => KinlyMemberAvatarChip(
                            displayName: member.username.isNotEmpty
                                ? member.username
                                : s.friendDefaultName,
                            avatarUrl: member.avatarUrl,
                            isOwner: member.isOwner,
                          ),
                        )
                        .toList(growable: false),
                  ),
                ],
                SizedBox(height: spacing.md),
                KinlyOutlinedButton.text(
                  onPressed: onRename,
                  label: s.profileSharedUnitRenameCta,
                  fullWidth: true,
                ),
                SizedBox(height: spacing.sm),
                KinlyFilledButton.destructiveText(
                  onPressed: onLeave,
                  label: s.profileSharedUnitLeaveCta,
                  fullWidth: true,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
