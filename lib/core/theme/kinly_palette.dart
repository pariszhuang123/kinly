import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'color_tokens.dart';
import 'control_tokens.dart';
import 'foundation/kinly_foundation_colors.dart';
import 'kinly_sections.dart';

/// Central palette + derived color engine for Kinly.
///
/// All derivations happen here. Widgets never branch on brightness and never
/// reference foundation colors directly.
class KinlyPalette {
  static KinlyColors build(Brightness brightness) {
    final derived = _DerivedEngine.fromBrightness(brightness);
    return KinlyColors(
      colorScheme: derived.scheme,
      colorTokens: _tokens(derived),
      controlColors: controls(brightness, derived.scheme),
      sections: derived.sections,
      linkColors: derived.linkColors,
      brandTextColors: derived.brandTextColors,
    );
  }

  static ColorScheme colorScheme(Brightness brightness) =>
      _DerivedEngine.fromBrightness(brightness).scheme;

  static KinlySections sections(Brightness brightness) =>
      _DerivedEngine.fromBrightness(brightness).sections;

  static KinlyLinkColors linkColors(Brightness brightness, ColorScheme scheme) =>
      _DerivedEngine.fromBrightness(brightness).linkColors;

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
  ) {
    final isDark = brightness == Brightness.dark;

    // Disabled baseline derived from surface/outline blend
    final disabledBase = _mix(colorScheme.surface, colorScheme.outline, 0.5);
    final disabledFg = _pickOnColor(
      background: disabledBase,
      preferred: colorScheme.onSurface,
    );

    // Filled: primary/onPrimary; disabled from disabled baseline
    final filledBg = colorScheme.primary;
    final filledFg = colorScheme.onPrimary;
    final filledDisabledBg = disabledBase;
    final filledDisabledFg = disabledFg;

    // Destructive: use error/onError in both modes
    final filledDestructiveBg = colorScheme.error;
    final filledDestructiveFg = colorScheme.onError;
    final filledDestructiveDisabledBg = disabledBase;
    final filledDestructiveDisabledFg = disabledFg;

    // Outlined: border from outline, fg from primary (contrast-safe)
    final outlinedFg = _pickOnColor(
      background: colorScheme.surface,
      preferred: colorScheme.primary,
    );
    final outlinedBorder =
        isDark ? colorScheme.outlineVariant : colorScheme.outline;
    final outlinedDisabledBorder = disabledBase;
    final outlinedDisabledFg = disabledFg;

    // Text / ghost
    final textFg = outlinedFg;
    final textDisabledFg = disabledFg;

    // FAB + add tile: mirror filled choices
    final fabBg = filledBg;
    final fabFg = filledFg;
    final addTileBg = filledBg;
    final addTileFg = filledFg;

    // Option row background/fg mirror surface containers
    final optionRowBg =
        isDark
            ? colorScheme.surfaceContainerHighest
            : colorScheme.surfaceContainer;
    final optionRowFg = colorScheme.onSurface;
    final optionRowSelectedBg = colorScheme.primaryContainer;
    final optionRowSelectedFg = colorScheme.onPrimaryContainer;
    final optionRowBorder = colorScheme.outlineVariant;

    // Checkbox / selection: checked uses primary container; unchecked surface + outline
    final checkboxChecked = colorScheme.primaryContainer;
    final checkboxUnchecked = colorScheme.surface;
    final checkboxBorder = colorScheme.outline;
    final selectionDisabledBg = disabledBase;
    final selectionDisabledBorder = disabledBase;
    final selectionDisabledFg = disabledFg;

    // Selectable item row: use surface containers and onSurface, with selected state
    final selectableItemBg = optionRowBg;
    final selectableItemBorder = checkboxBorder;
    final selectableItemFg = colorScheme.onSurface;
    final selectableItemBgSelected = colorScheme.primaryContainer;
    final selectableItemBorderSelected = colorScheme.primaryContainer;
    final selectableItemFgSelected = colorScheme.onPrimaryContainer;

    // Loader: use onSurface in dark, primary in light
    final loaderColor = isDark ? colorScheme.onSurface : colorScheme.primary;

    // Badges
    final badgeBg = colorScheme.primary.withValues(alpha: 0.14);
    final badgeFg = _pickOnColor(background: badgeBg, preferred: colorScheme.onPrimary);
    final errorBadgeBg = colorScheme.error.withValues(alpha: 0.18);
    final errorBadgeFg = _pickOnColor(
      background: errorBadgeBg,
      preferred: colorScheme.onError,
    );

    // Expand badge: use section accent alpha handled by caller; icon uses onSurface in dark
    final expandBadgeBg = colorScheme.primary.withValues(alpha: 0.12);
    final expandBadgeIcon =
        isDark ? colorScheme.onSurface : colorScheme.primary;

    // Comment box: surface containers
    final commentBoxBg =
        isDark ? colorScheme.surfaceContainerHigh : colorScheme.surface;
    final commentBoxBorder =
        isDark ? colorScheme.outlineVariant : colorScheme.outline;

    // Date/time pickers: mirror filled choices (inverse primary in dark)
    final pickerPrimary = isDark ? colorScheme.secondary : colorScheme.primary;
    final pickerOnPrimary =
        isDark ? colorScheme.onSecondary : colorScheme.onPrimary;

    // Avatar badge
    final avatarBadgeBg =
        isDark ? Colors.white : Colors.black; // per existing logic
    final avatarBadgeFg = isDark ? colorScheme.primary : colorScheme.onPrimary;

    return KinlyControlColors(
      filledBg: filledBg,
      filledFg: filledFg,
      filledDisabledBg: filledDisabledBg,
      filledDisabledFg: filledDisabledFg,
      filledDestructiveBg: filledDestructiveBg,
      filledDestructiveFg: filledDestructiveFg,
      filledDestructiveDisabledBg: filledDestructiveDisabledBg,
      filledDestructiveDisabledFg: filledDestructiveDisabledFg,
      outlinedBorder: outlinedBorder,
      outlinedFg: outlinedFg,
      outlinedDisabledBorder: outlinedDisabledBorder,
      outlinedDisabledFg: outlinedDisabledFg,
      textFg: textFg,
      textDisabledFg: textDisabledFg,
      fabBg: fabBg,
      fabFg: fabFg,
      addTileBg: addTileBg,
      addTileFg: addTileFg,
      checkboxChecked: checkboxChecked,
      checkboxUnchecked: checkboxUnchecked,
      checkboxBorder: checkboxBorder,
      selectionDisabledBg: selectionDisabledBg,
      selectionDisabledBorder: selectionDisabledBorder,
      selectionDisabledFg: selectionDisabledFg,
      optionRowBg: optionRowBg,
      optionRowFg: optionRowFg,
      optionRowSelectedBg: optionRowSelectedBg,
      optionRowSelectedFg: optionRowSelectedFg,
      optionRowBorder: optionRowBorder,
      selectableItemBg: selectableItemBg,
      selectableItemBorder: selectableItemBorder,
      selectableItemFg: selectableItemFg,
      selectableItemBgSelected: selectableItemBgSelected,
      selectableItemBorderSelected: selectableItemBorderSelected,
      selectableItemFgSelected: selectableItemFgSelected,
      loaderColor: loaderColor,
      badgeBg: badgeBg,
      badgeFg: badgeFg,
      errorBadgeBg: errorBadgeBg,
      errorBadgeFg: errorBadgeFg,
      expandBadgeBg: expandBadgeBg,
      expandBadgeIcon: expandBadgeIcon,
      commentBoxBg: commentBoxBg,
      commentBoxBorder: commentBoxBorder,
      pickerPrimary: pickerPrimary,
      pickerOnPrimary: pickerOnPrimary,
      avatarBadgeBg: avatarBadgeBg,
      avatarBadgeFg: avatarBadgeFg,
    );
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

    final surfaceBase =
        isDark ? KinlyFoundationColors.surfaceDark : KinlyFoundationColors.surfaceLight;
    Color lift(double amount) => _mix(surfaceBase, _white, amount);
    Color shade(double amount) => _mix(surfaceBase, _black, amount);

    // Surfaces
    final surface = surfaceBase;
    final surfaceContainerLowest = isDark ? lift(0.05) : lift(0.02);
    final surfaceContainerLow = isDark ? lift(0.08) : lift(0.04);
    final surfaceContainer = isDark ? lift(0.12) : lift(0.06);
    final surfaceContainerHigh = isDark ? lift(0.16) : lift(0.08);
    final surfaceContainerHighest = isDark ? lift(0.22) : lift(0.12);
    final surfaceBright = isDark ? lift(0.20) : lift(0.10);
    final surfaceDim = isDark ? shade(0.06) : shade(0.08);
    final inverseSurface = isDark ? lift(0.92) : shade(0.82);
    final onSurface = _pickOnColor(
      background: surface,
      preferred: isDark ? _white : KinlyFoundationColors.ink,
    );

    // Brand roles
    final primary =
        isDark ? _mix(KinlyFoundationColors.brandPrimary, _white, 0.08) : KinlyFoundationColors.brandPrimary;
    final primaryContainer =
        _mix(primary, isDark ? surfaceBase : _white, isDark ? 0.28 : 0.18);
    final onPrimary = _pickOnColor(background: primary, preferred: _white);
    final onPrimaryContainer = _pickOnColor(
      background: primaryContainer,
      preferred: KinlyFoundationColors.ink,
    );

    final secondary =
        isDark ? _mix(KinlyFoundationColors.brandSecondary, _white, 0.06) : KinlyFoundationColors.brandSecondary;
    final secondaryContainer =
        _mix(secondary, isDark ? surfaceBase : _white, isDark ? 0.26 : 0.18);
    final onSecondary = _pickOnColor(background: secondary, preferred: _white);
    final onSecondaryContainer = _pickOnColor(
      background: secondaryContainer,
      preferred: KinlyFoundationColors.ink,
    );

    final tertiary =
        isDark ? _mix(KinlyFoundationColors.brandAccent, _white, 0.02) : KinlyFoundationColors.brandAccent;
    final tertiaryContainer =
        _mix(tertiary, isDark ? surfaceBase : _white, isDark ? 0.24 : 0.16);
    final onTertiary = _pickOnColor(background: tertiary, preferred: _white);
    final onTertiaryContainer = _pickOnColor(
      background: tertiaryContainer,
      preferred: KinlyFoundationColors.ink,
    );

    // Error semantics
    final error = isDark ? _mix(KinlyFoundationColors.error, _white, 0.08) : KinlyFoundationColors.error;
    final errorContainer =
        _mix(surfaceBase, KinlyFoundationColors.error, isDark ? 0.28 : 0.16);
    final onError = _pickOnColor(background: error, preferred: _white);
    final onErrorContainer = _pickOnColor(
      background: errorContainer,
      preferred: KinlyFoundationColors.ink,
    );

    // Outline
    final outline = isDark
        ? _mix(KinlyFoundationColors.outline, surfaceBase, 0.65)
        : KinlyFoundationColors.outline;
    final outlineVariant = _mix(outline, surfaceBase, 0.35);

    final inversePrimary = _mix(primary, _white, 0.55);
    final onInverseSurface =
        _pickOnColor(background: inverseSurface, preferred: KinlyFoundationColors.ink);

    // Sections
    final sections = _buildSections(
      isDark: isDark,
      surface: surface,
      primary: primary,
      secondary: secondary,
      accent: KinlyFoundationColors.brandAccent,
      outline: outline,
    );

    // Link colors
    final linkColors = isDark
        ? KinlyLinkColors(link: onSurface, icon: onSurface)
        : KinlyLinkColors(link: primary, icon: primary);

    // Brand text
    final brandTextColors = KinlyBrandTextColors(
      sageText: _mix(KinlyFoundationColors.brandSecondary, _black, 0.4),
      honeyText: _mix(KinlyFoundationColors.brandAccent, _black, 0.55),
      tealBrand: KinlyFoundationColors.brandPrimary,
    );

    // Support tokens (derived)
    final success =
        _mix(KinlyFoundationColors.brandSecondary, _black, isDark ? 0.0 : 0.12);
    final warning =
        _mix(KinlyFoundationColors.brandAccent, _black, isDark ? 0.0 : 0.12);
    final info =
        _mix(KinlyFoundationColors.brandPrimary, _white, isDark ? 0.12 : 0.06);
    final disabled = _mix(surfaceBase, outline, 0.5);

    final scheme = ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: onSecondaryContainer,
      tertiary: tertiary,
      onTertiary: onTertiary,
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer,
      error: error,
      onError: onError,
      errorContainer: errorContainer,
      onErrorContainer: onErrorContainer,
      surface: surface,
      onSurface: onSurface,
      surfaceContainerHighest: surfaceContainerHighest,
      surfaceContainerHigh: surfaceContainerHigh,
      surfaceContainer: surfaceContainer,
      surfaceContainerLow: surfaceContainerLow,
      surfaceContainerLowest: surfaceContainerLowest,
      surfaceDim: surfaceDim,
      surfaceBright: surfaceBright,
      outline: outline,
      outlineVariant: outlineVariant,
      shadow: _black.withValues(alpha: 0.3),
      scrim: _black.withValues(alpha: 0.5),
      inverseSurface: inverseSurface,
      onInverseSurface: onInverseSurface,
      inversePrimary: inversePrimary,
      surfaceTint: primary,
    );

    return _DerivedColors(
      scheme: scheme,
      sections: sections,
      linkColors: linkColors,
      brandTextColors: brandTextColors,
      success: success,
      warning: warning,
      info: info,
      disabled: disabled,
    );
  }

  static KinlySections _buildSections({
    required bool isDark,
    required Color surface,
    required Color primary,
    required Color secondary,
    required Color accent,
    required Color outline,
  }) {
    Color sectionBackground(Color accentColor) =>
        _mix(surface, accentColor, isDark ? 0.18 : 0.08);
    Color sectionCard(Color accentColor) =>
        _mix(surface, accentColor, isDark ? 0.24 : 0.12);
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

    return KinlySections(
      flow: buildSection(primary),
      share: buildSection(accent),
      pulse: buildSection(secondary),
      empty: buildSection(emptyAccent),
    );
  }
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
  return whiteContrast >= inkContrast ? Colors.white : KinlyFoundationColors.ink;
}
