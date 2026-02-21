import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/features/share/share.dart';
import 'package:kinly/features/share/ui/share_detail_route_args.dart';
import 'package:kinly/features/share/ui/share_paid_item_detail_screen.dart';
import 'package:kinly/features/share/ui/share_paid_to_me_detail_screen.dart';
import 'package:kinly/foundation/surfaces/today/domain/models.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/contracts/expenses/models.dart';
import 'package:kinly/core/ui/kinly_icons.dart';
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

  testWidgets('shows icons and drill-through only when comments/photo exist', (
    tester,
  ) async {
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
          description: 'Plain paid item',
          amountCents: 1200,
          markedPaidAt: DateTime.now(),
          recurrenceEvery: null,
          recurrenceUnit: null,
          startDate: DateTime(2024, 1, 1),
          notes: null,
          evidencePhotoPath: null,
        ),
        ExpensePaidToMeItem(
          expenseId: 'e2',
          description: 'With note',
          amountCents: 1800,
          markedPaidAt: DateTime.now(),
          recurrenceEvery: null,
          recurrenceUnit: null,
          startDate: DateTime(2024, 1, 2),
          notes: 'Settled at table',
          evidencePhotoPath: null,
        ),
      ],
    );

    final entry = TodaySharePaidToMe(
      debtorUserId: 'debtor-1',
      debtorUsername: 'Jamie',
      totalPaidCents: 3000,
      unseenCount: 1,
      latestPaidAt: DateTime.now(),
    );
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder:
              (_, __) => SharePaidToMeDetailScreen(
                entry: entry,
                homeId: 'home-1',
                expensesRepository: repo,
              ),
        ),
        GoRoute(
          path: '/share/paid-item-detail',
          name: AppRouteNames.sharePaidItemDetail,
          builder: (_, state) {
            final args = state.extra as SharePaidItemDetailRouteArgs;
            return SharePaidItemDetailScreen(item: args.item);
          },
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(
        theme: buildKinlyTheme(Brightness.light),
        localizationsDelegates: const [S.delegate],
        supportedLocales: S.delegate.supportedLocales,
        routerConfig: router,
      ),
    );

    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.byIcon(KinlyIcons.notesOutlined), findsOneWidget);
    expect(find.byIcon(KinlyIcons.photoCameraOutlined), findsNothing);
    expect(find.byIcon(KinlyIcons.chevronRight), findsOneWidget);

    await tester.tap(find.text('Plain paid item'));
    await tester.pumpAndSettle();
    expect(find.byType(SharePaidItemDetailScreen), findsNothing);

    await tester.tap(find.text('With note'));
    await tester.pumpAndSettle();
    expect(find.byType(SharePaidItemDetailScreen), findsOneWidget);
    expect(find.text('Settled at table'), findsOneWidget);
  });
}
