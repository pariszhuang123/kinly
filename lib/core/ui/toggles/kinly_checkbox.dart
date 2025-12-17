import 'package:flutter/material.dart';

import '../../theme/control_tokens.dart';
import '../../theme/kinly_palette.dart';

/// Bare Kinly-styled checkbox, for use when you manage the label layout.
///
/// Same color logic as [KinlyToggle], but without the ListTile wrapper.
class KinlyCheckbox extends StatelessWidget {
  const KinlyCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controls =
        theme.extension<KinlyControlColors>() ??
        KinlyPalette.build(theme.brightness).controlColors;

    return Checkbox(
      value: value,
      onChanged: (checked) => onChanged(checked ?? false),
      activeColor: controls.checkboxChecked,
      checkColor: controls.selectableItemFgSelected,
      side: BorderSide(color: controls.checkboxBorder),
      visualDensity: const VisualDensity(horizontal: -2, vertical: -3),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
