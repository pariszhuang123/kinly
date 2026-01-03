import 'package:flutter/material.dart';

import '../../theme/color_tokens.dart';
import '../../theme/kinly_palette.dart';
import '../../theme/opacity.dart';
import '../../theme/radius.dart';
import '../../theme/spacing.dart';
import '../../theme/typography_tokens.dart';
import '../enums/kinly_banner_type.dart';

class KinlyInfoBanner extends StatelessWidget {
  const KinlyInfoBanner({
    super.key,
    required this.message,
    this.type = KinlyBannerType.info,
    this.leading,
    this.trailing,
  });

  final String message;
  final KinlyBannerType type;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>();
    final corners = theme.extension<Corners>();
    final colors =
        theme.extension<KinlyColorTokens>() ??
        KinlyPalette.build(theme.brightness).colorTokens;
    final typeScale = theme.extension<KinlyTypography>();
    final opacities = theme.extension<KinlyOpacity>()!;

    final bg = _backgroundForType(colors, opacities);
    final fg = _foregroundForType(colors);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing?.l ?? 16,
        vertical: spacing?.m ?? 12,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(corners?.medium ?? 12),
      ),
      child: Row(
        children: [
          if (leading != null) ...[leading!, SizedBox(width: spacing?.s ?? 8)],
          Expanded(
            child: Text(
              message,
              style: (typeScale?.bodyMedium ?? theme.textTheme.bodyMedium)
                  ?.copyWith(color: fg),
            ),
          ),
          if (trailing != null) ...[
            SizedBox(width: spacing?.s ?? 8),
            trailing!,
          ],
        ],
      ),
    );
  }

  Color _backgroundForType(KinlyColorTokens colors, KinlyOpacity opacities) {
    switch (type) {
      case KinlyBannerType.success:
        return colors.primaryContainer;
      case KinlyBannerType.info:
        return colors.info;
      case KinlyBannerType.warning:
        return colors.warning;
      case KinlyBannerType.error:
        return colors.error.withValues(alpha: opacities.alphaSM);
    }
  }

  Color _foregroundForType(KinlyColorTokens colors) {
    switch (type) {
      case KinlyBannerType.success:
        return colors.onPrimaryContainer;
      case KinlyBannerType.info:
      case KinlyBannerType.warning:
        return colors.onSurface;
      case KinlyBannerType.error:
        return colors.onError;
    }
  }
}
