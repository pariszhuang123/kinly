import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/expenses/models.dart';
import '../../../data/repositories/expenses_repository.dart';

part 'share_created_list_event.dart';
part 'share_created_list_state.dart';

class ShareCreatedListBloc
    extends Bloc<ShareCreatedListEvent, ShareCreatedListState> {
  ShareCreatedListBloc({
    required ExpensesRepository expensesRepository,
    required String homeId,
  }) : _expensesRepository = expensesRepository,
       _homeId = homeId,
       super(const ShareCreatedListState()) {
    on<ShareCreatedListRequested>(_onRequested);
    on<ShareCreatedListRefreshed>(_onRefreshed);
  }

  final ExpensesRepository _expensesRepository;
  final String _homeId;

  Future<void> _onRequested(
    ShareCreatedListRequested event,
    Emitter<ShareCreatedListState> emit,
  ) async {
    await _load(emit, showLoader: true);
  }

  Future<void> _onRefreshed(
    ShareCreatedListRefreshed event,
    Emitter<ShareCreatedListState> emit,
  ) async {
    if (!state.isRefreshing) {
      emit(state.copyWith(isRefreshing: true));
    }
    await _load(emit, showLoader: false);
  }

  Future<void> _load(
    Emitter<ShareCreatedListState> emit, {
    required bool showLoader,
  }) async {
    if (showLoader) {
      emit(
        state.copyWith(
          status: ShareCreatedListStatus.loading,
          clearError: true,
        ),
      );
    }

    try {
      final summaries = await _expensesRepository.listCreatedByMe(
        homeId: _homeId,
      );
      final entries = summaries
          .where((summary) => summary.status != ExpenseStatus.cancelled)
          .map(ShareCreatedListEntry.fromSummary)
          .toList(growable: false)
        ..sort(
          (a, b) => b.createdAt.compareTo(a.createdAt),
        );
      emit(
        state.copyWith(
          status: ShareCreatedListStatus.success,
          entries: entries,
          isRefreshing: false,
          clearError: true,
          lastUpdated: DateTime.now(),
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: ShareCreatedListStatus.failure,
          errorMessage: error.toString(),
          isRefreshing: false,
        ),
      );
    }
  }
}
