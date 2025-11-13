part of 'auth_bloc.dart';

enum AuthStatus { unknown, unauthenticated, authenticated }

enum AuthMembershipStatus { unknown, none, active }

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.unknown,
    this.userId,
    this.isLoading = false,
    this.errorMessage,
    this.membershipStatus = AuthMembershipStatus.unknown,
  });

  final AuthStatus status;
  final String? userId;
  final bool isLoading;
  final String? errorMessage;
  final AuthMembershipStatus membershipStatus;

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get hasActiveMembership =>
      membershipStatus == AuthMembershipStatus.active;

  AuthState copyWith({
    AuthStatus? status,
    Object? userId = _unset,
    bool? isLoading,
    Object? errorMessage = _unset,
    AuthMembershipStatus? membershipStatus,
  }) {
    return AuthState(
      status: status ?? this.status,
      userId: userId == _unset ? this.userId : userId as String?,
      isLoading: isLoading ?? this.isLoading,
      errorMessage:
          errorMessage == _unset ? this.errorMessage : errorMessage as String?,
      membershipStatus: membershipStatus ?? this.membershipStatus,
    );
  }

  static const _unset = Object();

  @override
  List<Object?> get props => [
    status,
    userId,
    isLoading,
    errorMessage,
    membershipStatus,
  ];
}
