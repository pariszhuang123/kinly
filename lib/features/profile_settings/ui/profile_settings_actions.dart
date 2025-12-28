part of 'profile_settings_screen.dart';

void handleProfileAction(BuildContext context, ProfileSettingsState state) {
  final s = S.of(context);
  final bloc = context.read<ProfileSettingsBloc>();
  final authBloc = context.read<AuthBloc>();
  final accent = _profileAccent(context);

  void showError() {
    KinlySnackBar.showError(
      context,
      state.actionMessage ?? s.profileGenericError,
      accentColor: accent,
    );
  }

  switch (state.action) {
    case ProfileSettingsAction.leaveSuccess:
      KinlySnackBar.showSuccess(
        context,
        s.profileLeaveSuccessMessage,
        accentColor: accent,
      );
      authBloc.add(const AuthMembershipRefreshRequested());
      break;
    case ProfileSettingsAction.leaveFailure:
      showError();
      break;
    case ProfileSettingsAction.transferSuccess:
      KinlySnackBar.showSuccess(
        context,
        s.profileLeaveTransferSuccessMessage,
        accentColor: accent,
      );
      break;
    case ProfileSettingsAction.transferFailure:
      showError();
      break;
    case ProfileSettingsAction.kickSuccess:
      KinlySnackBar.showSuccess(
        context,
        s.profileKickSuccessMessage,
        accentColor: accent,
      );
      break;
    case ProfileSettingsAction.kickFailure:
      showError();
      break;
    case ProfileSettingsAction.deleteSuccess:
      KinlySnackBar.showSuccess(
        context,
        s.profileDeleteSuccessMessage,
        accentColor: accent,
      );
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

Future<void> handleProfileDeleteTap(BuildContext context) async {
  final bloc = context.read<ProfileSettingsBloc>();
  final state = bloc.state;
  final s = S.of(context);
  final accent = _profileAccent(context);

  if (state.leaveEligibilityLoading) {
    KinlySnackBar.showInfo(
      context,
      s.profileLeaveEligibilityLoading,
      accentColor: accent,
    );
    return;
  }

  if (state.leaveEligibilityError != null) {
    KinlySnackBar.showError(
      context,
      s.profileLeaveEligibilityError,
      accentColor: accent,
    );
    return;
  }

  final confirmed = await showKinlyConfirmDialog(
    context,
    title: s.profileConfirmDeleteTitle,
    message: s.profileConfirmDeleteMessage,
    confirmLabel: s.profileActionConfirmDelete,
    destructive: true,
  );
  if (!context.mounted || confirmed != true) return;

  final isOwner = state.isOwner;
  final hasOtherMembers = state.otherActiveMembers.isNotEmpty;

  if (isOwner && hasOtherMembers) {
    final candidates = state.transferCandidates;
    if (candidates.isEmpty) {
      KinlySnackBar.showError(
        context,
        s.profileLeaveOwnerNoEligibleMembers,
        accentColor: accent,
      );
      return;
    }

    final selectedUserId = await showTransferOwnershipSheet(
      context,
      candidates,
    );
    if (!context.mounted) return;

    if (selectedUserId != null) {
      bloc.add(
        ProfileSettingsTransferOwnerRequested(
          selectedUserId,
          followUp: TransferFollowUp.delete,
        ),
      );
    }
    return;
  }

  bloc.add(const ProfileSettingsDeleteRequested());
}

Future<void> handleProfileLeaveTap(BuildContext context) async {
  final bloc = context.read<ProfileSettingsBloc>();
  final state = bloc.state;
  final s = S.of(context);
  final accent = _profileAccent(context);

  if (state.leaveEligibilityLoading) {
    KinlySnackBar.showInfo(
      context,
      s.profileLeaveEligibilityLoading,
      accentColor: accent,
    );
    return;
  }

  if (state.leaveEligibilityError != null) {
    KinlySnackBar.showError(
      context,
      s.profileLeaveEligibilityError,
      accentColor: accent,
    );
    return;
  }

  final membership = state.membership;
  if (membership == null) {
    KinlySnackBar.showError(
      context,
      s.profileMissingHomeError,
      accentColor: accent,
    );
    return;
  }

  final isOwner = state.isOwner;
  final hasOtherMembers = state.otherActiveMembers.isNotEmpty;

  if (!isOwner || !hasOtherMembers) {
    final message =
        isOwner && !hasOtherMembers
            ? s.profileLeaveOwnerSoloMessage
            : s.profileConfirmLeaveMessage;

    final confirmed = await showProfileLeaveDialog(context, message: message);
    if (!context.mounted) return;

    if (confirmed == true) {
      bloc.add(const ProfileSettingsLeaveRequested());
    }
    return;
  }

  final candidates = state.transferCandidates;
  if (candidates.isEmpty) {
    KinlySnackBar.showError(
      context,
      s.profileLeaveOwnerNoEligibleMembers,
      accentColor: accent,
    );
    return;
  }

  final selectedUserId = await showTransferOwnershipSheet(context, candidates);
  if (!context.mounted) return;

  if (selectedUserId != null) {
    bloc.add(ProfileSettingsTransferOwnerRequested(selectedUserId));
  }
}

Future<bool?> showProfileLeaveDialog(
  BuildContext context, {
  required String message,
}) {
  final s = S.of(context);
  return showKinlyConfirmDialog(
    context,
    title: s.profileConfirmLeaveTitle,
    message: message,
    confirmLabel: s.profileActionConfirm,
    destructive: true,
  );
}

Future<void> handleProfileKickTap(BuildContext context) async {
  final bloc = context.read<ProfileSettingsBloc>();
  final state = bloc.state;
  final s = S.of(context);
  final accent = _profileAccent(context);

  if (!state.isOwner) {
    KinlySnackBar.showError(
      context,
      s.profileKickOwnerOnly,
      accentColor: accent,
    );
    return;
  }

  if (state.leaveEligibilityLoading) {
    KinlySnackBar.showInfo(
      context,
      s.profileLeaveEligibilityLoading,
      accentColor: accent,
    );
    return;
  }

  if (state.leaveEligibilityError != null) {
    KinlySnackBar.showError(
      context,
      s.profileLeaveEligibilityError,
      accentColor: accent,
    );
    return;
  }

  final candidates = state.kickEligibleMembers;
  if (candidates.isEmpty) {
    KinlySnackBar.showInfo(
      context,
      s.profileKickNoMembers,
      accentColor: accent,
    );
    return;
  }

  final selectedUserId = await showKickMemberSheet(context, candidates);
  if (!context.mounted) return;

  if (selectedUserId != null) {
    bloc.add(ProfileSettingsKickMemberRequested(selectedUserId));
  }
}

Future<String?> showTransferOwnershipSheet(
  BuildContext context,
  List<HomeMemberSummary> candidates,
) {
  final s = S.of(context);

  return KinlyBottomSheet.show<String>(
    context: context,
    isScrollControlled: true,
    title: s.profileLeaveTransferSheetTitle,
    subtitle: s.profileLeaveTransferSheetSubtitle,
    body: Builder(
      builder: (sheetContext) {
        final theme = Theme.of(sheetContext);
        final spacing = theme.extension<Spacing>()!;

        return Wrap(
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
        );
      },
    ),
  );
}

Future<String?> showKickMemberSheet(
  BuildContext context,
  List<HomeMemberSummary> members,
) {
  final s = S.of(context);

  return KinlyBottomSheet.show<String>(
    context: context,
    isScrollControlled: true,
    title: s.profileKickSheetTitle,
    subtitle: s.profileKickSheetSubtitle,
    body: Builder(
      builder: (sheetContext) {
        final theme = Theme.of(sheetContext);
        final spacing = theme.extension<Spacing>()!;

        String? selectedUserId;

        return StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
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
                              () => setState(
                                () => selectedUserId = member.userId,
                              ),
                        );
                      }).toList(),
                ),
                SizedBox(height: spacing.xl),
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
              ],
            );
          },
        );
      },
    ),
  );
}

Future<void> confirmProfileLogout(BuildContext context) async {
  context.read<AuthBloc>().add(const AuthSignOutRequested());
  if (!context.mounted) return;
  Navigator.of(context).pop();
}

Future<void> openProfileIdentity(
  BuildContext context, {
  required ProfileSettingsUser? user,
}) async {
  final authBloc = context.read<AuthBloc>();
  final membership = authBloc.state.membership;
  if (membership == null) {
    KinlySnackBar.showError(
      context,
      S.of(context).profileMissingHomeError,
      accentColor: _profileAccent(context),
    );
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
    final updated = ProfileSettingsUser(
      displayName: result.username,
      avatarUrl: result.avatarUrl,
      avatarStoragePath: result.avatarStoragePath,
    );

    if (sl.isRegistered<ProfileUpdateNotifier>()) {
      sl<ProfileUpdateNotifier>().notify(result);
    }

    context.read<ProfileSettingsBloc>().add(
      ProfileSettingsUserUpdated(updated),
    );

    KinlySnackBar.showSuccess(
      context,
      S.of(context).profileIdentitySuccessMessage,
      accentColor: _profileAccent(context),
    );
  }
}

Future<void> openInfoHub(BuildContext context) async {
  await Navigator.of(
    context,
  ).push(MaterialPageRoute(builder: (_) => const InfoHubWebViewScreen()));
}

Color? _profileAccent(BuildContext context) {
  return Theme.of(context).extension<KinlySections>()?.pulse.accent;
}
