import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinly/core/chores/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinly/features/flow/bloc/flow_list_bloc.dart';
import 'package:kinly/features/flow/ui/flow_list_filter.dart';
import 'package:kinly/features/flow/ui/flow_list_screen.dart';
import 'package:mocktail/mocktail.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/core/theme/opacity.dart';

class _MockFlowListBloc extends MockBloc<FlowListEvent, FlowListState>
    implements FlowListBloc {}

void main() {
  setUpAll(() {
    registerFallbackValue(const FlowListRequested());
  });

  late _MockFlowListBloc bloc;

  setUp(() {
    bloc = _MockFlowListBloc();
  });

  Widget buildTestApp(Widget child) {
    return MaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: ThemeData.light().copyWith(
        extensions: const <ThemeExtension<dynamic>>[KinlyOpacity.defaults],
      ),
      home: child,
    );
  }

  testWidgets('filters active list to current user when scope is mine', (
    tester,
  ) async {
    final now = DateTime.now();
    final mine = ChoreListEntry(
      id: 'mine-1',
      homeId: 'home-1',
      name: 'My chore',
      startDate: now.subtract(const Duration(days: 1)),
      assigneeUserId: 'user-123',
    );
    final other = ChoreListEntry(
      id: 'other-1',
      homeId: 'home-1',
      name: 'Other chore',
      startDate: now.subtract(const Duration(days: 1)),
      assigneeUserId: 'user-999',
    );
    final draft = ChoreListEntry(
      id: 'draft-1',
      homeId: 'home-1',
      name: 'Draft chore',
      startDate: now.subtract(const Duration(days: 1)),
      assigneeUserId: null,
    );
    final state = FlowListState(
      status: FlowListStatus.success,
      items: [mine, other, draft],
    );

    when(() => bloc.state).thenReturn(state);
    whenListen(
      bloc,
      Stream<FlowListState>.fromIterable([state]),
      initialState: state,
    );

    await tester.pumpWidget(
      buildTestApp(
        BlocProvider<FlowListBloc>.value(
          value: bloc,
          child: const FlowListScreen(
            filter: FlowListFilter.active,
            currentUserId: 'user-123',
            showOnlyCurrentUser: true,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('My chore'), findsOneWidget);
    expect(find.text('Other chore'), findsNothing);
    // Drafts are excluded from the active filter even before scoping.
    expect(find.text('Draft chore'), findsNothing);
  });

  testWidgets('shows drafts regardless of scope when viewing drafts filter', (
    tester,
  ) async {
    final now = DateTime.now();
    final draft = ChoreListEntry(
      id: 'draft-1',
      homeId: 'home-1',
      name: 'Draft chore',
      startDate: now.subtract(const Duration(days: 1)),
      assigneeUserId: null,
    );
    final state = FlowListState(status: FlowListStatus.success, items: [draft]);

    when(() => bloc.state).thenReturn(state);
    whenListen(
      bloc,
      Stream<FlowListState>.fromIterable([state]),
      initialState: state,
    );

    await tester.pumpWidget(
      buildTestApp(
        BlocProvider<FlowListBloc>.value(
          value: bloc,
          child: const FlowListScreen(
            filter: FlowListFilter.drafts,
            currentUserId: 'user-123',
            showOnlyCurrentUser: true,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Draft chore'), findsOneWidget);
  });
}
