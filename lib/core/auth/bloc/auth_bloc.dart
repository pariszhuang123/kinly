import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:kinly/contracts/homes/models.dart';
import 'package:kinly/contracts/homes/ports/home_repository.dart';
import 'package:kinly/contracts/profile/ports/profile_repository.dart';
import 'package:kinly/core/auth/enums/auth_status.dart';
import 'package:kinly/core/logging/debug_logger.dart';
import 'package:kinly/core/logging/logger.dart';
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
    Logger? logger,
  }) : _authRepository = authRepository,
       _homeRepository = homeRepository,
       _profileRepository = profileRepository,
       _logger = logger ?? const DebugLogger(),
       super(const AuthState()) {
    on<_AuthSessionChanged>(_onSessionChanged);
    on<AuthSignInWithGoogleRequested>(_onGoogleSignInRequested);
    on<AuthSignInWithAppleRequested>(_onAppleSignInRequested);
    on<DemoLoginRequested>(_onDemoLoginRequested);
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
  final Logger _logger;
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
    _logger.info(
      'Auth session changed. hasSession=${session != null} '
      'incomingUserId=${session?.userId} currentUserId=${state.userId} '
      'membershipStatus=${state.membershipStatus}',
      tag: 'Auth',
    );
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

    final isSameAuthenticatedUser =
        state.status == AuthStatus.authenticated && state.userId == session.userId;
    if (isSameAuthenticatedUser) {
      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          userId: session.userId,
          isLoading: false,
          errorMessage: null,
          isProfileDeactivated: false,
        ),
      );
      final deactivated = await _checkProfileActive();
      if (deactivated) return;
      await _refreshMembership(emit, setUnknownWhileLoading: false);
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
    await _refreshMembership(emit, setUnknownWhileLoading: true);
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

  Future<void> _onDemoLoginRequested(
    DemoLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _performAuthAction(
      emit,
      () => _authRepository.signInWithPassword(
        email: event.email,
        password: event.password,
      ),
    );
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
    await _refreshMembership(emit, setUnknownWhileLoading: true);
  }

  Future<void> _refreshMembership(
    Emitter<AuthState> emit, {
    required bool setUnknownWhileLoading,
  }) async {
    final previousMembership = state.membership;
    final currentStatus = state.membershipStatus;
    final fallbackStatus =
        setUnknownWhileLoading
            ? AuthMembershipStatus.unknown
            : currentStatus == AuthMembershipStatus.active ||
                    previousMembership != null
                ? AuthMembershipStatus.active
                : currentStatus;
    if (setUnknownWhileLoading) {
      emit(state.copyWith(membershipStatus: AuthMembershipStatus.unknown));
    }
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
      _logger.info(
        'Membership refresh complete. status=${membership == null ? AuthMembershipStatus.none : AuthMembershipStatus.active} '
        'homeId=${membership?.homeId}',
        tag: 'Auth',
      );
    } catch (error) {
      emit(
        state.copyWith(
          membershipStatus: fallbackStatus,
          membership: previousMembership,
          errorMessage: membershipLoadFailedKey,
        ),
      );
      _logger.warn(
        'Membership refresh failed; preserving fallback state. '
        'fallbackStatus=$fallbackStatus hasPreviousMembership=${previousMembership != null}',
        tag: 'Auth',
        error: error,
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
