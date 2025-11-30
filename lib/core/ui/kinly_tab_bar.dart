import 'package:flutter/material.dart';

import '../theme/color_tokens.dart';
import '../theme/radius.dart';
import '../theme/spacing.dart';
import '../theme/typography_tokens.dart';

/// Inline tab bar built on Kinly tokens. Use for lightweight single-row tabs.
class KinlyTabBar<T> extends StatelessWidget {
  const KinlyTabBar({
    super.key,
    required this.tabs,
    required this.selected,
    required this.onChanged,
  });

  final Map<T, String> tabs;
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
      segments:
          tabs.entries
              .map(
                (entry) => ButtonSegment<T>(
                  value: entry.key,
                  label: Text(entry.value),
                ),
              )
              .toList(),
      selected: {selected},
      onSelectionChanged: (values) => onChanged(values.first),
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
          final isSelected = states.contains(WidgetState.selected);
          if (isSelected) {
            return colors?.primaryContainer ?? colorScheme.primaryContainer;
          }
          return colors?.surfaceVariant ?? colorScheme.surfaceContainerHighest;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          if (isSelected) {
            return colors?.onPrimaryContainer ?? colorScheme.onPrimaryContainer;
          }
          return colors?.onSurface ?? colorScheme.onSurface;
        }),
        side: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          final color =
              isSelected
                  ? colors?.primary ?? colorScheme.primary
                  : colors?.outline ?? colorScheme.outline;
          return BorderSide(color: color);
        }),
      ),
    );
  }
}
