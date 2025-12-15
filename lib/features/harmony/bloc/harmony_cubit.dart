import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/mood/enums/mood_scale.dart';
import '../../../core/mood/models.dart';
import '../../../data/repositories/mood_repository.dart';
import '../../../core/supabase/supabase_error_mapper.dart';

part 'harmony_state.dart';

class HarmonyCubit extends Cubit<HarmonyState> {
  HarmonyCubit({
    required String homeId,
    required MoodRepository moodRepository,
  }) : _homeId = homeId,
       _moodRepository = moodRepository,
       super(const HarmonyState());

  final String _homeId;
  final MoodRepository _moodRepository;

  void selectMood(MoodScale mood) {
    if (state.selectedMood == mood) return;

    final wasEligible =
        _canShare(state.selectedMood) && _hasComment(state.comment);
    final isEligible = _canShare(mood) && _hasComment(state.comment);
    emit(
      state.copyWith(
        selectedMood: mood,
        addToWall: _deriveAddToWall(
          mood: mood,
          comment: state.comment,
          current: state.addToWall,
          wasEligible: wasEligible,
          isEligible: isEligible,
        ),
      ),
    );
  }

  void commentChanged(String value) {
    final wasEligible =
        _canShare(state.selectedMood) && _hasComment(state.comment);
    final isEligible = _canShare(state.selectedMood) && _hasComment(value);
    emit(
      state.copyWith(
        comment: value,
        addToWall: _deriveAddToWall(
          mood: state.selectedMood,
          comment: value,
          current: state.addToWall,
          wasEligible: wasEligible,
          isEligible: isEligible,
        ),
      ),
    );
  }

  void toggleAddToWall(bool value) {
    if (!_canShare(state.selectedMood) || !_hasComment(state.comment)) return;
    emit(state.copyWith(addToWall: value));
  }

  Future<void> submit() async {
    final mood = state.selectedMood;
    if (mood == null || state.isSubmitting) return;
    emit(state.copyWith(isSubmitting: true, submitError: null));
    try {
      final result = await _moodRepository.submit(
        homeId: _homeId,
        mood: mood,
        comment: state.comment,
        addToWall:
            state.addToWall && _canShare(mood) && _hasComment(state.comment),
      );
      emit(
        state.copyWith(
          isSubmitting: false,
          submitSuccessTick: state.submitSuccessTick + 1,
          lastResult: result,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isSubmitting: false,
          submitError: _mapError(error),
        ),
      );
    }
  }

  bool _canShare(MoodScale? mood) =>
      mood == MoodScale.sunny || mood == MoodScale.partiallySunny;

  bool _hasComment(String? comment) =>
      comment != null && comment.trim().isNotEmpty;

  bool _deriveAddToWall({
    required MoodScale? mood,
    required String? comment,
    required bool current,
    required bool wasEligible,
    required bool isEligible,
  }) {
    final canShare = _canShare(mood);
    final hasComment = _hasComment(comment);
    if (!canShare || !hasComment) return false;
    if (isEligible && !wasEligible) {
      // First time both conditions met -> pre-tick on.
      return true;
    }
    // Otherwise preserve current (allows manual untick).
    return current;
  }

  String _mapError(Object error) {
    if (error is MoodSubmitException) {
      switch (error.code) {
        case MoodSubmitErrorCode.moodAlreadySubmitted:
          return 'moodAlreadySubmitted';
        case MoodSubmitErrorCode.forbidden:
        case MoodSubmitErrorCode.unauthorized:
          return 'forbidden';
        case MoodSubmitErrorCode.invalidHome:
        case MoodSubmitErrorCode.invalidMood:
          return 'unknown';
        case MoodSubmitErrorCode.unknown:
          return 'unknown';
      }
    }
    return 'unknown';
  }
}
