import 'package:bloc/bloc.dart';

import '../../../../core/supabase/supabase_error_mapper.dart';
import '../../../../data/repositories/home_repository.dart';

part 'start_home_event.dart';
part 'start_home_state.dart';

class StartHomeBloc extends Bloc<StartHomeEvent, StartHomeState> {
  StartHomeBloc(
    this._homeRepository, {
    void Function()? onProfileDeactivated,
  }) : _onProfileDeactivated = onProfileDeactivated,
       super(const StartHomeState()) {
    on<StartHomeCreateRequested>(_onCreateRequested);
  }

  final HomeRepository _homeRepository;
  final void Function()? _onProfileDeactivated;

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
      if (e is HomeCreateException &&
          e.code == CreateHomeErrorCode.profileDeactivated) {
        _onProfileDeactivated?.call();
        emit(
          state.copyWith(
            status: StartHomeStatus.failure,
            errorMessage: e.message,
            isProfileDeactivated: true,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: StartHomeStatus.failure,
            errorMessage: e.toString(),
          ),
        );
      }
    }
  }
}
