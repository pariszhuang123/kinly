import 'package:flutter/material.dart';

import '../theme/radius.dart';
import '../theme/spacing.dart';
import 'enums/kinly_pill_size.dart';

/// Lightweight pill/badge aligned to Kinly spacing + corner tokens.
class KinlyPill extends StatelessWidget {
  const KinlyPill({
    super.key,
    required this.label,
    this.size = KinlyPillSize.compact,
    required this.backgroundColor,
    required this.textColor,
    this.borderColor,
    this.textStyle,
  });

  final String label;
  final KinlyPillSize size;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;
    final corners = theme.extension<Corners>();

    final horizontal = size == KinlyPillSize.compact ? spacing.sm : spacing.md;
    final vertical = size == KinlyPillSize.compact ? spacing.xs : spacing.sm;
    final radius =
        size == KinlyPillSize.compact
            ? (corners?.sm ?? 10)
            : (corners?.md ?? 14);

    final effectiveTextStyle =
        textStyle ??
        (size == KinlyPillSize.compact
            ? theme.textTheme.labelSmall
            : theme.textTheme.labelMedium);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
        border: borderColor != null ? Border.all(color: borderColor!) : null,
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: horizontal,
          vertical: vertical,
        ),
        child: Text(
          label,
          softWrap: true,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: effectiveTextStyle?.copyWith(color: textColor, height: 1.1),
        ),
      ),
    );
  }
}
