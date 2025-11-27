import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../theme/spacing.dart';

/// A generic Kinly-styled horizontal selector for any option type.
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
  final bool scrollable;

  /// Width of each card.
  final double optionWidth;

  /// Size of the icon (SVG or IconData).
  final double iconSize;

  /// Whether the label appears below the icon.
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;

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

    if (!scrollable) return row;

    return SingleChildScrollView(scrollDirection: Axis.horizontal, child: row);
  }

  bool _isSelected(KinlySelectorOption<T> option) {
    if (selectedValue == null) return false;
    return option.value == selectedValue;
  }
}

/// Generic option model
class KinlySelectorOption<T> {
  const KinlySelectorOption({
    required this.value,
    required this.label,
    this.svgAsset,
    this.iconData,
  });

  final T value;
  final String label;
  final String? svgAsset;
  final IconData? iconData;
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
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // These tokens come from your Kinly theme (buildKinlyTheme).
    final borderColor = isSelected ? colors.primary : colors.outlineVariant;

    final bg =
        isSelected
            ? colors.primaryContainer
            : (isDark
                ? colors.surfaceContainerHigh
                : colors.surfaceContainerHighest);

    final textColor = isSelected ? colors.onPrimaryContainer : colors.onSurface;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: EdgeInsets.all(spacing.sm),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIcon(context, colors),
            if (showLabel) ...[
              SizedBox(height: spacing.xs),
              Text(
                option.label,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context, ColorScheme colors) {
    if (option.svgAsset != null) {
      return SizedBox(
        height: iconSize,
        width: iconSize,
        child: SvgPicture.asset(option.svgAsset!),
      );
    }

    if (option.iconData != null) {
      return Icon(
        option.iconData,
        size: iconSize,
        color: isSelected ? colors.onPrimaryContainer : colors.onSurface,
      );
    }

    return const SizedBox.shrink();
  }
}
