import 'package:flutter/widgets.dart';

/// Builds a safe anchor rect for iOS share popovers.
Rect sharePositionOriginForContext(BuildContext context) {
  final renderObject = context.findRenderObject();
  if (renderObject is RenderBox && renderObject.hasSize) {
    final size = renderObject.size;
    if (size.width > 0 && size.height > 0) {
      final origin = renderObject.localToGlobal(Offset.zero);
      return Rect.fromLTWH(origin.dx, origin.dy, size.width, size.height);
    }
  }

  final mediaQuery = MediaQuery.maybeOf(context);
  if (mediaQuery != null) {
    final size = mediaQuery.size;
    if (size.width > 0 && size.height > 0) {
      return Rect.fromLTWH(size.width / 2, size.height / 2, 1, 1);
    }
  }

  return const Rect.fromLTWH(0, 0, 1, 1);
}
