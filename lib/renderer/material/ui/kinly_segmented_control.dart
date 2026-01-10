import 'package:flutter/material.dart';

import '../theme/color_tokens.dart';
import '../theme/kinly_palette.dart';
import '../theme/radius.dart';
import '../theme/spacing.dart';
import '../theme/typography_tokens.dart';

/// Kinly-styled segmented control (single-select).
class KinlySegmentedControl<T> extends StatelessWidget {
  const KinlySegmentedControl({
    super.key,
    required this.segments,
    required this.selected,
    required this.onChanged,
  });

  final Map<T, String> segments;
  final T selected;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>();
    final corners = theme.extension<Corners>();
    final colors =
        theme.extension<KinlyColorTokens>() ??
        KinlyPalette.build(theme.brightness).colorTokens;
    final type = theme.extension<KinlyTypography>();

    return SegmentedButton<T>(
      segments:
          segments.entries
              .map(
                (entry) => ButtonSegment<T>(
                  value: entry.key,
                  label: Text(entry.value),
                ),
              )
              .toList(),
      selected: {selected},
      onSelectionChanged: (values) {
        final value = values.first;
        onChanged(value);
      },
      style: ButtonStyle(
        textStyle: WidgetStateProperty.all(
          type?.labelMedium ?? theme.textTheme.labelMedium,
        ),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(
            horizontal: spacing?.m ?? 12,
            vertical: spacing?.s ?? 8,
          ),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(corners?.large ?? 16),
          ),
        ),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.primaryContainer;
          }
          return colors.surfaceVariant;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.onPrimaryContainer;
          }
          return colors.onSurface;
        }),
        side: WidgetStateProperty.resolveWith((states) {
          final color =
              states.contains(WidgetState.selected)
                  ? colors.primary
                  : colors.outline;
          return BorderSide(color: color);
        }),
      ),
    );
  }
}
