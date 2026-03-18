import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/contracts/personal_directory/models.dart';
import 'package:kinly/contracts/personal_directory/ports/personal_directory_repository.dart';
import 'package:kinly/features/share/share.dart';
import 'package:kinly/features/share/ui/share_detail_route_args.dart';
import 'package:kinly/features/share/ui/share_owed_detail_screen.dart';
import 'package:kinly/foundation/surfaces/today/domain/models.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/theme/kinly_sections.dart';
import 'package:kinly/core/theme/opacity.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/contracts/expenses/models.dart';
import 'package:kinly/core/ui/kinly_icons.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kinly/features/share/ui/share_owed_item_detail_screen.dart';

class _MockExpensesRepository extends Mock implements ExpensesRepository {}

class _MockPersonalDirectoryRepository extends Mock
    implements PersonalDirectoryRepository {}

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
    final personalDirectoryRepository = _MockPersonalDirectoryRepository();
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
    when(
      () => personalDirectoryRepository.getMemberBankAccount(
        targetUserId: any(named: 'targetUserId'),
      ),
    ).thenAnswer((_) async => null);

    final owed = TodayShareOwed(
      payerUserId: 'user-1',
      displayName: 'Alex',
      totalOwedCents: 5000,
      items: [
        TodayShareOwedItem(
          expenseId: 'exp-1',
          description: 'Groceries',
          amountCents: 2500,
          recurrenceEvery: null,
          recurrenceUnit: null,
          startDate: DateTime(2024, 1, 1),
        ),
        TodayShareOwedItem(
          expenseId: 'exp-2',
          description: 'Snacks',
          amountCents: 2500,
          recurrenceEvery: 1,
          recurrenceUnit: ExpenseRecurrenceUnit.week,
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
              preference: SectionColors(
                background: Colors.white,
                card: Colors.white,
                icon: Colors.blueGrey,
                accent: Colors.teal,
              ),
              shopping: SectionColors(
                background: Colors.white,
                card: Colors.white,
                icon: Colors.blueGrey,
                accent: Colors.blue,
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
                        personalDirectoryRepository: personalDirectoryRepository,
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
    final personalDirectoryRepository = _MockPersonalDirectoryRepository();
    when(
      () => repo.payMyDue(recipientUserId: any(named: 'recipientUserId')),
    ).thenThrow(Exception('boom'));
    when(
      () => personalDirectoryRepository.getMemberBankAccount(
        targetUserId: any(named: 'targetUserId'),
      ),
    ).thenAnswer((_) async => null);

    final owed = TodayShareOwed(
      payerUserId: 'user-1',
      displayName: 'Alex',
      totalOwedCents: 2500,
      items: [
        TodayShareOwedItem(
          expenseId: 'exp-1',
          description: 'Groceries',
          amountCents: 2500,
          recurrenceEvery: null,
          recurrenceUnit: null,
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
              preference: SectionColors(
                background: Colors.white,
                card: Colors.white,
                icon: Colors.blueGrey,
                accent: Colors.teal,
              ),
              shopping: SectionColors(
                background: Colors.white,
                card: Colors.white,
                icon: Colors.blueGrey,
                accent: Colors.blue,
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
          child: ShareOwedDetailScreen(
            owed: owed,
            expensesRepository: repo,
            personalDirectoryRepository: personalDirectoryRepository,
          ),
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

  testWidgets('shows icons and drill-through only for comments/photo items', (
    tester,
  ) async {
    final personalDirectoryRepository = _MockPersonalDirectoryRepository();
    when(
      () => personalDirectoryRepository.getMemberBankAccount(
        targetUserId: any(named: 'targetUserId'),
      ),
    ).thenAnswer((_) async => null);
    final owed = TodayShareOwed(
      payerUserId: 'user-1',
      displayName: 'Alex',
      totalOwedCents: 4500,
      items: [
        TodayShareOwedItem(
          expenseId: 'exp-1',
          description: 'Plain row',
          amountCents: 1500,
          recurrenceEvery: null,
          recurrenceUnit: null,
          startDate: DateTime(2024, 1, 1),
        ),
        TodayShareOwedItem(
          expenseId: 'exp-2',
          description: 'With comments',
          amountCents: 1500,
          recurrenceEvery: null,
          recurrenceUnit: null,
          startDate: DateTime(2024, 1, 2),
          notes: 'Remember to reimburse',
        ),
        TodayShareOwedItem(
          expenseId: 'exp-3',
          description: 'With photo',
          amountCents: 1500,
          recurrenceEvery: null,
          recurrenceUnit: null,
          startDate: DateTime(2024, 1, 3),
          evidencePhotoPath: 'https://example.com/photo.jpg',
        ),
      ],
    );
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder:
              (_, __) => MediaQuery(
                data: const MediaQueryData(disableAnimations: true),
                child: ShareOwedDetailScreen(
                  owed: owed,
                  expensesRepository: _MockExpensesRepository(),
                  personalDirectoryRepository: personalDirectoryRepository,
                ),
              ),
        ),
        GoRoute(
          path: '/share/owed-item-detail',
          name: AppRouteNames.shareOwedItemDetail,
          builder: (_, state) {
            final args = state.extra as ShareOwedItemDetailRouteArgs;
            return ShareOwedItemDetailScreen(item: args.item);
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

    await tester.pumpAndSettle();

    expect(find.byIcon(KinlyIcons.notesOutlined), findsOneWidget);
    expect(find.byIcon(KinlyIcons.photoCameraOutlined), findsOneWidget);
    expect(find.byIcon(KinlyIcons.chevronRight), findsNWidgets(2));

    await tester.tap(find.text('Plain row'));
    await tester.pumpAndSettle();
    expect(find.byType(ShareOwedItemDetailScreen), findsNothing);

    await tester.tap(find.text('With comments'));
    await tester.pumpAndSettle();
    expect(find.byType(ShareOwedItemDetailScreen), findsOneWidget);
    expect(find.text('Remember to reimburse'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('With photo'));
    await tester.pumpAndSettle();
    expect(find.byType(ShareOwedItemDetailScreen), findsOneWidget);
    final detailContext = tester.element(find.byType(ShareOwedItemDetailScreen));
    expect(
      find.text(S.of(detailContext).shoppingPhotoLabel),
      findsOneWidget,
    );
  });

  testWidgets('shows period label for recurring and one-time shares', (
    tester,
  ) async {
    final personalDirectoryRepository = _MockPersonalDirectoryRepository();
    when(
      () => personalDirectoryRepository.getMemberBankAccount(
        targetUserId: any(named: 'targetUserId'),
      ),
    ).thenAnswer((_) async => null);
    final owed = TodayShareOwed(
      payerUserId: 'user-1',
      displayName: 'Alex',
      totalOwedCents: 1500,
      items: [
        TodayShareOwedItem(
          expenseId: 'exp-1',
          description: 'Weekly groceries',
          amountCents: 1500,
          recurrenceEvery: 1,
          recurrenceUnit: ExpenseRecurrenceUnit.week,
          startDate: DateTime(2024, 1, 1),
        ),
        TodayShareOwedItem(
          expenseId: 'exp-2',
          description: 'One-off dinner',
          amountCents: 1500,
          recurrenceEvery: null,
          recurrenceUnit: null,
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
            personalDirectoryRepository: personalDirectoryRepository,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Applies to January 1 - 7, 2024'), findsOneWidget);
    expect(find.text('One time'), findsOneWidget);
  });

  testWidgets('payment reference prefers username when available', (
    tester,
  ) async {
    final personalDirectoryRepository = _MockPersonalDirectoryRepository();
    when(
      () => personalDirectoryRepository.getMemberBankAccount(
        targetUserId: any(named: 'targetUserId'),
      ),
    ).thenAnswer(
      (_) async => PersonalDirectoryBankAccount(
        id: 'bank-1',
        accountHolderName: 'Alex Doe',
        accountNumber: '12345678',
        createdAt: DateTime(2026, 3, 18),
        updatedAt: DateTime(2026, 3, 18),
      ),
    );

    final owed = TodayShareOwed(
      payerUserId: 'user-1',
      displayName: 'Alex Doe',
      username: 'alex',
      totalOwedCents: 2500,
      items: [
        TodayShareOwedItem(
          expenseId: 'exp-1',
          description: 'Groceries',
          amountCents: 2500,
          recurrenceEvery: null,
          recurrenceUnit: null,
          startDate: DateTime(2024, 1, 1),
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
            personalDirectoryRepository: personalDirectoryRepository,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('alex'), findsOneWidget);
    expect(find.text('Alex Doe'), findsNWidgets(2));
  });
}
