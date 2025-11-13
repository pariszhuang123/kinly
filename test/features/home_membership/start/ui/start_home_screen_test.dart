import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/features/auth/bloc/auth_bloc.dart';
import 'package:kinly/features/home_membership/start/ui/start_home_screen.dart';
import 'package:kinly/generated/l10n.dart';

class _MockAuthBloc extends MockBloc<AuthEvent, AuthState>
    implements AuthBloc {}

class _FakeAuthEvent extends Fake implements AuthEvent {}

class _FakeAuthState extends Fake implements AuthState {}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeAuthEvent());
    registerFallbackValue(_FakeAuthState());
  });

  late _MockAuthBloc authBloc;

  setUp(() {
    authBloc = _MockAuthBloc();
    when(
      () => authBloc.stream,
    ).thenAnswer((_) => const Stream<AuthState>.empty());
  });

  Widget _buildApp() {
    return MaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: BlocProvider<AuthBloc>.value(
        value: authBloc,
        child: const StartHomeScreen(),
      ),
    );
  }

  testWidgets('shows message when user has no membership', (tester) async {
    when(
      () => authBloc.state,
    ).thenReturn(const AuthState(membershipStatus: AuthMembershipStatus.none));

    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();

    expect(find.text('You haven’t joined a home yet.'), findsOneWidget);
  });

  testWidgets('shows message when membership status is active', (tester) async {
    when(() => authBloc.state).thenReturn(
      const AuthState(membershipStatus: AuthMembershipStatus.active),
    );

    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();

    expect(find.text('You’re already part of a home.'), findsOneWidget);
  });
}
