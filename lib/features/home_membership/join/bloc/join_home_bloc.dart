import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../features/home/home.dart';
import '../../../../core/supabase/supabase_error_mapper.dart';

part 'join_home_event.dart';
part 'join_home_state.dart';

class JoinHomeBloc extends Bloc<JoinHomeEvent, JoinHomeState> {
  JoinHomeBloc({required HomeRepository homeRepository})
    : _homeRepository = homeRepository,
      super(const JoinHomeState()) {
    on<JoinHomeCodeChanged>(_onCodeChanged);
    on<JoinHomeSubmitted>(_onSubmitted);
    on<JoinHomeReset>(_onReset);
  }

  final HomeRepository _homeRepository;

  void _onCodeChanged(JoinHomeCodeChanged event, Emitter<JoinHomeState> emit) {
    emit(
      state.copyWith(
        code: event.code.trim(),
        status: JoinHomeStatus.editing,
        errorMessage: null,
        errorType: null,
      ),
    );
  }

  Future<void> _onSubmitted(
    JoinHomeSubmitted event,
    Emitter<JoinHomeState> emit,
  ) async {
    if (!state.canSubmit || state.status == JoinHomeStatus.submitting) return;

    emit(
      state.copyWith(
        status: JoinHomeStatus.submitting,
        errorMessage: null,
        errorType: null,
      ),
    );
    try {
      await _homeRepository.join(state.code);
      emit(
        state.copyWith(
          status: JoinHomeStatus.success,
          errorType: null,
          errorMessage: null,
        ),
      );
    } catch (error) {
      final mapped = _mapJoinError(error);
      emit(
        state.copyWith(
          status: JoinHomeStatus.failure,
          errorMessage: mapped.message,
          errorType: mapped.type,
        ),
      );
    }
  }

  void _onReset(JoinHomeReset event, Emitter<JoinHomeState> emit) {
    emit(const JoinHomeState());
  }

  _JoinErrorResult _mapJoinError(Object error) {
    if (error is HomeJoinException) {
      return _JoinErrorResult(
        type: _mapJoinErrorType(error.code),
        message: error.message,
      );
    }
    return _JoinErrorResult(
      type: JoinHomeErrorType.unknown,
      message: error.toString(),
    );
  }

  JoinHomeErrorType _mapJoinErrorType(JoinErrorCode code) {
    switch (code) {
      case JoinErrorCode.invalidCode:
        return JoinHomeErrorType.invalidCode;
      case JoinErrorCode.inactiveInvite:
        return JoinHomeErrorType.inactiveInvite;
      case JoinErrorCode.alreadyInOtherHome:
        return JoinHomeErrorType.alreadyInOtherHome;
      case JoinErrorCode.paywallLimitActiveMembers:
        return JoinHomeErrorType.paywallLimit;
      case JoinErrorCode.profileDeactivated:
        return JoinHomeErrorType.profileDeactivated;
      case JoinErrorCode.unauthorized:
        return JoinHomeErrorType.unauthorized;
      case JoinErrorCode.forbidden:
        return JoinHomeErrorType.forbidden;
      case JoinErrorCode.unknown:
        return JoinHomeErrorType.unknown;
    }
  }
}

class _JoinErrorResult {
  const _JoinErrorResult({this.type, this.message});

  final JoinHomeErrorType? type;
  final String? message;
}
