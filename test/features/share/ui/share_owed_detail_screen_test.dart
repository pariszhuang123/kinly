import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/features/share/share.dart';
import 'package:kinly/features/share/ui/share_owed_detail_screen.dart';
import 'package:kinly/foundation/surfaces/today/domain/models.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/theme/kinly_sections.dart';
import 'package:kinly/core/theme/opacity.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/contracts/expenses/models.dart';
import 'package:intl/date_symbol_data_local.dart';

class _MockExpensesRepository extends Mock implements ExpensesRepository {}

class _RouteHost extends StatefulWidget {
  const _RouteHost({required this.buildRoute});

  final Route<Object?> Function(BuildContext context) buildRoute;

  @override
  State<_RouteHost> createState() => _RouteHostState();
}

class _RouteHostState extends State<_RouteHost> {
  Object? poppedResult;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final result = await Navigator.of(
        context,
      ).push<Object?>(widget.buildRoute(context));
      if (!mounted) return;
      setState(() => poppedResult = result);
    });
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initializeDateFormatting('en');
  });

  testWidgets('marks paid pops true and calls repository', (tester) async {
    final repo = _MockExpensesRepository();
    when(
      () => repo.payMyDue(recipientUserId: any(named: 'recipientUserId')),
    ).thenAnswer(
      (_) async => ExpensesPayMyDueResult(
        recipientUserId: 'user-1',
        splitsPaid: 2,
        expensesTouched: 2,
        expensesNewlyFullyPaid: 1,
      ),
    );

    final owed = TodayShareOwed(
      payerUserId: 'user-1',
      displayName: 'Alex',
      totalOwedCents: 5000,
      items: [
        TodayShareOwedItem(
          expenseId: 'exp-1',
          description: 'Groceries',
          amountCents: 2500,
          recurrenceInterval: ExpenseRecurrenceInterval.none,
          startDate: DateTime(2024, 1, 1),
        ),
        TodayShareOwedItem(
          expenseId: 'exp-2',
          description: 'Snacks',
          amountCents: 2500,
          recurrenceInterval: ExpenseRecurrenceInterval.weekly,
          startDate: DateTime(2024, 1, 8),
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [S.delegate],
        supportedLocales: S.delegate.supportedLocales,
        theme: ThemeData.light().copyWith(
          extensions: [
            const Spacing(
              xxs: 2,
              xs: 4,
              s: 8,
              m: 12,
              l: 16,
              xl: 24,
              xxl: 32,
              xxxl: 40,
            ),
            KinlySections(
              flow: SectionColors(
                background: Colors.white,
                card: Colors.white,
                icon: Colors.blueGrey,
                accent: Colors.teal,
              ),
              share: SectionColors(
                background: Colors.white,
                card: Colors.white,
                icon: Colors.blueGrey,
                accent: Colors.orange,
              ),
              pulse: SectionColors(
                background: Colors.white,
                card: Colors.white,
                icon: Colors.red,
                accent: Colors.pink,
              ),
              empty: const SectionColors(
                background: Colors.white,
                card: Colors.white,
                icon: Colors.grey,
                accent: Colors.grey,
              ),
            ),
            KinlyOpacity.defaults,
          ],
        ),
        home: _RouteHost(
          buildRoute:
              (_) => MaterialPageRoute<Object?>(
                builder:
                    (_) => MediaQuery(
                      data: const MediaQueryData(disableAnimations: true),
                      child: ShareOwedDetailScreen(
                        owed: owed,
                        expensesRepository: repo,
                      ),
                    ),
              ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    final context = tester.element(find.byType(ShareOwedDetailScreen));
    final label = S.of(context).shareOwedDetailPaid;

    await tester.tap(find.text(label));
    await tester.pump();
    await tester.pumpAndSettle();

    verify(() => repo.payMyDue(recipientUserId: 'user-1')).called(1);

    final hostState = tester.state<_RouteHostState>(find.byType(_RouteHost));
    expect(hostState.poppedResult, true);
  });

  testWidgets('error path shows message on failure', (tester) async {
    final repo = _MockExpensesRepository();
    when(
      () => repo.payMyDue(recipientUserId: any(named: 'recipientUserId')),
    ).thenThrow(Exception('boom'));

    final owed = TodayShareOwed(
      payerUserId: 'user-1',
      displayName: 'Alex',
      totalOwedCents: 2500,
      items: [
        TodayShareOwedItem(
          expenseId: 'exp-1',
          description: 'Groceries',
          amountCents: 2500,
          recurrenceInterval: ExpenseRecurrenceInterval.none,
          startDate: DateTime(2024, 1, 1),
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [S.delegate],
        supportedLocales: S.delegate.supportedLocales,
        theme: ThemeData.light().copyWith(
          extensions: [
            const Spacing(
              xxs: 2,
              xs: 4,
              s: 8,
              m: 12,
              l: 16,
              xl: 24,
              xxl: 32,
              xxxl: 40,
            ),
            KinlySections(
              flow: SectionColors(
                background: Colors.white,
                card: Colors.white,
                icon: Colors.blueGrey,
                accent: Colors.teal,
              ),
              share: SectionColors(
                background: Colors.white,
                card: Colors.white,
                icon: Colors.blueGrey,
                accent: Colors.orange,
              ),
              pulse: SectionColors(
                background: Colors.white,
                card: Colors.white,
                icon: Colors.red,
                accent: Colors.pink,
              ),
              empty: const SectionColors(
                background: Colors.white,
                card: Colors.white,
                icon: Colors.grey,
                accent: Colors.grey,
              ),
            ),
            KinlyOpacity.defaults,
          ],
        ),
        home: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: ShareOwedDetailScreen(owed: owed, expensesRepository: repo),
        ),
      ),
    );

    await tester.pumpAndSettle();
    final context = tester.element(find.byType(ShareOwedDetailScreen));
    final label = S.of(context).shareOwedDetailPaid;

    await tester.tap(find.text(label));
    await tester.pumpAndSettle();

    expect(find.text(S.of(context).shareOwedDetailError), findsOneWidget);
  });

  testWidgets('notes toggle uses onSurface color in dark theme for contrast', (
    tester,
  ) async {
    final owed = TodayShareOwed(
      payerUserId: 'user-1',
      displayName: 'Alex',
      totalOwedCents: 1500,
      items: [
        TodayShareOwedItem(
          expenseId: 'exp-1',
          description: 'Snacks',
          amountCents: 1500,
          recurrenceInterval: ExpenseRecurrenceInterval.none,
          startDate: DateTime(2024, 1, 1),
          notes: 'Remember to reimburse',
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: buildKinlyTheme(Brightness.dark),
        localizationsDelegates: const [S.delegate],
        supportedLocales: S.delegate.supportedLocales,
        home: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: ShareOwedDetailScreen(
            owed: owed,
            expensesRepository: _MockExpensesRepository(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final iconFinder = find.byIcon(Icons.expand_more_rounded);
    expect(iconFinder, findsOneWidget);

    final icon = tester.widget<Icon>(iconFinder);
    final context = tester.element(find.byType(ShareOwedDetailScreen));
    final onSurface = Theme.of(context).colorScheme.onSurface;

    expect(icon.color, onSurface);
  });

  testWidgets('shows period label for recurring and one-time shares', (
    tester,
  ) async {
    final owed = TodayShareOwed(
      payerUserId: 'user-1',
      displayName: 'Alex',
      totalOwedCents: 1500,
      items: [
        TodayShareOwedItem(
          expenseId: 'exp-1',
          description: 'Weekly groceries',
          amountCents: 1500,
          recurrenceInterval: ExpenseRecurrenceInterval.weekly,
          startDate: DateTime(2024, 1, 1),
        ),
        TodayShareOwedItem(
          expenseId: 'exp-2',
          description: 'One-off dinner',
          amountCents: 1500,
          recurrenceInterval: ExpenseRecurrenceInterval.none,
          startDate: DateTime(2024, 1, 8),
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: buildKinlyTheme(Brightness.light),
        localizationsDelegates: const [S.delegate],
        supportedLocales: S.delegate.supportedLocales,
        home: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: ShareOwedDetailScreen(
            owed: owed,
            expensesRepository: _MockExpensesRepository(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Applies to January 1 - 7, 2024'), findsOneWidget);
    expect(find.text('One time'), findsOneWidget);
  });
}

