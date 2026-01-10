part of 'profile_surface.dart';

void handleProfileAction(
  BuildContext context,
  ProfileSettingsState state, {
  required VoidCallback onMembershipRefresh,
  required VoidCallback onSignOut,
}) {
  final s = S.of(context);
  final bloc = context.read<ProfileSettingsBloc>();
  final accent = _profileAccent(context);

  void showError() {
    KinlySnackBar.showError(
      context,
      state.actionMessage ?? s.profileGenericError,
      accentColor: accent,
    );
  }

  final successMessages = {
    ProfileSettingsAction.leaveSuccess: s.profileLeaveSuccessMessage,
    ProfileSettingsAction.transferSuccess: s.profileLeaveTransferSuccessMessage,
    ProfileSettingsAction.kickSuccess: s.profileKickSuccessMessage,
    ProfileSettingsAction.deleteSuccess: s.profileDeleteSuccessMessage,
  };
  final failureActions = const {
    ProfileSettingsAction.leaveFailure,
    ProfileSettingsAction.transferFailure,
    ProfileSettingsAction.kickFailure,
    ProfileSettingsAction.deleteFailure,
  };

  final successMessage = successMessages[state.action];
  if (successMessage != null) {
    KinlySnackBar.showSuccess(context, successMessage, accentColor: accent);
    if (state.action == ProfileSettingsAction.leaveSuccess) {
      onMembershipRefresh();
    } else if (state.action == ProfileSettingsAction.deleteSuccess) {
      onSignOut();
    }
  } else if (failureActions.contains(state.action)) {
    showError();
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

  if (_handleEligibilityMessages(context, state, s, accent)) return;
  if (_handleMissingMembership(context, state, s, accent)) return;
  if (await _handleOwnerFlow(context, state, s, bloc, accent)) return;
  if (!context.mounted) return;
  await _handleNonOwnerFlow(context, state, s, bloc);
}

bool _handleEligibilityMessages(
  BuildContext context,
  ProfileSettingsState state,
  S s,
  Color? accent,
) {
  if (state.leaveEligibilityLoading) {
    KinlySnackBar.showInfo(
      context,
      s.profileLeaveEligibilityLoading,
      accentColor: accent,
    );
    return true;
  }
  if (state.leaveEligibilityError != null) {
    KinlySnackBar.showError(
      context,
      s.profileLeaveEligibilityError,
      accentColor: accent,
    );
    return true;
  }
  return false;
}

bool _handleMissingMembership(
  BuildContext context,
  ProfileSettingsState state,
  S s,
  Color? accent,
) {
  if (state.membership != null) return false;
  KinlySnackBar.showError(
    context,
    s.profileMissingHomeError,
    accentColor: accent,
  );
  return true;
}

Future<bool> _handleOwnerFlow(
  BuildContext context,
  ProfileSettingsState state,
  S s,
  ProfileSettingsBloc bloc,
  Color? accent,
) async {
  final isOwner = state.isOwner;
  final hasOtherMembers = state.otherActiveMembers.isNotEmpty;
  if (!isOwner || !hasOtherMembers) return false;

  final candidates = state.transferCandidates;
  if (candidates.isEmpty) {
    KinlySnackBar.showError(
      context,
      s.profileLeaveOwnerNoEligibleMembers,
      accentColor: accent,
    );
    return true;
  }

  final selectedUserId = await showTransferOwnershipSheet(context, candidates);
  if (!context.mounted) return true;

  if (selectedUserId != null) {
    bloc.add(ProfileSettingsTransferOwnerRequested(selectedUserId));
  }
  return true;
}

Future<void> _handleNonOwnerFlow(
  BuildContext context,
  ProfileSettingsState state,
  S s,
  ProfileSettingsBloc bloc,
) async {
  final isOwner = state.isOwner;
  final hasOtherMembers = state.otherActiveMembers.isNotEmpty;
  final message =
      isOwner && !hasOtherMembers
          ? s.profileLeaveOwnerSoloMessage
          : s.profileConfirmLeaveMessage;

  final confirmed = await showProfileLeaveDialog(context, message: message);
  if (!context.mounted) return;
  if (confirmed == true) {
    bloc.add(const ProfileSettingsLeaveRequested());
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
        final theme = KinlyThemeAccess.of(sheetContext);
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
    body: _KickMemberSheetContent(members: members),
  );
}

class _KickMemberSheetContent extends StatefulWidget {
  const _KickMemberSheetContent({required this.members});

  final List<HomeMemberSummary> members;

  @override
  State<_KickMemberSheetContent> createState() =>
      _KickMemberSheetContentState();
}

class _KickMemberSheetContentState extends State<_KickMemberSheetContent> {
  String? _selectedUserId;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final spacing = KinlyThemeAccess.of(context).extension<Spacing>()!;
    final onConfirmTap =
        _selectedUserId == null
            ? null
            : () => Navigator.of(context).pop(_selectedUserId);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          spacing: spacing.md,
          runSpacing: spacing.md,
          alignment: WrapAlignment.center,
          children:
              widget.members.map((member) {
                final displayName =
                    member.username.isNotEmpty
                        ? member.username
                        : s.friendDefaultName;

                return KinlyMemberAvatarChip(
                  displayName: displayName,
                  avatarUrl: member.avatarUrl,
                  isOwner: member.isOwner,
                  isSelected: _selectedUserId == member.userId,
                  onTap: () => setState(() => _selectedUserId = member.userId),
                );
              }).toList(),
        ),
        SizedBox(height: spacing.xl),
        KinlyFilledButton.destructiveText(
          onPressed: onConfirmTap,
          label: s.profileKickActionConfirm,
          fullWidth: true,
        ),
        SizedBox(height: spacing.sm),
      ],
    );
  }
}

Future<void> confirmProfileLogout(
  BuildContext context, {
  required VoidCallback onSignOut,
}) async {
  onSignOut();
  if (!context.mounted) return;
  Navigator.of(context).pop();
}

Future<void> openProfileIdentity(
  BuildContext context, {
  required ProfileSettingsUser? user,
  required CurrentMembership? membership,
}) async {
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

  final result = await context.pushNamed(
    AppRouteNames.profileIdentity,
    extra: args,
  );
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
  await context.pushNamed(AppRouteNames.infoHub);
}

Color? _profileAccent(BuildContext context) {
  return KinlyThemeAccess.of(context).extension<KinlySections>()?.pulse.accent;
}
