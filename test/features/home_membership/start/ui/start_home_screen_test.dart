import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/features/auth/bloc/auth_bloc.dart';
import 'package:kinly/features/home_membership/start/ui/start_home_screen.dart';
import 'package:kinly/features/home_membership/start/bloc/start_home_bloc.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/core/theme/kinly_theme.dart';
import 'package:kinly/contracts/auth/models/user_context.dart';
import 'package:kinly/contracts/auth/ports/user_context_repository.dart';
import 'package:kinly/core/di/locator.dart';
import 'package:kinly/core/links/join_intent_coordinator.dart';

class _MockAuthBloc extends MockBloc<AuthEvent, AuthState>
    implements AuthBloc {}

class _MockStartHomeBloc extends MockBloc<StartHomeEvent, StartHomeState>
    implements StartHomeBloc {}

class _MockJoinIntentCoordinator extends Mock
    implements JoinIntentCoordinator {}

class _FakeAuthEvent extends Fake implements AuthEvent {}

class _FakeAuthState extends Fake implements AuthState {}

class _FakeUserContextRepository implements UserContextRepository {
  @override
  Future<UserContext> fetch() async => const UserContext(
    userId: 'user-ctx',
    hasHome: false,
    activeHomeId: null,
    hasPreferenceReport: false,
    hasPersonalMentions: false,
    avatarUrl: null,
  );
}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeAuthEvent());
    registerFallbackValue(_FakeAuthState());
    registerFallbackValue(const StartHomeCreateRequested());
    registerFallbackValue(const StartHomeState());
  });

  late _MockAuthBloc authBloc;
  late _MockStartHomeBloc startHomeBloc;
  late _MockJoinIntentCoordinator joinCoordinator;

  setUp(() async {
    await sl.reset();
    sl.registerLazySingleton<UserContextRepository>(
      () => _FakeUserContextRepository(),
    );

    authBloc = _MockAuthBloc();
    when(
      () => authBloc.stream,
    ).thenAnswer((_) => const Stream<AuthState>.empty());

    startHomeBloc = _MockStartHomeBloc();
    when(
      () => startHomeBloc.stream,
    ).thenAnswer((_) => const Stream<StartHomeState>.empty());
    when(() => startHomeBloc.state).thenReturn(const StartHomeState());

    joinCoordinator = _MockJoinIntentCoordinator();
    sl.registerLazySingleton<JoinIntentCoordinator>(() => joinCoordinator);
  });

  tearDown(() async {
    await sl.reset();
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
      home: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>.value(value: authBloc),
          BlocProvider<StartHomeBloc>.value(value: startHomeBloc),
        ],
        child: const StartHomeScreen(),
      ),
    );
  }

  testWidgets('shows message when user has no membership', (tester) async {
    when(
      () => authBloc.state,
    ).thenReturn(const AuthState(membershipStatus: AuthMembershipStatus.none));

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    final s = S.of(tester.element(find.byType(StartHomeScreen)));
    expect(find.text(s.membership_status_none), findsOneWidget);
  });

  testWidgets('shows message when membership status is active', (tester) async {
    when(() => authBloc.state).thenReturn(
      const AuthState(membershipStatus: AuthMembershipStatus.active),
    );

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    final s = S.of(tester.element(find.byType(StartHomeScreen)));
    expect(find.text(s.membership_status_active), findsOneWidget);
  });

  testWidgets('disables create/join buttons when membership not none', (
    tester,
  ) async {
    when(() => authBloc.state).thenReturn(
      const AuthState(membershipStatus: AuthMembershipStatus.active),
    );

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    final s = S.of(tester.element(find.byType(StartHomeScreen)));
    final createButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, s.welcome_create),
    );
    final joinButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, s.welcome_join),
    );
    expect(createButton.onPressed, isNull);
    expect(joinButton.onPressed, isNull);
  });

  testWidgets('enables buttons when membership status is none', (tester) async {
    when(
      () => authBloc.state,
    ).thenReturn(const AuthState(membershipStatus: AuthMembershipStatus.none));

    await tester.pumpWidget(buildApp());
    await tester.pump();

    final s = S.of(tester.element(find.byType(StartHomeScreen)));
    final createButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, s.welcome_create),
    );
    final joinButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, s.welcome_join),
    );
    expect(createButton.onPressed, isNotNull);
    expect(joinButton.onPressed, isNotNull);
  });
}
