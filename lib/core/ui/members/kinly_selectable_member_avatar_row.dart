import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../homes/models.dart';
import '../../theme/spacing.dart';
import '../../theme/color_tokens.dart';
import '../kinly_circle_avatar.dart';

/// Interactive variant of [KinlyMemberAvatarRow] that supports multi-select.
///
/// Keeps spacing/token usage aligned with the display-only row but adds Kinly
/// selection affordances (halo + lift). Selection logic remains outside this
/// widget; callers pass the current `selectedMemberIds` and handle toggles.
class KinlySelectableMemberAvatarRow extends StatelessWidget {
  const KinlySelectableMemberAvatarRow({
    super.key,
    required this.members,
    required this.selectedMemberIds,
    required this.onToggle,
    this.showNames = false,
    this.avatarRadius = 20,
    this.spacing,
    this.runSpacing,
  });

  final List<HomeMemberSummary> members;
  final Set<String> selectedMemberIds;
  final ValueChanged<String> onToggle;
  final bool showNames;
  final double avatarRadius;
  final double? spacing;
  final double? runSpacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacingTokens = theme.extension<Spacing>();
    final gap = spacing ?? spacingTokens?.m ?? 12.0;
    final wrapRunSpacing = runSpacing ?? spacingTokens?.s ?? 8.0;

    return Wrap(
      spacing: gap,
      runSpacing: wrapRunSpacing,
      children: members
          .map(
            (member) => _SelectableAvatar(
              member: member,
              isSelected: selectedMemberIds.contains(member.userId),
              showName: showNames,
              avatarRadius: avatarRadius,
              onTap: () => onToggle(member.userId),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _SelectableAvatar extends StatelessWidget {
  const _SelectableAvatar({
    required this.member,
    required this.isSelected,
    required this.showName,
    required this.avatarRadius,
    required this.onTap,
  });

  final HomeMemberSummary member;
  final bool isSelected;
  final bool showName;
  final double avatarRadius;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final colorTokens = theme.extension<KinlyColorTokens>();
    final spacingTokens = theme.extension<Spacing>();
    final diameter = avatarRadius * 2;
    const minTapTarget = 48.0;
    final extraPadding = math.max(0.0, (minTapTarget - diameter) / 2);
    final tapPadding = math.max(spacingTokens?.xxs ?? 4.0, extraPadding);
    final isDark = theme.brightness == Brightness.dark;
    final basePrimary = colorTokens?.primary ?? colorScheme.primary;
    final baseContainer =
        colorTokens?.primaryContainer ?? colorScheme.primaryContainer;
    // Use lighter container tone in dark mode so the halo stays visible on dark surfaces.
    final haloColor =
        isDark
            ? baseContainer.withValues(alpha: 0.38)
            : basePrimary.withValues(alpha: 0.26);
    final ringColor =
        isDark
            ? baseContainer.withValues(alpha: 0.78)
            : basePrimary.withValues(alpha: 0.42);
    final ringThickness = isSelected ? 2.0 : 0.0;
    final haloPadding =
        isSelected ? math.max(spacingTokens?.xs ?? 4.0, 4.0) : 0.0;

    Widget avatar = AnimatedScale(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOut,
      scale: isSelected ? 1.05 : 1.0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        decoration:
            isSelected
                ? BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: ringColor, width: ringThickness),
                  boxShadow: [
                    BoxShadow(
                      color: haloColor,
                      blurRadius: 16,
                      spreadRadius: 4,
                    ),
                  ],
                )
                : const BoxDecoration(shape: BoxShape.circle),
        child: Padding(
          padding: EdgeInsets.all(ringThickness),
          child: KinlyCircleAvatar(
            avatarUrl: member.avatarUrl,
            isOwner: member.isOwner,
            radius: avatarRadius,
            fallbackInitial:
                member.username.isNotEmpty ? member.username[0] : null,
          ),
        ),
      ),
    );

    if (showName) {
      avatar = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          avatar,
          SizedBox(height: spacingTokens?.s ?? 8.0),
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

    return Semantics(
      key: ValueKey('selectable-member-${member.userId}'),
      button: true,
      selected: isSelected,
      label: member.username,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsetsDirectional.all(tapPadding + haloPadding),
            child: avatar,
          ),
        ),
      ),
    );
  }
}
