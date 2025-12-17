import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/core/theme/kinly_sections.dart';
import 'package:kinly/core/ui/selector/kinly_expand_badge.dart';

void main() {
  const accent = Color(0xFF336699);
  const iconColor = Color(0xFF112233);
  const sectionColors = SectionColors(
    background: Colors.transparent,
    card: Colors.transparent,
    icon: iconColor,
    accent: accent,
  );

  Widget wrapBadge({bool? isDarkOverride}) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: KinlyExpandBadge(
            isExpanded: true,
            colors: sectionColors,
            isDarkOverride: isDarkOverride,
          ),
        ),
      ),
    );
  }

  testWidgets('uses section icon color and default background alpha', (
    tester,
  ) async {
    await tester.pumpWidget(wrapBadge(isDarkOverride: false));

    final icon = tester.widget<Icon>(find.byType(Icon));
    expect(icon.color, iconColor);

    final decorated = tester.widget<DecoratedBox>(find.byType(DecoratedBox));
    final decoration = decorated.decoration as BoxDecoration;
    expect(decoration.color, accent.withValues(alpha: 0.12));
  });

  testWidgets('uses dark alpha when isDarkOverride is true', (tester) async {
    await tester.pumpWidget(wrapBadge(isDarkOverride: true));

    final decorated = tester.widget<DecoratedBox>(find.byType(DecoratedBox));
    final decoration = decorated.decoration as BoxDecoration;
    expect(decoration.color, accent.withValues(alpha: 0.16));
  });
}
