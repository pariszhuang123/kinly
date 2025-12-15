import 'package:flutter/material.dart';

import '../../homes/models.dart';
import '../kinly_circle_avatar.dart';
import '../selector/kinly_selectable_item_row.dart';

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
    return KinlySelectableItemRow<String>(
      items:
          members
              .map(
                (member) => KinlySelectableItem<String>(
                  value: member.userId,
                  label: member.username,
                  semanticsLabel: member.username,
                  key: ValueKey('selectable-member-${member.userId}'),
                  builder: (context, _) => KinlyCircleAvatar(
                    avatarUrl: member.avatarUrl,
                    isOwner: member.isOwner,
                    radius: avatarRadius,
                    fallbackInitial:
                        member.username.isNotEmpty ? member.username[0] : null,
                  ),
                ),
              )
              .toList(growable: false),
      selectedValues: selectedMemberIds,
      onToggle: onToggle,
      showLabels: showNames,
      itemVisualSize: avatarRadius * 2,
      spacing: spacing,
      runSpacing: runSpacing,
      allowDeselect: true,
    );
  }
}
