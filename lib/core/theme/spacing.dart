// lib/core/theme/spacing.dart
import 'package:flutter/material.dart';

@immutable
class Spacing extends ThemeExtension<Spacing> {
  const Spacing({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
  });

  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;

  @override
  Spacing copyWith({
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
  }) {
    return Spacing(
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
    );
  }

  @override
  ThemeExtension<Spacing> lerp(ThemeExtension<Spacing>? other, double t) {
    if (other is! Spacing) return this;

    double lerpDouble(double a, double b) => a + (b - a) * t;

    return Spacing(
      xs: lerpDouble(xs, other.xs),
      sm: lerpDouble(sm, other.sm),
      md: lerpDouble(md, other.md),
      lg: lerpDouble(lg, other.lg),
      xl: lerpDouble(xl, other.xl),
    );
  }
}
