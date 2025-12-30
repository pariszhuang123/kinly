import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/chores/models.dart';
import '../../../data/repositories/home_repository.dart';
import 'package:kinly/features/flow/flow.dart';

part 'flow_list_event.dart';
part 'flow_list_state.dart';

class FlowListBloc extends Bloc<FlowListEvent, FlowListState> {
  FlowListBloc({
    required String homeId,
    required ChoresRepository choresRepository,
    required HomeRepository homeRepository,
  }) : _homeId = homeId,
       _choresRepository = choresRepository,
       _homeRepository = homeRepository,
       super(const FlowListState()) {
    on<FlowListRequested>(_onRequested);
    on<FlowListRefreshed>(_onRefreshed);
  }

  final String _homeId;
  final ChoresRepository _choresRepository;
  final HomeRepository _homeRepository;

  Future<void> _onRequested(
    FlowListRequested event,
    Emitter<FlowListState> emit,
  ) async {
    await _load(emit, showLoader: true);
  }

  Future<void> _onRefreshed(
    FlowListRefreshed event,
    Emitter<FlowListState> emit,
  ) async {
    if (!state.isRefreshing) {
      emit(state.copyWith(isRefreshing: true));
    }
    await _load(emit, showLoader: false);
  }

  Future<void> _load(
    Emitter<FlowListState> emit, {
    required bool showLoader,
  }) async {
    if (showLoader) {
      emit(state.copyWith(status: FlowListStatus.loading, clearError: true));
    }

    try {
      final members = await _homeRepository.listActiveMembers(
        _homeId,
        excludeSelf: false,
      );
      String? ownerUserId;
      if (members.isNotEmpty) {
        ownerUserId =
            (members.firstWhere(
              (member) => member.isOwner,
              orElse: () => members.first,
            )).userId;
      }
      final entries = _filterDueTodayOrEarlier(
        await _choresRepository.listForHome(_homeId),
      );
      emit(
        state.copyWith(
          status: FlowListStatus.success,
          items: entries,
          isRefreshing: false,
          clearError: true,
          lastUpdated: DateTime.now(),
          ownerUserId: ownerUserId,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: FlowListStatus.failure,
          errorMessage: error.toString(),
          isRefreshing: false,
        ),
      );
    }
  }

  List<ChoreListEntry> _filterDueTodayOrEarlier(List<ChoreListEntry> entries) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return entries
        .where((entry) {
          final entryDate = DateTime(
            entry.startDate.year,
            entry.startDate.month,
            entry.startDate.day,
          );
          return !entryDate.isAfter(today);
        })
        .toList(growable: false);
  }
}
