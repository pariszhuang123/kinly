import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Animated Kinly loader that uses the house logo and adapts to light/dark theme.
class KinlyLoader extends StatefulWidget {
  const KinlyLoader({
    super.key,
    this.size = 72,
    this.color,
    this.semanticLabel,
  });

  final double size;
  final Color? color;
  final String? semanticLabel;

  @override
  State<KinlyLoader> createState() => _KinlyLoaderState();
}

class _KinlyLoaderState extends State<KinlyLoader>
    with SingleTickerProviderStateMixin {
  static const _assetPath = 'assets/icons/logo/Kinly logo.svg';
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _scaleAnimation = Tween<double>(
      begin: 0.94,
      end: 1.06,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final resolvedColor =
        widget.color ??
        (theme.brightness == Brightness.dark
            ? colorScheme.onSurfaceVariant
            : colorScheme.primary);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: SvgPicture.asset(
        _assetPath,
        width: widget.size,
        height: widget.size,
        semanticsLabel: widget.semanticLabel,
        colorFilter: ColorFilter.mode(resolvedColor, BlendMode.srcIn),
      ),
    );
  }
}
