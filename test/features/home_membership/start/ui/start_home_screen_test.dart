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

class _MockAuthBloc extends MockBloc<AuthEvent, AuthState>
    implements AuthBloc {}

class _MockStartHomeBloc extends MockBloc<StartHomeEvent, StartHomeState>
    implements StartHomeBloc {}

class _FakeAuthEvent extends Fake implements AuthEvent {}

class _FakeAuthState extends Fake implements AuthState {}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeAuthEvent());
    registerFallbackValue(_FakeAuthState());
    registerFallbackValue(const StartHomeCreateRequested());
    registerFallbackValue(const StartHomeState());
  });

  late _MockAuthBloc authBloc;
  late _MockStartHomeBloc startHomeBloc;

  setUp(() {
    authBloc = _MockAuthBloc();
    when(
      () => authBloc.stream,
    ).thenAnswer((_) => const Stream<AuthState>.empty());

    startHomeBloc = _MockStartHomeBloc();
    when(
      () => startHomeBloc.stream,
    ).thenAnswer((_) => const Stream<StartHomeState>.empty());
    when(() => startHomeBloc.state).thenReturn(const StartHomeState());
  });

  Widget buildApp() {
    return MaterialApp(
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

    expect(find.text("You haven't joined a home yet."), findsOneWidget);
  });

  testWidgets('shows message when membership status is active', (tester) async {
    when(() => authBloc.state).thenReturn(
      const AuthState(membershipStatus: AuthMembershipStatus.active),
    );

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.text("You're already part of a home."), findsOneWidget);
  });
}
