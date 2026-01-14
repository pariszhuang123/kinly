import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/contracts/mood/personal_wall_models.dart';
import 'package:kinly/contracts/mood/ports/mood_repository.dart';
import '../../../core/logging/logger.dart';
import '../../../core/logging/debug_logger.dart';
import 'package:kinly/contracts/homes/ports/home_repository.dart';

part 'personal_gratitude_state.dart';

class PersonalGratitudeCubit extends Cubit<PersonalGratitudeState> {
  PersonalGratitudeCubit({
    required MoodRepository moodRepository,
    required HomeRepository homeRepository,
    required String homeId,
    Logger? logger,
  }) : _repo = moodRepository,
       _homeRepository = homeRepository,
       _homeId = homeId,
       _logger = logger ?? const DebugLogger(),
       super(const PersonalGratitudeState.initial());

  final MoodRepository _repo;
  final HomeRepository _homeRepository;
  final Logger _logger;
  final String _homeId;

  Future<void> loadInitial() async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final status = await _repo.getPersonalStatus();
      final stats = await _repo.getPersonalStats();
      final page = await _repo.listPersonalWall(limit: 20);
      emit(
        state.copyWith(
          isLoading: false,
          items: page.items,
          cursorAt: page.cursorCreatedAt,
          cursorId: page.cursorId,
          hasMore:
              page.items.isNotEmpty &&
              (stats.totalReceived > page.items.length),
          status: status,
          stats: stats,
          hasLoaded: true,
        ),
      );
      await _repo.markPersonalWallRead();
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;
    emit(state.copyWith(isLoadingMore: true, error: null));
    try {
      final page = await _repo.listPersonalWall(
        beforeAt: state.cursorAt,
        beforeId: state.cursorId,
      );
      final merged = [...state.items, ...page.items];
      emit(
        state.copyWith(
          isLoadingMore: false,
          items: merged,
          cursorAt: page.cursorCreatedAt,
          cursorId: page.cursorId,
          hasMore: page.items.isNotEmpty && page.cursorId != null,
          hasLoaded: true,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoadingMore: false, error: e.toString()));
    }
  }

  Future<void> logShareEvent() async {
    try {
      await _homeRepository.logShareEvent(
        feature: 'gratitude_wall_personal',
        channel: 'system_share',
        homeId: _homeId,
      );
    } catch (error, stackTrace) {
      _logger.warn(
        'Failed to log personal gratitude wall share',
        error: error,
        stackTrace: stackTrace,
        tag: 'PersonalGratitude',
      );
    }
  }
}
