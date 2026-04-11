import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:kinly/contracts/homes/home_units_models.dart';
import 'package:kinly/contracts/homes/ports/home_units_repository.dart';

part 'profile_shared_unit_join_event.dart';
part 'profile_shared_unit_join_state.dart';

class ProfileSharedUnitJoinBloc
    extends Bloc<ProfileSharedUnitJoinEvent, ProfileSharedUnitJoinState> {
  ProfileSharedUnitJoinBloc({
    required HomeUnitsRepository homeUnitsRepository,
    required String homeId,
  }) : _homeUnitsRepository = homeUnitsRepository,
       _homeId = homeId,
       super(const ProfileSharedUnitJoinState()) {
    on<ProfileSharedUnitJoinStarted>(_onStarted);
    on<ProfileSharedUnitJoinSelected>(_onSelected);
    on<ProfileSharedUnitJoinSubmitted>(_onSubmitted);
  }

  final HomeUnitsRepository _homeUnitsRepository;
  final String _homeId;

  Future<void> _onStarted(
    ProfileSharedUnitJoinStarted event,
    Emitter<ProfileSharedUnitJoinState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ProfileSharedUnitJoinStatus.loading,
        errorMessage: null,
      ),
    );
    try {
      final units = await _homeUnitsRepository.listJoinableSharedUnits(
        homeId: _homeId,
      );
      emit(
        state.copyWith(
          status: ProfileSharedUnitJoinStatus.ready,
          units: units,
          selectedUnitId: units.length == 1 ? units.first.unitId : null,
          errorMessage: null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: ProfileSharedUnitJoinStatus.failure,
          errorMessage: error.toString(),
          units: const <HomeUnitSummary>[],
        ),
      );
    }
  }

  void _onSelected(
    ProfileSharedUnitJoinSelected event,
    Emitter<ProfileSharedUnitJoinState> emit,
  ) {
    emit(state.copyWith(selectedUnitId: event.unitId, errorMessage: null));
  }

  Future<void> _onSubmitted(
    ProfileSharedUnitJoinSubmitted event,
    Emitter<ProfileSharedUnitJoinState> emit,
  ) async {
    final unitId = state.selectedUnitId;
    if (unitId == null || unitId.isEmpty || state.isSubmitting) {
      return;
    }
    emit(
      state.copyWith(
        status: ProfileSharedUnitJoinStatus.submitting,
        errorMessage: null,
      ),
    );
    try {
      await _homeUnitsRepository.joinSharedUnit(unitId: unitId);
      emit(
        state.copyWith(
          status: ProfileSharedUnitJoinStatus.success,
          errorMessage: null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: ProfileSharedUnitJoinStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}
