import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/foundation/surfaces/today/domain/models.dart';
import 'package:kinly/foundation/surfaces/today/widgets/today_share_section/today_share_section.dart';
import 'package:kinly/generated/l10n.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final fakeSvg = _FakeSvgAssetBundle();

  testWidgets('renders share tabs and shows paid entry', (tester) async {
    final owed = TodayShareOwed(
      payerUserId: 'payer-1',
      displayName: 'Alex',
      totalOwedCents: 1234,
      items: [
        TodayShareOwedItem(
          expenseId: 'exp-1',
          description: 'Lunch',
          amountCents: 1234,
          recurrenceEvery: null,
          recurrenceUnit: null,
          startDate: DateTime(2024, 1, 1),
        ),
      ],
    );

    final paid = TodaySharePaidToMe(
      debtorUserId: 'debtor-1',
      debtorUsername: 'Jamie',
      totalPaidCents: 2400,
      unseenCount: 1,
      latestPaidAt: DateTime.now(),
    );

    await tester.pumpWidget(
      DefaultAssetBundle(
        bundle: fakeSvg,
        child: MaterialApp(
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          theme: buildKinlyTheme(Brightness.light),
          home: Scaffold(
            body: TodayShareSection(
              owed: [owed],
              paidToMe: [paid],
              drafts: const [],
              errorMessage: null,
              onOwedTap: (_) {},
              onPaidToMeTap: (_) {},
              onDraftTap: (_) {},
              onSeeAllDraftsTap: () {},
            ),
          ),
        ),
      ),
    );

    final l10n = S.of(tester.element(find.byType(TodayShareSection)));

    expect(find.text(l10n.todayShareTabActive), findsOneWidget);
    expect(find.text(l10n.todayShareTabPaidToMe), findsOneWidget);

    // Switch to Paid to me tab
    await tester.tap(find.text(l10n.todayShareTabPaidToMe));
    await tester.pumpAndSettle();

    expect(find.text('Jamie'), findsOneWidget);
    expect(find.textContaining('new payment'), findsOneWidget);
  });

  testWidgets('invokes paid-to-me tap callback', (tester) async {
    bool tapped = false;

    final paid = TodaySharePaidToMe(
      debtorUserId: 'debtor-2',
      debtorUsername: 'Taylor',
      totalPaidCents: 5000,
      unseenCount: 0,
      latestPaidAt: DateTime.now(),
    );

    await tester.pumpWidget(
      DefaultAssetBundle(
        bundle: fakeSvg,
        child: MaterialApp(
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          theme: buildKinlyTheme(Brightness.light),
          home: Scaffold(
            body: TodayShareSection(
              owed: const [],
              paidToMe: [paid],
              drafts: const [],
              errorMessage: null,
              onOwedTap: (_) {},
              onPaidToMeTap: (_) {
                tapped = true;
              },
              onDraftTap: (_) {},
              onSeeAllDraftsTap: () {},
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Taylor'));
    expect(tapped, isTrue);
  });
}

class _FakeSvgAssetBundle extends CachingAssetBundle {
  static const _svg =
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1 1"><path d="M0 0h1v1H0z"/></svg>';

  @override
  Future<ByteData> load(String key) async {
    final bytes = Uint8List.fromList(_svg.codeUnits);
    return ByteData.view(bytes.buffer);
  }

  @override
  Future<String> loadString(String key, {bool cache = true}) async => _svg;
}
