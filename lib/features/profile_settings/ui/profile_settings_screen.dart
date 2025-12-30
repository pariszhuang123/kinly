import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/homes/models.dart';
import '../../../core/theme/kinly_sections.dart';
import '../../../core/theme/spacing.dart';
import '../../../app/router/app_router.dart';
import '../../../core/profile/models.dart';
import '../../../core/ui/buttons/kinly_filled_button.dart';
import '../../../core/ui/scroll/kinly_scroll_fade.dart';
import '../../../core/ui/kinly_bottom_sheet.dart';
import '../../../core/ui/dialogs/kinly_dialogs.dart';
import '../../../core/ui/snackbars/kinly_snackbar.dart';
import '../../../core/ui/profile/kinly_profile_header.dart';
import '../../../core/ui/settings/kinly_settings_card.dart';
import '../../../core/ui/settings/kinly_settings_tile.dart';
import '../../../core/ui/members/kinly_member_avatar_chip.dart';
import '../../../core/utils/kinly_support.dart';
import '../../../generated/l10n.dart';
import '../../../core/profile/profile_update_notifier.dart';
import '../../../core/di/locator.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../bloc/profile_settings_bloc.dart';
import '../edit/profile_identity_provider.dart';
import 'info_hub_webview.dart';

part 'profile_settings_actions.dart';

class ProfileSettingsScreen extends StatelessWidget {
  const ProfileSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<Spacing>()!;
    final s = S.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(s.profileSettingsTitle)),
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
                        () => _openProfileIdentity(context, user: state.user),
                  ),
                  SizedBox(height: spacing.xl),

                  // ── General section: Info Hub + Contact ────────────────────
                  KinlySettingsCard(
                    children: [
                      KinlySettingsTile(
                        title: s.profileInfoHubTitle,
                        subtitle: s.profileInfoHubSubtitle,
                        icon: Icons.menu_book_outlined,
                        onTap: () => _openInfoHub(context),
                      ),
                      const Divider(height: 0),
                      KinlySettingsTile(
                        title: s.profileContactUsTitle,
                        subtitle: s.profileContactUsSubtitle,
                        icon: Icons.support_agent_outlined,
                        // Shared support helper (with mounted check inside)
                        onTap: () => KinlySupport.contactSupport(context),
                      ),
                      const Divider(height: 0),
                      KinlySettingsTile(
                        title: s.profileConnectionSettingsTitle,
                        subtitle: s.profileConnectionSettingsSubtitle,
                        icon: Icons.notifications_active_outlined,
                        onTap: () => context.push(AppRoutes.connectionSettings),
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
                        icon: Icons.logout,
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
        icon: Icons.exit_to_app_rounded,
        destructive: true,
        showProgress: state.isLeaveActionBusy,
        onTap: state.isLeaveActionBusy ? null : () => _handleLeaveTap(context),
      ),
    ];

    final hasKickTargets =
        state.isOwner && state.kickEligibleMembers.isNotEmpty;
    if (hasKickTargets) {
      tiles.addAll([
        const Divider(height: 0),
        KinlySettingsTile(
          title: s.profileKickMemberTitle,
          subtitle: s.profileKickMemberSubtitle,
          icon: Icons.person_remove_alt_1_rounded,
          destructive: true,
          showProgress: state.kickInProgress,
          onTap: state.kickInProgress ? null : () => _handleKickTap(context),
        ),
      ]);
    }

    tiles.addAll([
      const Divider(height: 0),
      KinlySettingsTile(
        title: s.profileDeleteAccountTitle,
        subtitle: s.profileDeleteAccountSubtitle,
        icon: Icons.delete_forever_outlined,
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
    handleProfileAction(context, state);
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
    await confirmProfileLogout(context);
  }

  Future<void> _openProfileIdentity(
    BuildContext context, {
    required ProfileSettingsUser? user,
  }) async {
    await openProfileIdentity(context, user: user);
  }

  Future<void> _openInfoHub(BuildContext context) async {
    await openInfoHub(context);
  }
}
