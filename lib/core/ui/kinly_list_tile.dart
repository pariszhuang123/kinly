import 'package:flutter/material.dart';

import '../theme/color_tokens.dart';
import '../theme/radius.dart';
import '../theme/spacing.dart';
import '../theme/typography_tokens.dart';

/// Tokenized list tile replacement.
class KinlyListTile extends StatelessWidget {
  const KinlyListTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.contentPadding,
  });

  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>();
    final colors = theme.extension<KinlyColorTokens>();
    final type = theme.extension<KinlyTypography>();
    final corners = theme.extension<Corners>();
    final colorScheme = theme.colorScheme;

    final padding =
        contentPadding ??
        EdgeInsetsDirectional.fromSTEB(
          spacing?.l ?? 16,
          spacing?.s ?? 8,
          spacing?.l ?? 16,
          spacing?.s ?? 8,
        );

    final tile = ListTile(
      contentPadding: padding,
      leading: leading,
      title: Text(
        title,
        style: (type?.titleSmall ?? theme.textTheme.titleSmall)?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      subtitle:
          subtitle == null
              ? null
              : Text(
                subtitle!,
                style: (type?.bodyMedium ?? theme.textTheme.bodyMedium)
                    ?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
      trailing: trailing,
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(corners?.medium ?? 12),
      ),
      tileColor: colors?.surfaceVariant ?? colorScheme.surfaceContainerHighest,
    );

    if (onTap == null) return tile;
    return Material(color: Colors.transparent, child: tile);
  }
}
