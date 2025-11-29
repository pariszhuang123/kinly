import 'package:flutter/material.dart';

import '../../theme/color_tokens.dart';
import '../../theme/radius.dart';
import '../../theme/spacing.dart';
import '../../theme/typography_tokens.dart';

/// Kinly-styled choice chip.
class KinlyChoiceChip extends StatelessWidget {
  const KinlyChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    this.onSelected,
    this.leading,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool>? onSelected;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>();
    final corners = theme.extension<Corners>();
    final colors = theme.extension<KinlyColorTokens>();
    final type = theme.extension<KinlyTypography>();
    final colorScheme = theme.colorScheme;

    final background =
        selected
            ? (colors?.primaryContainer ?? colorScheme.primaryContainer)
            : (colors?.surfaceVariant ?? colorScheme.surfaceVariant);
    final borderColor =
        selected
            ? (colors?.primary ?? colorScheme.primary)
            : (colors?.outline ?? colorScheme.outline);
    final labelColor =
        selected
            ? (colors?.onPrimaryContainer ?? colorScheme.onPrimaryContainer)
            : (colors?.onSurface ?? colorScheme.onSurface);

    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null) ...[
            leading!,
            SizedBox(width: spacing?.xs ?? 4),
          ],
          Text(
            label,
            style: (type?.labelSmall ?? theme.textTheme.labelSmall)?.copyWith(
              color: labelColor,
            ),
          ),
        ],
      ),
      selected: selected,
      onSelected: onSelected,
      backgroundColor: background,
      selectedColor: background,
      disabledColor: (colors?.disabled ?? colorScheme.outlineVariant)
          .withValues(alpha: 0.4),
      labelPadding: EdgeInsets.symmetric(
        horizontal: spacing?.s ?? 8,
        vertical: spacing?.xxs ?? 2,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(corners?.pill ?? 999),
        side: BorderSide(color: borderColor),
      ),
    );
  }
}
