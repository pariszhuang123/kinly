import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/theme/opacity.dart';
import 'package:kinly/features/flow/ui/flow_chore_detail/widgets/flow_chore_extras_section.dart';
import 'package:kinly/generated/l10n.dart';

void main() {
  Widget wrapWithApp(Widget child) {
    return MaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
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
          KinlyOpacity.defaults,
        ],
      ),
      home: Scaffold(body: child),
    );
  }

  testWidgets('renders how-to as clickable link when handler provided', (
    tester,
  ) async {
    var tapped = false;
    await tester.pumpWidget(
      wrapWithApp(
        FlowChoreExtrasSection(
          notesLabel: 'Notes',
          notesBody: 'Use mild soap',
          howToLabel: 'How-to',
          howToBody: 'https://example.com',
          onHowToTap: () => tapped = true,
        ),
      ),
    );

    await tester.tap(find.text(S.current.flowChoreDetailMoreInfoTitle));
    await tester.pumpAndSettle();

    await tester.tap(find.text('https://example.com'));
    expect(tapped, isTrue);
  });

  testWidgets('renders plain text when no how-to handler', (tester) async {
    await tester.pumpWidget(
      wrapWithApp(
        FlowChoreExtrasSection(
          notesLabel: 'Notes',
          notesBody: 'Use mild soap',
          howToLabel: 'How-to',
          howToBody: 'No link',
        ),
      ),
    );

    await tester.tap(find.text(S.current.flowChoreDetailMoreInfoTitle));
    await tester.pumpAndSettle();

    expect(find.text('No link'), findsOneWidget);
  });
}
