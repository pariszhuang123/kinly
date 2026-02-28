import 'package:flutter/material.dart';

import '../theme/color_tokens.dart';
import '../theme/kinly_palette.dart';
import '../theme/radius.dart';
import '../theme/spacing.dart';
import '../theme/typography_tokens.dart';

/// Inline tab bar built on Kinly tokens. Use for lightweight single-row tabs.
///
/// Supports:
/// - Non-null selection (default behaviour, one tab always selected)
/// - Nullable selection when [emptySelectionAllowed] is true.
class KinlyTabBar<T> extends StatelessWidget {
  const KinlyTabBar({
    super.key,
    required this.tabs,
    required this.onChanged,
    this.selected,
    this.emptySelectionAllowed = false,
    this.selectedIcons,
  });

  /// Map of value -> label.
  final Map<T, String> tabs;

  /// Currently selected tab value (nullable).
  final T? selected;

  /// Called when selection changes. Receives `null` when deselected
  /// (only possible if [emptySelectionAllowed] is true).
  final ValueChanged<T?> onChanged;

  /// Whether no selection is allowed (passes `null` to [onChanged]).
  final bool emptySelectionAllowed;

  /// Per-tab icons shown when that tab is selected. Tabs without an entry
  /// fall back to the default check icon.
  final Map<T, Widget>? selectedIcons;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>();
    final corners = theme.extension<Corners>();
    final colors =
        theme.extension<KinlyColorTokens>() ??
        KinlyPalette.build(theme.brightness).colorTokens;
    final type = theme.extension<KinlyTypography>();

    final hasCustomIcons = selectedIcons != null;

    return SegmentedButton<T>(
      emptySelectionAllowed: emptySelectionAllowed,
      showSelectedIcon: !hasCustomIcons,
      segments:
          tabs.entries
              .map(
                (entry) {
                  final isSelected = entry.key == selected;
                  Widget? icon;
                  if (hasCustomIcons && isSelected) {
                    icon =
                        selectedIcons![entry.key] ??
                        const Icon(Icons.check, size: 18);
                  }
                  return ButtonSegment<T>(
                    value: entry.key,
                    label: Text(entry.value),
                    icon: icon,
                  );
                },
              )
              .toList(),
      selected: selected != null ? {selected as T} : <T>{},
      onSelectionChanged: (values) {
        if (values.isEmpty) {
          onChanged(null);
        } else {
          onChanged(values.first);
        }
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
          final isSelected = states.contains(WidgetState.selected);
          if (isSelected) {
            return colors.primaryContainer;
          }
          return colors.surfaceVariant;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          if (isSelected) {
            return colors.onPrimaryContainer;
          }
          return colors.onSurface;
        }),
        side: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          final color = isSelected ? colors.primary : colors.outline;
          return BorderSide(color: color);
        }),
      ),
    );
  }
}
