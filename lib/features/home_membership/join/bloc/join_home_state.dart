part of 'join_home_bloc.dart';

enum JoinHomeStatus { initial, editing, submitting, success, failure }

class JoinHomeState extends Equatable {
  const JoinHomeState({
    this.code = '',
    this.status = JoinHomeStatus.initial,
    this.errorMessage,
  });

  final String code;
  final JoinHomeStatus status;
  final String? errorMessage;

  bool get canSubmit => code.isNotEmpty;

  JoinHomeState copyWith({
    String? code,
    JoinHomeStatus? status,
    Object? errorMessage = _unset,
  }) {
    return JoinHomeState(
      code: code ?? this.code,
      status: status ?? this.status,
      errorMessage:
          errorMessage == _unset ? this.errorMessage : errorMessage as String?,
    );
  }

  static const _unset = Object();

  @override
  List<Object?> get props => [code, status, errorMessage];
}
