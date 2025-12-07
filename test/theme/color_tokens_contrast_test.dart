import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kinly/core/theme/color_tokens.dart';
import 'package:kinly/core/theme/kinly_palette.dart';
import 'package:kinly/core/theme/kinly_sections.dart';

double _relativeLuminance(Color color) {
  final c = color.computeLuminance();
  return c;
}

double _contrastRatio(Color a, Color b) {
  final l1 = _relativeLuminance(a);
  final l2 = _relativeLuminance(b);
  final brightest = l1 > l2 ? l1 : l2;
  final darkest = l1 > l2 ? l2 : l1;
  return (brightest + 0.05) / (darkest + 0.05);
}

void _expectRatio(Color fg, Color bg, double minRatio, String description) {
  expect(
    _contrastRatio(fg, bg),
    greaterThanOrEqualTo(minRatio),
    reason: '$description should be >= $minRatio',
  );
}

void main() {
  for (final brightness in Brightness.values) {
    test('Kinly color tokens meet contrast thresholds for $brightness', () {
      final palette = KinlyPalette.build(brightness);
      final KinlyColorTokens tokens = palette.colorTokens;
      final scheme = palette.colorScheme;

      _expectRatio(tokens.onPrimary, tokens.primary, 4.5, 'primary text');
      _expectRatio(
        tokens.onPrimaryContainer,
        tokens.primaryContainer,
        4.5,
        'primary container text',
      );
      _expectRatio(tokens.onSecondary, tokens.secondary, 4.5, 'secondary text');
      _expectRatio(
        tokens.onSecondaryContainer,
        tokens.secondaryContainer,
        4.5,
        'secondary container text',
      );
      _expectRatio(tokens.onSurface, tokens.surface, 4.5, 'surface text');
      _expectRatio(
        tokens.onInverseSurface,
        tokens.inverseSurface,
        4.5,
        'inverse surface text',
      );
      _expectRatio(tokens.onError, tokens.error, 4.5, 'error text');
      _expectRatio(
        scheme.onTertiaryContainer,
        scheme.tertiaryContainer,
        4.5,
        'tertiary container text',
      );
    });

    test('Section palettes meet contrast thresholds for $brightness', () {
      final KinlySections sections = KinlyPalette.sections(brightness);
      _expectRatio(
        sections.flow.icon,
        sections.flow.background,
        4.5,
        'flow icon',
      );
      _expectRatio(
        sections.share.icon,
        sections.share.background,
        4.5,
        'share icon',
      );
      _expectRatio(
        sections.pulse.icon,
        sections.pulse.background,
        4.5,
        'pulse icon',
      );
      _expectRatio(
        sections.empty.icon,
        sections.empty.background,
        4.5,
        'empty icon',
      );
    });
  }
}
