import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/core/chores/models.dart';
import 'package:kinly/features/flow/bloc/flow_chore_detail_bloc.dart';
import 'package:kinly/features/flow/ui/flow_chore_detail/flow_chore_detail_screen.dart';
import 'package:kinly/features/flow/ui/flow_chore_detail/widgets/flow_chore_detail_view.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/theme/kinly_sections.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../../support/fake_telemetry.dart';

class _MockFlowChoreDetailBloc
    extends MockBloc<FlowChoreDetailEvent, FlowChoreDetailState>
    implements FlowChoreDetailBloc {}

class _FakeFlowChoreDetailEvent extends Fake implements FlowChoreDetailEvent {}

class _FakeFlowChoreDetailState extends Fake implements FlowChoreDetailState {}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initializeDateFormatting('en');
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: 'https://example.supabase.co',
      anonKey: 'public-anon-key',
    );
    registerFallbackValue(_FakeFlowChoreDetailEvent());
    registerFallbackValue(_FakeFlowChoreDetailState());
  });

  final completionResult = ChoreCompletionResult(
    status: ChoreCompletionStatus.nonRecurringCompleted,
    choreId: 'chore-1',
    homeId: 'home-1',
    state: ChoreState.completed,
    recurrence: ChoreRecurrence.none,
    previousNextOccurrence: null,
    newNextOccurrence: null,
    stepsAdvanced: null,
  );

  testWidgets('emits telemetry when completion success state observed', (
    tester,
  ) async {
    final telemetry = FakeTelemetry();
    final bloc = _MockFlowChoreDetailBloc();
    final details = ChoreDetails(
      chore: Chore(
        id: 'chore-1',
        homeId: 'home-1',
        createdByUserId: 'owner',
        assigneeUserId: 'assignee',
        name: 'Wash dishes',
        startDate: DateTime.utc(2024, 1, 1),
        recurrence: ChoreRecurrence.none,
        recurrenceCursor: null,
        nextOccurrence: null,
        expectationPhotoPath: null,
        howToVideoUrl: null,
        notes: 'Use blue sponge',
        state: ChoreState.active,
        completedAt: null,
        createdAt: DateTime.utc(2024, 1, 1),
        updatedAt: DateTime.utc(2024, 1, 1),
      ),
      assignees: const [
        ChoreAssigneeSummary(userId: 'assignee', fullName: 'Jordan'),
      ],
    );

    final loadedState = const FlowChoreDetailState.initial().copyWith(
      isLoading: false,
      details: details,
    );
    final completedState = loadedState.copyWith(
      isLoading: false,
      completionResult: completionResult,
    );

    when(() => bloc.state).thenReturn(loadedState);
    whenListen(
      bloc,
      Stream<FlowChoreDetailState>.fromIterable([loadedState, completedState]),
      initialState: loadedState,
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
          ],
        ),
        home: BlocProvider<FlowChoreDetailBloc>.value(
          value: bloc,
          child: FlowChoreDetailScreen(telemetry: telemetry),
        ),
      ),
    );

    // Allow listener to react and overlay to render/dismiss.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1000));

    expect(telemetry.events.length, 1);
    expect(telemetry.events.single.name, 'dopamine_shown');
    expect(telemetry.events.single.properties['milestone'], 'flow');
  });

  testWidgets(
    'reduce motion path sets telemetry reduce_motion=true and no haptic',
    (tester) async {
      final telemetry = FakeTelemetry();
      final bloc = _MockFlowChoreDetailBloc();
      final details = ChoreDetails(
        chore: Chore(
          id: 'chore-2',
          homeId: 'home-1',
          createdByUserId: 'owner',
          assigneeUserId: 'assignee',
          name: 'Vacuum',
          startDate: DateTime.utc(2024, 1, 1),
          recurrence: ChoreRecurrence.none,
          recurrenceCursor: null,
          nextOccurrence: null,
          expectationPhotoPath: null,
          howToVideoUrl: null,
          notes: 'Hallway only',
          state: ChoreState.active,
          completedAt: null,
          createdAt: DateTime.utc(2024, 1, 1),
          updatedAt: DateTime.utc(2024, 1, 1),
        ),
        assignees: const [
          ChoreAssigneeSummary(userId: 'assignee', fullName: 'Casey'),
        ],
      );

      final loadedState = const FlowChoreDetailState.initial().copyWith(
        isLoading: false,
        details: details,
      );
      final completedState = loadedState.copyWith(
        isLoading: false,
        completionResult: completionResult,
      );

      when(() => bloc.state).thenReturn(loadedState);
      whenListen(
        bloc,
        Stream<FlowChoreDetailState>.fromIterable([
          loadedState,
          completedState,
        ]),
        initialState: loadedState,
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
            ],
          ),
          home: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: BlocProvider<FlowChoreDetailBloc>.value(
              value: bloc,
              child: FlowChoreDetailScreen(telemetry: telemetry),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1000));

      expect(telemetry.events.length, 1);
      final event = telemetry.events.single;
      expect(event.name, 'dopamine_shown');
      expect(event.properties['reduce_motion'], true);
      expect(event.properties['haptic_used'], false);
    },
  );

  testWidgets('completion error shows snackbar and no telemetry', (
    tester,
  ) async {
    final telemetry = FakeTelemetry();
    final bloc = _MockFlowChoreDetailBloc();
    final details = ChoreDetails(
      chore: Chore(
        id: 'chore-err',
        homeId: 'home-1',
        createdByUserId: 'owner',
        assigneeUserId: 'assignee',
        name: 'Mop',
        startDate: DateTime.utc(2024, 1, 1),
        recurrence: ChoreRecurrence.none,
        recurrenceCursor: null,
        nextOccurrence: null,
        expectationPhotoPath: null,
        howToVideoUrl: null,
        notes: '',
        state: ChoreState.active,
        completedAt: null,
        createdAt: DateTime.utc(2024, 1, 1),
        updatedAt: DateTime.utc(2024, 1, 1),
      ),
      assignees: const [],
    );
    final errorState = const FlowChoreDetailState.initial().copyWith(
      isLoading: false,
      details: details,
      completionErrorMessage: 'not allowed',
      completionErrorTick: 1,
    );

    when(() => bloc.state).thenReturn(errorState);
    whenListen(
      bloc,
      Stream<FlowChoreDetailState>.fromIterable([errorState]),
      initialState: errorState,
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
          ],
        ),
        home: BlocProvider<FlowChoreDetailBloc>.value(
          value: bloc,
          child: FlowChoreDetailScreen(telemetry: telemetry),
        ),
      ),
    );

    await tester.pump();
    expect(telemetry.events, isEmpty);
  });

  testWidgets(
    'hides start date and recurrence when active chore is assigned to current user',
    (tester) async {
      final details = ChoreDetails(
        chore: Chore(
          id: 'chore-3',
          homeId: 'home-1',
          createdByUserId: 'owner',
          assigneeUserId: 'user-123',
          name: 'Dust shelves',
          startDate: DateTime.utc(2024, 2, 1),
          recurrence: ChoreRecurrence.weekly,
          recurrenceCursor: null,
          nextOccurrence: null,
          expectationPhotoPath: null,
          howToVideoUrl: null,
          notes: '',
          state: ChoreState.active,
          completedAt: null,
          createdAt: DateTime.utc(2024, 1, 1),
          updatedAt: DateTime.utc(2024, 1, 1),
        ),
        assignees: const [],
      );
      final state = const FlowChoreDetailState.initial().copyWith(
        isLoading: false,
        details: details,
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
            ],
          ),
          home: Scaffold(
            body: FlowChoreDetailView(
              state: state,
              onRetry: () {},
              onComplete: null,
              completeButtonKey: GlobalKey(),
              currentUserId: 'user-123',
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.text(S.current.flowChoreStartLabel), findsNothing);
      expect(find.text(S.current.flowChoreRecurrenceLabel), findsNothing);
    },
  );

  testWidgets(
    'shows start date and recurrence when chore is not assigned to current user',
    (tester) async {
      final details = ChoreDetails(
        chore: Chore(
          id: 'chore-4',
          homeId: 'home-1',
          createdByUserId: 'owner',
          assigneeUserId: 'other-user',
          name: 'Clean fridge',
          startDate: DateTime.utc(2024, 2, 1),
          recurrence: ChoreRecurrence.weekly,
          recurrenceCursor: null,
          nextOccurrence: null,
          expectationPhotoPath: null,
          howToVideoUrl: null,
          notes: '',
          state: ChoreState.active,
          completedAt: null,
          createdAt: DateTime.utc(2024, 1, 1),
          updatedAt: DateTime.utc(2024, 1, 1),
        ),
        assignees: const [],
      );
      final state = const FlowChoreDetailState.initial().copyWith(
        isLoading: false,
        details: details,
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
            ],
          ),
          home: Scaffold(
            body: FlowChoreDetailView(
              state: state,
              onRetry: () {},
              onComplete: null,
              completeButtonKey: GlobalKey(),
              currentUserId: 'user-123',
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.text(S.current.flowChoreStartLabel), findsOneWidget);
      expect(find.text(S.current.flowChoreRecurrenceLabel), findsOneWidget);
    },
  );
}
