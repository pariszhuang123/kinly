import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/chores/models.dart';
import '../../../data/repositories/chores_repository.dart';

part 'flow_list_event.dart';
part 'flow_list_state.dart';

class FlowListBloc extends Bloc<FlowListEvent, FlowListState> {
  FlowListBloc({
    required String homeId,
    required ChoresRepository choresRepository,
  }) : _homeId = homeId,
       _choresRepository = choresRepository,
       super(const FlowListState()) {
    on<FlowListRequested>(_onRequested);
    on<FlowListRefreshed>(_onRefreshed);
  }

  final String _homeId;
  final ChoresRepository _choresRepository;

  Future<void> _onRequested(
    FlowListRequested event,
    Emitter<FlowListState> emit,
  ) async {
    await _load(emit, showLoader: true);
  }

  Future<void> _onRefreshed(
    FlowListRefreshed event,
    Emitter<FlowListState> emit,
  ) async {
    if (!state.isRefreshing) {
      emit(state.copyWith(isRefreshing: true));
    }
    await _load(emit, showLoader: false);
  }

  Future<void> _load(
    Emitter<FlowListState> emit, {
    required bool showLoader,
  }) async {
    if (showLoader) {
      emit(
        state.copyWith(
          status: FlowListStatus.loading,
          clearError: true,
        ),
      );
    }

    try {
      final entries = await _choresRepository.listForHome(_homeId);
      emit(
        state.copyWith(
          status: FlowListStatus.success,
          items: entries,
          isRefreshing: false,
          clearError: true,
          lastUpdated: DateTime.now(),
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: FlowListStatus.failure,
          errorMessage: error.toString(),
          isRefreshing: false,
        ),
      );
    }
  }
}
