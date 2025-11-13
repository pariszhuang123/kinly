import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/core/homes/models.dart';
import 'package:kinly/features/auth/bloc/auth_bloc.dart';
import 'package:kinly/features/today/ui/today_screen.dart';
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
        child: const TodayScreen(),
      ),
    );
  }

  testWidgets('shows no membership message when user has none', (tester) async {
    when(
      () => authBloc.state,
    ).thenReturn(const AuthState(membershipStatus: AuthMembershipStatus.none));

    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();

    expect(
      find.text('No active home yet. Create or join to see today’s view.'),
      findsOneWidget,
    );
  });

  testWidgets('shows membership details when active', (tester) async {
    when(() => authBloc.state).thenReturn(
      AuthState(
        status: AuthStatus.authenticated,
        membershipStatus: AuthMembershipStatus.active,
        membership: CurrentMembership(
          userId: 'user-1',
          homeId: 'home-42',
          role: 'member',
          validFrom: DateTime.utc(2025, 1, 1),
        ),
      ),
    );

    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();

    expect(find.text('Current home: home-42 • Role: member'), findsOneWidget);
  });
}
