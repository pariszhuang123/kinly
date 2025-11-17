import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/chores/models.dart'; // ChoreListEntry, etc.
import '../../../data/repositories/chores_repository.dart';
import '../domain/models.dart'; // TodayFlowTask etc.

part 'today_event.dart';
part 'today_state.dart';

class TodayBloc extends Bloc<TodayEvent, TodayState> {
  final ChoresRepository _choresRepository;
  final String _homeId;

  TodayBloc({
    required ChoresRepository choresRepository,
    required String homeId,
  }) : _choresRepository = choresRepository,
       _homeId = homeId,
       super(const TodayState.loading()) {
    on<TodayStarted>(_onStarted);
    on<TodayRefreshed>(_onRefreshed);

    // kick off initial load
    add(const TodayStarted());
  }

  Future<void> _onStarted(TodayStarted event, Emitter<TodayState> emit) async {
    await _loadToday(emit);
  }

  Future<void> _onRefreshed(
    TodayRefreshed event,
    Emitter<TodayState> emit,
  ) async {
    await _loadToday(emit, isRefresh: true);
  }

  Future<void> _loadToday(
    Emitter<TodayState> emit, {
    bool isRefresh = false,
  }) async {
    try {
      if (!isRefresh) {
        emit(const TodayState.loading());
      }

      final draftsFuture = _choresRepository.listTodayFlow(
        homeId: _homeId,
        state: ChoreState.draft,
      );
      final activeFuture = _choresRepository.listTodayFlow(
        homeId: _homeId,
        state: ChoreState.active,
      );

      final drafts = await draftsFuture;
      final active = await activeFuture;

      // Drafts (unassigned) read as "new today" items, followed by active tasks.
      final flowTasks = <TodayFlowTask>[
        ...drafts.map(
          (entry) => _mapEntryToTodayTask(entry, isNewTodayOverride: true),
        ),
        ...active.map(_mapEntryToTodayTask),
      ];

      emit(
        TodayState.loaded(
          flowTasks: flowTasks,
          // later: you can add today’s expenses, gratitude items, etc.
        ),
      );
    } catch (error) {
      // for now: basic error handling
      emit(
        TodayState.failure(
          message: "Could not load today's chores. Please try again.",
          error: error,
        ),
      );
      // optional: log error/stackTrace via your logger/Sentry here
    }
  }

  TodayFlowTask _mapEntryToTodayTask(
    TodayFlowEntry entry, {
    bool? isNewTodayOverride,
  }) {
    return TodayFlowTask(
      id: entry.id,
      title: entry.name,
      isNewToday: isNewTodayOverride ?? entry.isDraft,
    );
  }
}
