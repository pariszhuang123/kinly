import 'package:flutter/material.dart';

import '../../theme/control_tokens.dart';

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
    final controls = Theme.of(context).extension<KinlyControlColors>();
    final scheme = Theme.of(context).colorScheme;

    return Checkbox(
      value: value,
      onChanged: (checked) => onChanged(checked ?? false),
      activeColor: controls?.checkboxChecked ?? scheme.primary,
      checkColor: controls?.checkboxBorder ?? scheme.onPrimary,
      visualDensity: const VisualDensity(horizontal: -2, vertical: -3),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
