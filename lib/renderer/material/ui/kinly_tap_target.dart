import 'package:flutter/material.dart';

class KinlyTapTarget extends StatelessWidget {
  const KinlyTapTarget({
    super.key,
    required this.child,
    this.onTap,
    this.minSize = 48,
    this.borderRadius,
    this.alignment = Alignment.center,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double minSize;
  final BorderRadius? borderRadius;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: minSize, minHeight: minSize),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius,
          child: Align(alignment: alignment, child: child),
        ),
      ),
    );
  }
}
