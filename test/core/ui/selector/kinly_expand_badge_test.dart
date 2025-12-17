import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/core/theme/kinly_sections.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/core/theme/control_tokens.dart';
import 'package:kinly/core/ui/selector/kinly_expand_badge.dart';

void main() {
  const accent = Color(0xFF336699);
  const sectionColors = SectionColors(
    background: Colors.transparent,
    card: Colors.transparent,
    icon: Colors.transparent,
    accent: accent,
  );

  Widget wrapBadge() => MaterialApp(
        theme: buildKinlyTheme(Brightness.light),
        home: Scaffold(
          body: Center(
            child: KinlyExpandBadge(
              isExpanded: true,
              colors: sectionColors,
            ),
          ),
        ),
      );

  testWidgets('uses section icon color and default background alpha', (
    tester,
  ) async {
    await tester.pumpWidget(wrapBadge());

    final decorated = tester.widget<DecoratedBox>(find.byType(DecoratedBox));
    final decoration = decorated.decoration as BoxDecoration;
    final controls = Theme.of(tester.element(find.byType(KinlyExpandBadge)))
        .extension<KinlyControlColors>()!;
    expect(decoration.color, controls.expandBadgeBg);
  });

  testWidgets('uses token icon/color fallback when theme has no extension',
      (tester) async {
    await tester.pumpWidget(wrapBadge());

    final decorated = tester.widget<DecoratedBox>(find.byType(DecoratedBox));
    final decoration = decorated.decoration as BoxDecoration;
    final controls = Theme.of(tester.element(find.byType(KinlyExpandBadge)))
        .extension<KinlyControlColors>()!;
    expect(decoration.color, controls.expandBadgeBg);
  });
}
