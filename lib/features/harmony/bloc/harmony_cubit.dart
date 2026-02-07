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
  }) : _homeId = homeId,
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
      final members = await _homeRepository.listActiveMembers(
        _homeId,
        excludeSelf: true,
      );
      emit(state.copyWith(isLoadingMembers: false, members: members));
    } catch (_) {
      emit(state.copyWith(isLoadingMembers: false, membersLoadFailed: true));
    }
  }

  void selectMood(MoodScale mood) {
    if (state.selectedMood == mood) return;

    final wasEligible =
        _isPositiveMood(state.selectedMood) && _hasComment(state.comment);
    final isEligible = _isPositiveMood(mood) && _hasComment(state.comment);
    final shouldClearMentions =
        !_canMention(mood) && state.selectedMentions.isNotEmpty;

    emit(
      state.copyWith(
        selectedMood: mood,
        selectedMentions: shouldClearMentions
            ? <String>{}
            : _trimMentionsForMood(state.selectedMentions, mood),
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
        _isPositiveMood(state.selectedMood) && _hasComment(state.comment);
    final isEligible =
        _isPositiveMood(state.selectedMood) && _hasComment(value);

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
    if (!_isPositiveMood(state.selectedMood)) return;
    emit(state.copyWith(addToWall: value));
  }

  void toggleMention(String userId) {
    if (!_canMention(state.selectedMood)) return;
    final selected = Set<String>.from(state.selectedMentions);
    if (selected.contains(userId)) {
      selected.remove(userId);
    } else {
      if (selected.length >= _mentionLimit(state.selectedMood)) return;
      selected.add(userId);
    }
    emit(state.copyWith(selectedMentions: selected));
  }

  void setMentions(Set<String> userIds) {
    if (!_canMention(state.selectedMood)) return;
    final limited = userIds.take(_mentionLimit(state.selectedMood)).toSet();
    emit(state.copyWith(selectedMentions: limited));
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
            state.addToWall &&
            _isPositiveMood(mood) &&
            _hasComment(state.comment),
        mentions: _canMention(mood)
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

  bool _isPositiveMood(MoodScale? mood) =>
      mood == MoodScale.sunny || mood == MoodScale.partiallySunny;

  bool _canMention(MoodScale? mood) =>
      _isPositiveMood(mood) ||
      mood == MoodScale.rainy ||
      mood == MoodScale.thunderstorm;

  int _mentionLimit(MoodScale? mood) =>
      _isPositiveMood(mood)
          ? 5
          : (mood == MoodScale.rainy || mood == MoodScale.thunderstorm ? 1 : 0);

  bool _hasComment(String? comment) =>
      comment != null && comment.trim().isNotEmpty;

  Set<String> _trimMentionsForMood(
    Set<String> mentions,
    MoodScale? mood,
  ) {
    final limit = _mentionLimit(mood);
    if (limit == 0 || mentions.length <= limit) return mentions;
    final ordered = mentions.toList(growable: false)..sort();
    return ordered.take(limit).toSet();
  }

  bool _deriveAddToWall({
    required MoodScale? mood,
    required String? comment,
    required bool current,
    required bool wasEligible,
    required bool isEligible,
  }) {
    final canShare = _isPositiveMood(mood);
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
    if (error is! MoodSubmitException) return 'unknown';
    return _moodSubmitErrorKeys[error.code] ?? 'unknown';
  }
}

const Map<MoodSubmitErrorCode, String> _moodSubmitErrorKeys = {
  MoodSubmitErrorCode.moodAlreadySubmitted: 'moodAlreadySubmitted',
  MoodSubmitErrorCode.notPositiveMood: 'notPositiveMood',
  MoodSubmitErrorCode.mentionLimitExceeded: 'mentionLimitExceeded',
  MoodSubmitErrorCode.duplicateMentions: 'duplicateMentions',
  MoodSubmitErrorCode.selfMentionNotAllowed: 'selfMentionNotAllowed',
  MoodSubmitErrorCode.mentionNotHomeMember: 'mentionNotHomeMember',
  MoodSubmitErrorCode.invalidMentionUser: 'invalidMentionUser',
  MoodSubmitErrorCode.commentRequiredForMention: 'commentRequiredForMention',
  MoodSubmitErrorCode.singleMentionRequired: 'singleMentionRequired',
  MoodSubmitErrorCode.commentRequiredForPublicWall: 'commentRequiredForPublicWall',
  MoodSubmitErrorCode.complaintTooShort: 'complaintTooShort',
  MoodSubmitErrorCode.complaintTooBrief: 'complaintTooBrief',
  MoodSubmitErrorCode.complaintNeedsSentence: 'complaintNeedsSentence',
  MoodSubmitErrorCode.forbidden: 'forbidden',
  MoodSubmitErrorCode.unauthorized: 'forbidden',
  MoodSubmitErrorCode.invalidHome: 'unknown',
  MoodSubmitErrorCode.invalidMood: 'unknown',
  MoodSubmitErrorCode.unknown: 'unknown',
};
