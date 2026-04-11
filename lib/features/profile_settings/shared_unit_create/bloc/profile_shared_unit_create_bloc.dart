import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:kinly/contracts/homes/home_units_models.dart';
import 'package:kinly/contracts/homes/ports/home_units_repository.dart';

part 'profile_shared_unit_create_event.dart';
part 'profile_shared_unit_create_state.dart';

class ProfileSharedUnitCreateBloc
    extends
        Bloc<ProfileSharedUnitCreateEvent, ProfileSharedUnitCreateState> {
  ProfileSharedUnitCreateBloc({
    required HomeUnitsRepository homeUnitsRepository,
    required String homeId,
    required String creatorMembershipId,
  }) : _homeUnitsRepository = homeUnitsRepository,
       _homeId = homeId,
       _creatorMembershipId = creatorMembershipId,
       super(const ProfileSharedUnitCreateState()) {
    on<ProfileSharedUnitCreateStarted>(_onStarted);
    on<ProfileSharedUnitCreateNameChanged>(_onNameChanged);
    on<ProfileSharedUnitCreateCandidateToggled>(_onCandidateToggled);
    on<ProfileSharedUnitCreateSubmitted>(_onSubmitted);
    on<ProfileSharedUnitCreateFeedbackCleared>(_onFeedbackCleared);
  }

  final HomeUnitsRepository _homeUnitsRepository;
  final String _homeId;
  final String _creatorMembershipId;

  Future<void> _onStarted(
    ProfileSharedUnitCreateStarted event,
    Emitter<ProfileSharedUnitCreateState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ProfileSharedUnitCreateStatus.loading,
        errorMessage: null,
      ),
    );
    try {
      final candidates = await _homeUnitsRepository.listCreateSharedUnitCandidates(
        homeId: _homeId,
      );
      emit(
        state.copyWith(
          status: ProfileSharedUnitCreateStatus.ready,
          candidates: candidates,
          errorMessage: null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: ProfileSharedUnitCreateStatus.failure,
          errorMessage: error.toString(),
          candidates: const <HomeUnitMemberCandidate>[],
        ),
      );
    }
  }

  void _onNameChanged(
    ProfileSharedUnitCreateNameChanged event,
    Emitter<ProfileSharedUnitCreateState> emit,
  ) {
    emit(
      state.copyWith(
        name: event.name,
        status: state.isSubmitting
            ? state.status
            : ProfileSharedUnitCreateStatus.ready,
        errorMessage: null,
      ),
    );
  }

  void _onCandidateToggled(
    ProfileSharedUnitCreateCandidateToggled event,
    Emitter<ProfileSharedUnitCreateState> emit,
  ) {
    final selected = Set<String>.from(state.selectedMembershipIds);
    if (event.selected) {
      selected.add(event.membershipId);
    } else {
      selected.remove(event.membershipId);
    }
    emit(
      state.copyWith(
        selectedMembershipIds: selected,
        status: state.isSubmitting
            ? state.status
            : ProfileSharedUnitCreateStatus.ready,
        errorMessage: null,
      ),
    );
  }

  Future<void> _onSubmitted(
    ProfileSharedUnitCreateSubmitted event,
    Emitter<ProfileSharedUnitCreateState> emit,
  ) async {
    if (!state.canSubmit || state.isSubmitting) {
      return;
    }
    emit(
      state.copyWith(
        status: ProfileSharedUnitCreateStatus.submitting,
        errorMessage: null,
      ),
    );
    try {
      final selectedIds = state.selectedMembershipIds.toList(growable: false)
        ..sort();
      await _homeUnitsRepository.createSharedUnit(
        homeId: _homeId,
        name: state.trimmedName,
        membershipIds: <String>[_creatorMembershipId, ...selectedIds],
      );
      emit(
        state.copyWith(
          status: ProfileSharedUnitCreateStatus.success,
          errorMessage: null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: ProfileSharedUnitCreateStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  void _onFeedbackCleared(
    ProfileSharedUnitCreateFeedbackCleared event,
    Emitter<ProfileSharedUnitCreateState> emit,
  ) {
    if (state.status != ProfileSharedUnitCreateStatus.failure &&
        state.errorMessage == null) {
      return;
    }
    emit(
      state.copyWith(
        status: ProfileSharedUnitCreateStatus.ready,
        errorMessage: null,
      ),
    );
  }
}
