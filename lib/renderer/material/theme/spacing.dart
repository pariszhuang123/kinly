// lib/core/theme/spacing.dart
import 'package:flutter/material.dart';

/// Spacing tokens used across Kinly.
/// Contract-aligned names (xxs → xxxl) with backward-compatible aliases
/// (sm/md/lg) so existing widgets keep working while we migrate.
@immutable
class Spacing extends ThemeExtension<Spacing> {
  const Spacing({
    required this.xxs,
    required this.xs,
    required this.s,
    required this.m,
    required this.l,
    required this.xl,
    required this.xxl,
    required this.xxxl,
  });

  /// 2
  final double xxs;

  /// 4
  final double xs;

  /// 8
  final double s;

  /// 12
  final double m;

  /// 16
  final double l;

  /// 24
  final double xl;

  /// 32
  final double xxl;

  /// 40
  final double xxxl;

  // Backwards-compatible aliases (legacy names)
  double get sm => s;
  double get md => m;
  double get lg => l;

  @override
  Spacing copyWith({
    double? xxs,
    double? xs,
    double? s,
    double? m,
    double? l,
    double? xl,
    double? xxl,
    double? xxxl,
  }) {
    return Spacing(
      xxs: xxs ?? this.xxs,
      xs: xs ?? this.xs,
      s: s ?? this.s,
      m: m ?? this.m,
      l: l ?? this.l,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
      xxxl: xxxl ?? this.xxxl,
    );
  }

  @override
  ThemeExtension<Spacing> lerp(ThemeExtension<Spacing>? other, double t) {
    if (other is! Spacing) return this;

    double lerpDouble(double a, double b) => a + (b - a) * t;

    return Spacing(
      xxs: lerpDouble(xxs, other.xxs),
      xs: lerpDouble(xs, other.xs),
      s: lerpDouble(s, other.s),
      m: lerpDouble(m, other.m),
      l: lerpDouble(l, other.l),
      xl: lerpDouble(xl, other.xl),
      xxl: lerpDouble(xxl, other.xxl),
      xxxl: lerpDouble(xxxl, other.xxxl),
    );
  }
}

