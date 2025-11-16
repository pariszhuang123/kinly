import 'package:flutter/material.dart';

/// Global size tokens for Kinly.
/// Things like icon sizes, toolbar heights, nav heights.
@immutable
class AppSizes extends ThemeExtension<AppSizes> {
  const AppSizes({
    required this.iconSm,
    required this.iconMd,
    required this.iconLg,
    required this.toolbarHeight,
    required this.bottomNavHeight,
    required this.fabDimension,
    required this.maxContentWidth,
  });

  /// Small icons (chips, inline)
  final double iconSm;

  /// Regular icons
  final double iconMd;

  /// Large icons (hero / empty states)
  final double iconLg;

  /// App bar / header height
  final double toolbarHeight;

  /// Bottom navigation bar height
  final double bottomNavHeight;

  /// FAB width/height
  final double fabDimension;

  /// Max width for main content on large screens (e.g. iPad)
  final double maxContentWidth;

  @override
  AppSizes copyWith({
    double? iconSm,
    double? iconMd,
    double? iconLg,
    double? toolbarHeight,
    double? bottomNavHeight,
    double? fabDimension,
    double? maxContentWidth,
  }) {
    return AppSizes(
      iconSm: iconSm ?? this.iconSm,
      iconMd: iconMd ?? this.iconMd,
      iconLg: iconLg ?? this.iconLg,
      toolbarHeight: toolbarHeight ?? this.toolbarHeight,
      bottomNavHeight: bottomNavHeight ?? this.bottomNavHeight,
      fabDimension: fabDimension ?? this.fabDimension,
      maxContentWidth: maxContentWidth ?? this.maxContentWidth,
    );
  }

  @override
  ThemeExtension<AppSizes> lerp(ThemeExtension<AppSizes>? other, double t) {
    if (other is! AppSizes) return this;

    double lerpDouble(double a, double b) => a + (b - a) * t;

    return AppSizes(
      iconSm: lerpDouble(iconSm, other.iconSm),
      iconMd: lerpDouble(iconMd, other.iconMd),
      iconLg: lerpDouble(iconLg, other.iconLg),
      toolbarHeight: lerpDouble(toolbarHeight, other.toolbarHeight),
      bottomNavHeight: lerpDouble(bottomNavHeight, other.bottomNavHeight),
      fabDimension: lerpDouble(fabDimension, other.fabDimension),
      maxContentWidth: lerpDouble(maxContentWidth, other.maxContentWidth),
    );
  }
}
