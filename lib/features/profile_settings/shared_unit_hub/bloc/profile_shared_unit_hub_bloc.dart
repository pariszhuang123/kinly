import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:kinly/contracts/homes/home_units_models.dart';
import 'package:kinly/contracts/homes/ports/home_units_repository.dart';

part 'profile_shared_unit_hub_event.dart';
part 'profile_shared_unit_hub_state.dart';

class ProfileSharedUnitHubBloc
    extends Bloc<ProfileSharedUnitHubEvent, ProfileSharedUnitHubState> {
  ProfileSharedUnitHubBloc({
    required HomeUnitsRepository homeUnitsRepository,
    required String homeId,
  }) : _homeUnitsRepository = homeUnitsRepository,
       _homeId = homeId,
       super(const ProfileSharedUnitHubState()) {
    on<ProfileSharedUnitHubStarted>(_onStarted);
    on<ProfileSharedUnitHubLeaveRequested>(_onLeaveRequested);
  }

  final HomeUnitsRepository _homeUnitsRepository;
  final String _homeId;

  Future<void> _onStarted(
    ProfileSharedUnitHubStarted event,
    Emitter<ProfileSharedUnitHubState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ProfileSharedUnitHubStatus.loading,
        errorMessage: null,
      ),
    );
    try {
      final contextFuture = _homeUnitsRepository.getMyUnitContext(homeId: _homeId);
      final createCandidatesFuture = _homeUnitsRepository
          .listCreateSharedUnitCandidates(homeId: _homeId);
      final joinableUnitsFuture = _homeUnitsRepository.listJoinableSharedUnits(
        homeId: _homeId,
      );

      final homeUnitContext = await contextFuture;
      final createCandidates = await createCandidatesFuture;
      final joinableUnits = await joinableUnitsFuture;

      emit(
        state.copyWith(
          status: ProfileSharedUnitHubStatus.ready,
          homeUnitContext: homeUnitContext,
          createCandidates: createCandidates,
          joinableUnits: joinableUnits,
          errorMessage: null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: ProfileSharedUnitHubStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> _onLeaveRequested(
    ProfileSharedUnitHubLeaveRequested event,
    Emitter<ProfileSharedUnitHubState> emit,
  ) async {
    final sharedUnit = state.activeSharedUnit;
    if (sharedUnit == null || state.isLeaving) {
      return;
    }

    emit(
      state.copyWith(
        status: ProfileSharedUnitHubStatus.leaving,
        errorMessage: null,
      ),
    );
    try {
      await _homeUnitsRepository.leaveSharedUnit(unitId: sharedUnit.unitId);
      add(const ProfileSharedUnitHubStarted());
    } catch (error) {
      emit(
        state.copyWith(
          status: ProfileSharedUnitHubStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}
