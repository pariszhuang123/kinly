import 'package:flutter/material.dart';

import '../../theme/control_tokens.dart';
import '../../theme/kinly_palette.dart';
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>();
    final corners = theme.extension<Corners>();
    final type = theme.extension<KinlyTypography>();
    final controls =
        theme.extension<KinlyControlColors>() ??
        KinlyPalette.build(theme.brightness).controlColors;

    final effectiveLabel = label.trim();
    assert(effectiveLabel.isNotEmpty, 'Badge label must not be empty');

    late final Color foreground;
    late final Color background;

    if (destructive) {
      foreground = controls.errorBadgeFg;
      background = controls.errorBadgeBg;
    } else if (accentColor != null) {
      foreground = accentColor!;
      background = accentColor!.withValues(alpha: 0.10);
    } else {
      foreground = controls.badgeFg;
      background = controls.badgeBg;
    }

    final horizontal = compact ? (spacing?.xs ?? 4) : (spacing?.sm ?? 8);
    final vertical = compact ? 4.0 : (spacing?.xs ?? 4);

    return Semantics(
      container: true,
      label: semanticsLabel ?? effectiveLabel,
      child: ExcludeSemantics(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(corners?.xs ?? 10),
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
              style: (type?.labelSmall ?? theme.textTheme.labelSmall)?.copyWith(
                color: foreground,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
