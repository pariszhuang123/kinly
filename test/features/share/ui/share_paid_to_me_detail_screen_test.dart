import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/features/share/share.dart';
import 'package:kinly/features/share/ui/share_paid_to_me_detail_screen.dart';
import 'package:kinly/foundation/surfaces/today/domain/models.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/contracts/expenses/models.dart';
import 'package:intl/date_symbol_data_local.dart';

class _MockExpensesRepository extends Mock implements ExpensesRepository {}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initializeDateFormatting('en');
  });

  testWidgets('loads detail, marks viewed, and renders items', (tester) async {
    final repo = _MockExpensesRepository();
    when(
      () => repo.listPaidToMeByDebtor(
        homeId: any(named: 'homeId'),
        debtorUserId: any(named: 'debtorUserId'),
      ),
    ).thenAnswer(
      (_) async => [
        ExpensePaidToMeItem(
          expenseId: 'e1',
          description: 'Lunch',
          amountCents: 1200,
          markedPaidAt: DateTime.now(),
          recurrenceEvery: 1,
          recurrenceUnit: ExpenseRecurrenceUnit.week,
          startDate: DateTime(2024, 1, 1),
          notes: null,
        ),
      ],
    );

    final entry = TodaySharePaidToMe(
      debtorUserId: 'debtor-1',
      debtorUsername: 'Jamie',
      totalPaidCents: 1200,
      unseenCount: 1,
      latestPaidAt: DateTime.now(),
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: buildKinlyTheme(Brightness.light),
        localizationsDelegates: const [S.delegate],
        supportedLocales: S.delegate.supportedLocales,
        home: SharePaidToMeDetailScreen(
          entry: entry,
          homeId: 'home-1',
          expensesRepository: repo,
        ),
      ),
    );

    // let futures resolve
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.text('Lunch'), findsOneWidget);
    expect(find.text('Applies to January 1 - 7, 2024'), findsOneWidget);
    verifyNever(
      () => repo.markPaidReceivedViewedForDebtor(
        homeId: 'home-1',
        debtorUserId: 'debtor-1',
      ),
    );
    verify(
      () =>
          repo.listPaidToMeByDebtor(homeId: 'home-1', debtorUserId: 'debtor-1'),
    ).called(1);

    when(
      () => repo.markPaidReceivedViewedForDebtor(
        homeId: any(named: 'homeId'),
        debtorUserId: any(named: 'debtorUserId'),
      ),
    ).thenAnswer((_) async => 1);

    final context = tester.element(find.byType(SharePaidToMeDetailScreen));
    final label = S.of(context).sharePaidDetailAcknowledge;

    await tester.tap(find.text(label));
    await tester.pump();
    await tester.pumpAndSettle();

    verify(
      () => repo.markPaidReceivedViewedForDebtor(
        homeId: 'home-1',
        debtorUserId: 'debtor-1',
      ),
    ).called(1);
  });
}
