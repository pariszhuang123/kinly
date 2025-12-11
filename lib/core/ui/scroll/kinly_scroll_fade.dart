import 'package:flutter/material.dart';

/// Wraps any scrollable child with Kinly-standard top/bottom fade and
/// suppresses the default overscroll glow so headers/backgrounds stay stable.
class KinlyScrollFade extends StatelessWidget {
  const KinlyScrollFade({
    super.key,
    required this.child,
    this.fadeFraction = 0.04,
    this.fadeTop = true,
    this.fadeBottom = true,
    this.maskColor = Colors.white,
  }) : assert(
         fadeFraction > 0 && fadeFraction < 0.5,
         'fadeFraction should be between 0 and 0.5',
       );

  /// The scrollable widget to wrap (ListView, CustomScrollView, GridView, etc).
  final Widget child;

  /// Fraction of the height to use for the fade at the edges.
  final double fadeFraction;

  /// Whether to fade the top edge.
  final bool fadeTop;

  /// Whether to fade the bottom edge.
  final bool fadeBottom;

  /// Mask color used for the shader (usually white; respects light/dark).
  final Color maskColor;

  @override
  Widget build(BuildContext context) {
    // If no fade requested, just suppress overscroll glow without masking.
    if (!fadeTop && !fadeBottom) {
      return NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (notification) {
          notification.disallowIndicator();
          return false;
        },
        child: child,
      );
    }

    // Build gradient only for the enabled edges to avoid tinting the app bar.
    late final List<double> stops;
    late final List<Color> colors;

    if (!fadeTop && fadeBottom) {
      stops = <double>[0.0, 1 - fadeFraction, 1.0];
      colors = <Color>[maskColor, maskColor, maskColor.withValues(alpha: 0)];
    } else if (fadeTop && !fadeBottom) {
      stops = <double>[0.0, fadeFraction, 1.0];
      colors = <Color>[maskColor.withValues(alpha: 0), maskColor, maskColor];
    } else {
      stops = <double>[0.0, fadeFraction, 1 - fadeFraction, 1.0];
      colors = <Color>[
        maskColor.withValues(alpha: 0),
        maskColor,
        maskColor,
        maskColor.withValues(alpha: 0),
      ];
    }

    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        notification.disallowIndicator();
        return false;
      },
      child: ShaderMask(
        shaderCallback: (Rect rect) {
          return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: colors,
            stops: stops,
          ).createShader(rect);
        },
        blendMode: BlendMode.dstIn,
        child: child,
      ),
    );
  }
}
