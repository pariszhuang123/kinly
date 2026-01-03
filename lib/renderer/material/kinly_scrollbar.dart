import 'package:flutter/material.dart';

class KinlyScrollbar extends StatelessWidget {
  const KinlyScrollbar({
    super.key,
    required this.child,
    this.thumbVisibility,
    this.controller,
  });

  final Widget child;
  final bool? thumbVisibility;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thumbVisibility: thumbVisibility,
      controller: controller,
      child: child,
    );
  }
}
