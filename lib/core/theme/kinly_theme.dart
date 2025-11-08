import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

@immutable
class Spacing extends ThemeExtension<Spacing> {
  const Spacing({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
  });

  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;

  @override
  Spacing copyWith({
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
  }) {
    return Spacing(
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
    );
  }

  @override
  ThemeExtension<Spacing> lerp(ThemeExtension<Spacing>? other, double t) {
    if (other is! Spacing) return this;
    return Spacing(
      xs: lerpDouble(xs, other.xs, t),
      sm: lerpDouble(sm, other.sm, t),
      md: lerpDouble(md, other.md, t),
      lg: lerpDouble(lg, other.lg, t),
      xl: lerpDouble(xl, other.xl, t),
    );
  }

  static double lerpDouble(double a, double b, double t) => a + (b - a) * t;
}

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

  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    visualDensity: VisualDensity.standard,
    textTheme: textTheme,
    scaffoldBackgroundColor: colorScheme.surface,
    elevatedButtonTheme: elevatedButtonTheme,
    snackBarTheme: snackBarTheme,
    extensions: const [Spacing(xs: 4, sm: 8, md: 12, lg: 16, xl: 24)],
  );
}
