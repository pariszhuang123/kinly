import 'package:flutter/material.dart';

import '../../homes/models.dart';
import '../../theme/spacing.dart';
import '../kinly_circle_avatar.dart';

/// Reusable avatar cluster for showing active members.
///
/// Keeps spacing/token usage consistent across paywall, flow, share, and hub
/// without introducing a new core primitive.
class KinlyMemberAvatarRow extends StatelessWidget {
  const KinlyMemberAvatarRow({
    super.key,
    required this.members,
    this.showNames = false,
    this.avatarRadius = 20,
    this.spacing,
    this.runSpacing,
  });

  final List<HomeMemberSummary> members;
  final bool showNames;
  final double avatarRadius;
  final double? spacing;
  final double? runSpacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacingTokens = theme.extension<Spacing>()!;
    final gap = spacing ?? spacingTokens.m;
    final wrapRunSpacing = runSpacing ?? spacingTokens.s;

    return Wrap(
      spacing: gap,
      runSpacing: wrapRunSpacing,
      children: members
          .map(
            (member) => Semantics(
              label: member.username,
              child: showNames
                  ? _AvatarWithLabel(
                      member: member,
                      avatarRadius: avatarRadius,
                    )
                  : KinlyCircleAvatar(
                      avatarUrl: member.avatarUrl,
                      isOwner: member.isOwner,
                      radius: avatarRadius,
                      fallbackInitial:
                          member.username.isNotEmpty ? member.username[0] : null,
                    ),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _AvatarWithLabel extends StatelessWidget {
  const _AvatarWithLabel({
    required this.member,
    required this.avatarRadius,
  });

  final HomeMemberSummary member;
  final double avatarRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        KinlyCircleAvatar(
          avatarUrl: member.avatarUrl,
          isOwner: member.isOwner,
          radius: avatarRadius,
          fallbackInitial:
              member.username.isNotEmpty ? member.username[0] : null,
        ),
        SizedBox(height: theme.extension<Spacing>()!.s),
        SizedBox(
          width: avatarRadius * 2.8,
          child: Text(
            member.username,
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
