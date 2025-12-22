import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/data/repositories/expenses_repository.dart';
import 'package:kinly/features/share/ui/share_paid_to_me_detail_screen.dart';
import 'package:kinly/features/today/domain/models.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/core/theme/kinly_theme.dart';

class _MockExpensesRepository extends Mock implements ExpensesRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('loads detail, marks viewed, and renders items', (tester) async {
    final repo = _MockExpensesRepository();
    when(
      () => repo.markPaidReceivedViewedForDebtor(
        homeId: any(named: 'homeId'),
        debtorUserId: any(named: 'debtorUserId'),
      ),
    ).thenAnswer((_) async => 1);
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
    verify(
      () => repo.markPaidReceivedViewedForDebtor(
        homeId: 'home-1',
        debtorUserId: 'debtor-1',
      ),
    ).called(1);
    verify(
      () =>
          repo.listPaidToMeByDebtor(homeId: 'home-1', debtorUserId: 'debtor-1'),
    ).called(1);
  });
}
