import 'package:flutter/material.dart';
import '../../theme/spacing.dart';
import '../../theme/color_tokens.dart';
import '../../theme/kinly_palette.dart';
import '../../theme/opacity.dart';
import '../kinly_circle_avatar.dart';

class KinlyProfileHeader extends StatelessWidget {
  const KinlyProfileHeader({
    super.key,
    required this.displayName,
    required this.subtitle,
    this.avatarUrl,
    this.isOwner = false,
    this.isLoading = false,
    this.onAvatarTap,
  });

  final String displayName;
  final String subtitle;
  final String? avatarUrl;
  final bool isOwner;
  final bool isLoading;
  final VoidCallback? onAvatarTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;
    final colors =
        theme.extension<KinlyColorTokens>() ??
        KinlyPalette.build(theme.brightness).colorTokens;
    final opacities = theme.extension<KinlyOpacity>()!;

    return Column(
      children: [
        Semantics(
          label: displayName,
          button: onAvatarTap != null,
          enabled: onAvatarTap != null,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(56),
              onTap: onAvatarTap,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    KinlyCircleAvatar(
                      avatarUrl: avatarUrl,
                      radius: 44,
                      isOwner: isOwner,
                    ),
                    if (isLoading)
                      PositionedDirectional(
                        bottom: 0,
                        end: 0,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: colors.surface,
                            shape: BoxShape.circle,
                          ),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(colors.primary),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: spacing.sm),
        Text(
          displayName,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: spacing.xs),
        Text(
          subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colors.onSurface.withValues(alpha: opacities.alphaFaint),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
