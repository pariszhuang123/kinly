import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/homes/models.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/router/app_router.dart';
import '../../../core/profile/models.dart';
import '../../../core/ui/buttons/kinly_filled_button.dart';
import '../../../core/ui/kinly_bottom_sheet.dart';
import '../../../core/ui/dialogs/kinly_dialogs.dart';
import '../../../core/ui/snackbars/kinly_snackbar.dart';
import '../../../core/ui/profile/kinly_profile_header.dart';
import '../../../core/ui/settings/kinly_settings_card.dart';
import '../../../core/ui/settings/kinly_settings_tile.dart';
import '../../../core/ui/members/kinly_member_avatar_chip.dart';
import '../../../core/utils/kinly_support.dart';
import '../../../generated/l10n.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../bloc/profile_settings_bloc.dart';
import '../edit/profile_identity_provider.dart';
import 'info_hub_webview.dart';

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

            return ListView(
              padding: EdgeInsets.all(spacing.lg),
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
                  children: () {
                    final tiles = <Widget>[
                      // Leave Home (always shown)
                      KinlySettingsTile(
                        title: s.profileLeaveHomeTitle,
                        subtitle: s.profileLeaveHomeSubtitle,
                        icon: Icons.exit_to_app_rounded,
                        destructive: true,
                        showProgress: state.isLeaveActionBusy,
                        onTap:
                            state.isLeaveActionBusy
                                ? null
                                : () => _handleLeaveTap(context),
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
                          onTap:
                              state.kickInProgress
                                  ? null
                                  : () => _handleKickTap(context),
                        ),
                      ]);
                    }

                    // Delete account at the bottom of the danger card
                    tiles.addAll([
                      const Divider(height: 0),
                      KinlySettingsTile(
                        title: s.profileDeleteAccountTitle,
                        subtitle: s.profileDeleteAccountSubtitle,
                        icon: Icons.delete_forever_outlined,
                        destructive: true,
                        showProgress: state.deleteInProgress,
                        onTap:
                            state.deleteInProgress
                                ? null
                                : () => _confirmDelete(context),
                      ),
                    ]);

                    return tiles;
                  }(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _handleAction(BuildContext context, ProfileSettingsState state) {
    final s = S.of(context);
    final bloc = context.read<ProfileSettingsBloc>();
    final authBloc = context.read<AuthBloc>();

    void showError() {
      KinlySnackBar.showError(
        context,
        state.actionMessage ?? s.profileGenericError,
      );
    }

    switch (state.action) {
      case ProfileSettingsAction.leaveSuccess:
        KinlySnackBar.showSuccess(context, s.profileLeaveSuccessMessage);
        authBloc.add(const AuthMembershipRefreshRequested());
        break;
      case ProfileSettingsAction.leaveFailure:
        showError();
        break;
      case ProfileSettingsAction.transferSuccess:
        KinlySnackBar.showSuccess(
          context,
          s.profileLeaveTransferSuccessMessage,
        );
        break;
      case ProfileSettingsAction.transferFailure:
        showError();
        break;
      case ProfileSettingsAction.kickSuccess:
        _showKickSuccessDialog(context);
        break;
      case ProfileSettingsAction.kickFailure:
        showError();
        break;
      case ProfileSettingsAction.deleteSuccess:
        KinlySnackBar.showSuccess(context, s.profileDeleteSuccessMessage);
        authBloc.add(const AuthSignOutRequested());
        break;
      case ProfileSettingsAction.deleteFailure:
        showError();
        break;
      case ProfileSettingsAction.none:
        break;
    }

    if (!context.mounted) return;
    bloc.add(const ProfileSettingsActionCleared());

    if (state.action == ProfileSettingsAction.leaveSuccess ||
        state.action == ProfileSettingsAction.deleteSuccess) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _handleLeaveTap(BuildContext context) async {
    final bloc = context.read<ProfileSettingsBloc>();
    final state = bloc.state;
    final s = S.of(context);

    if (state.leaveEligibilityLoading) {
      KinlySnackBar.showInfo(context, s.profileLeaveEligibilityLoading);
      return;
    }

    if (state.leaveEligibilityError != null) {
      KinlySnackBar.showError(context, s.profileLeaveEligibilityError);
      return;
    }

    final membership = state.membership;
    if (membership == null) {
      KinlySnackBar.showError(context, s.profileMissingHomeError);
      return;
    }

    final isOwner = state.isOwner;
    final hasOtherMembers = state.otherActiveMembers.isNotEmpty;

    if (!isOwner || !hasOtherMembers) {
      final message =
          isOwner && !hasOtherMembers
              ? s.profileLeaveOwnerSoloMessage
              : s.profileConfirmLeaveMessage;

      final confirmed = await _showLeaveConfirmationDialog(
        context,
        message: message,
      );
      if (!context.mounted) return;

      if (confirmed == true) {
        bloc.add(const ProfileSettingsLeaveRequested());
      }
      return;
    }

    final candidates = state.transferCandidates;
    if (candidates.isEmpty) {
      KinlySnackBar.showError(context, s.profileLeaveOwnerNoEligibleMembers);
      return;
    }

    final selectedUserId = await _showTransferOwnershipSheet(
      context,
      candidates,
    );
    if (!context.mounted) return;

    if (selectedUserId != null) {
      bloc.add(ProfileSettingsTransferOwnerRequested(selectedUserId));
    }
  }

  Future<bool?> _showLeaveConfirmationDialog(
    BuildContext context, {
    required String message,
  }) {
    final s = S.of(context);
    return showKinlyConfirmDialog(
      context,
      title: s.profileConfirmLeaveTitle,
      message: message,
      confirmLabel: s.profileActionConfirm,
    );
  }

  Future<void> _handleKickTap(BuildContext context) async {
    final bloc = context.read<ProfileSettingsBloc>();
    final state = bloc.state;
    final s = S.of(context);

    if (!state.isOwner) {
      KinlySnackBar.showError(context, s.profileKickOwnerOnly);
      return;
    }

    if (state.leaveEligibilityLoading) {
      KinlySnackBar.showInfo(context, s.profileLeaveEligibilityLoading);
      return;
    }

    if (state.leaveEligibilityError != null) {
      KinlySnackBar.showError(context, s.profileLeaveEligibilityError);
      return;
    }

    final candidates = state.kickEligibleMembers;
    if (candidates.isEmpty) {
      KinlySnackBar.showInfo(context, s.profileKickNoMembers);
      return;
    }

    final selectedUserId = await _showKickMemberSheet(context, candidates);
    if (!context.mounted) return;

    if (selectedUserId != null) {
      bloc.add(ProfileSettingsKickMemberRequested(selectedUserId));
    }
  }

  Future<String?> _showTransferOwnershipSheet(
    BuildContext context,
    List<HomeMemberSummary> candidates,
  ) {
    final s = S.of(context);

    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        final theme = Theme.of(sheetContext);
        final spacing = theme.extension<Spacing>()!;

        return KinlyBottomSheet(
          title: s.profileLeaveTransferSheetTitle,
          subtitle: s.profileLeaveTransferSheetSubtitle,
          body: Wrap(
            spacing: spacing.md,
            runSpacing: spacing.md,
            alignment: WrapAlignment.center,
            children:
                candidates.map((member) {
                  final displayName =
                      member.username.isNotEmpty
                          ? member.username
                          : s.friendDefaultName;

                  return KinlyMemberAvatarChip(
                    displayName: displayName,
                    avatarUrl: member.avatarUrl,
                    isOwner: member.isOwner,
                    onTap: () => Navigator.of(sheetContext).pop(member.userId),
                  );
                }).toList(),
          ),
        );
      },
    );
  }

  Future<String?> _showKickMemberSheet(
    BuildContext context,
    List<HomeMemberSummary> members,
  ) {
    final s = S.of(context);

    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        final theme = Theme.of(sheetContext);
        final spacing = theme.extension<Spacing>()!;

        String? selectedUserId;

        return StatefulBuilder(
          builder: (context, setState) {
            return KinlyBottomSheet(
              title: s.profileKickSheetTitle,
              subtitle: s.profileKickSheetSubtitle,
              body: Wrap(
                spacing: spacing.md,
                runSpacing: spacing.md,
                alignment: WrapAlignment.center,
                children:
                    members.map((member) {
                      final displayName =
                          member.username.isNotEmpty
                              ? member.username
                              : s.friendDefaultName;

                      return KinlyMemberAvatarChip(
                        displayName: displayName,
                        avatarUrl: member.avatarUrl,
                        isOwner: member.isOwner,
                        isSelected: selectedUserId == member.userId,
                        onTap:
                            () =>
                                setState(() => selectedUserId = member.userId),
                      );
                    }).toList(),
              ),
              footer: [
                KinlyFilledButton.destructiveText(
                  onPressed:
                      selectedUserId == null
                          ? null
                          : () =>
                              Navigator.of(sheetContext).pop(selectedUserId),
                  label: s.profileKickActionConfirm,
                  fullWidth: true,
                ),
                SizedBox(height: spacing.sm),
                TextButton(
                  onPressed: () => Navigator.of(sheetContext).pop(),
                  child: Text(s.profileActionCancel),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showKickSuccessDialog(BuildContext context) {
    final s = S.of(context);
    showKinlyInfoDialog(
      context,
      title: s.profileKickSuccessTitle,
      message: s.profileKickSuccessMessage,
      closeLabel: s.profileKickSuccessClose,
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final s = S.of(context);

    final confirmed = await showKinlyConfirmDialog(
      context,
      title: s.profileConfirmDeleteTitle,
      message: s.profileConfirmDeleteMessage,
      confirmLabel: s.profileActionConfirm,
      destructive: true,
    );
    if (!context.mounted) return;

    if (confirmed == true) {
      context.read<ProfileSettingsBloc>().add(
        const ProfileSettingsDeleteRequested(),
      );
    }
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final s = S.of(context);

    final confirmed = await showKinlyConfirmDialog(
      context,
      title: s.profileLogoutDialogTitle,
      message: s.profileLogoutDialogMessage,
      confirmLabel: s.profileLogoutTitle,
    );
    if (!context.mounted) return;

    if (confirmed == true) {
      context.read<AuthBloc>().add(const AuthSignOutRequested());
      Navigator.of(context).pop();
    }
  }

  Future<void> _openProfileIdentity(
    BuildContext context, {
    required ProfileSettingsUser? user,
  }) async {
    final authBloc = context.read<AuthBloc>();
    final membership = authBloc.state.membership;
    if (membership == null) {
      KinlySnackBar.showError(context, S.of(context).profileMissingHomeError);
      return;
    }

    final args = ProfileIdentityRouteArgs(
      homeId: membership.homeId,
      initialUsername: user?.displayName,
      initialAvatarStoragePath: user?.avatarStoragePath,
      initialAvatarUrl: user?.avatarUrl,
    );

    final result = await context.push(AppRoutes.profileIdentity, extra: args);
    if (!context.mounted) return;

    if (result is UserProfile) {
      final now = DateTime.now().millisecondsSinceEpoch;
      final bustedAvatarUrl =
          result.avatarUrl == null ? null : '${result.avatarUrl}?v=$now';

      final updated = ProfileSettingsUser(
        displayName: result.username,
        avatarUrl: bustedAvatarUrl,
        avatarStoragePath: result.avatarStoragePath,
      );

      context.read<ProfileSettingsBloc>().add(
        ProfileSettingsUserUpdated(updated),
      );

      KinlySnackBar.showSuccess(
        context,
        S.of(context).profileIdentitySuccessMessage,
      );
    }
  }

  Future<void> _openInfoHub(BuildContext context) async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const InfoHubWebViewScreen()));
  }
}
