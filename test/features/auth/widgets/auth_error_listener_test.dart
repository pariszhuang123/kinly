import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/features/auth/bloc/auth_bloc.dart';
import 'package:kinly/features/auth/widgets/auth_error_listener.dart';

class _MockAuthBloc extends MockBloc<AuthEvent, AuthState>
    implements AuthBloc {}

class _FakeAuthEvent extends Fake implements AuthEvent {}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeAuthEvent());
  });

  group('AuthErrorListener', () {
    late _MockAuthBloc bloc;

    setUp(() {
      bloc = _MockAuthBloc();
    });

    testWidgets(
      'shows SnackBar and clears error when state exposes errorMessage',
      (tester) async {
        when(() => bloc.state).thenReturn(const AuthState());
        whenListen(
          bloc,
          Stream<AuthState>.fromIterable(
            const [AuthState(errorMessage: 'Boom')],
          ),
          initialState: const AuthState(),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider<AuthBloc>.value(
              value: bloc,
              child: const AuthErrorListener(
                child: Scaffold(body: SizedBox()),
              ),
            ),
          ),
        );

        await tester.pump(); // allow listener to process stream event

        expect(find.text('Boom'), findsOneWidget);
        verify(() => bloc.add(const AuthErrorCleared())).called(1);
      },
    );

    testWidgets(
      'does nothing when errorMessage is null',
      (tester) async {
        when(() => bloc.state).thenReturn(const AuthState());
        whenListen(
          bloc,
          const Stream<AuthState>.empty(),
          initialState: const AuthState(),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider<AuthBloc>.value(
              value: bloc,
              child: const AuthErrorListener(
                child: Scaffold(body: SizedBox()),
              ),
            ),
          ),
        );

        await tester.pump();

        expect(find.byType(SnackBar), findsNothing);
        verifyNever(() => bloc.add(any<AuthEvent>()));
      },
    );
  });
}
