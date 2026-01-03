import 'package:flutter/material.dart';

class KinlyLinearProgressIndicator extends StatelessWidget {
  const KinlyLinearProgressIndicator({
    super.key,
    this.value,
    this.minHeight,
    this.backgroundColor,
    this.valueColor,
  });

  final double? value;
  final double? minHeight;
  final Color? backgroundColor;
  final Animation<Color?>? valueColor;

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: value,
      minHeight: minHeight,
      backgroundColor: backgroundColor,
      valueColor: valueColor,
    );
  }
}
