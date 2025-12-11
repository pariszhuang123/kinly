// lib/features/hub/ui/hub_members_section.dart
import 'package:flutter/material.dart';

import '../../../../core/theme/spacing.dart';
import '../../../../core/ui/buttons/kinly_add_tile_button.dart';
import '../../../../core/ui/buttons/kinly_outlined_button.dart';
import '../../../../core/ui/members/kinly_member_avatar_stack.dart';
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

  // Shared avatar radius so members + add tile stay in sync
  static const double _avatarRadius = 32.0;

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
        if (state.hasInvite &&
            state.isOwner &&
            state.inviteCode.isNotEmpty) ...[
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
            height: _avatarRadius * 2 + spacing.lg + spacing.md,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                KinlyMemberAvatarStack(
                  members: members,
                  accent: colorScheme.primary,
                  maxVisible: 5,
                  radius: _avatarRadius,
                ),
                SizedBox(width: spacing.md),
                _AddMemberTile(
                  spacing: spacing,
                  avatarRadius: _avatarRadius,
                  onTap: onInviteTap,
                  label: s.hubInviteCta, // one-line i18n label
                ),
              ],
            ),
          )
        else
          Padding(
            padding: EdgeInsets.only(top: spacing.md),
            child: KinlyAddTileButton(
              label: s.hubInviteCta,
              onTap: onInviteTap,
            ),
          ),
      ],
    );
  }
}

class _AddMemberTile extends StatelessWidget {
  const _AddMemberTile({
    required this.spacing,
    required this.avatarRadius,
    required this.onTap,
    required this.label,
  });

  final Spacing spacing;
  final double avatarRadius;
  final VoidCallback onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Match avatar visual size
        SizedBox(
          height: avatarRadius * 2,
          width: avatarRadius * 2,
          child: KinlyAddTileButton(
            onTap: onTap,
          ), // inherits dark/light styling from theme
        ),
        SizedBox(height: spacing.sm),
        SizedBox(
          width: avatarRadius * 3.0,
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
