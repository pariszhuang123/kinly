import 'package:flutter/widgets.dart';

/// Central swipe shell for home-tab surfaces.
///
/// Keeps gesture wiring outside foundation surfaces so those files only
/// depend on Kinly/app-level wrappers.
class HomeTabSwipeRegion extends StatelessWidget {
  const HomeTabSwipeRegion({
    super.key,
    required this.child,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.minSwipeDistance = 80,
    this.minSwipeVelocity = 250,
  });

  final Widget child;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;
  final double minSwipeDistance;
  final double minSwipeVelocity;

  @override
  Widget build(BuildContext context) {
    return _HomeTabSwipeDetector(
      minSwipeDistance: minSwipeDistance,
      minSwipeVelocity: minSwipeVelocity,
      onSwipeLeft: onSwipeLeft,
      onSwipeRight: onSwipeRight,
      child: child,
    );
  }
}

class _HomeTabSwipeDetector extends StatefulWidget {
  const _HomeTabSwipeDetector({
    required this.child,
    required this.minSwipeDistance,
    required this.minSwipeVelocity,
    this.onSwipeLeft,
    this.onSwipeRight,
  });

  final Widget child;
  final double minSwipeDistance;
  final double minSwipeVelocity;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;

  @override
  State<_HomeTabSwipeDetector> createState() => _HomeTabSwipeDetectorState();
}

class _HomeTabSwipeDetectorState extends State<_HomeTabSwipeDetector> {
  double _dragDx = 0;

  void _handleDragStart(DragStartDetails details) {
    _dragDx = 0;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _dragDx += details.delta.dx;
  }

  void _handleDragEnd(DragEndDetails details) {
    final velocity = details.velocity.pixelsPerSecond.dx;
    final distance = _dragDx.abs();
    final isSwipe =
        distance >= widget.minSwipeDistance ||
        velocity.abs() >= widget.minSwipeVelocity;
    if (!isSwipe) return;

    if (_dragDx < 0 || velocity < 0) {
      widget.onSwipeLeft?.call();
    } else {
      widget.onSwipeRight?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragStart: _handleDragStart,
      onHorizontalDragUpdate: _handleDragUpdate,
      onHorizontalDragEnd: _handleDragEnd,
      child: widget.child,
    );
  }
}
