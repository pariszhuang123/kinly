import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/core/theme/kinly_palette.dart';

Brightness _modeByName(String name) {
  return Brightness.values.firstWhere((mode) => mode.name == name);
}

double _contrastRatio(Color foreground, Color background) {
  final l1 = foreground.computeLuminance();
  final l2 = background.computeLuminance();
  final light = math.max(l1, l2);
  final dark = math.min(l1, l2);
  return (light + 0.05) / (dark + 0.05);
}

double _srgbToLinear(double value) {
  if (value <= 0.04045) {
    return value / 12.92;
  }
  return math.pow((value + 0.055) / 1.055, 2.4).toDouble();
}

({double l, double a, double b}) _toLab(Color color) {
  final r = _srgbToLinear(color.r);
  final g = _srgbToLinear(color.g);
  final bl = _srgbToLinear(color.b);

  final x = (r * 0.4124564) + (g * 0.3575761) + (bl * 0.1804375);
  final y = (r * 0.2126729) + (g * 0.7151522) + (bl * 0.0721750);
  final z = (r * 0.0193339) + (g * 0.1191920) + (bl * 0.9503041);

  const xr = 0.95047;
  const yr = 1.0;
  const zr = 1.08883;

  final fx = _xyzToLabPivot(x / xr);
  final fy = _xyzToLabPivot(y / yr);
  final fz = _xyzToLabPivot(z / zr);

  return (l: (116.0 * fy) - 16.0, a: 500.0 * (fx - fy), b: 200.0 * (fy - fz));
}

double _xyzToLabPivot(double t) {
  const delta = 6.0 / 29.0;
  final delta3 = delta * delta * delta;
  if (t > delta3) {
    return math.pow(t, 1.0 / 3.0).toDouble();
  }
  return (t / (3.0 * delta * delta)) + (4.0 / 29.0);
}

double _deltaL(Color a, Color b) {
  final labA = _toLab(a);
  final labB = _toLab(b);
  return (labA.l - labB.l).abs();
}

double _chroma(Color color) {
  final lab = _toLab(color);
  return math.sqrt((lab.a * lab.a) + (lab.b * lab.b));
}

double _hueDrift(Color lightColor, Color darkColor) {
  final lightHue = HSLColor.fromColor(lightColor).hue;
  final darkHue = HSLColor.fromColor(darkColor).hue;
  final delta = (darkHue - lightHue).abs();
  return math.min(delta, 360.0 - delta);
}

double _saturationDelta(Color lightColor, Color darkColor) {
  final lightSat = HSLColor.fromColor(lightColor).saturation * 100.0;
  final darkSat = HSLColor.fromColor(darkColor).saturation * 100.0;
  return darkSat - lightSat;
}

void main() {
  final lightMode = _modeByName('light');
  final darkMode = _modeByName('dark');

  group('Dark mode refinement contract', () {
    test('dark surface hierarchy thresholds are satisfied', () {
      final palette = KinlyPalette.build(darkMode);
      final scheme = palette.colorScheme;

      final backgroundPrimary = scheme.surface;
      final backgroundSecondary = scheme.surfaceContainer;
      final cardPrimary = scheme.surfaceContainerHigh;

      final deltaPrimaryToSecondary = _deltaL(
        backgroundPrimary,
        backgroundSecondary,
      );
      final deltaSecondaryToCard = _deltaL(backgroundSecondary, cardPrimary);
      final deltaPrimaryToCard = _deltaL(backgroundPrimary, cardPrimary);

      expect(deltaPrimaryToSecondary, inInclusiveRange(6.0, 10.0));
      expect(deltaSecondaryToCard, inInclusiveRange(6.0, 10.0));
      expect(deltaPrimaryToCard, inInclusiveRange(12.0, 16.0));
    });

    test('dark surface chroma stays above muddy threshold', () {
      final palette = KinlyPalette.build(darkMode);
      final scheme = palette.colorScheme;

      expect(_chroma(scheme.surface), greaterThan(3.0));
      expect(_chroma(scheme.surfaceContainer), greaterThan(3.0));
      expect(_chroma(scheme.surfaceContainerHigh), greaterThan(3.0));
    });

    test('primary hue drift and saturation delta stay in guardrails', () {
      final lightPalette = KinlyPalette.build(lightMode);
      final darkPalette = KinlyPalette.build(darkMode);

      final drift = _hueDrift(
        lightPalette.colorScheme.primary,
        darkPalette.colorScheme.primary,
      );
      final satDelta = _saturationDelta(
        lightPalette.colorScheme.primary,
        darkPalette.colorScheme.primary,
      );

      expect(drift, lessThanOrEqualTo(8.0));
      expect(satDelta, inInclusiveRange(-10.0, 10.0));
    });

    test('dark contrast thresholds remain compliant', () {
      final palette = KinlyPalette.build(darkMode);
      final scheme = palette.colorScheme;
      final sections = palette.sections;

      expect(
        _contrastRatio(scheme.onSurface, scheme.surface),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        _contrastRatio(scheme.onPrimary, scheme.primary),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        _contrastRatio(scheme.onTertiary, scheme.tertiary),
        greaterThanOrEqualTo(4.5),
      );

      expect(
        _contrastRatio(sections.flow.icon, sections.flow.card),
        greaterThanOrEqualTo(3.0),
      );
      expect(
        _contrastRatio(sections.share.icon, sections.share.card),
        greaterThanOrEqualTo(3.0),
      );
      expect(
        _contrastRatio(sections.pulse.icon, sections.pulse.card),
        greaterThanOrEqualTo(3.0),
      );
      expect(
        _contrastRatio(sections.empty.icon, sections.empty.card),
        greaterThanOrEqualTo(3.0),
      );
    });
  });
}
