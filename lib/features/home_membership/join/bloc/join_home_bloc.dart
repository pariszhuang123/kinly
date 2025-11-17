import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/repositories/home_repository.dart';
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
      ),
    );
  }

  Future<void> _onSubmitted(
    JoinHomeSubmitted event,
    Emitter<JoinHomeState> emit,
  ) async {
    if (!state.canSubmit || state.status == JoinHomeStatus.submitting) return;

    emit(state.copyWith(status: JoinHomeStatus.submitting, errorMessage: null));
    try {
      await _homeRepository.join(state.code);
      emit(state.copyWith(status: JoinHomeStatus.success));
    } catch (error) {
      emit(
        state.copyWith(
          status: JoinHomeStatus.failure,
          errorMessage: _mapJoinErrorMessage(error),
        ),
      );
    }
  }

  void _onReset(JoinHomeReset event, Emitter<JoinHomeState> emit) {
    emit(const JoinHomeState());
  }

  String _mapJoinErrorMessage(Object error) {
    if (error is HomeJoinException) {
      switch (error.code) {
        case JoinErrorCode.paywallLimitActiveMembers:
          return 'This home has reached its member limit. Ask the owner to upgrade or remove a member.';
        default:
          return error.message;
      }
    }
    return error.toString();
  }
}
