import 'package:flutter/material.dart';

import '../theme/color_tokens.dart';
import '../theme/elevation.dart';
import '../theme/radius.dart';
import '../theme/spacing.dart';

/// General-purpose action card with tokenized padding, radius, and tap state.
class KinlyActionCard extends StatelessWidget {
  const KinlyActionCard({
    super.key,
    required this.child,
    this.onTap,
    this.background,
    this.padding,
  });

  final Widget child;
  final VoidCallback? onTap;
  final Color? background;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>();
    final corners = theme.extension<Corners>();
    final elevations = theme.extension<Elevations>();
    final colors = theme.extension<KinlyColorTokens>();
    final colorScheme = theme.colorScheme;

    final cardColor = background ??
        colors?.surface ??
        colorScheme.surfaceContainerHigh;

    final content = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
      child: Container(
        padding: padding ?? EdgeInsets.all(spacing?.l ?? 16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(corners?.medium ?? 12),
        ),
        child: child,
      ),
    );

    if (onTap == null) {
      return content;
    }

    return Semantics(
      button: true,
      enabled: onTap != null,
      child: Material(
        color: Colors.transparent,
        elevation: elevations?.level1 ?? 1,
        borderRadius: BorderRadius.circular(corners?.medium ?? 12),
        child: InkWell(
          borderRadius: BorderRadius.circular(corners?.medium ?? 12),
          onTap: onTap,
          child: content,
        ),
      ),
    );
  }
}
