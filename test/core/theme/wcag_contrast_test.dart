import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/core/theme/kinly_palette.dart';

double _contrastRatio(Color foreground, Color background) {
  final l1 = foreground.computeLuminance();
  final l2 = background.computeLuminance();
  final light = l1 > l2 ? l1 : l2;
  final dark = l1 > l2 ? l2 : l1;
  return (light + 0.05) / (dark + 0.05);
}

void _expectContrast(Color fg, Color bg, double threshold, String label) {
  final ratio = _contrastRatio(fg, bg);
  expect(
    ratio >= threshold,
    true,
    reason: '$label contrast $ratio < $threshold',
  );
}

void main() {
  group('WCAG contrast', () {
    for (final brightness in [Brightness.light, Brightness.dark]) {
      final colors = KinlyPalette.build(brightness);
      final scheme = colors.colorScheme;
      final controls = colors.controlColors;
      final sections = colors.sections;

      test('global pairings ${brightness.name}', () {
        _expectContrast(
          scheme.onSurface,
          scheme.surface,
          4.5,
          'onSurface/surface',
        );
        _expectContrast(
          scheme.onSurface,
          scheme.surfaceContainer,
          4.5,
          'onSurface/surfaceContainer',
        );
        _expectContrast(
          scheme.onPrimary,
          scheme.primary,
          4.5,
          'onPrimary/primary',
        );
        _expectContrast(
          scheme.onSecondary,
          scheme.secondary,
          4.5,
          'onSecondary/secondary',
        );
        _expectContrast(scheme.onError, scheme.error, 4.5, 'onError/error');
      });

      test('control tokens ${brightness.name}', () {
        _expectContrast(controls.filledFg, controls.filledBg, 4.5, 'filled');
        _expectContrast(
          controls.outlinedFg,
          scheme.surface,
          4.5,
          'outlined/surface',
        );
        _expectContrast(
          controls.selectableItemFgSelected,
          controls.selectableItemBgSelected,
          4.5,
          'selectable selected',
        );
        _expectContrast(
          controls.optionRowFg,
          controls.optionRowBg,
          4.5,
          'option row',
        );
        _expectContrast(
          controls.optionRowSelectedFg,
          controls.optionRowSelectedBg,
          4.5,
          'option row selected',
        );
      });

      test('sections ${brightness.name}', () {
        void expectSection(String name, Color icon, Color card) {
          _expectContrast(icon, card, 3.0, '$name icon/card');
        }

        expectSection('flow', sections.flow.icon, sections.flow.card);
        expectSection('share', sections.share.icon, sections.share.card);
        expectSection('pulse', sections.pulse.icon, sections.pulse.card);
        expectSection('empty', sections.empty.icon, sections.empty.card);
      });
    }
  });
}
