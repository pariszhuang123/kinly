import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/core/chores/models.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/features/today/bloc/today_bloc.dart';
import 'package:kinly/features/today/domain/models.dart';
import 'package:kinly/features/today/ui/today_screen.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/features/today/ui/widgets/today_empty_state_card.dart';
import 'package:kinly/core/ui/kinly_loader.dart';

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
    when(() => todayBloc.state).thenReturn(const TodayState.loading());
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
        shareDrafts: [],
      ),
    );

    await tester.pumpWidget(buildApp());
    await tester.pump();

    expect(find.byType(TodayEmptyStateCard), findsOneWidget);
  });
}
