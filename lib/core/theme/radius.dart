import 'package:flutter/material.dart';

/// Corner radius tokens for Kinly.
/// Keeps rounded shapes consistent across the app.
@immutable
class Corners extends ThemeExtension<Corners> {
  const Corners({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.pill,
  });

  /// Tiny elements (chips, tags)
  final double xs;

  /// Small controls (text fields, small buttons)
  final double sm;

  /// Cards, list items
  final double md;

  /// Large surfaces (bottom sheets, section containers)
  final double lg;

  /// Hero elements, modals
  final double xl;

  /// Full pill (e.g. badges, big pill buttons)
  final double pill;

  @override
  Corners copyWith({
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? pill,
  }) {
    return Corners(
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      pill: pill ?? this.pill,
    );
  }

  @override
  ThemeExtension<Corners> lerp(ThemeExtension<Corners>? other, double t) {
    if (other is! Corners) return this;

    double lerpDouble(double a, double b) => a + (b - a) * t;

    return Corners(
      xs: lerpDouble(xs, other.xs),
      sm: lerpDouble(sm, other.sm),
      md: lerpDouble(md, other.md),
      lg: lerpDouble(lg, other.lg),
      xl: lerpDouble(xl, other.xl),
      pill: lerpDouble(pill, other.pill),
    );
  }
}
