import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/spacing.dart';
import '../../../core/ui/kinly_circle_avatar.dart';
import '../../../generated/l10n.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../bloc/profile_settings_bloc.dart';
import 'info_hub_webview.dart';

class ProfileSettingsScreen extends StatelessWidget {
  const ProfileSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<Spacing>()!;
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).profileSettingsTitle)),
      body: BlocListener<ProfileSettingsBloc, ProfileSettingsState>(
        listenWhen: (previous, current) => previous.action != current.action,
        listener: _handleAction,
        child: BlocBuilder<ProfileSettingsBloc, ProfileSettingsState>(
          builder: (context, state) {
            return ListView(
              padding: EdgeInsets.all(spacing.lg),
              children: [
                _ProfileHeader(
                  user: state.user,
                  isLoading: state.isLoadingUser,
                ),
                SizedBox(height: spacing.xl),
                _ProfileSettingsCard(
                  children: [
                    _ProfileSettingsTile(
                      title: S.of(context).profileLeaveHomeTitle,
                      subtitle: S.of(context).profileLeaveHomeSubtitle,
                      icon: Icons.exit_to_app_rounded,
                      destructive: false,
                      showProgress: state.leaveInProgress,
                      onTap:
                          state.leaveInProgress
                              ? null
                              : () => _confirmLeave(context),
                    ),
                    const Divider(height: 0),
                    _ProfileSettingsTile(
                      title: S.of(context).profileInfoHubTitle,
                      subtitle: S.of(context).profileInfoHubSubtitle,
                      icon: Icons.menu_book_outlined,
                      onTap: () => _openInfoHub(context),
                    ),
                    const Divider(height: 0),
                    _ProfileSettingsTile(
                      title: S.of(context).profileContactUsTitle,
                      subtitle: S.of(context).profileContactUsSubtitle,
                      icon: Icons.support_agent_outlined,
                      onTap: () => _contactSupport(context),
                    ),
                  ],
                ),
                SizedBox(height: spacing.md),
                _ProfileSettingsCard(
                  children: [
                    _ProfileSettingsTile(
                      title: S.of(context).profileLogoutTitle,
                      subtitle: S.of(context).profileLogoutSubtitle,
                      icon: Icons.logout,
                      onTap: () => _confirmLogout(context),
                    ),
                  ],
                ),
                SizedBox(height: spacing.md),
                _ProfileSettingsCard(
                  children: [
                    _ProfileSettingsTile(
                      title: S.of(context).profileDeleteAccountTitle,
                      subtitle: S.of(context).profileDeleteAccountSubtitle,
                      icon: Icons.delete_forever_outlined,
                      destructive: true,
                      showProgress: state.deleteInProgress,
                      onTap:
                          state.deleteInProgress
                              ? null
                              : () => _confirmDelete(context),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _handleAction(BuildContext context, ProfileSettingsState state) {
    final messenger = ScaffoldMessenger.of(context);
    final s = S.of(context);
    final bloc = context.read<ProfileSettingsBloc>();
    final authBloc = context.read<AuthBloc>();

    void showError() {
      messenger.showSnackBar(
        SnackBar(content: Text(state.actionMessage ?? s.profileGenericError)),
      );
    }

    switch (state.action) {
      case ProfileSettingsAction.leaveSuccess:
        messenger.showSnackBar(
          SnackBar(content: Text(s.profileLeaveSuccessMessage)),
        );
        authBloc.add(const AuthMembershipRefreshRequested());
        break;
      case ProfileSettingsAction.leaveFailure:
        showError();
        break;
      case ProfileSettingsAction.deleteSuccess:
        messenger.showSnackBar(
          SnackBar(content: Text(s.profileDeleteSuccessMessage)),
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

  Future<void> _confirmLeave(BuildContext context) async {
    final s = S.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(s.profileConfirmLeaveTitle),
            content: Text(s.profileConfirmLeaveMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(s.profileActionCancel),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(s.profileActionConfirm),
              ),
            ],
          ),
    );
    if (confirmed == true && context.mounted) {
      context.read<ProfileSettingsBloc>().add(
        const ProfileSettingsLeaveRequested(),
      );
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final s = S.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(s.profileConfirmDeleteTitle),
            content: Text(s.profileConfirmDeleteMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(s.profileActionCancel),
              ),
              FilledButton.tonal(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(s.profileActionConfirm),
              ),
            ],
          ),
    );
    if (confirmed == true && context.mounted) {
      context.read<ProfileSettingsBloc>().add(
        const ProfileSettingsDeleteRequested(),
      );
    }
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final s = S.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(s.profileLogoutDialogTitle),
            content: Text(s.profileLogoutDialogMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(s.profileActionCancel),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(s.profileLogoutTitle),
              ),
            ],
          ),
    );
    if (confirmed == true && context.mounted) {
      context.read<AuthBloc>().add(const AuthSignOutRequested());
      Navigator.of(context).pop();
    }
  }

  Future<void> _contactSupport(BuildContext context) async {
    final s = S.of(context);
    final uri = Uri(
      scheme: 'mailto',
      path: 'support@makinglifeeasie.com',
      queryParameters: {'subject': s.profileContactEmailSubject},
    );
    final messenger = ScaffoldMessenger.of(context);
    if (!await launchUrl(uri)) {
      messenger.showSnackBar(
        SnackBar(content: Text(s.profileContactLaunchError)),
      );
    }
  }

  Future<void> _openInfoHub(BuildContext context) async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const InfoHubWebViewScreen()));
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.user, required this.isLoading});

  final ProfileSettingsUser? user;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;
    final s = S.of(context);
    final colorScheme = theme.colorScheme;
    final name =
        (user?.displayName.isNotEmpty ?? false)
            ? user!.displayName
            : s.friendDefaultName;

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            KinlyCircleAvatar(avatarUrl: user?.avatarUrl, radius: 44),
            if (isLoading)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    shape: BoxShape.circle,
                  ),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(colorScheme.primary),
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: spacing.sm),
        Text(
          name,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: spacing.xs),
        Text(
          s.profileSettingsSubtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _ProfileSettingsCard extends StatelessWidget {
  const _ProfileSettingsCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: theme.colorScheme.surfaceVariant.withValues(alpha: 0.3),
      child: Column(mainAxisSize: MainAxisSize.min, children: children),
    );
  }
}

class _ProfileSettingsTile extends StatelessWidget {
  const _ProfileSettingsTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
    this.destructive = false,
    this.showProgress = false,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap;
  final bool destructive;
  final bool showProgress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final leadingColor = destructive ? colorScheme.error : colorScheme.primary;
    final titleStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w600,
      color: destructive ? colorScheme.error : colorScheme.onSurface,
    );
    final subtitleStyle = theme.textTheme.bodyMedium?.copyWith(
      color: colorScheme.onSurfaceVariant,
    );

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: leadingColor.withValues(alpha: 0.12),
        child: Icon(icon, color: leadingColor),
      ),
      title: Text(title, style: titleStyle),
      subtitle: Text(subtitle, style: subtitleStyle),
      trailing:
          showProgress
              ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(leadingColor),
                ),
              )
              : const Icon(Icons.chevron_right),
      onTap: showProgress ? null : onTap,
    );
  }
}
