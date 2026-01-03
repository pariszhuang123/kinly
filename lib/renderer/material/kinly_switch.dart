import 'package:flutter/material.dart';

class KinlySwitch extends StatelessWidget {
  const KinlySwitch({
    super.key,
    required this.value,
    required this.onChanged,
  }) : _useAdaptive = false;

  final bool value;
  final ValueChanged<bool>? onChanged;

  factory KinlySwitch.adaptive({
    Key? key,
    required bool value,
    required ValueChanged<bool>? onChanged,
  }) {
    return KinlySwitch._adaptive(
      key: key,
      value: value,
      onChanged: onChanged,
    );
  }

  const KinlySwitch._adaptive({
    super.key,
    required this.value,
    required this.onChanged,
  }) : _useAdaptive = true;

  final bool _useAdaptive;

  @override
  Widget build(BuildContext context) {
    if (_useAdaptive) {
      return Switch.adaptive(value: value, onChanged: onChanged);
    }
    return Switch(value: value, onChanged: onChanged);
  }
}
