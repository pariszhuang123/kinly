// lib/core/theme/kinly_theme.dart
import 'package:flutter/material.dart';

import 'app_sizes.dart';
import 'elevation.dart';
import 'kinly_palette.dart';
import 'motion.dart';
import 'radius.dart';
import 'spacing.dart';
import 'typography_tokens.dart';
export 'kinly_palette.dart'
    show KinlyPalette, KinlyColors, KinlyLinkColors, KinlyBrandTextColors;

ThemeData buildKinlyTheme(Brightness brightness) {
  final palette = KinlyPalette.build(brightness);
  final colorScheme = palette.colorScheme;

  // Typography tokens (DM Sans + Inter to preserve Kinly feel)
  final typographyTokens = KinlyTypography.fromBrightness(brightness);
  final textTheme = TextTheme(
    displayLarge: typographyTokens.displayLarge,
    displayMedium: typographyTokens.displayMedium,
    headlineLarge: typographyTokens.headlineLarge,
    headlineMedium: typographyTokens.headlineMedium,
    titleLarge: typographyTokens.titleLarge,
    titleMedium: typographyTokens.titleMedium,
    titleSmall: typographyTokens.titleSmall,
    bodyLarge: typographyTokens.bodyLarge,
    bodyMedium: typographyTokens.bodyMedium,
    bodySmall: typographyTokens.bodySmall,
    labelLarge: typographyTokens.labelMedium,
    labelMedium: typographyTokens.labelMedium,
    labelSmall: typographyTokens.labelSmall,
  );

  // Buttons
  final elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      minimumSize: const Size.fromHeight(48),
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: typographyTokens.labelMedium,
    ),
  );

  final filledButtonTheme = FilledButtonThemeData(
    style: FilledButton.styleFrom(
      minimumSize: const Size.fromHeight(48),
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: typographyTokens.labelMedium,
    ),
  );

  final outlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      minimumSize: const Size.fromHeight(44),
      foregroundColor:
          brightness == Brightness.dark ? colorScheme.onSurface : colorScheme.primary,
      side: BorderSide(
        color: brightness == Brightness.dark
            ? colorScheme.outline
            : colorScheme.primary,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: typographyTokens.labelMedium,
    ),
  );

  final snackBarTheme = SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    backgroundColor: colorScheme.inverseSurface,
    contentTextStyle: TextStyle(color: colorScheme.onInverseSurface),
  );

  // Design tokens
  const spacing = Spacing(
    xxs: 2,
    xs: 4,
    s: 8,
    m: 12,
    l: 16,
    xl: 24,
    xxl: 32,
    xxxl: 40,
  );
  const corners = Corners(xs: 4, sm: 8, md: 12, lg: 16, xl: 24, pill: 999);
  const elevations = Elevations(
    level0: 0,
    level1: 1,
    level2: 3,
    level3: 6,
    level4: 10,
    level5: 16,
  );
  final motion = Motion(
    durationFast: const Duration(milliseconds: 120),
    durationMedium: const Duration(milliseconds: 200),
    durationSlow: const Duration(milliseconds: 300),
    durationSnappy: const Duration(milliseconds: 160),
    easeStandard: const Cubic(0.4, 0.0, 0.2, 1),
    easeAccelerate: const Cubic(0.4, 0.0, 1, 1),
    easeDecelerate: const Cubic(0.0, 0.0, 0.2, 1),
    easeEmotional: const Cubic(0.25, 1, 0.5, 1),
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
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    scaffoldBackgroundColor: colorScheme.surface,
    elevatedButtonTheme: elevatedButtonTheme,
    filledButtonTheme: filledButtonTheme,
    outlinedButtonTheme: outlinedButtonTheme,
    snackBarTheme: snackBarTheme,
    extensions: [
      spacing,
      corners,
      elevations,
      motion,
      palette.colorTokens,
      palette.controlColors,
      typographyTokens,
      appSizes,
      palette.sections,
      palette.linkColors,
      palette.brandTextColors,
    ],
  );
}
