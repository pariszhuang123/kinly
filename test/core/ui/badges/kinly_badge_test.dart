import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kinly/core/theme/control_tokens.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/core/ui/badges/kinly_badge.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: buildKinlyTheme(Brightness.light),
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  testWidgets('defaults to single-line text', (tester) async {
    await tester.pumpWidget(_wrap(const KinlyBadge(label: 'New')));

    final text = tester.widget<Text>(
      find.descendant(of: find.byType(KinlyBadge), matching: find.byType(Text)),
    );
    expect(text.maxLines, 1);
    expect(text.overflow, TextOverflow.ellipsis);
  });

  testWidgets('maxLines can be increased', (tester) async {
    await tester.pumpWidget(_wrap(const KinlyBadge(label: 'New', maxLines: 2)));

    final text = tester.widget<Text>(
      find.descendant(of: find.byType(KinlyBadge), matching: find.byType(Text)),
    );
    expect(text.maxLines, 2);
  });

  testWidgets('destructive variant uses error badge tokens', (tester) async {
    await tester.pumpWidget(
      _wrap(const KinlyBadge(label: 'Overdue', destructive: true)),
    );

    final element = tester.element(find.byType(KinlyBadge));
    final controls = Theme.of(element).extension<KinlyControlColors>()!;

    final decorated = tester.widget<DecoratedBox>(
      find.descendant(
        of: find.byType(KinlyBadge),
        matching: find.byType(DecoratedBox),
      ),
    );
    final decoration = decorated.decoration as BoxDecoration;
    expect(decoration.color, controls.errorBadgeBg);

    final text = tester.widget<Text>(
      find.descendant(of: find.byType(KinlyBadge), matching: find.byType(Text)),
    );
    expect(text.style?.color, controls.errorBadgeFg);
  });

  testWidgets('custom colors require both background and foreground', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(const KinlyBadge(label: 'X', backgroundColor: Colors.red)),
    );
    expect(tester.takeException(), isA<AssertionError>());

    await tester.pumpWidget(
      _wrap(const KinlyBadge(label: 'X', foregroundColor: Colors.red)),
    );
    expect(tester.takeException(), isA<AssertionError>());
  });

  testWidgets('custom colors are applied and border is optional', (tester) async {
    const background = Color(0xFF112233);
    const foreground = Color(0xFFEECCAA);
    const border = Color(0xFF445566);

    await tester.pumpWidget(
      _wrap(
        const KinlyBadge(
          label: 'Custom',
          backgroundColor: background,
          foregroundColor: foreground,
          borderColor: border,
          textStyle: TextStyle(color: Colors.green),
        ),
      ),
    );

    final decorated = tester.widget<DecoratedBox>(
      find.descendant(
        of: find.byType(KinlyBadge),
        matching: find.byType(DecoratedBox),
      ),
    );
    final decoration = decorated.decoration as BoxDecoration;
    expect(decoration.color, background);
    expect(decoration.border, Border.all(color: border));

    final text = tester.widget<Text>(
      find.descendant(of: find.byType(KinlyBadge), matching: find.byType(Text)),
    );
    expect(text.style?.color, foreground);
  });
}
