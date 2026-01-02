import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/logging/debug_logger.dart';
import '../../../core/logging/logger.dart';
import 'package:kinly/contracts/mood/models.dart';
import 'package:kinly/contracts/homes/ports/home_repository.dart';
import 'package:kinly/contracts/mood/ports/mood_repository.dart';
import '../harmony.dart';

part 'gratitude_wall_state.dart';

class GratitudeWallCubit extends Cubit<GratitudeWallState> {
  GratitudeWallCubit({
    required String homeId,
    required MoodRepository moodRepository,
    required HomeRepository homeRepository,
    Logger? logger,
  }) : _homeId = homeId,
       _moodRepository = moodRepository,
       _homeRepository = homeRepository,
       _logger = logger ?? const DebugLogger(),
       super(const GratitudeWallState.initial());

  final String _homeId;
  final MoodRepository _moodRepository;
  final HomeRepository _homeRepository;
  final Logger _logger;

  Future<void> loadInitial() async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final wallFuture = _moodRepository.listWall(homeId: _homeId);
      final statsFuture = _moodRepository.getWallStats(_homeId);

      final page = await wallFuture;
      final stats = await statsFuture;

      final hasMore = page.posts.length < stats.totalPosts;
      emit(
        state.copyWith(
          isLoading: false,
          posts: page.posts,
          cursorCreatedAt: page.cursorCreatedAt,
          cursorId: page.cursorId,
          hasMore: hasMore,
          hasLoaded: true,
          totalPosts: stats.totalPosts,
        ),
      );
      await _moodRepository.markWallRead(_homeId);
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;
    emit(state.copyWith(isLoadingMore: true, error: null));
    try {
      final page = await _moodRepository.listWall(
        homeId: _homeId,
        cursorCreatedAt: state.cursorCreatedAt,
        cursorId: state.cursorId,
      );
      final merged = [...state.posts, ...page.posts];
      final totalPosts = state.totalPosts ?? merged.length;
      final hasMore = merged.length < totalPosts;
      emit(
        state.copyWith(
          isLoadingMore: false,
          posts: merged,
          cursorCreatedAt: page.cursorCreatedAt,
          cursorId: page.cursorId,
          hasMore: hasMore,
          hasLoaded: true,
          totalPosts: totalPosts,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoadingMore: false, error: e.toString()));
    }
  }

  Future<void> logShareEvent() async {
    try {
      await _homeRepository.logShareEvent(
        feature: 'gratitude_wall_house',
        channel: 'system_share',
        homeId: _homeId,
      );
    } catch (error, stackTrace) {
      _logger.warn(
        'Failed to log gratitude wall share',
        error: error,
        stackTrace: stackTrace,
        tag: 'GratitudeWall',
      );
    }
  }
}
