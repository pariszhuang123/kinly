import 'package:flutter/material.dart';

/// Elevation tokens for Kinly.
/// These can map to Material elevations or custom shadows.
@immutable
class Elevations extends ThemeExtension<Elevations> {
  const Elevations({
    required this.level0,
    required this.level1,
    required this.level2,
    required this.level3,
    required this.level4,
    required this.level5,
  });

  /// Flat surfaces (background, basic containers)
  final double level0;

  /// Subtle elevation (cards, list items)
  final double level1;

  /// Prominent cards (Today sections)
  final double level2;

  /// Floating elements (FAB, bottom sheets)
  final double level3;

  /// Highest elevation (dialogs, modals)
  final double level4;

  /// Hero / large modal surfaces
  final double level5;

  @override
  Elevations copyWith({
    double? level0,
    double? level1,
    double? level2,
    double? level3,
    double? level4,
    double? level5,
  }) {
    return Elevations(
      level0: level0 ?? this.level0,
      level1: level1 ?? this.level1,
      level2: level2 ?? this.level2,
      level3: level3 ?? this.level3,
      level4: level4 ?? this.level4,
      level5: level5 ?? this.level5,
    );
  }

  @override
  ThemeExtension<Elevations> lerp(ThemeExtension<Elevations>? other, double t) {
    if (other is! Elevations) return this;

    double lerpDouble(double a, double b) => a + (b - a) * t;

    return Elevations(
      level0: lerpDouble(level0, other.level0),
      level1: lerpDouble(level1, other.level1),
      level2: lerpDouble(level2, other.level2),
      level3: lerpDouble(level3, other.level3),
      level4: lerpDouble(level4, other.level4),
      level5: lerpDouble(level5, other.level5),
    );
  }
}

