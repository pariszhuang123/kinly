import 'package:flutter/material.dart';

/// Design color tokens used across Kinly.
@immutable
class KinlyColorTokens extends ThemeExtension<KinlyColorTokens> {
  const KinlyColorTokens({
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.error,
    required this.onError,
    required this.surface,
    required this.surfaceDark,
    required this.surfaceVariant,
    required this.surfaceVariantDark,
    required this.onSurface,
    required this.onSurfaceDark,
    required this.outline,
    required this.outlineDark,
    required this.success,
    required this.warning,
    required this.info,
    required this.disabled,
    required this.inverseSurface,
    required this.onInverseSurface,
  });

  final Color primary;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;
  final Color error;
  final Color onError;
  final Color surface;
  final Color surfaceDark;
  final Color surfaceVariant;
  final Color surfaceVariantDark;
  final Color onSurface;
  final Color onSurfaceDark;
  final Color outline;
  final Color outlineDark;
  final Color success;
  final Color warning;
  final Color info;
  final Color disabled;
  final Color inverseSurface;
  final Color onInverseSurface;

  @override
  KinlyColorTokens copyWith({
    Color? primary,
    Color? onPrimary,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    Color? secondary,
    Color? onSecondary,
    Color? secondaryContainer,
    Color? onSecondaryContainer,
    Color? error,
    Color? onError,
    Color? surface,
    Color? surfaceDark,
    Color? surfaceVariant,
    Color? surfaceVariantDark,
    Color? onSurface,
    Color? onSurfaceDark,
    Color? outline,
    Color? outlineDark,
    Color? success,
    Color? warning,
    Color? info,
    Color? disabled,
    Color? inverseSurface,
    Color? onInverseSurface,
  }) {
    return KinlyColorTokens(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      onPrimaryContainer: onPrimaryContainer ?? this.onPrimaryContainer,
      secondary: secondary ?? this.secondary,
      onSecondary: onSecondary ?? this.onSecondary,
      secondaryContainer: secondaryContainer ?? this.secondaryContainer,
      onSecondaryContainer: onSecondaryContainer ?? this.onSecondaryContainer,
      error: error ?? this.error,
      onError: onError ?? this.onError,
      surface: surface ?? this.surface,
      surfaceDark: surfaceDark ?? this.surfaceDark,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      surfaceVariantDark: surfaceVariantDark ?? this.surfaceVariantDark,
      onSurface: onSurface ?? this.onSurface,
      onSurfaceDark: onSurfaceDark ?? this.onSurfaceDark,
      outline: outline ?? this.outline,
      outlineDark: outlineDark ?? this.outlineDark,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      disabled: disabled ?? this.disabled,
      inverseSurface: inverseSurface ?? this.inverseSurface,
      onInverseSurface: onInverseSurface ?? this.onInverseSurface,
    );
  }

  @override
  KinlyColorTokens lerp(ThemeExtension<KinlyColorTokens>? other, double t) {
    if (other is! KinlyColorTokens) return this;

    Color lerpColor(Color a, Color b) => Color.lerp(a, b, t) ?? a;

    return KinlyColorTokens(
      primary: lerpColor(primary, other.primary),
      onPrimary: lerpColor(onPrimary, other.onPrimary),
      primaryContainer: lerpColor(primaryContainer, other.primaryContainer),
      onPrimaryContainer:
          lerpColor(onPrimaryContainer, other.onPrimaryContainer),
      secondary: lerpColor(secondary, other.secondary),
      onSecondary: lerpColor(onSecondary, other.onSecondary),
      secondaryContainer:
          lerpColor(secondaryContainer, other.secondaryContainer),
      onSecondaryContainer:
          lerpColor(onSecondaryContainer, other.onSecondaryContainer),
      error: lerpColor(error, other.error),
      onError: lerpColor(onError, other.onError),
      surface: lerpColor(surface, other.surface),
      surfaceDark: lerpColor(surfaceDark, other.surfaceDark),
      surfaceVariant: lerpColor(surfaceVariant, other.surfaceVariant),
      surfaceVariantDark:
          lerpColor(surfaceVariantDark, other.surfaceVariantDark),
      onSurface: lerpColor(onSurface, other.onSurface),
      onSurfaceDark: lerpColor(onSurfaceDark, other.onSurfaceDark),
      outline: lerpColor(outline, other.outline),
      outlineDark: lerpColor(outlineDark, other.outlineDark),
      success: lerpColor(success, other.success),
      warning: lerpColor(warning, other.warning),
      info: lerpColor(info, other.info),
      disabled: lerpColor(disabled, other.disabled),
      inverseSurface: lerpColor(inverseSurface, other.inverseSurface),
      onInverseSurface: lerpColor(onInverseSurface, other.onInverseSurface),
    );
  }
}
