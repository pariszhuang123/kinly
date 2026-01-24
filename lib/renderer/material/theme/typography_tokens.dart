import 'package:flutter/material.dart';

/// Typography tokens for Kinly.
@immutable
class KinlyTypography extends ThemeExtension<KinlyTypography> {
  static const fontFamily = 'NotoSansArabicVariable';

  const KinlyTypography({
    required this.displayLarge,
    required this.displayMedium,
    required this.headlineLarge,
    required this.headlineMedium,
    required this.titleLarge,
    required this.titleMedium,
    required this.titleSmall,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    required this.labelMedium,
    required this.labelSmall,
  });

  final TextStyle displayLarge;
  final TextStyle displayMedium;
  final TextStyle headlineLarge;
  final TextStyle headlineMedium;
  final TextStyle titleLarge;
  final TextStyle titleMedium;
  final TextStyle titleSmall;
  final TextStyle bodyLarge;
  final TextStyle bodyMedium;
  final TextStyle bodySmall;
  final TextStyle labelMedium;
  final TextStyle labelSmall;

  factory KinlyTypography.fromBrightness(Brightness brightness) {
    final baseColor =
        brightness == Brightness.dark ? Colors.white : Colors.black;

    TextStyle notoSansArabic(
      double size,
      FontWeight weight, {
      FontStyle fontStyle = FontStyle.normal,
    }) {
      return TextStyle(
        fontFamily: fontFamily,
        fontSize: size,
        fontWeight: weight,
        fontStyle: fontStyle,
        color: baseColor,
      );
    }

    return KinlyTypography(
      displayLarge: notoSansArabic(40, FontWeight.w700),
      displayMedium: notoSansArabic(32, FontWeight.w700),
      headlineLarge: notoSansArabic(28, FontWeight.w700),
      headlineMedium: notoSansArabic(24, FontWeight.w600),
      titleLarge: notoSansArabic(20, FontWeight.w600),
      titleMedium: notoSansArabic(18, FontWeight.w600),
      titleSmall: notoSansArabic(16, FontWeight.w600),
      bodyLarge: notoSansArabic(16, FontWeight.w400),
      bodyMedium: notoSansArabic(14, FontWeight.w400),
      bodySmall: notoSansArabic(12, FontWeight.w400),
      labelMedium: notoSansArabic(14, FontWeight.w600),
      labelSmall: notoSansArabic(12, FontWeight.w600),
    );
  }

  @override
  KinlyTypography copyWith({
    TextStyle? displayLarge,
    TextStyle? displayMedium,
    TextStyle? headlineLarge,
    TextStyle? headlineMedium,
    TextStyle? titleLarge,
    TextStyle? titleMedium,
    TextStyle? titleSmall,
    TextStyle? bodyLarge,
    TextStyle? bodyMedium,
    TextStyle? bodySmall,
    TextStyle? labelMedium,
    TextStyle? labelSmall,
  }) {
    return KinlyTypography(
      displayLarge: displayLarge ?? this.displayLarge,
      displayMedium: displayMedium ?? this.displayMedium,
      headlineLarge: headlineLarge ?? this.headlineLarge,
      headlineMedium: headlineMedium ?? this.headlineMedium,
      titleLarge: titleLarge ?? this.titleLarge,
      titleMedium: titleMedium ?? this.titleMedium,
      titleSmall: titleSmall ?? this.titleSmall,
      bodyLarge: bodyLarge ?? this.bodyLarge,
      bodyMedium: bodyMedium ?? this.bodyMedium,
      bodySmall: bodySmall ?? this.bodySmall,
      labelMedium: labelMedium ?? this.labelMedium,
      labelSmall: labelSmall ?? this.labelSmall,
    );
  }

  @override
  KinlyTypography lerp(ThemeExtension<KinlyTypography>? other, double t) {
    if (other is! KinlyTypography) return this;
    return KinlyTypography(
      displayLarge: TextStyle.lerp(displayLarge, other.displayLarge, t)!,
      displayMedium: TextStyle.lerp(displayMedium, other.displayMedium, t)!,
      headlineLarge: TextStyle.lerp(headlineLarge, other.headlineLarge, t)!,
      headlineMedium: TextStyle.lerp(headlineMedium, other.headlineMedium, t)!,
      titleLarge: TextStyle.lerp(titleLarge, other.titleLarge, t)!,
      titleMedium: TextStyle.lerp(titleMedium, other.titleMedium, t)!,
      titleSmall: TextStyle.lerp(titleSmall, other.titleSmall, t)!,
      bodyLarge: TextStyle.lerp(bodyLarge, other.bodyLarge, t)!,
      bodyMedium: TextStyle.lerp(bodyMedium, other.bodyMedium, t)!,
      bodySmall: TextStyle.lerp(bodySmall, other.bodySmall, t)!,
      labelMedium: TextStyle.lerp(labelMedium, other.labelMedium, t)!,
      labelSmall: TextStyle.lerp(labelSmall, other.labelSmall, t)!,
    );
  }
}
