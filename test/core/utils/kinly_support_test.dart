import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kinly/core/ui/support/kinly_support.dart';
import 'package:kinly/core/ui/support/enums/kinly_support_intent.dart';
import 'package:kinly/generated/l10n.dart';

void main() {
  testWidgets('buildEmailUri uses intent-specific subjects', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: [S.delegate],
        supportedLocales: [Locale('en')],
        home: SizedBox.shrink(),
      ),
    );
    final context = tester.element(find.byType(SizedBox));

    final contact = KinlySupport.buildEmailUri(
      context,
      KinlySupportIntent.contact,
    );
    final reactivate = KinlySupport.buildEmailUri(
      context,
      KinlySupportIntent.reactivate,
    );
    final nps = KinlySupport.buildEmailUri(context, KinlySupportIntent.nps);

    expect(
      contact.queryParameters['subject'],
      S.of(context).profileContactEmailSubject,
    );
    expect(
      reactivate.queryParameters['subject'],
      S.of(context).profileContactEmailSubject,
    );
    expect(nps.queryParameters['subject'], S.of(context).npsEmailSubject);
  });
}
