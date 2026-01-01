part of 'join_home_bloc.dart';

enum JoinHomeStatus { initial, editing, submitting, success, blocked, failure }

enum JoinHomeErrorType {
  invalidCode,
  inactiveInvite,
  alreadyInOtherHome,
  paywallLimit,
  profileDeactivated,
  unauthorized,
  forbidden,
  unknown,
}

class JoinHomeState extends Equatable {
  const JoinHomeState({
    this.code = '',
    this.status = JoinHomeStatus.initial,
    this.errorMessage,
    this.errorType,
  });

  final String code;
  final JoinHomeStatus status;
  final String? errorMessage;
  final JoinHomeErrorType? errorType;

  bool get canSubmit => code.isNotEmpty;

  JoinHomeState copyWith({
    String? code,
    JoinHomeStatus? status,
    Object? errorMessage = _unset,
    Object? errorType = _unset,
  }) {
    return JoinHomeState(
      code: code ?? this.code,
      status: status ?? this.status,
      errorMessage:
          errorMessage == _unset ? this.errorMessage : errorMessage as String?,
      errorType:
          errorType == _unset
              ? this.errorType
              : errorType as JoinHomeErrorType?,
    );
  }

  static const _unset = Object();

  @override
  List<Object?> get props => [code, status, errorMessage, errorType];
}
