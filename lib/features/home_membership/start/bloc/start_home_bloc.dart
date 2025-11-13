import 'package:bloc/bloc.dart';

import '../../../../data/repositories/home_repository.dart';

part 'start_home_event.dart';
part 'start_home_state.dart';

class StartHomeBloc extends Bloc<StartHomeEvent, StartHomeState> {
  StartHomeBloc(this._homeRepository) : super(const StartHomeState()) {
    on<StartHomeCreateRequested>(_onCreateRequested);
  }

  final HomeRepository _homeRepository;

  Future<void> _onCreateRequested(
    StartHomeCreateRequested event,
    Emitter<StartHomeState> emit,
  ) async {
    if (state.status == StartHomeStatus.loading) return;

    emit(state.copyWith(status: StartHomeStatus.loading, errorMessage: null));

    try {
      // Call your RPC via the repository.
      // We don't actually need the home_id here; AuthBloc will refresh membership.
      await _homeRepository.create();

      emit(state.copyWith(status: StartHomeStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: StartHomeStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
