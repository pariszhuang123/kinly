import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/home_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required AuthRepository authRepository,
    required HomeRepository homeRepository,
  }) : _authRepository = authRepository,
       _homeRepository = homeRepository,
       super(const AuthState()) {
    on<_AuthSessionChanged>(_onSessionChanged);
    on<AuthSignInWithGoogleRequested>(_onGoogleSignInRequested);
    on<AuthSignInWithAppleRequested>(_onAppleSignInRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthErrorCleared>(_onErrorCleared);

    _sessionSub = _authRepository.session$.listen(
      (session) => add(_AuthSessionChanged(session)),
    );
    add(_AuthSessionChanged(_authRepository.current));
  }

  final AuthRepository _authRepository;
  final HomeRepository _homeRepository;
  late final StreamSubscription<AuthSession?> _sessionSub;

  Future<void> _onSessionChanged(
    _AuthSessionChanged event,
    Emitter<AuthState> emit,
  ) async {
    final session = event.session;
    if (session == null) {
      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          userId: null,
          membershipStatus: AuthMembershipStatus.none,
          isLoading: false,
          errorMessage: null,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: AuthStatus.authenticated,
        userId: session.userId,
        membershipStatus: AuthMembershipStatus.unknown,
        isLoading: false,
        errorMessage: null,
      ),
    );
    try {
      final membership = await _homeRepository.getCurrentMembership();
      emit(
        state.copyWith(
          membershipStatus:
              membership == null
                  ? AuthMembershipStatus.none
                  : AuthMembershipStatus.active,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          membershipStatus: AuthMembershipStatus.unknown,
          errorMessage: 'Failed to load membership: $error',
        ),
      );
    }
  }

  Future<void> _onGoogleSignInRequested(
    AuthSignInWithGoogleRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _performAuthAction(emit, _authRepository.signInWithGoogle);
  }

  Future<void> _onAppleSignInRequested(
    AuthSignInWithAppleRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _performAuthAction(emit, _authRepository.signInWithApple);
  }

  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _performAuthAction(emit, _authRepository.signOut);
  }

  Future<void> _performAuthAction(
    Emitter<AuthState> emit,
    Future<void> Function() action,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await action();
    } catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: error.toString()));
    }
  }

  void _onErrorCleared(AuthErrorCleared event, Emitter<AuthState> emit) {
    if (state.errorMessage != null) {
      emit(state.copyWith(errorMessage: null));
    }
  }

  @override
  Future<void> close() {
    _sessionSub.cancel();
    return super.close();
  }
}
