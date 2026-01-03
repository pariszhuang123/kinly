import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../selector/kinly_selectable_item_row.dart';
import '../../theme/spacing.dart';

class KinlyWeatherSelectorOption<T> {
  const KinlyWeatherSelectorOption({
    required this.value,
    required this.label,
    required this.svgAsset,
    this.semanticsLabel,
  });

  final T value;
  final String label;
  final String svgAsset;
  final String? semanticsLabel;
}

/// Kinly-styled single-select row for weather/mood icons.
class KinlyWeatherSelectorRow<T> extends StatelessWidget {
  const KinlyWeatherSelectorRow({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
    this.showLabels = false,
    this.spacing,
    this.runSpacing,
    this.iconSize = 44,
    this.alignment = WrapAlignment.center,
  });

  final List<KinlyWeatherSelectorOption<T>> options;
  final T? selectedValue;
  final ValueChanged<T> onChanged;
  final bool showLabels;
  final double? spacing;
  final double? runSpacing;
  final double iconSize;
  final WrapAlignment alignment;

  @override
  Widget build(BuildContext context) {
    final spacingTokens = Theme.of(context).extension<Spacing>();
    return KinlySelectableItemRow<T>(
      items:
          options
              .map(
                (option) => KinlySelectableItem<T>(
                  value: option.value,
                  label: option.label,
                  semanticsLabel: option.semanticsLabel,
                  builder:
                      (_, __) => ClipOval(
                        child: SizedBox(
                          width: iconSize,
                          height: iconSize,
                          child: SvgPicture.asset(
                            option.svgAsset,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                ),
              )
              .toList(growable: false),
      selectedValues:
          selectedValue != null
              ? <T>{selectedValue as T}
              : <T>{},
      onToggle: onChanged,
      showLabels: showLabels,
      itemVisualSize: iconSize + (spacingTokens?.xxs ?? 4.0) * 2,
      spacing: spacing,
      runSpacing: runSpacing,
      allowDeselect: false,
      alignment: alignment,
    );
  }
}
