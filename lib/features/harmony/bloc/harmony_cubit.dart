import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/contracts/mood/enums/mood_scale.dart';
import 'package:kinly/contracts/mood/models.dart';
import 'package:kinly/contracts/homes/models.dart';
import 'package:kinly/contracts/homes/ports/home_repository.dart';
import '../harmony.dart';
import '../../../core/supabase/supabase_error_mapper.dart';

part 'harmony_state.dart';

class HarmonyCubit extends Cubit<HarmonyState> {
  HarmonyCubit({
    required String homeId,
    required MoodRepository moodRepository,
    required HomeRepository homeRepository,
  })
    : _homeId = homeId,
      _moodRepository = moodRepository,
      _homeRepository = homeRepository,
      super(const HarmonyState());

  final String _homeId;
  final MoodRepository _moodRepository;
  final HomeRepository _homeRepository;

  Future<void> loadMembers() async {
    if (state.isLoadingMembers || state.members.isNotEmpty) return;
    emit(state.copyWith(isLoadingMembers: true, membersLoadFailed: false));
    try {
      final members =
          await _homeRepository.listActiveMembers(_homeId, excludeSelf: true);
      emit(state.copyWith(isLoadingMembers: false, members: members));
    } catch (_) {
      emit(state.copyWith(isLoadingMembers: false, membersLoadFailed: true));
    }
  }

  void selectMood(MoodScale mood) {
    if (state.selectedMood == mood) return;

    final wasEligible =
        _canShare(state.selectedMood) && _hasComment(state.comment);
    final isEligible = _canShare(mood) && _hasComment(state.comment);
    final shouldClearMentions =
        !_canShare(mood) && state.selectedMentions.isNotEmpty;

    emit(
      state.copyWith(
        selectedMood: mood,
        selectedMentions:
            shouldClearMentions ? <String>{} : state.selectedMentions,
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

  void toggleMention(String userId) {
    if (!_canShare(state.selectedMood)) return;
    final selected = Set<String>.from(state.selectedMentions);
    if (selected.contains(userId)) {
      selected.remove(userId);
    } else {
      if (selected.length >= 5) return;
      selected.add(userId);
    }
    emit(state.copyWith(selectedMentions: selected));
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
        mentions: _canShare(mood)
            ? state.selectedMentions.toList(growable: false)
            : const [],
      );
      emit(
        state.copyWith(
          isSubmitting: false,
          submitSuccessTick: state.submitSuccessTick + 1,
          lastResult: result,
        ),
      );
    } catch (error) {
      emit(state.copyWith(isSubmitting: false, submitError: _mapError(error)));
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
        case MoodSubmitErrorCode.notPositiveMood:
          return 'notPositiveMood';
        case MoodSubmitErrorCode.mentionLimitExceeded:
          return 'mentionLimitExceeded';
        case MoodSubmitErrorCode.duplicateMentions:
          return 'duplicateMentions';
        case MoodSubmitErrorCode.selfMentionNotAllowed:
          return 'selfMentionNotAllowed';
        case MoodSubmitErrorCode.mentionNotHomeMember:
          return 'mentionNotHomeMember';
        case MoodSubmitErrorCode.invalidMentionUser:
          return 'invalidMentionUser';
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
