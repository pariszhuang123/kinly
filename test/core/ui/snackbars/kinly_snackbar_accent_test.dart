import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:math' as math;

import 'package:kinly/core/ui/snackbars/kinly_snackbar.dart';
import 'package:kinly/core/theme/color_tokens.dart';
import 'package:kinly/core/theme/kinly_palette.dart';
import 'package:kinly/core/theme/spacing.dart';

void main() {
  double contrastRatio(Color a, Color b) {
    double linearize(double v) {
      return v <= 0.03928
          ? v / 12.92
          : math.pow((v + 0.055) / 1.055, 2.4).toDouble();
    }

    double luminance(Color c) {
      final r = linearize(c.r);
      final g = linearize(c.g);
      final b = linearize(c.b);
      return 0.2126 * r + 0.7152 * g + 0.0722 * b;
    }

    final l1 = luminance(a) + 0.05;
    final l2 = luminance(b) + 0.05;
    return l1 > l2 ? l1 / l2 : l2 / l1;
  }

  testWidgets(
    'KinlySnackBar ensures accent contrast + readable text across variants',
    (tester) async {
      final variants = <({
        String name,
        Color Function(KinlyColorTokens tokens) background,
        void Function(BuildContext context, String message, Color accent) show,
      })>[
        (
          name: 'success',
          background: (tokens) => tokens.success,
          show:
              (context, message, accent) => KinlySnackBar.showSuccess(
                context,
                message,
                accentColor: accent,
              ),
        ),
        (
          name: 'error',
          background: (tokens) => tokens.error,
          show:
              (context, message, accent) => KinlySnackBar.showError(
                context,
                message,
                accentColor: accent,
              ),
        ),
        (
          name: 'info',
          background: (tokens) => tokens.info,
          show:
              (context, message, accent) => KinlySnackBar.showInfo(
                context,
                message,
                accentColor: accent,
              ),
        ),
        (
          name: 'warning',
          background: (tokens) => tokens.warning,
          show:
              (context, message, accent) => KinlySnackBar.showWarning(
                context,
                message,
                accentColor: accent,
              ),
        ),
      ];

      for (final brightness in const [Brightness.light, Brightness.dark]) {
        for (final variant in variants) {
          final message = '${variant.name} saved ($brightness)';
          Color? expectedBackground;

          await tester.pumpWidget(
            MaterialApp(
              theme: (brightness == Brightness.dark
                      ? ThemeData.dark()
                      : ThemeData.light())
                  .copyWith(
                    extensions: const [
                      Spacing(
                        xxs: 2,
                        xs: 4,
                        s: 8,
                        m: 12,
                        l: 16,
                        xl: 24,
                        xxl: 32,
                        xxxl: 40,
                      ),
                    ],
                  ),
              home: Builder(
                builder: (context) {
                  final tokens =
                      KinlyPalette.build(
                        Theme.of(context).brightness,
                      ).colorTokens;
                  expectedBackground = variant.background(tokens);
                  return Scaffold(
                    body: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          variant.show(
                            context,
                            message,
                            // Passing a low-contrast accent (same as background)
                            // should be adjusted to a higher-contrast accent
                            // internally.
                            expectedBackground!,
                          );
                        },
                        child: const Text('Show'),
                      ),
                    ),
                  );
                },
              ),
            ),
          );

          await tester.tap(find.text('Show'));
          await tester.pump();

          expect(find.byType(SnackBar), findsOneWidget);
          expect(find.text(message), findsOneWidget);

          final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
          final background = snackBar.backgroundColor;
          expect(background, isNotNull);
          expect(background, expectedBackground);

          final stripBoxFinder = find.byWidgetPredicate(
            (w) => w is SizedBox && w.width == 8,
          );
          final accentBox = tester.widget<DecoratedBox>(
            find.descendant(
              of: stripBoxFinder,
              matching: find.byType(DecoratedBox),
            ),
          );
          final effectiveAccent =
              (accentBox.decoration as BoxDecoration).color!;

          // Accent shouldn't match background when the requested accent is
          // identical to the background.
          expect(effectiveAccent, isNot(background));
          expect(
            contrastRatio(background!, effectiveAccent),
            greaterThanOrEqualTo(3),
          );

          final shape = snackBar.shape;
          expect(shape, isA<RoundedRectangleBorder>());
          final border = shape! as RoundedRectangleBorder;
          expect(border.side.color, effectiveAccent);

          final expectedTextColor =
              ThemeData.estimateBrightnessForColor(background) == Brightness.dark
                  ? Colors.white
                  : Colors.black;
          final text = tester.widget<Text>(find.text(message));
          expect(text.style?.color, expectedTextColor);
        }
      }
    },
  );

}
