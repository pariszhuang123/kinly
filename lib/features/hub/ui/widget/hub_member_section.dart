// lib/features/hub/ui/hub_members_section.dart
import 'package:flutter/material.dart';

import '../../../../core/homes/models.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/ui/kinly_circle_avatar.dart';
import '../../../../core/ui/buttons/kinly_outlined_button.dart';
import '../../../../generated/l10n.dart';
import '../../bloc/hub_bloc.dart';

class HubMembersSection extends StatelessWidget {
  const HubMembersSection({
    super.key,
    required this.state,
    required this.onInviteTap,
    this.onCopyCode,
    this.onRotateInvite,
  });

  final HubState state;
  final VoidCallback onInviteTap;
  final VoidCallback? onCopyCode;
  final VoidCallback? onRotateInvite;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = theme.extension<Spacing>()!;
    final isDark = theme.brightness == Brightness.dark;
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
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: spacing.md),
        if (state.hasInvite && state.inviteCode.isNotEmpty) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  state.inviteCode,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isDark ? colorScheme.onSurface : colorScheme.primary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (state.isOwner && onRotateInvite != null) ...[
                SizedBox(width: spacing.sm),
                KinlyOutlinedButton.icon(
                  onPressed: onRotateInvite!,
                  icon: Icons.refresh,
                  label: s.hubRotateInvite,
                  compact: true,
                ),
              ],
            ],
          ),
          SizedBox(height: spacing.sm),
          if (onCopyCode != null)
            Align(
              alignment: Alignment.centerLeft,
              child: KinlyOutlinedButton.icon(
                onPressed: onCopyCode!,
                icon: Icons.copy,
                label: s.hubCopyCode,
                compact: true,
              ),
            ),
        ],
        if (state.hasInvite && state.inviteCode.isNotEmpty)
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
