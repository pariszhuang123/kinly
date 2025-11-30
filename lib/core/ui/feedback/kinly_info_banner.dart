import 'package:flutter/material.dart';

import '../../theme/color_tokens.dart';
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
    final colors = theme.extension<KinlyColorTokens>();
    final typeScale = theme.extension<KinlyTypography>();
    final colorScheme = theme.colorScheme;

    final bg = switch (type) {
      KinlyBannerType.success =>
        colors?.primaryContainer ?? colorScheme.primaryContainer,
      KinlyBannerType.info => colors?.info ?? colorScheme.inversePrimary,
      KinlyBannerType.warning =>
        colors?.warning ?? colorScheme.tertiaryContainer,
      KinlyBannerType.error => colors?.error ?? colorScheme.errorContainer,
    };
    final fg = switch (type) {
      KinlyBannerType.success =>
        colors?.onPrimaryContainer ?? colorScheme.onPrimaryContainer,
      KinlyBannerType.info =>
        colors?.onInverseSurface ?? colorScheme.onInverseSurface,
      KinlyBannerType.warning => colors?.onSurface ?? colorScheme.onSurface,
      KinlyBannerType.error => colors?.onError ?? colorScheme.onError,
    };

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
}
