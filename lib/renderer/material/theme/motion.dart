import 'dart:ui';

import 'package:flutter/material.dart';

/// Motion tokens (durations + easing) for Kinly.
@immutable
class Motion extends ThemeExtension<Motion> {
  const Motion({
    required this.durationFast,
    required this.durationMedium,
    required this.durationSlow,
    required this.durationSnappy,
    required this.easeStandard,
    required this.easeAccelerate,
    required this.easeDecelerate,
    required this.easeEmotional,
  });

  final Duration durationFast;
  final Duration durationMedium;
  final Duration durationSlow;
  final Duration durationSnappy;

  final Curve easeStandard;
  final Curve easeAccelerate;
  final Curve easeDecelerate;
  final Curve easeEmotional;

  @override
  Motion copyWith({
    Duration? durationFast,
    Duration? durationMedium,
    Duration? durationSlow,
    Duration? durationSnappy,
    Curve? easeStandard,
    Curve? easeAccelerate,
    Curve? easeDecelerate,
    Curve? easeEmotional,
  }) {
    return Motion(
      durationFast: durationFast ?? this.durationFast,
      durationMedium: durationMedium ?? this.durationMedium,
      durationSlow: durationSlow ?? this.durationSlow,
      durationSnappy: durationSnappy ?? this.durationSnappy,
      easeStandard: easeStandard ?? this.easeStandard,
      easeAccelerate: easeAccelerate ?? this.easeAccelerate,
      easeDecelerate: easeDecelerate ?? this.easeDecelerate,
      easeEmotional: easeEmotional ?? this.easeEmotional,
    );
  }

  @override
  ThemeExtension<Motion> lerp(ThemeExtension<Motion>? other, double t) {
    if (other is! Motion) return this;

    Curve lerpCurve(Curve a, Curve b) => t < 0.5 ? a : b;

    double lerpInt(int a, int b) => lerpDouble(a.toDouble(), b.toDouble(), t)!;

    return Motion(
      durationFast: Duration(
        milliseconds:
            lerpInt(
              durationFast.inMilliseconds,
              other.durationFast.inMilliseconds,
            ).round(),
      ),
      durationMedium: Duration(
        milliseconds:
            lerpInt(
              durationMedium.inMilliseconds,
              other.durationMedium.inMilliseconds,
            ).round(),
      ),
      durationSlow: Duration(
        milliseconds:
            lerpInt(
              durationSlow.inMilliseconds,
              other.durationSlow.inMilliseconds,
            ).round(),
      ),
      durationSnappy: Duration(
        milliseconds:
            lerpInt(
              durationSnappy.inMilliseconds,
              other.durationSnappy.inMilliseconds,
            ).round(),
      ),
      easeStandard: lerpCurve(easeStandard, other.easeStandard),
      easeAccelerate: lerpCurve(easeAccelerate, other.easeAccelerate),
      easeDecelerate: lerpCurve(easeDecelerate, other.easeDecelerate),
      easeEmotional: lerpCurve(easeEmotional, other.easeEmotional),
    );
  }
}
