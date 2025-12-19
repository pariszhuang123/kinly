import 'package:flutter/material.dart';

import '../theme/color_tokens.dart';
import '../theme/kinly_palette.dart';
import '../theme/opacity.dart';
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
    this.semanticsLabel,
  });

  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? contentPadding;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    assert(
      (semanticsLabel ?? title).isNotEmpty,
      'Semantic label must not be empty',
    );
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>();
    final colors = theme.extension<KinlyColorTokens>();
    final derived = colors ?? KinlyPalette.build(theme.brightness).colorTokens;
    final type = theme.extension<KinlyTypography>();
    final corners = theme.extension<Corners>();
    final opacities = theme.extension<KinlyOpacity>()!;

    final padding =
        contentPadding ??
        EdgeInsetsDirectional.fromSTEB(
          spacing?.l ?? 16,
          spacing?.s ?? 8,
          spacing?.l ?? 16,
          spacing?.s ?? 8,
        );

    final tile = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
      child: ListTile(
        contentPadding: padding,
        leading: leading,
        title: Text(
          title,
          style: (type?.titleSmall ?? theme.textTheme.titleSmall)?.copyWith(
            color: derived.onSurface,
          ),
        ),
        subtitle:
            subtitle == null
                ? null
                : Text(
                  subtitle!,
                  style: (type?.bodyMedium ?? theme.textTheme.bodyMedium)
                      ?.copyWith(
                        color: derived.onSurface.withValues(
                          alpha: opacities.alphaFaint,
                        ),
                      ),
                ),
        trailing: trailing,
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(corners?.medium ?? 12),
        ),
        tileColor: derived.surfaceVariant,
      ),
    );

    final semanticsText =
        semanticsLabel ??
        (subtitle == null ? title : '$title, $subtitle');

    final wrappedTile =
        onTap == null ? tile : Material(color: Colors.transparent, child: tile);

    return Semantics(
      button: onTap != null,
      enabled: onTap != null,
      label: semanticsText,
      child: wrappedTile,
    );
  }
}
