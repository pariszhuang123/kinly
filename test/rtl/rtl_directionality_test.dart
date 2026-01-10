import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/generated/l10n.dart';

void main() {
  testWidgets('Arabic locale sets RTL directionality', (tester) async {
    const probeKey = ValueKey('rtl-probe');

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ar'),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        theme: buildKinlyTheme(Brightness.light),
        home: Builder(builder: (context) => SizedBox(key: probeKey)),
      ),
    );

    await tester.pumpAndSettle();
    final context = tester.element(find.byKey(probeKey));
    expect(Directionality.of(context), TextDirection.rtl);
  });
}
