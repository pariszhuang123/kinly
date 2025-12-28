import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../theme/control_tokens.dart';
import '../../theme/kinly_palette.dart';
import '../../theme/spacing.dart';

/// A generic Kinly-styled selector for any option type.
///
/// T = the value type (e.g. MoodScale, enum, String, int).
class KinlyOptionSelectorRow<T> extends StatelessWidget {
  const KinlyOptionSelectorRow({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
    this.scrollable = true,
    this.optionWidth = 100,
    this.iconSize = 40,
    this.showLabel = true,
  });

  /// All options to render.
  final List<KinlySelectorOption<T>> options;

  /// Currently selected value (nullable).
  final T? selectedValue;

  /// Called when an option is tapped.
  final ValueChanged<T> onChanged;

  /// Scroll horizontally if overflow.
  ///
  /// - true  => single-row, horizontal scroll
  /// - false => multiple centered rows using a fixed pattern
  final bool scrollable;

  /// Default width of each card (used in scrollable mode).
  final double optionWidth;

  /// Default icon size (used in scrollable mode).
  final double iconSize;

  /// Whether the label appears below the icon.
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;

    // Original one-row horizontal scroll behavior.
    if (scrollable) {
      final row = Row(
        children: [
          for (final option in options)
            Padding(
              padding: EdgeInsetsDirectional.only(end: spacing.md),
              child: _KinlyOptionCard<T>(
                option: option,
                isSelected: _isSelected(option),
                onTap: () => onChanged(option.value),
                width: optionWidth,
                iconSize: iconSize,
                showLabel: showLabel,
              ),
            ),
        ],
      );

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: row,
      );
    }

    // Multi-row centered layout with responsive sizes.
    final rows = _splitIntoRows(options);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var rowIndex = 0; rowIndex < rows.length; rowIndex++)
          Padding(
            padding: EdgeInsets.only(
              // Much smaller vertical gaps than before
              top: rowIndex == 0 ? spacing.s : spacing.m,
              bottom: rowIndex == rows.length - 1 ? spacing.s : spacing.m,
            ),
            child: _buildRow(context, rows[rowIndex]),
          ),
      ],
    );
  }

  bool _isSelected(KinlySelectorOption<T> option) {
    if (selectedValue == null) return false;
    return option.value == selectedValue;
  }

  Widget _buildRow(
    BuildContext context,
    List<KinlySelectorOption<T>> rowOptions,
  ) {
    final spacing = Theme.of(context).extension<Spacing>()!;
    final rowCount = rowOptions.length;

    // Responsive sizing based on row length.
    final rowIconSize = _computeIconSize(rowCount);
    final rowCardWidth = _computeCardWidth(rowCount);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < rowOptions.length; i++)
          Padding(
            padding: EdgeInsetsDirectional.only(
              end: i == rowOptions.length - 1 ? 0 : spacing.md,
            ),
            child: _KinlyOptionCard<T>(
              option: rowOptions[i],
              isSelected: _isSelected(rowOptions[i]),
              onTap: () => onChanged(rowOptions[i].value),
              width: rowCardWidth,
              iconSize: rowIconSize,
              showLabel: showLabel,
            ),
          ),
      ],
    );
  }

  /// Fixed layout pattern:
  /// - 5 -> 3 + 2
  /// - 6 -> 3 + 3
  /// - 7 -> 4 + 3
  /// - 8 -> 4 + 4
  /// - 9+ -> groups of 4
  List<List<KinlySelectorOption<T>>> _splitIntoRows(
    List<KinlySelectorOption<T>> all,
  ) {
    final n = all.length;
    final counts = _computeRowCounts(n);

    final rows = <List<KinlySelectorOption<T>>>[];
    var start = 0;

    for (final count in counts) {
      final end = (start + count).clamp(0, n);
      if (start >= end) break;
      rows.add(all.sublist(start, end));
      start = end;
    }

    return rows;
  }

  List<int> _computeRowCounts(int n) {
    const presets = <int, List<int>>{
      1: [1],
      2: [2],
      3: [3],
      4: [4],
      5: [3, 2],
      6: [3, 3],
      7: [4, 3],
      8: [4, 4],
    };
    final preset = presets[n];
    if (preset != null) return preset;

    // fallback layout: rows of 4
    const perRow = 4;
    final full = n ~/ perRow;
    final leftover = n % perRow;

    final result = List<int>.filled(full, perRow);
    if (leftover > 0) result.add(leftover);
    return result;
  }

  double _computeIconSize(int rowCount) {
    switch (rowCount) {
      case 1:
      case 2:
        return 50; // large
      case 3:
        return 44; // medium
      case 4:
        return 40; // small-medium
      default:
        return 40; // small
    }
  }

  double _computeCardWidth(int rowCount) {
    switch (rowCount) {
      case 1:
      case 2:
        return 90;
      case 3:
        return 80;
      case 4:
        return 70;
      default:
        return 60;
    }
  }
}

/// Generic option model.
class KinlySelectorOption<T> {
  const KinlySelectorOption({
    required this.value,
    required this.label,
    this.svgAsset,
    this.iconData,
    this.semanticsLabel,
  });

  final T value;
  final String label;
  final String? svgAsset;
  final IconData? iconData;
  final String? semanticsLabel;
}

class _KinlyOptionCard<T> extends StatelessWidget {
  const _KinlyOptionCard({
    required this.option,
    required this.isSelected,
    required this.onTap,
    required this.width,
    required this.iconSize,
    required this.showLabel,
  });

  final KinlySelectorOption<T> option;
  final bool isSelected;
  final VoidCallback onTap;

  final double width;
  final double iconSize;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;
    final controls =
        theme.extension<KinlyControlColors>() ??
        KinlyPalette.build(theme.brightness).controlColors;

    final bg =
        isSelected ? controls.selectableItemBgSelected : controls.optionRowBg;

    final textColor =
        isSelected ? controls.selectableItemFgSelected : controls.optionRowFg;
    final labelText = option.semanticsLabel ?? option.label;

    return Semantics(
      button: true,
      enabled: true,
      label: labelText,
      child: GestureDetector(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
          child: Container(
            width: width,
            padding: EdgeInsets.all(spacing.xs),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? controls.selectableItemBorderSelected
                      : controls.optionRowBorder,
                ),
              ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildIcon(context, controls),
                if (showLabel) ...[
                  SizedBox(height: spacing.xs),
                  Text(
                    option.label,
                    textAlign: TextAlign.center,
                    style:
                        theme.textTheme.bodyMedium?.copyWith(color: textColor),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the icon with a circular selection ring that cuts into the icon.
  Widget _buildIcon(BuildContext context, KinlyControlColors controls) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;

    final ringColor = isSelected
        ? controls.selectableItemBorderSelected
        : controls.selectableItemBorder;
    final ringBackground = controls.selectableItemBg;

    // Inner visual (SVG or Icon).
    Widget? inner;
    if (option.svgAsset != null) {
      inner = SvgPicture.asset(option.svgAsset!, fit: BoxFit.cover);
    } else if (option.iconData != null) {
      inner = Icon(
        option.iconData,
        size: iconSize,
        color:
            isSelected ? controls.selectableItemFgSelected : controls.selectableItemFg,
      );
    }

    if (inner == null) {
      return const SizedBox.shrink();
    }

    // Circular ring that clips the square icon — gives a tight color halo.
    return Container(
      padding: EdgeInsets.all(spacing.xxs), // thin halo
      decoration: BoxDecoration(
        color: ringBackground,
        shape: BoxShape.circle,
        border: Border.all(color: ringColor, width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(iconSize / 2),
        child: SizedBox(width: iconSize, height: iconSize, child: inner),
      ),
    );
  }
}
