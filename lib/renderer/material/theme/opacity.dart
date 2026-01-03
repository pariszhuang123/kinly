import 'package:flutter/material.dart';

/// Opacity tokens to avoid raw alpha literals sprinkled across UI.
@immutable
class KinlyOpacity extends ThemeExtension<KinlyOpacity> {
  const KinlyOpacity({
    required this.alphaXXS,
    required this.alphaXS,
    required this.alphaSM,
    required this.alphaMD,
    required this.alphaLG,
    required this.alphaXL,
    required this.alphaXXL,
    required this.alphaShadow,
    required this.alphaHalo,
    required this.alphaMuted,
    required this.alphaScrim,
    required this.alphaDim,
    required this.alphaFaint,
    required this.alphaFaintStrong,
    required this.alphaOpaque,
    required this.alphaOpaqueHigh,
  });

  /// 0.05 — hairline dividers/ink hints.
  final double alphaXXS;

  /// 0.08 — very light overlays/badges.
  final double alphaXS;

  /// 0.12 — light overlays/hover/subtle fills.
  final double alphaSM;

  /// 0.16 — light badge/background tints.
  final double alphaMD;

  /// 0.20 — soft cards/overlays.
  final double alphaLG;

  /// 0.24 — standard overlay/elevation.
  final double alphaXL;

  /// 0.28 — strong overlay/hero gradients.
  final double alphaXXL;

  /// 0.30 — shadow tint.
  final double alphaShadow;

  /// 0.35 — focus/halo glows.
  final double alphaHalo;

  /// 0.40 — muted/disabled tints.
  final double alphaMuted;

  /// 0.50 — scrims/backdrops.
  final double alphaScrim;

  /// 0.60 — dim layers.
  final double alphaDim;

  /// 0.70 — faded/disabled text/icons.
  final double alphaFaint;

  /// 0.72 — strong faded state (legacy cases).
  final double alphaFaintStrong;

  /// 0.90 — near-opaque surfaces.
  final double alphaOpaque;

  /// 0.92 — very near-opaque surfaces.
  final double alphaOpaqueHigh;

  static const defaults = KinlyOpacity(
    alphaXXS: 0.05,
    alphaXS: 0.08,
    alphaSM: 0.12,
    alphaMD: 0.16,
    alphaLG: 0.20,
    alphaXL: 0.24,
    alphaXXL: 0.28,
    alphaShadow: 0.30,
    alphaHalo: 0.35,
    alphaMuted: 0.40,
    alphaScrim: 0.50,
    alphaDim: 0.60,
    alphaFaint: 0.70,
    alphaFaintStrong: 0.72,
    alphaOpaque: 0.90,
    alphaOpaqueHigh: 0.92,
  );

  @override
  KinlyOpacity copyWith({
    double? alphaXXS,
    double? alphaXS,
    double? alphaSM,
    double? alphaMD,
    double? alphaLG,
    double? alphaXL,
    double? alphaXXL,
    double? alphaShadow,
    double? alphaHalo,
    double? alphaMuted,
    double? alphaScrim,
    double? alphaDim,
    double? alphaFaint,
    double? alphaFaintStrong,
    double? alphaOpaque,
    double? alphaOpaqueHigh,
  }) {
    return KinlyOpacity(
      alphaXXS: alphaXXS ?? this.alphaXXS,
      alphaXS: alphaXS ?? this.alphaXS,
      alphaSM: alphaSM ?? this.alphaSM,
      alphaMD: alphaMD ?? this.alphaMD,
      alphaLG: alphaLG ?? this.alphaLG,
      alphaXL: alphaXL ?? this.alphaXL,
      alphaXXL: alphaXXL ?? this.alphaXXL,
      alphaShadow: alphaShadow ?? this.alphaShadow,
      alphaHalo: alphaHalo ?? this.alphaHalo,
      alphaMuted: alphaMuted ?? this.alphaMuted,
      alphaScrim: alphaScrim ?? this.alphaScrim,
      alphaDim: alphaDim ?? this.alphaDim,
      alphaFaint: alphaFaint ?? this.alphaFaint,
      alphaFaintStrong: alphaFaintStrong ?? this.alphaFaintStrong,
      alphaOpaque: alphaOpaque ?? this.alphaOpaque,
      alphaOpaqueHigh: alphaOpaqueHigh ?? this.alphaOpaqueHigh,
    );
  }

  @override
  ThemeExtension<KinlyOpacity> lerp(
    ThemeExtension<KinlyOpacity>? other,
    double t,
  ) {
    if (other is! KinlyOpacity) return this;
    double lerpDouble(double a, double b) => a + (b - a) * t;
    return KinlyOpacity(
      alphaXXS: lerpDouble(alphaXXS, other.alphaXXS),
      alphaXS: lerpDouble(alphaXS, other.alphaXS),
      alphaSM: lerpDouble(alphaSM, other.alphaSM),
      alphaMD: lerpDouble(alphaMD, other.alphaMD),
      alphaLG: lerpDouble(alphaLG, other.alphaLG),
      alphaXL: lerpDouble(alphaXL, other.alphaXL),
      alphaXXL: lerpDouble(alphaXXL, other.alphaXXL),
      alphaShadow: lerpDouble(alphaShadow, other.alphaShadow),
      alphaHalo: lerpDouble(alphaHalo, other.alphaHalo),
      alphaMuted: lerpDouble(alphaMuted, other.alphaMuted),
      alphaScrim: lerpDouble(alphaScrim, other.alphaScrim),
      alphaDim: lerpDouble(alphaDim, other.alphaDim),
      alphaFaint: lerpDouble(alphaFaint, other.alphaFaint),
      alphaFaintStrong: lerpDouble(alphaFaintStrong, other.alphaFaintStrong),
      alphaOpaque: lerpDouble(alphaOpaque, other.alphaOpaque),
      alphaOpaqueHigh: lerpDouble(alphaOpaqueHigh, other.alphaOpaqueHigh),
    );
  }
}

