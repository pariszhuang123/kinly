import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/motion.dart';

/// Provides access to reduce-motion preference + Kinly motion tokens.
class KinlyMotionAware extends InheritedWidget {
  const KinlyMotionAware({
    super.key,
    required this.reduceMotion,
    required this.motion,
    required super.child,
  });

  /// Whether OS reduce-motion is enabled.
  final bool reduceMotion;

  /// Motion tokens from the theme.
  final Motion motion;

  /// Wrap a subtree so descendants can read [KinlyMotionAware.of].
  static Widget builder({
    Key? key,
    required WidgetBuilder builder,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final motion =
        theme.extension<Motion>() ??
        const Motion(
          durationFast: Duration(milliseconds: 120),
          durationMedium: Duration(milliseconds: 200),
          durationSlow: Duration(milliseconds: 300),
          durationSnappy: Duration(milliseconds: 160),
          easeStandard: Curves.linear,
          easeAccelerate: Curves.linear,
          easeDecelerate: Curves.linear,
          easeEmotional: Curves.linear,
        );

    final media = MediaQuery.maybeOf(context);
    final reduceMotion =
        media?.disableAnimations ??
        PlatformDispatcher.instance.accessibilityFeatures.disableAnimations;

    return KinlyMotionAware(
      key: key,
      reduceMotion: reduceMotion,
      motion: motion,
      child: Builder(builder: builder),
    );
  }

  /// Convenience to fetch the nearest motion scope.
  static KinlyMotionAware of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<KinlyMotionAware>();
    if (scope != null) return scope;
    final motion = Theme.of(context).extension<Motion>();
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ??
        PlatformDispatcher.instance.accessibilityFeatures.disableAnimations;
    return KinlyMotionAware(
      reduceMotion: reduceMotion,
      motion:
          motion ??
          const Motion(
            durationFast: Duration(milliseconds: 120),
            durationMedium: Duration(milliseconds: 200),
            durationSlow: Duration(milliseconds: 300),
            durationSnappy: Duration(milliseconds: 160),
            easeStandard: Curves.linear,
            easeAccelerate: Curves.linear,
            easeDecelerate: Curves.linear,
            easeEmotional: Curves.linear,
          ),
      child: const SizedBox.shrink(),
    );
  }

  /// Use a shorter duration if reduced motion is requested.
  Duration effectiveDuration(
    Duration regular, {
    Duration reduced = Duration.zero,
  }) {
    return reduceMotion ? reduced : regular;
  }

  /// Whether animations should be avoided entirely.
  bool get shouldReduceMotion => reduceMotion;

  @override
  bool updateShouldNotify(KinlyMotionAware oldWidget) {
    return reduceMotion != oldWidget.reduceMotion || motion != oldWidget.motion;
  }
}
