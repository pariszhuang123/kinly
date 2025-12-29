import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/core/chores/models.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/features/today/bloc/today_bloc.dart';
import 'package:kinly/features/today/domain/models.dart';
import 'package:kinly/features/today/ui/today_screen.dart';
import 'package:kinly/features/today/ui/widgets/today_header/today_header.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/features/today/ui/widgets/today_empty_state_card.dart';
import 'package:kinly/core/ui/kinly_loader.dart';
import 'package:kinly/core/expenses/enums/expense_recurrence_interval.dart';

class _MockTodayBloc extends MockBloc<TodayEvent, TodayState>
    implements TodayBloc {}

class _FakeTodayEvent extends Fake implements TodayEvent {}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeTodayEvent());
    registerFallbackValue(const TodayState.loading());
  });

  late _MockTodayBloc todayBloc;

  setUp(() {
    todayBloc = _MockTodayBloc();
    when(
      () => todayBloc.stream,
    ).thenAnswer((_) => const Stream<TodayState>.empty());
    when(
      () => todayBloc.state,
    ).thenReturn(const TodayState.loading(harmonyPromptTick: 0));
  });

  Widget buildApp() {
    return MaterialApp(
      theme: buildKinlyTheme(Brightness.light),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: BlocProvider<TodayBloc>.value(
        value: todayBloc,
        child: const TodayScreen(),
      ),
    );
  }

  testWidgets('shows loading indicator while state is loading', (tester) async {
    when(() => todayBloc.state).thenReturn(const TodayState.loading());

    await tester.pumpWidget(buildApp());
    await tester.pump();

    expect(find.byType(KinlyLoader), findsWidgets);
  });

  testWidgets('renders Flow section when tasks are available', (tester) async {
    when(() => todayBloc.state).thenReturn(
      TodayState.loaded(
        activeTasks: const [
          TodayFlowTask(
            id: '1',
            title: 'Take out trash',
            state: ChoreState.active,
          ),
        ],
        draftTasks: const [],
        shareOwed: const [],
        sharePaidToMe: const [],
        shareDrafts: const [],
      ),
    );

    await tester.pumpWidget(buildApp());
    await tester.pump();

    expect(find.text('Take out trash'), findsOneWidget);
  });

  testWidgets('shows empty state card when no tasks', (tester) async {
    when(() => todayBloc.state).thenReturn(
      const TodayState.loaded(
        activeTasks: [],
        draftTasks: [],
        shareOwed: [],
        sharePaidToMe: [],
        shareDrafts: [],
      ),
    );

    await tester.pumpWidget(buildApp());
    await tester.pump();

    expect(find.byType(TodayEmptyStateCard), findsOneWidget);
  });

  testWidgets('plays confetti when transitioning from tasks to caught up', (
    tester,
  ) async {
    final streamController = StreamController<TodayState>.broadcast();
    addTearDown(streamController.close);
    when(() => todayBloc.stream).thenAnswer((_) => streamController.stream);
    when(() => todayBloc.state).thenReturn(const TodayState.loading());

    await tester.pumpWidget(buildApp());
    await tester.pump();

    streamController.add(
      TodayState.loaded(
        activeTasks: const [
          TodayFlowTask(id: '1', title: 'Task', state: ChoreState.active),
        ],
        draftTasks: const [],
        shareOwed: const [],
        sharePaidToMe: const [],
        shareDrafts: const [],
      ),
    );
    await tester.pump();

    streamController.add(
      const TodayState.loaded(
        activeTasks: [],
        draftTasks: [],
        shareOwed: [],
        sharePaidToMe: [],
        shareDrafts: [],
      ),
    );
    await tester.pump();

    final confetti = tester.widget<ConfettiWidget>(find.byType(ConfettiWidget));
    expect(confetti.confettiController.state, ConfettiControllerState.playing);
  });

  testWidgets('does not play confetti when already caught up', (tester) async {
    final streamController = StreamController<TodayState>.broadcast();
    addTearDown(streamController.close);
    when(() => todayBloc.stream).thenAnswer((_) => streamController.stream);
    when(() => todayBloc.state).thenReturn(const TodayState.loading());

    await tester.pumpWidget(buildApp());
    await tester.pump();

    streamController.add(
      const TodayState.loaded(
        activeTasks: [],
        draftTasks: [],
        shareOwed: [],
        sharePaidToMe: [],
        shareDrafts: [],
      ),
    );
    await tester.pump();

    final confetti = tester.widget<ConfettiWidget>(find.byType(ConfettiWidget));
    expect(confetti.confettiController.state, ConfettiControllerState.stopped);
  });

  testWidgets('keeps header fixed while cards scroll', (tester) async {
    await tester.binding.setSurfaceSize(const Size(375, 600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    when(() => todayBloc.state).thenReturn(
      TodayState.loaded(
        activeTasks: const [
          TodayFlowTask(
            id: '1',
            title: 'Take out trash',
            state: ChoreState.active,
          ),
        ],
        draftTasks: const [],
        shareOwed: List.generate(
          25,
          (i) => TodayShareOwed(
            payerUserId: 'payer_$i',
            displayName: 'Payer $i',
            totalOwedCents: 1234,
            items: [
              TodayShareOwedItem(
                expenseId: 'e1',
                description: 'Test expense',
                amountCents: 1234,
                recurrenceInterval: ExpenseRecurrenceInterval.none,
                startDate: DateTime(2024, 1, 1),
              ),
            ],
          ),
        ),
        sharePaidToMe: const [],
        shareDrafts: const [],
        profile: const TodayUserProfile(userId: 'u1', username: 'Alex'),
      ),
    );

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    final headerFinder = find.byType(TodayHeader);
    expect(headerFinder, findsOneWidget);

    final listItemFinder = find.text('Payer 0');
    expect(listItemFinder, findsOneWidget);

    final headerTopBefore = tester.getTopLeft(headerFinder).dy;
    final listItemTopBefore = tester.getTopLeft(listItemFinder).dy;

    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -400),
    );
    await tester.pumpAndSettle();

    final headerTopAfter = tester.getTopLeft(headerFinder).dy;
    final listItemTopAfter = tester.getTopLeft(listItemFinder).dy;

    expect(headerTopAfter, closeTo(headerTopBefore, 0.5));
    expect(listItemTopAfter, lessThan(listItemTopBefore - 20));
  });
}
