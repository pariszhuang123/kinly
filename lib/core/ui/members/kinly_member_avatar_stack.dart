import 'package:flutter/material.dart';

import 'package:kinly/contracts/homes/models.dart';
import '../../theme/color_tokens.dart';
import '../../theme/kinly_palette.dart';
import '../../theme/opacity.dart';
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
    final tokens =
        Theme.of(context).extension<KinlyColorTokens>() ??
        KinlyPalette.build(Theme.of(context).brightness).colorTokens;
    final opacities = Theme.of(context).extension<KinlyOpacity>()!;
    final surface = tokens.surface;
    final overflowBg = Color.alphaBlend(
      (accent ?? tokens.primary).withValues(alpha: opacities.alphaSM),
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
                    color:
                        Theme.of(context).extension<KinlyColorTokens>()?.onSurface
                                .withValues(alpha: opacities.alphaXXS) ??
                        tokens.onSurface.withValues(alpha: opacities.alphaXXS),
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
