import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:kinly/contracts/homes/models.dart';
import 'package:kinly/contracts/homes/ports/home_repository.dart';
import 'package:kinly/contracts/profile/ports/profile_repository.dart';
import 'package:kinly/core/auth/enums/auth_status.dart';
import '../auth.dart';

export 'package:kinly/core/auth/enums/auth_status.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  static const membershipLoadFailedKey = 'auth.membership_load_failed';

  AuthBloc({
    required AuthRepository authRepository,
    required HomeRepository homeRepository,
    ProfileRepository? profileRepository,
  }) : _authRepository = authRepository,
       _homeRepository = homeRepository,
       _profileRepository = profileRepository,
       super(const AuthState()) {
    on<_AuthSessionChanged>(_onSessionChanged);
    on<AuthSignInWithGoogleRequested>(_onGoogleSignInRequested);
    on<AuthSignInWithAppleRequested>(_onAppleSignInRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthMembershipRefreshRequested>(_onMembershipRefreshRequested);
    on<AuthErrorCleared>(_onErrorCleared);
    on<AuthProfileDeactivatedDetected>(_onProfileDeactivatedDetected);

    _sessionSub = _authRepository.session$.listen(
      (session) => add(_AuthSessionChanged(session)),
    );
    add(_AuthSessionChanged(_authRepository.current));
  }

  final AuthRepository _authRepository;
  final HomeRepository _homeRepository;
  final ProfileRepository? _profileRepository;
  late final StreamSubscription<AuthSession?> _sessionSub;
  static const _retryDelay = Duration(milliseconds: 800);
  static const _maxAttempts = 2;
  static const _nullMembershipRetryDelay = Duration(milliseconds: 250);
  static const _nullMembershipMaxAttempts = 2;

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
          membership: null,
          isProfileDeactivated: false,
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
        membership: null,
        isProfileDeactivated: false,
      ),
    );
    final deactivated = await _checkProfileActive();
    if (deactivated) return;
    await _refreshMembership(emit);
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
      emit(state.copyWith(isLoading: false));
    } catch (error) {
      emit(
        state.copyWith(isLoading: false, errorMessage: _describeError(error)),
      );
    }
  }

  String _describeError(Object error) {
    if (error is AuthException) return error.message;
    return error.toString();
  }

  void _onErrorCleared(AuthErrorCleared event, Emitter<AuthState> emit) {
    if (state.errorMessage != null) {
      emit(state.copyWith(errorMessage: null));
    }
  }

  Future<void> _onMembershipRefreshRequested(
    AuthMembershipRefreshRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (!state.isAuthenticated) return;
    await _refreshMembership(emit);
  }

  Future<void> _refreshMembership(Emitter<AuthState> emit) async {
    final previousMembership = state.membership;
    final fallbackStatus =
        state.membershipStatus == AuthMembershipStatus.active ||
                previousMembership != null
            ? AuthMembershipStatus.active
            : AuthMembershipStatus.unknown;
    emit(state.copyWith(membershipStatus: AuthMembershipStatus.unknown));
    try {
      var membership = await _fetchMembershipWithRetry();
      if (membership == null &&
          previousMembership == null &&
          state.status == AuthStatus.authenticated) {
        membership = await _retryNullMembership();
      }
      emit(
        state.copyWith(
          membershipStatus:
              membership == null
                  ? AuthMembershipStatus.none
                  : AuthMembershipStatus.active,
          membership: membership,
          errorMessage: null,
          isProfileDeactivated: false,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          membershipStatus: fallbackStatus,
          membership: previousMembership,
          errorMessage: membershipLoadFailedKey,
        ),
      );
    }
  }

  void _onProfileDeactivatedDetected(
    AuthProfileDeactivatedDetected event,
    Emitter<AuthState> emit,
  ) {
    _handleProfileDeactivated(emit);
  }

  Future<bool> _checkProfileActive() async {
    if (_profileRepository == null) return false;
    try {
      final profile = await _profileRepository.getCurrentProfile();
      if (profile == null) {
        return await _handleProfileDeactivated(null);
      }
    } catch (_) {
      // ignore and proceed
    }
    return false;
  }

  Future<bool> _handleProfileDeactivated(Emitter<AuthState>? emit) async {
    final newState = state.copyWith(
      isProfileDeactivated: true,
      status: AuthStatus.unauthenticated,
      userId: null,
      membershipStatus: AuthMembershipStatus.none,
      membership: null,
      errorMessage: null,
    );
    if (emit != null) {
      emit(newState);
    } else {
      // ignore: invalid_use_of_visible_for_testing_member
      this.emit(newState);
    }
    try {
      await _authRepository.signOut();
    } catch (_) {}
    return true;
  }

  Future<CurrentMembership?> _retryNullMembership() async {
    for (var attempt = 0; attempt < _nullMembershipMaxAttempts; attempt++) {
      await Future<void>.delayed(_nullMembershipRetryDelay);
      final membership = await _fetchMembershipWithRetry();
      if (membership != null) return membership;
    }
    return null;
  }

  Future<CurrentMembership?> _fetchMembershipWithRetry() async {
    Object? lastError;
    for (var attempt = 0; attempt < _maxAttempts; attempt++) {
      try {
        return await _homeRepository.getCurrentMembership();
      } catch (error) {
        lastError = error;
        if (attempt == _maxAttempts - 1) break;
        await Future<void>.delayed(_retryDelay);
      }
    }
    throw lastError ?? Exception('Unknown membership fetch failure');
  }

  @override
  Future<void> close() {
    _sessionSub.cancel();
    return super.close();
  }
}
