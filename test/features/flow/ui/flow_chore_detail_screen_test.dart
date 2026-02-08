import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/contracts/chores/models.dart';
import 'package:kinly/features/flow/bloc/flow_chore_detail_bloc.dart';
import 'package:kinly/features/flow/domain/flow_chore_outcome.dart';
import 'package:kinly/features/flow/ui/flow_chore_detail/flow_chore_detail_screen.dart';
import 'package:kinly/features/flow/ui/flow_chore_detail/widgets/flow_chore_detail_view.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/core/auth/bloc/auth_bloc.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/theme/kinly_sections.dart';
import 'package:kinly/core/theme/opacity.dart';
import 'package:kinly/core/supabase/storage_path_resolver.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';

class _MockFlowChoreDetailBloc
    extends MockBloc<FlowChoreDetailEvent, FlowChoreDetailState>
    implements FlowChoreDetailBloc {}

class _FakeFlowChoreDetailEvent extends Fake implements FlowChoreDetailEvent {}

class _FakeFlowChoreDetailState extends Fake implements FlowChoreDetailState {}

class _MockAuthBloc extends MockBloc<AuthEvent, AuthState>
    implements AuthBloc {}

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
    SharedPreferences.setMockInitialValues({});
    await supabase.Supabase.initialize(
      url: 'https://example.supabase.co',
      anonKey: 'public-anon-key',
    );
    final sl = GetIt.instance;
    if (!sl.isRegistered<StoragePathResolver>()) {
      sl.registerSingleton<StoragePathResolver>(
        StoragePathResolver(client: supabase.Supabase.instance.client),
      );
    }
    registerFallbackValue(_FakeFlowChoreDetailEvent());
    registerFallbackValue(_FakeFlowChoreDetailState());
  });

  final completionResult = ChoreCompletionResult(
    status: ChoreCompletionStatus.nonRecurringCompleted,
    choreId: 'chore-1',
    homeId: 'home-1',
    state: ChoreState.completed,
    recurrenceEvery: null,
    recurrenceUnit: null,
    previousNextOccurrence: null,
    newNextOccurrence: null,
    stepsAdvanced: null,
  );

  testWidgets('pops outcome when completion success state observed', (
    tester,
  ) async {
    final bloc = _MockFlowChoreDetailBloc();
    final details = ChoreDetails(
      chore: Chore(
        id: 'chore-1',
        homeId: 'home-1',
        createdByUserId: 'owner',
        assigneeUserId: 'assignee',
        name: 'Wash dishes',
        startDate: DateTime.utc(2024, 1, 1),
        recurrenceEvery: null,
        recurrenceUnit: null,
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

    final authBloc = _MockAuthBloc();
    when(() => authBloc.state).thenReturn(
      const AuthState(status: AuthStatus.authenticated, userId: 'user-1'),
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
                    (_) => MultiBlocProvider(
                      providers: [
                        BlocProvider<FlowChoreDetailBloc>.value(value: bloc),
                        BlocProvider<AuthBloc>.value(value: authBloc),
                      ],
                      child: const FlowChoreDetailScreen(),
                    ),
              ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final hostState = tester.state<_RouteHostState>(find.byType(_RouteHost));

    expect(hostState.poppedResult, isA<FlowChoreOutcome>());
    final outcome = hostState.poppedResult! as FlowChoreOutcome;
    expect(outcome.choreId, completionResult.choreId);
    expect(outcome.isCompleted, true);
  });

  testWidgets('completion error shows snackbar', (tester) async {
    final bloc = _MockFlowChoreDetailBloc();
    final details = ChoreDetails(
      chore: Chore(
        id: 'chore-err',
        homeId: 'home-1',
        createdByUserId: 'owner',
        assigneeUserId: 'assignee',
        name: 'Mop',
        startDate: DateTime.utc(2024, 1, 1),
        recurrenceEvery: null,
        recurrenceUnit: null,
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
    final loadedState = const FlowChoreDetailState.initial().copyWith(
      isLoading: false,
      details: details,
      completionErrorTick: 0,
    );
    final errorState = const FlowChoreDetailState.initial().copyWith(
      isLoading: false,
      details: details,
      completionErrorMessage: 'not allowed',
      completionErrorTick: 1,
    );

    when(() => bloc.state).thenReturn(loadedState);
    whenListen(
      bloc,
      Stream<FlowChoreDetailState>.fromIterable([loadedState, errorState]),
      initialState: loadedState,
    );
    final authBloc = _MockAuthBloc();
    when(() => authBloc.state).thenReturn(
      const AuthState(status: AuthStatus.authenticated, userId: 'user-1'),
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
        home: MultiBlocProvider(
          providers: [
            BlocProvider<FlowChoreDetailBloc>.value(value: bloc),
            BlocProvider<AuthBloc>.value(value: authBloc),
          ],
          child: const FlowChoreDetailScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('not allowed'), findsOneWidget);
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
          recurrenceEvery: 1,
          recurrenceUnit: ChoreRecurrenceUnit.week,
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
          home: Scaffold(
            body: FlowChoreDetailView(
              state: state,
              onRetry: () {},
              onComplete: null,
              completeButtonKey: GlobalKey(),
              currentUserId: 'user-123',
              storagePathResolver: StoragePathResolver(
                client: supabase.Supabase.instance.client,
              ),
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
          recurrenceEvery: 1,
          recurrenceUnit: ChoreRecurrenceUnit.week,
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
          home: Scaffold(
            body: FlowChoreDetailView(
              state: state,
              onRetry: () {},
              onComplete: null,
              completeButtonKey: GlobalKey(),
              currentUserId: 'user-123',
              storagePathResolver: StoragePathResolver(
                client: supabase.Supabase.instance.client,
              ),
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
