import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'color_tokens.dart';
import 'control_tokens.dart';
import 'foundation/kinly_foundation_colors.dart';
import 'kinly_control_palette.dart';
import 'kinly_sections.dart';
import 'opacity.dart';

/// Central palette + derived color engine for Kinly.
///
/// All derivations happen here. Widgets never branch on brightness and never
/// reference foundation colors directly.
class KinlyPalette {
  static KinlyColors build(Brightness brightness) {
    final derived = _DerivedEngine.fromBrightness(brightness);
    const opacities = KinlyOpacity.defaults;
    return KinlyColors(
      colorScheme: derived.scheme,
      colorTokens: _tokens(derived),
      controlColors: controls(brightness, derived.scheme, opacities),
      sections: derived.sections,
      linkColors: derived.linkColors,
      brandTextColors: derived.brandTextColors,
    );
  }

  static ColorScheme colorScheme(Brightness brightness) =>
      _DerivedEngine.fromBrightness(brightness).scheme;

  static KinlySections sections(Brightness brightness) =>
      _DerivedEngine.fromBrightness(brightness).sections;

  static KinlyLinkColors linkColors(
    Brightness brightness,
    ColorScheme scheme,
  ) => _DerivedEngine.fromBrightness(brightness).linkColors;

  static KinlyBrandTextColors brandTextColors() =>
      _DerivedEngine.fromBrightness(Brightness.light).brandTextColors;

  static KinlyColorTokens _tokens(_DerivedColors derived) {
    final scheme = derived.scheme;
    return KinlyColorTokens(
      primary: scheme.primary,
      onPrimary: scheme.onPrimary,
      primaryContainer: scheme.primaryContainer,
      onPrimaryContainer: scheme.onPrimaryContainer,
      secondary: scheme.secondary,
      onSecondary: scheme.onSecondary,
      secondaryContainer: scheme.secondaryContainer,
      onSecondaryContainer: scheme.onSecondaryContainer,
      error: scheme.error,
      onError: scheme.onError,
      surface: scheme.surface,
      surfaceVariant: scheme.surfaceContainer,
      onSurface: scheme.onSurface,
      outline: scheme.outline,
      success: derived.success,
      warning: derived.warning,
      info: derived.info,
      disabled: derived.disabled,
      inverseSurface: scheme.inverseSurface,
      onInverseSurface: scheme.onInverseSurface,
    );
  }

  static KinlyControlColors controls(
    Brightness brightness,
    ColorScheme colorScheme,
    KinlyOpacity opacities,
  ) {
    return buildControlColors(brightness, colorScheme, opacities);
  }
}

/// Bundle returned by [KinlyPalette.build] to set up the theme.
class KinlyColors {
  const KinlyColors({
    required this.colorScheme,
    required this.colorTokens,
    required this.controlColors,
    required this.sections,
    required this.linkColors,
    required this.brandTextColors,
  });

  final ColorScheme colorScheme;
  final KinlyColorTokens colorTokens;
  final KinlyControlColors controlColors;
  final KinlySections sections;
  final KinlyLinkColors linkColors;
  final KinlyBrandTextColors brandTextColors;
}

/// Link colors for inline actions and icons.
class KinlyLinkColors extends ThemeExtension<KinlyLinkColors> {
  final Color link;
  final Color icon;

  const KinlyLinkColors({required this.link, required this.icon});

  @override
  KinlyLinkColors copyWith({Color? link, Color? icon}) {
    return KinlyLinkColors(link: link ?? this.link, icon: icon ?? this.icon);
  }

  @override
  KinlyLinkColors lerp(ThemeExtension<KinlyLinkColors>? other, double t) {
    if (other is! KinlyLinkColors) return this;
    return KinlyLinkColors(
      link: Color.lerp(link, other.link, t) ?? link,
      icon: Color.lerp(icon, other.icon, t) ?? icon,
    );
  }
}

/// Brand text colors that don't fit standard tokens.
class KinlyBrandTextColors extends ThemeExtension<KinlyBrandTextColors> {
  final Color sageText;
  final Color honeyText;
  final Color tealBrand;

  const KinlyBrandTextColors({
    required this.sageText,
    required this.honeyText,
    required this.tealBrand,
  });

  @override
  KinlyBrandTextColors copyWith({
    Color? sageText,
    Color? honeyText,
    Color? tealBrand,
  }) {
    return KinlyBrandTextColors(
      sageText: sageText ?? this.sageText,
      honeyText: honeyText ?? this.honeyText,
      tealBrand: tealBrand ?? this.tealBrand,
    );
  }

  @override
  KinlyBrandTextColors lerp(
    ThemeExtension<KinlyBrandTextColors>? other,
    double t,
  ) {
    if (other is! KinlyBrandTextColors) return this;
    return KinlyBrandTextColors(
      sageText: Color.lerp(sageText, other.sageText, t) ?? sageText,
      honeyText: Color.lerp(honeyText, other.honeyText, t) ?? honeyText,
      tealBrand: Color.lerp(tealBrand, other.tealBrand, t) ?? tealBrand,
    );
  }
}

class _DerivedEngine {
  static const _white = Colors.white;
  static const _black = Colors.black;

  static _DerivedColors fromBrightness(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    const opacities = KinlyOpacity.defaults;

    final surfaceBase = _surfaceBase(brightness);
    Color lift(double amount) => _mix(surfaceBase, _white, amount);
    Color shade(double amount) => _mix(surfaceBase, _black, amount);

    final surfaces = _deriveSurfaces(
      isDark: isDark,
      lift: lift,
      shade: shade,
      surfaceBase: surfaceBase,
    );
    final brand = _deriveBrand(isDark: isDark, surfaceBase: surfaceBase);
    final error = _deriveError(isDark: isDark, surfaceBase: surfaceBase);
    final outline = _deriveOutline(isDark: isDark, surfaceBase: surfaceBase);
    final sections = _buildSections(
      isDark: isDark,
      surface: surfaces.surface,
      primary: brand.primary,
      secondary: brand.secondary,
      tertiary: brand.tertiary,
      accent: KinlyFoundationColors.brandAccent,
      outline: outline.outline,
      opacities: opacities,
    );
    final linkColors =
        isDark
            ? KinlyLinkColors(
              link: surfaces.onSurface,
              icon: surfaces.onSurface,
            )
            : KinlyLinkColors(link: brand.primary, icon: brand.primary);
    final brandTextColors = _deriveBrandText();
    final support = _deriveSupport(
      isDark: isDark,
      surfaceBase: surfaceBase,
      outline: outline.outline,
    );

    final scheme = ColorScheme(
      brightness: brightness,
      primary: brand.primary,
      onPrimary: brand.onPrimary,
      primaryContainer: brand.primaryContainer,
      onPrimaryContainer: brand.onPrimaryContainer,
      secondary: brand.secondary,
      onSecondary: brand.onSecondary,
      secondaryContainer: brand.secondaryContainer,
      onSecondaryContainer: brand.onSecondaryContainer,
      tertiary: brand.tertiary,
      onTertiary: brand.onTertiary,
      tertiaryContainer: brand.tertiaryContainer,
      onTertiaryContainer: brand.onTertiaryContainer,
      error: error.error,
      onError: error.onError,
      errorContainer: error.errorContainer,
      onErrorContainer: error.onErrorContainer,
      surface: surfaces.surface,
      onSurface: surfaces.onSurface,
      surfaceContainerHighest: surfaces.surfaceContainerHighest,
      surfaceContainerHigh: surfaces.surfaceContainerHigh,
      surfaceContainer: surfaces.surfaceContainer,
      surfaceContainerLow: surfaces.surfaceContainerLow,
      surfaceContainerLowest: surfaces.surfaceContainerLowest,
      surfaceDim: surfaces.surfaceDim,
      surfaceBright: surfaces.surfaceBright,
      outline: outline.outline,
      outlineVariant: outline.outlineVariant,
      shadow: (isDark ? _white : _black).withValues(
        alpha: opacities.alphaShadow,
      ),
      scrim: _black.withValues(alpha: opacities.alphaScrim),
      inverseSurface: surfaces.inverseSurface,
      onInverseSurface: surfaces.onInverseSurface,
      inversePrimary: brand.inversePrimary,
      surfaceTint: brand.primary,
    );

    return _DerivedColors(
      scheme: scheme,
      sections: sections,
      linkColors: linkColors,
      brandTextColors: brandTextColors,
      success: support.success,
      warning: support.warning,
      info: support.info,
      disabled: support.disabled,
    );
  }

  static KinlySections _buildSections({
    required bool isDark,
    required Color surface,
    required Color primary,
    required Color secondary,
    required Color tertiary,
    required Color accent,
    required Color outline,
    required KinlyOpacity opacities,
  }) {
    Color sectionBackground(Color accentColor) => _mix(
      surface,
      accentColor,
      isDark ? opacities.alphaMD : opacities.alphaXS,
    );
    Color sectionCard(Color accentColor) => _mix(
      surface,
      accentColor,
      isDark ? opacities.alphaXL : opacities.alphaSM,
    );
    SectionColors buildSection(Color accentColor) {
      final card = sectionCard(accentColor);
      return SectionColors(
        background: sectionBackground(accentColor),
        card: card,
        icon: _pickOnColor(
          background: card,
          preferred: accentColor,
          threshold: 3.0,
        ),
        accent: accentColor,
      );
    }

    final emptyAccent = _mix(outline, surface, 0.4);
    final preferenceAccent = _mix(primary, tertiary, isDark ? 0.24 : 0.32);
    final shoppingAccent = _mix(secondary, tertiary, isDark ? 0.36 : 0.44);

    return KinlySections(
      flow: buildSection(primary),
      share: buildSection(accent),
      pulse: buildSection(secondary),
      preference: buildSection(preferenceAccent),
      shopping: buildSection(shoppingAccent),
      empty: buildSection(emptyAccent),
    );
  }

  static Color _surfaceBase(Brightness brightness) {
    if (brightness == Brightness.dark) {
      // Keep dark mode brand-forward by tinting the base surface toward primary.
      return _mix(
        KinlyFoundationColors.surfaceDark,
        KinlyFoundationColors.brandPrimary,
        0.10,
      );
    }
    return KinlyFoundationColors.surfaceLight;
  }

  static _SurfaceSet _deriveSurfaces({
    required bool isDark,
    required Color Function(double) lift,
    required Color Function(double) shade,
    required Color surfaceBase,
  }) {
    final surfaceContainerLowest = isDark ? lift(0.03) : lift(0.02);
    final surfaceContainerLow = isDark ? lift(0.05) : lift(0.04);
    final surfaceContainer = isDark ? lift(0.06) : lift(0.06);
    final surfaceContainerHigh = isDark ? lift(0.13) : lift(0.08);
    final surfaceContainerHighest = isDark ? lift(0.18) : lift(0.12);
    final surfaceBright = isDark ? lift(0.16) : lift(0.10);
    final surfaceDim = isDark ? shade(0.04) : shade(0.08);
    final inverseSurface = isDark ? lift(0.92) : shade(0.82);
    final onSurface = _pickOnColor(
      background: surfaceBase,
      preferred: isDark ? _white : KinlyFoundationColors.ink,
    );
    final onInverseSurface = _pickOnColor(
      background: inverseSurface,
      preferred: KinlyFoundationColors.ink,
    );

    return _SurfaceSet(
      surface: surfaceBase,
      surfaceContainerLowest: surfaceContainerLowest,
      surfaceContainerLow: surfaceContainerLow,
      surfaceContainer: surfaceContainer,
      surfaceContainerHigh: surfaceContainerHigh,
      surfaceContainerHighest: surfaceContainerHighest,
      surfaceBright: surfaceBright,
      surfaceDim: surfaceDim,
      inverseSurface: inverseSurface,
      onSurface: onSurface,
      onInverseSurface: onInverseSurface,
    );
  }

  static _BrandSet _deriveBrand({
    required bool isDark,
    required Color surfaceBase,
  }) {
    final primary = _mix(
      KinlyFoundationColors.brandPrimary,
      isDark ? _white : _black,
      isDark ? 0.11 : 0.10,
    );
    final primaryContainer = _mix(
      primary,
      isDark ? surfaceBase : _white,
      isDark ? 0.28 : 0.18,
    );
    final onPrimary = _pickOnColor(background: primary, preferred: _white);
    final onPrimaryContainer = _pickOnColor(
      background: primaryContainer,
      preferred: KinlyFoundationColors.ink,
    );

    final secondary = _mix(
      KinlyFoundationColors.brandSecondary,
      isDark ? _white : _black,
      isDark ? 0.06 : 0.10,
    );
    final secondaryContainer = _mix(
      secondary,
      isDark ? surfaceBase : _white,
      isDark ? 0.26 : 0.18,
    );
    final onSecondary = _pickOnColor(background: secondary, preferred: _white);
    final onSecondaryContainer = _pickOnColor(
      background: secondaryContainer,
      preferred: KinlyFoundationColors.ink,
    );

    final tertiary = _mix(
      KinlyFoundationColors.brandAccent,
      isDark ? _white : _black,
      isDark ? 0.02 : 0.10,
    );
    final tertiaryContainer = _mix(
      tertiary,
      isDark ? surfaceBase : _white,
      isDark ? 0.24 : 0.16,
    );
    final onTertiary = _pickOnColor(background: tertiary, preferred: _white);
    final onTertiaryContainer = _pickOnColor(
      background: tertiaryContainer,
      preferred: KinlyFoundationColors.ink,
    );

    final inversePrimary = _mix(primary, _white, 0.55);

    return _BrandSet(
      primary: primary,
      primaryContainer: primaryContainer,
      onPrimary: onPrimary,
      onPrimaryContainer: onPrimaryContainer,
      secondary: secondary,
      secondaryContainer: secondaryContainer,
      onSecondary: onSecondary,
      onSecondaryContainer: onSecondaryContainer,
      tertiary: tertiary,
      tertiaryContainer: tertiaryContainer,
      onTertiary: onTertiary,
      onTertiaryContainer: onTertiaryContainer,
      inversePrimary: inversePrimary,
    );
  }

  static _ErrorSet _deriveError({
    required bool isDark,
    required Color surfaceBase,
  }) {
    final error = _mix(
      KinlyFoundationColors.error,
      isDark ? _white : _black,
      isDark ? 0.28 : 0.16,
    );
    final errorContainer = _mix(
      surfaceBase,
      KinlyFoundationColors.error,
      isDark ? 0.28 : 0.16,
    );
    final onError = _pickOnColor(background: error, preferred: _white);
    final onErrorContainer = _pickOnColor(
      background: errorContainer,
      preferred: KinlyFoundationColors.ink,
    );

    return _ErrorSet(
      error: error,
      errorContainer: errorContainer,
      onError: onError,
      onErrorContainer: onErrorContainer,
    );
  }

  static _OutlineSet _deriveOutline({
    required bool isDark,
    required Color surfaceBase,
  }) {
    final outline =
        isDark
            ? _mix(KinlyFoundationColors.outline, surfaceBase, 0.65)
            : KinlyFoundationColors.outline;
    final outlineVariant = _mix(outline, surfaceBase, 0.35);
    return _OutlineSet(outline: outline, outlineVariant: outlineVariant);
  }

  static KinlyBrandTextColors _deriveBrandText() {
    return KinlyBrandTextColors(
      sageText: _mix(KinlyFoundationColors.brandSecondary, _black, 0.4),
      honeyText: _mix(KinlyFoundationColors.brandAccent, _black, 0.55),
      tealBrand: _mix(KinlyFoundationColors.brandPrimary, _black, 0.4),
    );
  }

  static _SupportSet _deriveSupport({
    required bool isDark,
    required Color surfaceBase,
    required Color outline,
  }) {
    final success = _mix(
      KinlyFoundationColors.brandSecondary,
      _black,
      isDark ? 0.0 : 0.12,
    );
    final warning = _mix(
      KinlyFoundationColors.brandAccent,
      _black,
      isDark ? 0.0 : 0.12,
    );
    final info = _mix(
      KinlyFoundationColors.brandPrimary,
      _white,
      isDark ? 0.12 : 0.06,
    );
    final disabled = _mix(surfaceBase, outline, 0.5);
    return _SupportSet(
      success: success,
      warning: warning,
      info: info,
      disabled: disabled,
    );
  }
}

class _SurfaceSet {
  _SurfaceSet({
    required this.surface,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
    required this.surfaceBright,
    required this.surfaceDim,
    required this.inverseSurface,
    required this.onSurface,
    required this.onInverseSurface,
  });

  final Color surface;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
  final Color surfaceBright;
  final Color surfaceDim;
  final Color inverseSurface;
  final Color onSurface;
  final Color onInverseSurface;
}

class _BrandSet {
  _BrandSet({
    required this.primary,
    required this.primaryContainer,
    required this.onPrimary,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.secondaryContainer,
    required this.onSecondary,
    required this.onSecondaryContainer,
    required this.tertiary,
    required this.tertiaryContainer,
    required this.onTertiary,
    required this.onTertiaryContainer,
    required this.inversePrimary,
  });

  final Color primary;
  final Color primaryContainer;
  final Color onPrimary;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color secondaryContainer;
  final Color onSecondary;
  final Color onSecondaryContainer;
  final Color tertiary;
  final Color tertiaryContainer;
  final Color onTertiary;
  final Color onTertiaryContainer;
  final Color inversePrimary;
}

class _ErrorSet {
  _ErrorSet({
    required this.error,
    required this.errorContainer,
    required this.onError,
    required this.onErrorContainer,
  });

  final Color error;
  final Color errorContainer;
  final Color onError;
  final Color onErrorContainer;
}

class _OutlineSet {
  _OutlineSet({required this.outline, required this.outlineVariant});

  final Color outline;
  final Color outlineVariant;
}

class _SupportSet {
  _SupportSet({
    required this.success,
    required this.warning,
    required this.info,
    required this.disabled,
  });

  final Color success;
  final Color warning;
  final Color info;
  final Color disabled;
}

class _DerivedColors {
  _DerivedColors({
    required this.scheme,
    required this.sections,
    required this.linkColors,
    required this.brandTextColors,
    required this.success,
    required this.warning,
    required this.info,
    required this.disabled,
  });

  final ColorScheme scheme;
  final KinlySections sections;
  final KinlyLinkColors linkColors;
  final KinlyBrandTextColors brandTextColors;
  final Color success;
  final Color warning;
  final Color info;
  final Color disabled;
}

Color _mix(Color a, Color b, double t) => Color.lerp(a, b, t) ?? a;

double _contrastRatio(Color foreground, Color background) {
  final l1 = foreground.computeLuminance();
  final l2 = background.computeLuminance();
  final light = math.max(l1, l2);
  final dark = math.min(l1, l2);
  return (light + 0.05) / (dark + 0.05);
}

Color _pickOnColor({
  required Color background,
  required Color preferred,
  double threshold = 4.5,
}) {
  if (_contrastRatio(preferred, background) >= threshold) {
    return preferred;
  }
  final whiteContrast = _contrastRatio(Colors.white, background);
  final inkContrast = _contrastRatio(KinlyFoundationColors.ink, background);
  return whiteContrast >= inkContrast
      ? Colors.white
      : KinlyFoundationColors.ink;
}
