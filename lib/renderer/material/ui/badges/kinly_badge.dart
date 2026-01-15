import 'package:flutter/material.dart';

import '../../theme/control_tokens.dart';
import '../../theme/kinly_palette.dart';
import '../../theme/opacity.dart';
import '../../theme/radius.dart';
import '../../theme/spacing.dart';
import '../../theme/typography_tokens.dart';

class KinlyBadge extends StatelessWidget {
  const KinlyBadge({
    super.key,
    required this.label,
    this.semanticsLabel,
    this.accentColor,
    this.destructive = false,
    this.compact = true,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.textStyle,
    this.maxLines = 1,
  });

  final String label;
  final String? semanticsLabel;

  /// If set, renders as an accent badge using this color.
  /// Useful for section-specific labels (Flow/Share/Pulse).
  final Color? accentColor;

  /// If true, renders using the destructive badge tokens.
  /// Prefer for irreversible / dangerous affordances only.
  final bool destructive;

  /// Compact badges are used inline in list rows.
  final bool compact;

  /// Optional override for custom badge styling. If you set one of
  /// [backgroundColor]/[foregroundColor], you must set both.
  final Color? backgroundColor;
  final Color? foregroundColor;

  /// Optional border for custom variants.
  final Color? borderColor;

  /// Optional text style override (color will be overridden by badge fg).
  final TextStyle? textStyle;

  /// Allow multi-line labels when needed (defaults to 1).
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>();
    final corners = theme.extension<Corners>();
    final type = theme.extension<KinlyTypography>();
    final controls =
        theme.extension<KinlyControlColors>() ??
        KinlyPalette.build(theme.brightness).controlColors;
    final opacities = theme.extension<KinlyOpacity>()!;

    final effectiveLabel = label.trim();
    assert(effectiveLabel.isNotEmpty, 'Badge label must not be empty');
    assert(
      (backgroundColor == null && foregroundColor == null) ||
          (backgroundColor != null && foregroundColor != null),
      'If you set backgroundColor or foregroundColor, you must set both.',
    );
    assert(maxLines > 0, 'maxLines must be > 0');

    final badgeColors = _resolveColors(controls, opacities);

    final horizontal = compact ? (spacing?.xs ?? 4) : (spacing?.sm ?? 8);
    final vertical = compact ? 4.0 : (spacing?.xs ?? 4);
    final border = borderColor != null ? Border.all(color: borderColor!) : null;
    final radius = corners?.pill ?? 999.0;

    return Semantics(
      container: true,
      label: semanticsLabel ?? effectiveLabel,
      child: ExcludeSemantics(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: badgeColors.background,
            borderRadius: BorderRadius.circular(radius),
            border: border,
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(
              horizontal,
              vertical,
              horizontal,
              vertical,
            ),
            child: Text(
              effectiveLabel,
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: (textStyle ??
                      (type?.labelSmall ?? theme.textTheme.labelSmall))
                  ?.copyWith(
                    color: badgeColors.foreground,
                    fontWeight: (textStyle?.fontWeight) ?? FontWeight.w700,
                    letterSpacing: (textStyle?.letterSpacing) ?? 0.2,
                  ),
            ),
          ),
        ),
      ),
    );
  }

  _BadgeColors _resolveColors(
    KinlyControlColors controls,
    KinlyOpacity opacities,
  ) {
    if (backgroundColor != null && foregroundColor != null) {
      return _BadgeColors(
        foreground: foregroundColor!,
        background: backgroundColor!,
      );
    }
    if (destructive) {
      return _BadgeColors(
        foreground: controls.errorBadgeFg,
        background: controls.errorBadgeBg,
      );
    }
    if (accentColor != null) {
      return _BadgeColors(
        foreground: accentColor!,
        background: accentColor!.withValues(alpha: opacities.alphaXS),
      );
    }
    return _BadgeColors(
      foreground: controls.badgeFg,
      background: controls.badgeBg,
    );
  }
}

class _BadgeColors {
  const _BadgeColors({required this.foreground, required this.background});
  final Color foreground;
  final Color background;
}
