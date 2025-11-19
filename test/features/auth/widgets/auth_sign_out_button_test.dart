import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/features/auth/bloc/auth_bloc.dart';
import 'package:kinly/features/auth/widgets/auth_sign_out_button.dart';
import 'package:kinly/generated/l10n.dart';

class _MockAuthBloc extends MockBloc<AuthEvent, AuthState>
    implements AuthBloc {}

class _FakeAuthEvent extends Fake implements AuthEvent {}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeAuthEvent());
  });

  group('AuthSignOutButton', () {
    late _MockAuthBloc bloc;

    setUp(() {
      bloc = _MockAuthBloc();
    });

    Widget buildHarness() {
      return MaterialApp(
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: BlocProvider<AuthBloc>.value(
          value: bloc,
          child: Scaffold(appBar: AppBar(actions: const [AuthSignOutButton()])),
        ),
      );
    }

    testWidgets('dispatches AuthSignOutRequested when tapped', (tester) async {
      when(() => bloc.state).thenReturn(const AuthState());

      await tester.pumpWidget(buildHarness());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.logout));
      await tester.pump();

      verify(() => bloc.add(const AuthSignOutRequested())).called(1);
    });

    testWidgets('is disabled while auth bloc is loading', (tester) async {
      when(() => bloc.state).thenReturn(const AuthState(isLoading: true));

      await tester.pumpWidget(buildHarness());
      await tester.pumpAndSettle();

      final button = tester.widget<IconButton>(find.byType(IconButton));
      expect(button.onPressed, isNull);
      verifyNever(() => bloc.add(any<AuthEvent>()));
    });
  });
}
