import 'package:flutter/material.dart';

/// Bare Kinly-styled checkbox, for use when you manage the label layout.
///
/// Same color logic as [KinlyToggle], but without the ListTile wrapper.
class KinlyCheckbox extends StatelessWidget {
  const KinlyCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.isDarkOverride,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final bool? isDarkOverride;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final isDark = isDarkOverride ?? theme.brightness == Brightness.dark;

    final Color activeColor;
    final Color checkColor;

    if (isDark) {
      activeColor = colors.primaryContainer;
      checkColor = colors.onSurface;
    } else {
      activeColor = colors.primary;
      checkColor = colors.onPrimary;
    }

    return Checkbox(
      value: value,
      onChanged: (checked) => onChanged(checked ?? false),
      activeColor: activeColor,
      checkColor: checkColor,
      visualDensity: const VisualDensity(horizontal: -2, vertical: -3),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
