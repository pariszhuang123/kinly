// lib/features/hub/ui/hub_members_section.dart
import 'package:flutter/widgets.dart';

import '../../../../core/theme/spacing.dart';
import '../../../../core/ui/buttons/kinly_add_tile_button.dart';
import '../../../../core/ui/buttons/kinly_outlined_button.dart';
import '../../../../core/ui/members/kinly_member_avatar_stack.dart';
import '../../../../generated/l10n.dart';
import '../bloc/hub_bloc.dart';
import '../../../../core/theme/kinly_sections.dart';
import '../../../../core/ui/kinly_theme_access.dart';
import '../../../../core/ui/kinly_icons.dart';

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
    final theme = KinlyThemeAccess.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = theme.extension<Spacing>()!;
    final sections = theme.extension<KinlySections>()!;
    final inviteColor = sections.share.icon;
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
                    color: inviteColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (state.isOwner && onRotateInvite != null) ...[
                SizedBox(width: spacing.sm),
                KinlyOutlinedButton.icon(
                  onPressed: onRotateInvite!,
                  icon: KinlyIcons.refresh,
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
            child: Padding(
              padding: EdgeInsetsDirectional.only(start: spacing.s),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _AddMemberTile(
                    avatarRadius: _avatarRadius,
                    onTap: onInviteTap,
                  ),
                  SizedBox(width: spacing.md),
                  KinlyMemberAvatarStack(
                    members: members,
                    accent: colorScheme.primary,
                    maxVisible: 5,
                    radius: _avatarRadius,
                  ),
                ],
              ),
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
  const _AddMemberTile({required this.avatarRadius, required this.onTap});

  final double avatarRadius;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: avatarRadius * 2,
          width: avatarRadius * 2,
          child: KinlyAddTileButton(
            onTap: onTap,
          ), // inherits dark/light styling from theme
        ),
      ],
    );
  }
}
