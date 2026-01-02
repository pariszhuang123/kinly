import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../contracts/chores/models.dart';
import '../../../core/supabase/supabase_error_mapper.dart';
import 'package:kinly/features/flow/flow.dart';

part 'flow_chore_detail_event.dart';
part 'flow_chore_detail_state.dart';

class FlowChoreDetailBloc
    extends Bloc<FlowChoreDetailEvent, FlowChoreDetailState> {
  FlowChoreDetailBloc({
    required String homeId,
    required String choreId,
    required ChoresRepository choresRepository,
  }) : _homeId = homeId,
       _choreId = choreId,
       _choresRepository = choresRepository,
       super(const FlowChoreDetailState.initial()) {
    on<FlowChoreDetailStarted>(_onStarted);
    on<FlowChoreDetailCompletionRequested>(_onCompletionRequested);
  }

  final String _homeId;
  final String _choreId;
  final ChoresRepository _choresRepository;

  Future<void> _onStarted(
    FlowChoreDetailStarted event,
    Emitter<FlowChoreDetailState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearLoadError: true));
    try {
      final details = await _choresRepository.getForHome(
        homeId: _homeId,
        choreId: _choreId,
      );
      emit(
        state.copyWith(
          isLoading: false,
          details: details,
          clearLoadError: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(isLoading: false, loadErrorMessage: error.toString()),
      );
    }
  }

  Future<void> _onCompletionRequested(
    FlowChoreDetailCompletionRequested event,
    Emitter<FlowChoreDetailState> emit,
  ) async {
    if (state.isCompleting) return;
    emit(
      state.copyWith(
        isCompleting: true,
        clearCompletionError: true,
        clearCompletionResult: true,
      ),
    );
    try {
      final result = await _choresRepository.complete(_choreId);
      emit(
        state.copyWith(
          isCompleting: false,
          completionResult: result,
          clearCompletionError: true,
        ),
      );
    } on ChoreException catch (error) {
      emit(
        state.copyWith(
          isCompleting: false,
          completionErrorMessage: error.message,
          completionErrorTick: state.completionErrorTick + 1,
          clearCompletionResult: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isCompleting: false,
          completionErrorMessage: error.toString(),
          completionErrorTick: state.completionErrorTick + 1,
          clearCompletionResult: true,
        ),
      );
    }
  }
}
