import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinly/features/auth/bloc/auth_bloc.dart';
import 'package:kinly/data/repositories/auth_repository.dart';
import 'package:kinly/data/repositories/home_repository.dart';
import 'package:kinly/core/homes/models.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockHomeRepository extends Mock implements HomeRepository {}

void main() {
  late _MockAuthRepository authRepository;
  late _MockHomeRepository homeRepository;
  late StreamController<AuthSession?> sessionController;

  setUp(() {
    authRepository = _MockAuthRepository();
    homeRepository = _MockHomeRepository();
    sessionController = StreamController<AuthSession?>.broadcast();
    when(
      () => authRepository.session$,
    ).thenAnswer((_) => sessionController.stream);
    when(() => authRepository.current).thenReturn(null);
  });

  tearDown(() async {
    await sessionController.close();
  });

  AuthBloc buildBloc() =>
      AuthBloc(authRepository: authRepository, homeRepository: homeRepository);

  blocTest<AuthBloc, AuthState>(
    'emits unauthenticated state when repository reports no session on start',
    build: () => buildBloc(),
    expect:
        () => const [
          AuthState(
            status: AuthStatus.unauthenticated,
            membershipStatus: AuthMembershipStatus.none,
          ),
        ],
  );

  blocTest<AuthBloc, AuthState>(
    'transitions to authenticated state and loads membership when session arrives',
    build: () {
      when(() => homeRepository.getCurrentMembership()).thenAnswer(
        (_) async => CurrentMembership(
          userId: '123',
          homeId: 'home-1',
          role: 'owner',
          validFrom: DateTime.utc(2024, 1, 1),
        ),
      );
      return buildBloc();
    },
    act: (bloc) => sessionController.add(const AuthSession(userId: '123')),
    expect:
        () => [
          const AuthState(
            status: AuthStatus.unauthenticated,
            membershipStatus: AuthMembershipStatus.none,
          ),
          const AuthState(
            status: AuthStatus.authenticated,
            userId: '123',
            membershipStatus: AuthMembershipStatus.unknown,
          ),
          predicate<AuthState>(
            (state) =>
                state.status == AuthStatus.authenticated &&
                state.membershipStatus == AuthMembershipStatus.active &&
                state.membership?.homeId == 'home-1' &&
                state.membership?.role == 'owner',
          ),
        ],
    verify: (_) {
      verify(() => homeRepository.getCurrentMembership()).called(1);
    },
  );

  blocTest<AuthBloc, AuthState>(
    'retries when membership is null immediately after sign-in',
    build: () {
      var calls = 0;
      when(() => homeRepository.getCurrentMembership()).thenAnswer((_) async {
        if (calls == 0) {
          calls++;
          return null;
        }
        return CurrentMembership(
          userId: 'user-4',
          homeId: 'home-4',
          role: 'member',
          validFrom: DateTime.utc(2025, 2, 1),
        );
      });
      return buildBloc();
    },
    act: (bloc) => sessionController.add(const AuthSession(userId: 'user-4')),
    wait: const Duration(milliseconds: 600),
    expect:
        () => [
          const AuthState(
            status: AuthStatus.unauthenticated,
            membershipStatus: AuthMembershipStatus.none,
          ),
          const AuthState(
            status: AuthStatus.authenticated,
            userId: 'user-4',
            membershipStatus: AuthMembershipStatus.unknown,
          ),
          predicate<AuthState>(
            (state) =>
                state.status == AuthStatus.authenticated &&
                state.membershipStatus == AuthMembershipStatus.active &&
                state.membership?.homeId == 'home-4',
          ),
        ],
    verify: (_) {
      verify(() => homeRepository.getCurrentMembership()).called(2);
    },
  );

  blocTest<AuthBloc, AuthState>(
    'surfaces errors when Google sign-in fails',
    build: () {
      when(
        () => authRepository.signInWithGoogle(),
      ).thenThrow(Exception('boom'));
      return buildBloc();
    },
    act: (bloc) => bloc.add(const AuthSignInWithGoogleRequested()),
    expect:
        () => [
          const AuthState(
            status: AuthStatus.unauthenticated,
            membershipStatus: AuthMembershipStatus.none,
          ),
          const AuthState(
            status: AuthStatus.unauthenticated,
            membershipStatus: AuthMembershipStatus.none,
            isLoading: true,
          ),
          predicate<AuthState>(
            (state) =>
                state.isLoading == false &&
                state.errorMessage != null &&
                state.errorMessage!.contains('boom'),
          ),
        ],
    verify: (_) {
      verify(() => authRepository.signInWithGoogle()).called(1);
    },
  );

  blocTest<AuthBloc, AuthState>(
    'clears loading after successful Google sign-in',
    build: () {
      when(() => authRepository.signInWithGoogle()).thenAnswer((_) async {});
      return buildBloc();
    },
    act: (bloc) => bloc.add(const AuthSignInWithGoogleRequested()),
    expect:
        () => [
          const AuthState(
            status: AuthStatus.unauthenticated,
            membershipStatus: AuthMembershipStatus.none,
          ),
          const AuthState(
            status: AuthStatus.unauthenticated,
            membershipStatus: AuthMembershipStatus.none,
            isLoading: true,
          ),
          predicate<AuthState>(
            (state) =>
                state.isLoading == false &&
                state.errorMessage == null &&
                state.membershipStatus == AuthMembershipStatus.none,
          ),
        ],
    verify: (_) {
      verify(() => authRepository.signInWithGoogle()).called(1);
    },
  );

  blocTest<AuthBloc, AuthState>(
    'surfaces errors when Apple sign-in fails',
    build: () {
      when(() => authRepository.signInWithApple()).thenThrow(Exception('boom'));
      return buildBloc();
    },
    act: (bloc) => bloc.add(const AuthSignInWithAppleRequested()),
    expect:
        () => [
          const AuthState(
            status: AuthStatus.unauthenticated,
            membershipStatus: AuthMembershipStatus.none,
          ),
          const AuthState(
            status: AuthStatus.unauthenticated,
            membershipStatus: AuthMembershipStatus.none,
            isLoading: true,
          ),
          predicate<AuthState>(
            (state) =>
                state.isLoading == false &&
                state.errorMessage != null &&
                state.errorMessage!.contains('boom'),
          ),
        ],
    verify: (_) {
      verify(() => authRepository.signInWithApple()).called(1);
    },
  );

  blocTest<AuthBloc, AuthState>(
    'surfaces errors when sign-out fails',
    build: () {
      when(() => authRepository.signOut()).thenThrow(Exception('boom'));
      return buildBloc();
    },
    act: (bloc) => bloc.add(const AuthSignOutRequested()),
    expect:
        () => [
          const AuthState(
            status: AuthStatus.unauthenticated,
            membershipStatus: AuthMembershipStatus.none,
          ),
          const AuthState(
            status: AuthStatus.unauthenticated,
            membershipStatus: AuthMembershipStatus.none,
            isLoading: true,
          ),
          predicate<AuthState>(
            (state) =>
                state.isLoading == false &&
                state.errorMessage != null &&
                state.errorMessage!.contains('boom'),
          ),
        ],
    verify: (_) {
      verify(() => authRepository.signOut()).called(1);
    },
  );

  blocTest<AuthBloc, AuthState>(
    'refreshes membership when requested while authenticated',
    build: () {
      when(
        () => authRepository.current,
      ).thenReturn(const AuthSession(userId: 'user-1'));
      when(() => homeRepository.getCurrentMembership()).thenAnswer(
        (_) async => CurrentMembership(
          userId: 'user-1',
          homeId: 'home-123',
          role: 'member',
          validFrom: DateTime.utc(2025, 1, 1),
        ),
      );
      return buildBloc();
    },
    act: (bloc) async {
      await Future<void>.delayed(Duration.zero);
      bloc.add(const AuthMembershipRefreshRequested());
    },
    skip: 2,
    expect:
        () => [
          predicate<AuthState>(
            (state) =>
                state.status == AuthStatus.authenticated &&
                state.userId == 'user-1' &&
                state.membershipStatus == AuthMembershipStatus.unknown,
          ),
          predicate<AuthState>(
            (state) =>
                state.status == AuthStatus.authenticated &&
                state.membershipStatus == AuthMembershipStatus.active &&
                state.membership?.homeId == 'home-123',
          ),
        ],
    verify: (_) {
      verify(
        () => homeRepository.getCurrentMembership(),
      ).called(greaterThanOrEqualTo(2));
    },
  );

  blocTest<AuthBloc, AuthState>(
    'sets error when membership refresh fails',
    build: () {
      var calls = 0;
      when(() => homeRepository.getCurrentMembership()).thenAnswer((_) async {
        if (calls == 0) {
          calls++;
          return CurrentMembership(
            userId: 'user-2',
            homeId: 'home-abc',
            role: 'member',
            validFrom: DateTime.utc(2025, 1, 1),
          );
        }
        throw Exception('boom');
      });
      when(
        () => authRepository.current,
      ).thenReturn(const AuthSession(userId: 'user-2'));
      return buildBloc();
    },
    seed:
        () => const AuthState(
          status: AuthStatus.authenticated,
          userId: 'user-2',
          membershipStatus: AuthMembershipStatus.active,
        ),
    act: (bloc) => bloc.add(const AuthMembershipRefreshRequested()),
    wait: const Duration(milliseconds: 900),
    skip: 2,
    expect:
        () => [
          isA<AuthState>()
              .having((s) => s.status, 'status', AuthStatus.authenticated)
              .having(
                (s) => s.membershipStatus,
                'membershipStatus',
                AuthMembershipStatus.unknown,
              ),
          isA<AuthState>()
              .having(
                (s) => s.errorMessage,
                'errorMessage',
                AuthBloc.membershipLoadFailedKey,
              )
              .having(
                (s) => s.membershipStatus,
                'membershipStatus',
                AuthMembershipStatus.active,
              ),
        ],
    verify:
        (_) => verify(
          () => homeRepository.getCurrentMembership(),
        ).called(greaterThanOrEqualTo(2)),
  );

  blocTest<AuthBloc, AuthState>(
    'retries membership fetch once before surfacing error',
    build: () {
      var calls = 0;
      when(() => homeRepository.getCurrentMembership()).thenAnswer((_) async {
        if (calls == 0) {
          calls++;
          return CurrentMembership(
            userId: 'user-3',
            homeId: 'home-init',
            role: 'member',
            validFrom: DateTime.utc(2025, 1, 1),
          );
        }
        if (calls == 1) {
          calls++;
          throw Exception('first fail');
        }
        return CurrentMembership(
          userId: 'user-3',
          homeId: 'home-777',
          role: 'member',
          validFrom: DateTime.utc(2025, 1, 2),
        );
      });
      when(
        () => authRepository.current,
      ).thenReturn(const AuthSession(userId: 'user-3'));
      return buildBloc();
    },
    act: (bloc) => bloc.add(const AuthMembershipRefreshRequested()),
    wait: const Duration(milliseconds: 900),
    skip: 2,
    expect:
        () => [
          isA<AuthState>()
              .having((s) => s.status, 'status', AuthStatus.authenticated)
              .having(
                (s) => s.membershipStatus,
                'membershipStatus',
                AuthMembershipStatus.unknown,
              ),
          isA<AuthState>()
              .having(
                (s) => s.membershipStatus,
                'membershipStatus',
                AuthMembershipStatus.active,
              )
              .having(
                (s) => s.membership?.homeId,
                'membership.homeId',
                'home-777',
              ),
        ],
    verify:
        (_) => verify(() => homeRepository.getCurrentMembership()).called(3),
  );
}
