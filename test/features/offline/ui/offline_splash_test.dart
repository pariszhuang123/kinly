import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kinly/features/offline/ui/offline_splash.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/core/theme/kinly_theme.dart';

void main() {
  testWidgets('OfflineSplash renders copy and triggers retry', (tester) async {
    var retried = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKinlyTheme(Brightness.light),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: OfflineSplash(
          onRetry: () {
            retried = true;
          },
        ),
      ),
    );

    await tester.pumpAndSettle();
    final context = tester.element(find.byType(OfflineSplash));
    final strings = S.of(context);

    expect(find.text(strings.offline_title), findsOneWidget);
    expect(find.text(strings.offline_body), findsOneWidget);

    await tester.tap(find.text(strings.offline_retry));
    expect(retried, isTrue);
  });
}
