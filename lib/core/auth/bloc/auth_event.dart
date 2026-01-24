part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthSignInWithGoogleRequested extends AuthEvent {
  const AuthSignInWithGoogleRequested();
}

class AuthSignInWithAppleRequested extends AuthEvent {
  const AuthSignInWithAppleRequested();
}

class DemoLoginRequested extends AuthEvent {
  const DemoLoginRequested({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}

class AuthMembershipRefreshRequested extends AuthEvent {
  const AuthMembershipRefreshRequested();
}

class AuthErrorCleared extends AuthEvent {
  const AuthErrorCleared();
}

class AuthProfileDeactivatedDetected extends AuthEvent {
  const AuthProfileDeactivatedDetected();
}

class _AuthSessionChanged extends AuthEvent {
  const _AuthSessionChanged(this.session);

  final AuthSession? session;

  @override
  List<Object?> get props => [session?.userId];
}
