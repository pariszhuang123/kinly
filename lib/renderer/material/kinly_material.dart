import 'package:flutter/material.dart';

class KinlyMaterial extends StatelessWidget {
  const KinlyMaterial({
    super.key,
    this.type = MaterialType.canvas,
    this.elevation = 0,
    this.color,
    this.shadowColor,
    this.surfaceTintColor,
    this.shape,
    this.borderRadius,
    this.clipBehavior = Clip.none,
    this.child,
  });

  final MaterialType type;
  final double elevation;
  final Color? color;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final ShapeBorder? shape;
  final BorderRadiusGeometry? borderRadius;
  final Clip clipBehavior;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: type,
      elevation: elevation,
      color: color,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      shape: shape,
      borderRadius: borderRadius,
      clipBehavior: clipBehavior,
      child: child,
    );
  }
}
