import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/color_tokens.dart';
import '../../theme/spacing.dart';

class KinlySelectableItem<T> {
  const KinlySelectableItem({
    required this.value,
    required this.label,
    required this.builder,
    this.semanticsLabel,
    this.key,
  });

  final T value;
  final String label;
  final String? semanticsLabel;
  final Key? key;

  /// Builds the visual for this item (e.g., avatar, icon).
  final Widget Function(BuildContext context, bool isSelected) builder;
}

/// Shared selectable row with Kinly halo + lift affordance.
///
/// Selection behaviour is handled by the caller:
/// - `selectedValues` drives visuals/semantics.
/// - `allowDeselect` controls whether tapping an already-selected item triggers
///   `onToggle` (set false to block unselect).
class KinlySelectableItemRow<T> extends StatelessWidget {
  const KinlySelectableItemRow({
    super.key,
    required this.items,
    required this.selectedValues,
    required this.onToggle,
    this.showLabels = false,
    this.itemVisualSize = 40,
    this.spacing,
    this.runSpacing,
    this.allowDeselect = true,
  });

  final List<KinlySelectableItem<T>> items;
  final Set<T> selectedValues;
  final ValueChanged<T> onToggle;
  final bool showLabels;
  final double itemVisualSize;
  final double? spacing;
  final double? runSpacing;
  final bool allowDeselect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacingTokens = theme.extension<Spacing>();
    final gap = spacing ?? spacingTokens?.m ?? 12.0;
    final wrapRunSpacing = runSpacing ?? spacingTokens?.s ?? 8.0;

    return Wrap(
      spacing: gap,
      runSpacing: wrapRunSpacing,
      alignment: WrapAlignment.start,
      children:
          items
              .map(
                (item) => _SelectableItem<T>(
                  item: item,
                  isSelected: selectedValues.contains(item.value),
                  showLabel: showLabels,
                  visualSize: itemVisualSize,
                  allowDeselect: allowDeselect,
                  onTap: () => onToggle(item.value),
                ),
              )
              .toList(growable: false),
    );
  }
}

class _SelectableItem<T> extends StatelessWidget {
  const _SelectableItem({
    required this.item,
    required this.isSelected,
    required this.showLabel,
    required this.visualSize,
    required this.allowDeselect,
    required this.onTap,
  });

  final KinlySelectableItem<T> item;
  final bool isSelected;
  final bool showLabel;
  final double visualSize;
  final bool allowDeselect;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final colorTokens = theme.extension<KinlyColorTokens>();
    final spacingTokens = theme.extension<Spacing>();
    final diameter = visualSize;
    const minTapTarget = 48.0;
    final extraPadding = math.max(0.0, (minTapTarget - diameter) / 2);
    final tapPadding = math.max(spacingTokens?.xxs ?? 4.0, extraPadding);
    final isDark = theme.brightness == Brightness.dark;
    final basePrimary = colorTokens?.primary ?? colorScheme.primary;
    final baseContainer =
        colorTokens?.primaryContainer ?? colorScheme.primaryContainer;
    final haloColor =
        isDark
            ? baseContainer.withValues(alpha: 0.38)
            : basePrimary.withValues(alpha: 0.26);
    final ringColor =
        isDark
            ? baseContainer.withValues(alpha: 0.78)
            : basePrimary.withValues(alpha: 0.42);
    final ringThickness = isSelected ? 2.0 : 0.0;
    final haloPadding =
        isSelected ? math.max(spacingTokens?.xs ?? 4.0, 4.0) : 0.0;

    Widget content = AnimatedScale(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOut,
      scale: isSelected ? 1.05 : 1.0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        decoration:
            isSelected
                ? BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: ringColor, width: ringThickness),
                  boxShadow: [
                    BoxShadow(
                      color: haloColor,
                      blurRadius: 16,
                      spreadRadius: 4,
                    ),
                  ],
                )
                : const BoxDecoration(shape: BoxShape.circle),
        child: Padding(
          padding: EdgeInsets.all(ringThickness),
          child: item.builder(context, isSelected),
        ),
      ),
    );

    if (showLabel) {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          content,
          SizedBox(height: spacingTokens?.s ?? 8.0),
          SizedBox(
            width: visualSize * 2.0,
            child: Text(
              item.label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
    }

    return Semantics(
      key: item.key,
      button: true,
      selected: isSelected,
      label: item.semanticsLabel ?? item.label,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () {
            if (isSelected && !allowDeselect) return;
            onTap();
          },
          child: Padding(
            padding: EdgeInsetsDirectional.all(tapPadding + haloPadding),
            child: content,
          ),
        ),
      ),
    );
  }
}
