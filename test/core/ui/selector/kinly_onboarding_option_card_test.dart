import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kinly/core/theme/kinly_sections.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/core/ui/kinly_icons.dart';
import 'package:kinly/core/ui/selector/kinly_onboarding_option_card.dart';

Widget _buildHarness({
  required bool isSelected,
  VoidCallback? onTap,
}) {
  return MaterialApp(
    theme: buildKinlyTheme(Brightness.light),
    home: Builder(
      builder: (context) {
        return Scaffold(
          body: Center(
            child: KinlyOnboardingOptionCard(
              label: 'Option label',
              isSelected: isSelected,
              colors: context.preferenceSection,
              onTap: onTap,
            ),
          ),
        );
      },
    ),
  );
}

void main() {
  testWidgets('shows selected indicator icon when selected', (tester) async {
    await tester.pumpWidget(_buildHarness(isSelected: true));

    expect(find.byIcon(KinlyIcons.checkRounded), findsOneWidget);
  });

  testWidgets('hides selected indicator icon when not selected', (tester) async {
    await tester.pumpWidget(_buildHarness(isSelected: false));

    expect(find.byIcon(KinlyIcons.checkRounded), findsNothing);
  });

  testWidgets('invokes callback when tapped', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      _buildHarness(
        isSelected: false,
        onTap: () {
          tapped = true;
        },
      ),
    );

    await tester.tap(find.text('Option label'));
    await tester.pump();

    expect(tapped, isTrue);
  });
}
