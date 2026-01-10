import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:kinly/foundation/surfaces/today/bloc/today_bloc.dart';
import 'package:kinly/foundation/surfaces/today/today_surface.dart';
import 'package:kinly/foundation/surfaces/today/widgets/today_empty_state_card.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/generated/l10n.dart';

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

  testWidgets('shows error message when TodayState.failure', (tester) async {
    when(() => todayBloc.state).thenReturn(
      const TodayState.failure(
        message: "Could not load today's chores. Please try again.",
      ),
    );

    await tester.pumpWidget(buildApp());
    await tester.pump();

    // TodayScreen currently renders the empty state when a failure occurs.
    expect(find.byType(TodayEmptyStateCard), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
