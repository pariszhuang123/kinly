import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/mood/models.dart';
import '../../../data/repositories/mood_repository.dart';

part 'gratitude_wall_state.dart';

class GratitudeWallCubit extends Cubit<GratitudeWallState> {
  GratitudeWallCubit({
    required String homeId,
    required MoodRepository moodRepository,
  }) : _homeId = homeId,
       _moodRepository = moodRepository,
       super(const GratitudeWallState.initial());

  final String _homeId;
  final MoodRepository _moodRepository;

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
      final merged = [
        ...state.posts,
        ...page.posts,
      ];
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
}
