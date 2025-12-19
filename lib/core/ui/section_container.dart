import 'package:flutter/material.dart';

import '../theme/kinly_sections.dart';
import '../theme/color_tokens.dart';
import '../theme/kinly_palette.dart';
import '../theme/radius.dart';
import '../theme/spacing.dart';
import '../theme/opacity.dart';

class SectionContainer extends StatelessWidget {
  final String title;
  final SectionColors colors;
  final Widget child;

  /// New: optional leading icon (like KinlySelectionCard)
  final Widget? leading;

  /// Existing: optional trailing widget (badge, chip, etc.)
  final Widget? trailing;

  final EdgeInsetsGeometry? padding;

  const SectionContainer({
    super.key,
    required this.title,
    required this.colors,
    required this.child,
    this.leading,
    this.trailing,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;
    final corners = theme.extension<Corners>()!;
    final tokens =
        theme.extension<KinlyColorTokens>() ??
        KinlyPalette.build(theme.brightness).colorTokens;
    final opacities = theme.extension<KinlyOpacity>()!;

    final effectivePadding =
        padding ??
        EdgeInsetsDirectional.fromSTEB(
          spacing.lg,
          spacing.lg,
          spacing.lg,
          spacing.md,
        );

    return Container(
      padding: effectivePadding,
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(corners.xlarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== HEADER ROW (leading icon + title + trailing) =====
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (leading != null)
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: colors.accent.withValues(alpha: opacities.alphaLG),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.all(spacing.sm),
                  child: Center(child: leading),
                ),

              if (leading != null) SizedBox(width: spacing.md),

              // Title
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: tokens.onSurface,
                  ),
                ),
              ),

              // Trailing widget
              if (trailing != null) trailing!,
            ],
          ),

          SizedBox(height: spacing.md),

          // ===== CONTENT =====
          child,
        ],
      ),
    );
  }
}
