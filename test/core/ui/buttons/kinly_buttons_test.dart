import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/core/theme/control_tokens.dart';
import 'package:kinly/core/ui/buttons/kinly_filled_button.dart';
import 'package:kinly/core/ui/buttons/kinly_outlined_button.dart';
import 'package:kinly/core/ui/buttons/kinly_fab.dart';

void main() {
  Widget _wrap(Widget child, {Brightness brightness = Brightness.light}) {
    return MaterialApp(
      theme: buildKinlyTheme(brightness),
      home: Scaffold(body: Center(child: child)),
    );
  }

  testWidgets('filled button uses control colors in light mode', (tester) async {
    await tester.pumpWidget(
      _wrap(
        KinlyFilledButton.text(
          onPressed: () {},
          label: 'Filled',
        ),
      ),
    );

    final filled = tester.widget<FilledButton>(find.byType(FilledButton));
    final style = filled.style!;
    final bg = style.backgroundColor!.resolve({})!;
    final fg = style.foregroundColor!.resolve({})!;

    final theme = Theme.of(tester.element(find.byType(FilledButton)));
    expect(bg, theme.extension<KinlyControlColors>()!.filledBg);
    expect(fg, theme.extension<KinlyControlColors>()!.filledFg);
  });

  testWidgets('outlined button uses control colors in dark mode', (tester) async {
    await tester.pumpWidget(
      _wrap(
        KinlyOutlinedButton.text(
          onPressed: () {},
          label: 'Outlined',
        ),
        brightness: Brightness.dark,
      ),
    );

    final outlined = tester.widget<OutlinedButton>(find.byType(OutlinedButton));
    final style = outlined.style!;
    final fg = style.foregroundColor!.resolve({})!;
    final side = style.side!.resolve({})!;

    final theme = Theme.of(tester.element(find.byType(OutlinedButton)));
    final controls = theme.extension<KinlyControlColors>()!;
    expect(fg, controls.outlinedFg);
    expect(side.color, controls.outlinedBorder);
  });

  testWidgets('fab uses control colors', (tester) async {
    await tester.pumpWidget(
      _wrap(
        KinlyFab(
          onPressed: () {},
          icon: Icons.add,
        ),
      ),
    );

    final fab = tester.widget<FloatingActionButton>(
      find.byType(FloatingActionButton),
    );
    final theme = Theme.of(tester.element(find.byType(FloatingActionButton)));
    final controls = theme.extension<KinlyControlColors>()!;

    expect(fab.backgroundColor, controls.fabBg);
    expect(fab.foregroundColor, controls.fabFg);
  });
}
