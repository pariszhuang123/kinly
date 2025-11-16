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
  const tealPrimary = Color(0xFF366D59); // Teal
  const sageSecondary = Color(0xFF8BAA91); // Placeholder sage green
  const honeyAccent = Color(0xFFF6B73C); // Honey
  final offWhite = isDark ? const Color(0xFF101312) : const Color(0xFFFAFAF9);

  final colorScheme = ColorScheme(
    brightness: brightness,
    primary: tealPrimary,
    onPrimary: Colors.white,
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
    error: Colors.red.shade700,
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

  // Typography: Display = Average Sans, Body = Open Sans
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

  final elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      minimumSize: const Size.fromHeight(48),
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      textStyle: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
    ),
  );

  final snackBarTheme = SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    backgroundColor: colorScheme.inverseSurface,
    contentTextStyle: TextStyle(color: colorScheme.onInverseSurface),
  );

  final sections =
      isDark
          ? const KinlySections(
            flow: SectionColors(
              background: Color(0xFF1F2623),
              card: Color(0xFF27302B),
              icon: Color(0xFFB8D9C7),
              accent: Color(0xFFF5C96A),
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
          )
          : const KinlySections(
            flow: SectionColors(
              background: Color(0xFFE2F0E6), // sage
              card: Color(0xFFD6E8DD),
              icon: Color(0xFF366D59),
              accent: Color(0xFFF5C96A),
            ),
            share: SectionColors(
              background: Color(0xFFF9F4E8), // honey cream
              card: Colors.white,
              icon: Color(0xFFDAA24E),
              accent: Color(0xFF366D59),
            ),
            pulse: SectionColors(
              background: Color(0xFFFCEFEA),
              card: Color(0xFFFFF7F3),
              icon: Color(0xFFE48E73),
              accent: Color(0xFF366D59),
            ),
          );

  // Design tokens as ThemeExtensions
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
    maxContentWidth: 640, // used to keep content nicely sized on tablets
  );

  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    visualDensity: VisualDensity.standard,
    textTheme: textTheme,
    scaffoldBackgroundColor: colorScheme.surface,
    elevatedButtonTheme: elevatedButtonTheme,
    snackBarTheme: snackBarTheme,
    extensions: [spacing, corners, elevations, appSizes, sections],
  );
}
