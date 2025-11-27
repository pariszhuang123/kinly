// lib/core/theme/kinly_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'kinly_sections.dart';
import 'spacing.dart';
import 'radius.dart';
import 'elevation.dart';
import 'app_sizes.dart';

ThemeData buildKinlyTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;

  // Brand palette
  const tealBrand = Color(0xFF366D59);
  const tealPrimary = Color(0xFF2F5B4B);
  const sageSecondary = Color(0xFF8BAA91);
  const honeyAccent = Color(0xFFF6B73C);

  const sageText = Color(0xFF3B5646);
  const honeyText = Color(0xFF704300);

  final offWhite = isDark ? const Color(0xFF101312) : const Color(0xFFFAFAF9);

  final colorScheme = ColorScheme(
    brightness: brightness,
    primary: tealPrimary,
    onPrimary: isDark ? Colors.black : Colors.white,
    primaryContainer: const Color(0xFF5C8876),
    onPrimaryContainer: Colors.white,
    secondary: sageSecondary,
    onSecondary: const Color(0xFF0F1A16),
    secondaryContainer: const Color(0xFFAEC6B4),
    onSecondaryContainer: const Color(0xFF0F1A16),
    tertiary: honeyAccent,
    onTertiary: const Color(0xFF1F1400),
    tertiaryContainer: const Color(0xFFFFE1A8),
    onTertiaryContainer: const Color(0xFF1F1400),
    error: isDark ? Colors.redAccent.shade200 : Colors.red.shade700,
    onError: Colors.white,
    errorContainer: Colors.red.shade100,
    onErrorContainer: Colors.red.shade900,
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
    outlineVariant: isDark ? const Color(0xFF2E3733) : const Color(0xFFD9E3DE),
    shadow: Colors.black.withValues(alpha: 0.3),
    scrim: Colors.black.withValues(alpha: 0.5),
    inverseSurface: isDark ? const Color(0xFFE7ECEA) : const Color(0xFF1A1F1D),
    onInverseSurface:
        isDark ? const Color(0xFF121614) : const Color(0xFFE7ECEA),
    inversePrimary: const Color(0xFF88C7B0),
    surfaceTint: tealPrimary,
  );

  // Typography
  final baseText =
      isDark ? Typography.whiteMountainView : Typography.blackMountainView;
  final display = GoogleFonts.dmSansTextTheme(baseText);
  final body = GoogleFonts.interTextTheme(baseText);
  final textTheme = body.copyWith(
    headlineLarge: display.headlineLarge,
    headlineMedium: display.headlineMedium,
    headlineSmall: display.headlineSmall,
    titleLarge: display.titleLarge,
  );

  // Buttons
  final elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      minimumSize: const Size.fromHeight(48),
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      textStyle: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
    ),
  );

  final filledButtonTheme = FilledButtonThemeData(
    style: FilledButton.styleFrom(
      minimumSize: const Size.fromHeight(44),
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      textStyle: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
    ),
  );

  final outlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      minimumSize: const Size.fromHeight(40),
      foregroundColor: isDark ? colorScheme.onSurface : colorScheme.primary,
      side: BorderSide(
        color: isDark ? colorScheme.outline : colorScheme.primary,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      textStyle: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
    ),
  );

  final snackBarTheme = SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    backgroundColor: colorScheme.inverseSurface,
    contentTextStyle: TextStyle(color: colorScheme.onInverseSurface),
  );

  // Section palettes
  final sections =
      isDark
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
              accent: Color(0xFF88C7B0),
            ),
            pulse: SectionColors(
              background: Color(0xFF2A2022),
              card: Color(0xFF33252A),
              icon: Color(0xFFFFB5A0),
              accent: Color(0xFF88C7B0),
            ),
            hub: SectionColors(
              background: Color(0xFF26201A),
              card: Color(0xFF31261C),
              icon: Color(0xFFF5C96A),
              accent: Color(0xFF88C7B0),
            ),
            empty: SectionColors(
              background: Color(0xFF2A2E2D),
              card: Color(0xFF1D2120),
              icon: Color(0xFFB8D9C7),
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
              icon: Color(0xFF704300),
              accent: tealBrand,
            ),
            pulse: SectionColors(
              background: Color(0xFFFCEFEA),
              card: Color(0xFFFFF7F3),
              icon: Color(0xFF7F2B0E),
              accent: tealBrand,
            ),
            hub: SectionColors(
              background: Color(0xFFFDF6EB),
              card: Color(0xFFFFF9F1),
              icon: Color(0xFFF6B73C),
              accent: Color(0xFF2F5B4B),
            ),
            empty: SectionColors(
              background: Color(0xFFF4F6F5),
              card: Color.fromARGB(255, 255, 255, 255),
              icon: Color(0xFF6C7A75),
              accent: Color(0xFFAAC7BD),
            ),
          );

  // NEW — Dynamic link colors
  final linkColors =
      isDark
          ? KinlyLinkColors(
            link: colorScheme.onSurface,
            icon: colorScheme.onSurface, // high contrast icons
          )
          : KinlyLinkColors(link: tealPrimary, icon: tealPrimary);

  // Design tokens
  const spacing = Spacing(xs: 4, sm: 8, md: 12, lg: 16, xl: 24);
  const corners = Corners(xs: 4, sm: 8, md: 12, lg: 20, xl: 28, pill: 999);
  const elevations = Elevations(
    level0: 0,
    level1: 1,
    level2: 3,
    level3: 6,
    level4: 8,
  );
  const appSizes = AppSizes(
    iconSm: 16,
    iconMd: 24,
    iconLg: 40,
    toolbarHeight: 56,
    bottomNavHeight: 64,
    fabDimension: 56,
    maxContentWidth: 640,
  );

  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    visualDensity: VisualDensity.standard,
    textTheme: textTheme,
    scaffoldBackgroundColor: colorScheme.surface,
    elevatedButtonTheme: elevatedButtonTheme,
    filledButtonTheme: filledButtonTheme,
    outlinedButtonTheme: outlinedButtonTheme,
    snackBarTheme: snackBarTheme,
    extensions: [
      spacing,
      corners,
      elevations,
      appSizes,
      sections,
      linkColors, // <-- ADDED
      const _KinlyBrandTextColors(
        sageText: sageText,
        honeyText: honeyText,
        tealBrand: tealBrand,
      ),
    ],
  );
}

class _KinlyBrandTextColors extends ThemeExtension<_KinlyBrandTextColors> {
  final Color sageText;
  final Color honeyText;
  final Color tealBrand;

  const _KinlyBrandTextColors({
    required this.sageText,
    required this.honeyText,
    required this.tealBrand,
  });

  @override
  _KinlyBrandTextColors copyWith({
    Color? sageText,
    Color? honeyText,
    Color? tealBrand,
  }) {
    return _KinlyBrandTextColors(
      sageText: sageText ?? this.sageText,
      honeyText: honeyText ?? this.honeyText,
      tealBrand: tealBrand ?? this.tealBrand,
    );
  }

  @override
  _KinlyBrandTextColors lerp(
    ThemeExtension<_KinlyBrandTextColors>? other,
    double t,
  ) {
    if (other is! _KinlyBrandTextColors) return this;
    return _KinlyBrandTextColors(
      sageText: Color.lerp(sageText, other.sageText, t) ?? sageText,
      honeyText: Color.lerp(honeyText, other.honeyText, t) ?? honeyText,
      tealBrand: Color.lerp(tealBrand, other.tealBrand, t) ?? tealBrand,
    );
  }
}

// --- NEW EXTENSION FOR LINK COLORS ---
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
