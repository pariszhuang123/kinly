import 'package:flutter/material.dart';

import 'color_tokens.dart';
import 'control_tokens.dart';
import 'kinly_sections.dart';

/// Central palette + builders for Kinly theme pieces.
///
/// All color values live here so contrast can be enforced in one place.
class KinlyPalette {
  // Brand/base colors
  static const Color tealBrand = Color(0xFF366D59);
  static const Color tealPrimary = Color(0xFF2F5B4B);
  static const Color tealPrimaryContainer = Color(0xFF5C8876);

  static const Color sageSecondary = Color(0xFF8BAA91);
  static const Color sageSecondaryContainer = Color(0xFFAEC6B4);

  static const Color honeyAccent = Color(0xFFF6B73C);
  static const Color honeyAccentContainer = Color(0xFFFFE1A8);

  static const Color sageText = Color(0xFF3B5646);
  static const Color honeyText = Color(0xFF704300);

  static const Color offWhiteLight = Color(0xFFFAFAF9);
  static const Color offWhiteDark = Color(0xFF101312);

  // Error ramp (const to allow token construction)
  static const Color errorDark = Color(0xFFFF5252); // redAccent.shade200
  static const Color error = Color(0xFFE53935); // slightly lighter for contrast
  static const Color errorContainer = Color(0xFFFFCDD2); // red.shade100
  static const Color onErrorContainer = Color(0xFFB71C1C); // red.shade900

  static ColorScheme colorScheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final offWhite = isDark ? offWhiteDark : offWhiteLight;

    return ColorScheme(
      brightness: brightness,
      primary: tealPrimary,
      onPrimary: Colors.white,
      primaryContainer: tealPrimaryContainer,
      onPrimaryContainer: Colors.black,
      secondary: sageSecondary,
      onSecondary: const Color(0xFF0F1A16),
      secondaryContainer: sageSecondaryContainer,
      onSecondaryContainer: const Color(0xFF0F1A16),
      tertiary: honeyAccent,
      onTertiary: const Color(0xFF1F1400),
      tertiaryContainer: honeyAccentContainer,
      onTertiaryContainer: const Color(0xFF1F1400),
      error: isDark ? errorDark : error,
      onError: Colors.black,
      errorContainer: errorContainer,
      onErrorContainer: onErrorContainer,
      surface: offWhite,
      onSurface: isDark ? Colors.white : const Color(0xFF101312),
      surfaceContainerHighest: isDark ? const Color(0xFF1B201E) : Colors.white,
      surfaceContainerHigh:
          isDark ? const Color(0xFF1D2220) : const Color(0xFFF2F2F1),
      surfaceContainer:
          isDark ? const Color(0xFF202624) : const Color(0xFFF5F5F4),
      surfaceContainerLow:
          isDark ? const Color(0xFF232927) : const Color(0xFFF7F7F6),
      surfaceContainerLowest:
          isDark ? const Color(0xFF151917) : const Color(0xFFFFFFFF),
      surfaceDim: isDark ? const Color(0xFF121614) : const Color(0xFFEEEEED),
      surfaceBright: isDark ? const Color(0xFF1A1F1D) : const Color(0xFFFFFFFF),
      outline: isDark ? const Color(0xFF3E4945) : const Color(0xFFB7C7C0),
      outlineVariant:
          isDark ? const Color(0xFF2E3733) : const Color(0xFFD9E3DE),
      shadow: Colors.black.withValues(alpha: 0.3),
      scrim: Colors.black.withValues(alpha: 0.5),
      inverseSurface:
          isDark ? const Color(0xFFE7ECEA) : const Color(0xFF1A1F1D),
      onInverseSurface:
          isDark ? const Color(0xFF121614) : const Color(0xFFE7ECEA),
      inversePrimary: const Color(0xFF88C7B0),
      surfaceTint: tealPrimary,
    );
  }

  static KinlySections sections(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return isDark
        ? const KinlySections(
          flow: SectionColors(
            background: Color(0xFF1F2623),
            card: Color(0xFF27302B),
            icon: Color(0xFFB8D9C7),
            accent: Color(0xFFB8D9C7),
          ),
          share: SectionColors(
            background: Color(0xFF262018),
            card: Color(0xFF30271B),
            icon: Color(0xFFF5C96A),
            accent: tealBrand,
          ),
          pulse: SectionColors(
            background: Color(0xFF2A2022),
            card: Color(0xFF33252A),
            icon: Color(0xFFF6B73C),
            accent: Color(0xFFF6B73C),
          ),
          empty: SectionColors(
            background: Color(0xFF2A2E2D),
            card: Color(0xFF1D2120),
            icon: Color(0xFFE4F2EA),
            accent: Color(0xFF88C7B0),
          ),
        )
        : const KinlySections(
          flow: SectionColors(
            background: Color(0xFFE2F0E6),
            card: Color(0xFFD6E8DD),
            icon: Color(0xFF26473A),
            accent: Color(0xFF26473A),
          ),
          share: SectionColors(
            background: Color(0xFFF9F4E8),
            card: Colors.white,
            icon: honeyText,
            accent: tealBrand,
          ),
          pulse: SectionColors(
            background: Color(0xFFFCEFEA),
            card: Color(0xFFFFF7F3),
            icon: honeyText,
            accent: Color(0xFFF6B73C),
          ),
          empty: SectionColors(
            background: Color(0xFFF4F6F5),
            card: Colors.white,
            icon: Color(0xFF32413B),
            accent: Color(0xFFAAC7BD),
          ),
        );
  }

  static KinlyLinkColors linkColors(Brightness brightness, ColorScheme scheme) {
    final isDark = brightness == Brightness.dark;
    return isDark
        ? KinlyLinkColors(link: scheme.onSurface, icon: scheme.onSurface)
        : KinlyLinkColors(link: tealPrimary, icon: tealPrimary);
  }

  static KinlyBrandTextColors brandTextColors() => const KinlyBrandTextColors(
    sageText: sageText,
    honeyText: honeyText,
    tealBrand: tealBrand,
  );

  static KinlyColorTokens tokens(ColorScheme colorScheme) {
    return KinlyColorTokens(
      primary: colorScheme.primary,
      onPrimary: colorScheme.onPrimary,
      primaryContainer: colorScheme.primaryContainer,
      onPrimaryContainer: colorScheme.onPrimaryContainer,
      secondary: colorScheme.secondary,
      onSecondary: colorScheme.onSecondary,
      secondaryContainer: colorScheme.secondaryContainer,
      onSecondaryContainer: colorScheme.onSecondaryContainer,
      error: colorScheme.error,
      onError: colorScheme.onError,
      surface: colorScheme.surface,
      surfaceVariant: colorScheme.surfaceContainer,
      onSurface: colorScheme.onSurface,
      outline: colorScheme.outline,
      success: const Color(0xFF2D8A5F),
      warning: const Color(0xFFF5C04A),
      info: const Color(0xFF89C8AC),
      disabled: const Color(0xFFD3D3D3),
      inverseSurface: colorScheme.inverseSurface,
      onInverseSurface: colorScheme.onInverseSurface,
    );
  }

  static KinlyControlColors controls(
    Brightness brightness,
    ColorScheme colorScheme,
  ) {
    final isDark = brightness == Brightness.dark;

    // Mirror current primitive choices:
    // Filled: light -> primary/onPrimary, dark -> primaryContainer/onSurface
    final filledBg =
        isDark ? colorScheme.primaryContainer : colorScheme.primary;
    final filledFg =
        isDark ? colorScheme.onSurface : colorScheme.onPrimary;

    // Destructive: use error/onError in both modes
    final filledDestructiveBg = colorScheme.error;
    final filledDestructiveFg = colorScheme.onError;

    // Outlined: light -> primary, dark -> onSurface/primaryContainer
    final outlinedFg =
        isDark ? colorScheme.onSurface : colorScheme.primary;
    final outlinedBorder =
        isDark ? colorScheme.primaryContainer : colorScheme.primary;

    // FAB + add tile: mirror filled choices
    final fabBg = filledBg;
    final fabFg = filledFg;
    final addTileBg = filledBg;
    final addTileFg = filledFg;

    // Option row background/fg mirror surface containers
    final optionRowBg = isDark
        ? colorScheme.surfaceContainerHighest
        : colorScheme.surfaceContainer;
    final optionRowFg = colorScheme.onSurface;

    // Checkbox: match existing onSurface/outline/primaryContainer usage
    final checkboxChecked = filledBg;
    final checkboxUnchecked = colorScheme.surface;
    final checkboxBorder =
        isDark ? colorScheme.outlineVariant : colorScheme.outline;

    // Selectable item row: use surface containers and onSurface, with selected state
    final selectableItemBg = optionRowBg;
    final selectableItemBorder = checkboxBorder;
    final selectableItemFg = colorScheme.onSurface;
    final selectableItemBgSelected = colorScheme.primaryContainer;
    final selectableItemBorderSelected = colorScheme.primaryContainer;
    final selectableItemFgSelected = colorScheme.onPrimaryContainer;

    // Loader: match KinlyLoader (uses onSurface/primary)
    final loaderColor =
        isDark ? colorScheme.onSurface : colorScheme.primary;

    // Expand badge: use section accent alpha handled by caller; icon uses onSurface in dark
    final expandBadgeBg = colorScheme.primary.withValues(alpha: 0.12);
    final expandBadgeIcon =
        isDark ? colorScheme.onSurface : colorScheme.primary;

    // Comment box: surface containers
    final commentBoxBg =
        isDark ? colorScheme.surfaceContainerHigh : colorScheme.surface;
    final commentBoxBorder =
        isDark ? colorScheme.outlineVariant : colorScheme.outline;

    // Settings tile badge: reuse error/onError with slight transparency handled by caller
    final settingsTileBadgeBg = colorScheme.error.withValues(alpha: 0.18);
    final settingsTileBadgeFg = colorScheme.onError;

    // Date/time pickers: mirror filled choices (inverse primary in dark)
    final pickerPrimary = isDark ? colorScheme.inversePrimary : colorScheme.primary;
    final pickerOnPrimary =
        isDark ? colorScheme.onInverseSurface : colorScheme.onPrimary;

    // Avatar badge
    final avatarBadgeBg =
        isDark ? Colors.white : Colors.black; // per existing logic
    final avatarBadgeFg = isDark ? colorScheme.primary : colorScheme.onPrimary;

    return KinlyControlColors(
      filledBg: filledBg,
      filledFg: filledFg,
      filledDestructiveBg: filledDestructiveBg,
      filledDestructiveFg: filledDestructiveFg,
      outlinedBorder: outlinedBorder,
      outlinedFg: outlinedFg,
      fabBg: fabBg,
      fabFg: fabFg,
      addTileBg: addTileBg,
      addTileFg: addTileFg,
      checkboxChecked: checkboxChecked,
      checkboxUnchecked: checkboxUnchecked,
      checkboxBorder: checkboxBorder,
      optionRowBg: optionRowBg,
      optionRowFg: optionRowFg,
      selectableItemBg: selectableItemBg,
      selectableItemBorder: selectableItemBorder,
      selectableItemFg: selectableItemFg,
      selectableItemBgSelected: selectableItemBgSelected,
      selectableItemBorderSelected: selectableItemBorderSelected,
      selectableItemFgSelected: selectableItemFgSelected,
      loaderColor: loaderColor,
      expandBadgeBg: expandBadgeBg,
      expandBadgeIcon: expandBadgeIcon,
      commentBoxBg: commentBoxBg,
      commentBoxBorder: commentBoxBorder,
      settingsTileBadgeBg: settingsTileBadgeBg,
      settingsTileBadgeFg: settingsTileBadgeFg,
      pickerPrimary: pickerPrimary,
      pickerOnPrimary: pickerOnPrimary,
      avatarBadgeBg: avatarBadgeBg,
      avatarBadgeFg: avatarBadgeFg,
    );
  }

  static KinlyColors build(Brightness brightness) {
    final scheme = colorScheme(brightness);
    return KinlyColors(
      colorScheme: scheme,
      colorTokens: tokens(scheme),
      controlColors: controls(brightness, scheme),
      sections: sections(brightness),
      linkColors: linkColors(brightness, scheme),
      brandTextColors: brandTextColors(),
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
