import 'package:flutter/material.dart';

import '../../homes/models.dart';
import '../kinly_circle_avatar.dart';

/// Compact stacked avatar row with soft overlap and +N overflow badge.
///
/// Reuses KinlyCircleAvatar for consistent styling with other member UI.
class KinlyMemberAvatarStack extends StatelessWidget {
  const KinlyMemberAvatarStack({
    super.key,
    required this.members,
    this.accent,
    this.maxVisible = 5,
    this.radius = 20,
  });

  final List<HomeMemberSummary> members;
  final Color? accent;
  final int maxVisible;
  final double radius;

  @override
  Widget build(BuildContext context) {
    if (members.isEmpty) return const SizedBox.shrink();
    final visible = members.take(maxVisible).toList();
    final overflow = members.length - visible.length;
    const stepFactor = 1.3;
    final step = radius * stepFactor;
    final stackWidth = radius * 2 + step * (visible.length - 1);
    final surface = Theme.of(context).colorScheme.surface;
    final overflowBg = Color.alphaBlend(
      (accent ?? Theme.of(context).colorScheme.primary).withValues(alpha: 0.12),
      surface,
    );

    return SizedBox(
      height: radius * 2,
      width: stackWidth + (overflow > 0 ? step : 0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (var i = 0; i < visible.length; i++)
            PositionedDirectional(
              start: i * step,
              child: KinlyCircleAvatar(
                avatarUrl: visible[i].avatarUrl,
                isOwner: visible[i].isOwner,
                radius: radius,
                fallbackInitial:
                    visible[i].username.isNotEmpty
                        ? visible[i].username[0]
                        : null,
              ),
            ),
          if (overflow > 0)
            PositionedDirectional(
              start: visible.length * step,
              child: Container(
                width: radius * 2,
                height: radius * 2,
                decoration: BoxDecoration(
                  color: overflowBg,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.05),
                  ),
                ),
                child: Center(
                  child: Text(
                    '+$overflow',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
