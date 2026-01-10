import 'package:flutter/material.dart';

import '../../theme/color_tokens.dart';
import '../../theme/kinly_palette.dart';
import '../../theme/opacity.dart';
import '../../theme/radius.dart';
import '../../theme/spacing.dart';
import '../../theme/typography_tokens.dart';

/// Kinly-styled filter chip (multi-select capable).
class KinlyFilterChip extends StatelessWidget {
  const KinlyFilterChip({
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
    final colors =
        theme.extension<KinlyColorTokens>() ??
        KinlyPalette.build(theme.brightness).colorTokens;
    final type = theme.extension<KinlyTypography>();
    final opacities = theme.extension<KinlyOpacity>()!;

    final background =
        selected ? colors.primaryContainer : colors.surfaceVariant;
    final borderColor = selected ? colors.primary : colors.outline;
    final labelColor = selected ? colors.onPrimaryContainer : colors.onSurface;

    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null) ...[leading!, SizedBox(width: spacing?.xs ?? 4)],
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
      checkmarkColor: labelColor,
      disabledColor: colors.disabled.withValues(alpha: opacities.alphaMuted),
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
