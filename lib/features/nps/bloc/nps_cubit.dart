import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/mood_repository.dart';
import '../../../core/supabase/supabase_error_mapper.dart';

part 'nps_state.dart';

class NpsCubit extends Cubit<NpsState> {
  NpsCubit({required String homeId, required MoodRepository moodRepository})
    : _homeId = homeId,
      _moodRepository = moodRepository,
      super(const NpsState());

  final String _homeId;
  final MoodRepository _moodRepository;

  Future<void> submitScore(int score) async {
    if (score < 0 || score > 10) return;
    if (state.isSubmitting) return;
    emit(
      state.copyWith(
        isSubmitting: true,
        submitError: null,
        lastSubmittedScore: score,
      ),
    );
    try {
      await _moodRepository.submitNps(homeId: _homeId, score: score);
      emit(
        state.copyWith(
          isSubmitting: false,
          submitSuccessTick: state.submitSuccessTick + 1,
          submitError: null,
          lastSubmittedScore: score,
        ),
      );
    } catch (error) {
      emit(state.copyWith(isSubmitting: false, submitError: _mapError(error)));
    }
  }

  String _mapError(Object error) {
    if (error is NpsSubmitException) {
      switch (error.code) {
        case NpsSubmitErrorCode.invalidScore:
          return 'invalidScore';
        case NpsSubmitErrorCode.notEligible:
          return 'notEligible';
        case NpsSubmitErrorCode.notRequired:
          return 'notRequired';
        case NpsSubmitErrorCode.forbidden:
        case NpsSubmitErrorCode.unauthorized:
          return 'forbidden';
        case NpsSubmitErrorCode.unknown:
          return 'unknown';
      }
    }
    return 'unknown';
  }
}
