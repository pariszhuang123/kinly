import 'package:flutter/material.dart';

import '../theme/color_tokens.dart';
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
    final colors = theme.extension<KinlyColorTokens>();
    final type = theme.extension<KinlyTypography>();
    final colorScheme = theme.colorScheme;

    return SegmentedButton<T>(
      segments: segments.entries
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
        backgroundColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return colors?.primaryContainer ?? colorScheme.primaryContainer;
            }
            return colors?.surfaceVariant ??
                colorScheme.surfaceContainerHighest;
          },
        ),
        foregroundColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return colors?.onPrimaryContainer ?? colorScheme.onPrimaryContainer;
            }
            return colors?.onSurface ?? colorScheme.onSurface;
          },
        ),
        side: WidgetStateProperty.resolveWith(
          (states) {
            final color =
                states.contains(WidgetState.selected)
                    ? colors?.primary ?? colorScheme.primary
                    : colors?.outline ?? colorScheme.outline;
            return BorderSide(color: color);
          },
        ),
      ),
    );
  }
}
