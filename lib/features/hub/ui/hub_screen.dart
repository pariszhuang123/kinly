import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/router/app_router.dart';
import '../../../core/homes/models.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/ui/home_bottom_nav.dart';
import '../../../core/ui/kinly_circle_avatar.dart';
import '../../../core/ui/kinly_loader.dart';
import '../../../generated/l10n.dart';
import '../bloc/hub_bloc.dart';

class HubScreen extends StatelessWidget {
  const HubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = theme.extension<Spacing>()!;
    final sizes = theme.extension<AppSizes>();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        title: Text(S.of(context).navHub),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = sizes?.maxContentWidth ?? 640.0;
            final width =
                constraints.maxWidth < maxWidth
                    ? constraints.maxWidth
                    : maxWidth;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: width),
                child: Padding(
                  padding: EdgeInsets.all(spacing.lg),
                  child: BlocBuilder<HubBloc, HubState>(
                    builder: (context, state) {
                      if (state.isLoading && !state.isRefreshing) {
                        return const Center(child: KinlyLoader());
                      }

                      if (state.isFailure) {
                        return _HubError(
                          onRetry:
                              () => context.read<HubBloc>().add(
                                const HubRefreshed(),
                              ),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh:
                            () async => context.read<HubBloc>().add(
                              const HubRefreshed(),
                            ),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _MembersSection(
                                spacing: spacing,
                                state: state,
                                onInviteTap: () => _shareInvite(context, state),
                              ),
                              SizedBox(height: spacing.xl),
                              _QrSection(
                                spacing: spacing,
                                state: state,
                                onShareAppTap:
                                    () => _shareAppLink(context, state),
                                onQrTap: () => _showQrSheet(context, state),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: HomeBottomNav(
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go(AppRoutes.today);
              break;
            case 1:
              context.go(AppRoutes.explore);
              break;
            case 2:
              break;
          }
        },
      ),
    );
  }

  Future<void> _shareInvite(BuildContext context, HubState state) async {
    final s = S.of(context);
    if (!state.hasInvite || state.inviteLink == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(s.hubInviteUnavailable)));
      context.read<HubBloc>().add(const HubRefreshed());
      return;
    }

    final message = s.hubShareInviteBody(state.inviteLink!, state.inviteCode);
    await Share.share(message, subject: s.hubShareInviteTitle);
  }

  Future<void> _shareAppLink(BuildContext context, HubState state) async {
    final s = S.of(context);
    final appLink = state.appLink;
    if (appLink.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(s.hubInviteUnavailable)));
      return;
    }
    await Share.share(s.hubShareAppBody(appLink), subject: s.hubShareAppTitle);
  }

  void _showQrSheet(BuildContext context, HubState state) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = theme.extension<Spacing>()!;
    final s = S.of(context);
    final appLink =
        state.appLink.isNotEmpty ? state.appLink : 'https://kinly.app';

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            spacing.lg,
            spacing.lg,
            spacing.lg,
            spacing.lg + MediaQuery.of(context).viewPadding.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(s.hubQrTitle, style: theme.textTheme.titleMedium),
              SizedBox(height: spacing.md),
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: EdgeInsets.all(spacing.lg),
                child: QrImageView(
                  data: appLink,
                  version: QrVersions.auto,
                  size: 220,
                  backgroundColor: colorScheme.surfaceContainerHighest,
                ),
              ),
              SizedBox(height: spacing.md),
              Text(
                s.hubQrSubtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: spacing.lg),
              FilledButton.icon(
                onPressed: () => _shareAppLink(context, state),
                icon: const Icon(Icons.ios_share_rounded),
                label: Text(s.hubShareAppCta),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MembersSection extends StatelessWidget {
  const _MembersSection({
    required this.spacing,
    required this.state,
    required this.onInviteTap,
  });

  final Spacing spacing;
  final HubState state;
  final VoidCallback onInviteTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);
    final members = state.members;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          s.hubMembersTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: spacing.sm),
        Text(
          s.hubMembersSubtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: spacing.md),
        if (members.isEmpty)
          Text(
            s.hubMembersEmpty,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        if (members.isNotEmpty)
          SizedBox(
            height: 110,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: members.length + 1,
              separatorBuilder: (_, __) => SizedBox(width: spacing.md),
              itemBuilder: (context, index) {
                if (index == members.length) {
                  return _InviteTile(spacing: spacing, onTap: onInviteTap);
                }
                final member = members[index];
                return _MemberTile(member: member, spacing: spacing);
              },
            ),
          )
        else
          Padding(
            padding: EdgeInsets.only(top: spacing.md),
            child: _InviteTile(spacing: spacing, onTap: onInviteTap),
          ),
      ],
    );
  }
}

class _MemberTile extends StatelessWidget {
  const _MemberTile({required this.member, required this.spacing});

  final HomeMemberSummary member;
  final Spacing spacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final avatarRadius = 28.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        KinlyCircleAvatar(
          avatarUrl: member.avatarUrl,
          radius: avatarRadius,
          isOwner: member.isOwner,
        ),
        SizedBox(height: spacing.sm),
        SizedBox(
          width: avatarRadius * 2.4,
          child: Text(
            member.username,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class _InviteTile extends StatelessWidget {
  const _InviteTile({required this.spacing, required this.onTap});

  final Spacing spacing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final s = S.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.add, color: colorScheme.onPrimaryContainer),
          ),
          SizedBox(height: spacing.sm),
          SizedBox(
            width: 64,
            child: Text(
              s.hubInviteCta,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _QrSection extends StatelessWidget {
  const _QrSection({
    required this.spacing,
    required this.state,
    required this.onShareAppTap,
    required this.onQrTap,
  });

  final Spacing spacing;
  final HubState state;
  final VoidCallback onShareAppTap;
  final VoidCallback onQrTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final s = S.of(context);
    final appLink =
        state.appLink.isNotEmpty ? state.appLink : 'https://kinly.app';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.all(spacing.lg),
      child: Row(
        children: [
          GestureDetector(
            onTap: onQrTap,
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.all(spacing.sm),
              child: QrImageView(
                data: appLink,
                version: QrVersions.auto,
                size: 96,
                backgroundColor: colorScheme.surface,
              ),
            ),
          ),
          SizedBox(width: spacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.hubQrTitle, style: theme.textTheme.titleMedium),
                SizedBox(height: spacing.xs),
                Text(
                  s.hubQrSubtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: spacing.md),
                FilledButton.icon(
                  onPressed: onShareAppTap,
                  icon: const Icon(Icons.ios_share_rounded),
                  label: Text(s.hubShareAppCta),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HubError extends StatelessWidget {
  const _HubError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final s = S.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, color: colorScheme.error),
          const SizedBox(height: 8),
          Text(s.hubError, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 12),
          FilledButton(onPressed: onRetry, child: Text(s.hubRetry)),
        ],
      ),
    );
  }
}
