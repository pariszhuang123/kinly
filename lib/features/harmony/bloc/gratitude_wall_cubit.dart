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
      final page = await _moodRepository.listWall(homeId: _homeId);
      emit(
        state.copyWith(
          isLoading: false,
          posts: page.posts,
          cursorCreatedAt: page.cursorCreatedAt,
          cursorId: page.cursorId,
          hasMore: page.posts.isNotEmpty,
          hasLoaded: true,
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
      emit(
        state.copyWith(
          isLoadingMore: false,
          posts: merged,
          cursorCreatedAt: page.cursorCreatedAt,
          cursorId: page.cursorId,
          hasMore: page.posts.isNotEmpty,
          hasLoaded: true,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoadingMore: false, error: e.toString()));
    }
  }
}
