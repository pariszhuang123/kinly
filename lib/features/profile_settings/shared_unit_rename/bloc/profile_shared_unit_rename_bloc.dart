import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:kinly/contracts/homes/ports/home_units_repository.dart';

part 'profile_shared_unit_rename_event.dart';
part 'profile_shared_unit_rename_state.dart';

class ProfileSharedUnitRenameBloc
    extends Bloc<ProfileSharedUnitRenameEvent, ProfileSharedUnitRenameState> {
  ProfileSharedUnitRenameBloc({
    required HomeUnitsRepository homeUnitsRepository,
    required String unitId,
    required String initialName,
  }) : _homeUnitsRepository = homeUnitsRepository,
       _unitId = unitId,
       super(ProfileSharedUnitRenameState(name: initialName)) {
    on<ProfileSharedUnitRenameNameChanged>(_onNameChanged);
    on<ProfileSharedUnitRenameSubmitted>(_onSubmitted);
  }

  final HomeUnitsRepository _homeUnitsRepository;
  final String _unitId;

  void _onNameChanged(
    ProfileSharedUnitRenameNameChanged event,
    Emitter<ProfileSharedUnitRenameState> emit,
  ) {
    emit(state.copyWith(name: event.name, errorMessage: null));
  }

  Future<void> _onSubmitted(
    ProfileSharedUnitRenameSubmitted event,
    Emitter<ProfileSharedUnitRenameState> emit,
  ) async {
    if (!state.canSubmit || state.isSubmitting) {
      return;
    }
    emit(
      state.copyWith(
        status: ProfileSharedUnitRenameStatus.submitting,
        errorMessage: null,
      ),
    );
    try {
      await _homeUnitsRepository.renameSharedUnit(
        unitId: _unitId,
        name: state.trimmedName,
      );
      emit(
        state.copyWith(
          status: ProfileSharedUnitRenameStatus.success,
          errorMessage: null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: ProfileSharedUnitRenameStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}
