import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:kinly/contracts/account/ports/account_repository.dart';
import 'package:kinly/contracts/homes/ports/home_repository.dart';
import 'package:kinly/contracts/homes/ports/home_units_repository.dart';
import 'package:kinly/contracts/homes/home_units_models.dart';
import 'package:kinly/contracts/homes/models.dart';
import 'package:kinly/contracts/profile/models.dart';
import 'package:kinly/contracts/profile/ports/profile_repository.dart';

part 'profile_settings_event.dart';
part 'profile_settings_state.dart';

class ProfileSettingsBloc
    extends Bloc<ProfileSettingsEvent, ProfileSettingsState> {
  ProfileSettingsBloc({
    required ProfileRepository profileRepository,
    required HomeRepository homeRepository,
    required HomeUnitsRepository homeUnitsRepository,
    required AccountRepository accountRepository,
    required String homeId,
    ProfileSettingsUser? initialUser,
  }) : _profileRepository = profileRepository,
       _homeRepository = homeRepository,
       _homeUnitsRepository = homeUnitsRepository,
       _accountRepository = accountRepository,
       _homeId = homeId,
       super(ProfileSettingsState.initial(user: initialUser)) {
    on<ProfileSettingsStarted>(_onStarted);
    on<ProfileSettingsLeaveRequested>(_onLeaveRequested);
    on<ProfileSettingsSharedUnitLeaveRequested>(_onSharedUnitLeaveRequested);
    on<ProfileSettingsTransferOwnerRequested>(_onTransferOwnerRequested);
    on<ProfileSettingsKickMemberRequested>(_onKickMemberRequested);
    on<ProfileSettingsDeleteRequested>(_onDeleteRequested);
    on<ProfileSettingsActionCleared>(_onActionCleared);
    on<ProfileSettingsUserUpdated>(_onUserUpdated);
  }

  final ProfileRepository _profileRepository;
  final HomeRepository _homeRepository;
  final HomeUnitsRepository _homeUnitsRepository;
  final AccountRepository _accountRepository;
  final String _homeId;

  Future<void> _onStarted(
    ProfileSettingsStarted event,
    Emitter<ProfileSettingsState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoadingUser: true,
        leaveEligibilityLoading: true,
        homeUnitsLoading: true,
        leaveEligibilityError: null,
        homeUnitsError: null,
      ),
    );
    await _loadProfile(emit);
    await _loadLeaveEligibility(emit);
    await _loadHomeUnits(emit);
    await _loadPlanStatus(emit);
  }

  Future<void> _loadPlanStatus(Emitter<ProfileSettingsState> emit) async {
    emit(state.copyWith(planStatusLoading: true));
    try {
      final plan = await _homeRepository.getPlanStatus();
      emit(state.copyWith(planStatus: plan, planStatusLoading: false));
    } catch (_) {
      emit(
        state.copyWith(
          planStatus: PlanStatus.unknown,
          planStatusLoading: false,
        ),
      );
    }
  }

  Future<void> _loadProfile(Emitter<ProfileSettingsState> emit) async {
    try {
      final profile = await _profileRepository.getCurrentProfile();
      final mapped = _mapProfile(profile);
      emit(state.copyWith(isLoadingUser: false, user: mapped ?? state.user));
    } catch (_) {
      emit(state.copyWith(isLoadingUser: false));
    }
  }

  Future<void> _loadLeaveEligibility(Emitter<ProfileSettingsState> emit) async {
    try {
      final membership = await _homeRepository.getCurrentMembership();
      if (membership == null) {
        emit(
          state.copyWith(
            leaveEligibilityLoading: false,
            leaveEligibilityError: 'missing-membership',
            membership: null,
            activeMembers: const <HomeMemberSummary>[],
          ),
        );
        return;
      }
      final members = await _homeRepository.listActiveMembers(_homeId);
      emit(
        state.copyWith(
          leaveEligibilityLoading: false,
          leaveEligibilityError: null,
          membership: membership,
          activeMembers: members,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          leaveEligibilityLoading: false,
          leaveEligibilityError: error.toString(),
        ),
      );
    }
  }

  Future<void> _loadHomeUnits(Emitter<ProfileSettingsState> emit) async {
    try {
      final unitContext = await _homeUnitsRepository.getMyUnitContext(
        homeId: _homeId,
      );
      final createCandidates = unitContext.hasSharedUnit
          ? const <HomeUnitMemberCandidate>[]
          : await _homeUnitsRepository.listCreateSharedUnitCandidates(
              homeId: _homeId,
            );
      final joinableUnits = unitContext.hasSharedUnit
          ? const <HomeUnitSummary>[]
          : await _homeUnitsRepository.listJoinableSharedUnits(
              homeId: _homeId,
            );
      emit(
        state.copyWith(
          homeUnitsLoading: false,
          homeUnitsError: null,
          homeUnitContext: unitContext,
          sharedUnitCreateCandidates: createCandidates,
          joinableSharedUnits: joinableUnits,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          homeUnitsLoading: false,
          homeUnitsError: error.toString(),
          homeUnitContext: null,
          sharedUnitCreateCandidates: const <HomeUnitMemberCandidate>[],
          joinableSharedUnits: const <HomeUnitSummary>[],
        ),
      );
    }
  }

  Future<void> _onLeaveRequested(
    ProfileSettingsLeaveRequested event,
    Emitter<ProfileSettingsState> emit,
  ) async {
    emit(
      state.copyWith(
        leaveInProgress: true,
        action: ProfileSettingsAction.none,
        actionMessage: null,
      ),
    );
    try {
      await _homeRepository.leave(homeId: _homeId);
      emit(
        state.copyWith(
          leaveInProgress: false,
          action: ProfileSettingsAction.leaveSuccess,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          leaveInProgress: false,
          action: ProfileSettingsAction.leaveFailure,
          actionMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> _onTransferOwnerRequested(
    ProfileSettingsTransferOwnerRequested event,
    Emitter<ProfileSettingsState> emit,
  ) async {
    emit(
      state.copyWith(
        transferInProgress: true,
        action: ProfileSettingsAction.none,
        actionMessage: null,
      ),
    );
    try {
      await _homeRepository.transferOwner(
        homeId: _homeId,
        newOwnerId: event.newOwnerUserId,
      );
      emit(
        state.copyWith(
          transferInProgress: false,
          action: ProfileSettingsAction.transferSuccess,
        ),
      );
      if (event.followUp == TransferFollowUp.delete) {
        add(const ProfileSettingsDeleteRequested());
      } else {
        add(const ProfileSettingsLeaveRequested());
      }
    } catch (error) {
      emit(
        state.copyWith(
          transferInProgress: false,
          action: ProfileSettingsAction.transferFailure,
          actionMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> _onSharedUnitLeaveRequested(
    ProfileSettingsSharedUnitLeaveRequested event,
    Emitter<ProfileSettingsState> emit,
  ) async {
    emit(
      state.copyWith(
        sharedUnitLeaveInProgress: true,
        action: ProfileSettingsAction.none,
        actionMessage: null,
      ),
    );
    try {
      await _homeUnitsRepository.leaveSharedUnit(unitId: event.unitId);
      emit(
        state.copyWith(
          sharedUnitLeaveInProgress: false,
          action: ProfileSettingsAction.sharedUnitLeaveSuccess,
        ),
      );
      emit(state.copyWith(homeUnitsLoading: true, homeUnitsError: null));
      await _loadHomeUnits(emit);
    } catch (error) {
      emit(
        state.copyWith(
          sharedUnitLeaveInProgress: false,
          action: ProfileSettingsAction.sharedUnitLeaveFailure,
          actionMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> _onKickMemberRequested(
    ProfileSettingsKickMemberRequested event,
    Emitter<ProfileSettingsState> emit,
  ) async {
    emit(
      state.copyWith(
        kickInProgress: true,
        action: ProfileSettingsAction.none,
        actionMessage: null,
      ),
    );
    try {
      await _homeRepository.kickMember(homeId: _homeId, userId: event.userId);
      emit(
        state.copyWith(
          kickInProgress: false,
          action: ProfileSettingsAction.kickSuccess,
        ),
      );
      emit(
        state.copyWith(
          leaveEligibilityLoading: true,
          homeUnitsLoading: true,
          leaveEligibilityError: null,
          homeUnitsError: null,
        ),
      );
      await _loadLeaveEligibility(emit);
      await _loadHomeUnits(emit);
    } catch (error) {
      emit(
        state.copyWith(
          kickInProgress: false,
          action: ProfileSettingsAction.kickFailure,
          actionMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> _onDeleteRequested(
    ProfileSettingsDeleteRequested event,
    Emitter<ProfileSettingsState> emit,
  ) async {
    emit(
      state.copyWith(
        deleteInProgress: true,
        action: ProfileSettingsAction.none,
        actionMessage: null,
      ),
    );
    try {
      await _accountRepository.deleteAccount();
      emit(
        state.copyWith(
          deleteInProgress: false,
          action: ProfileSettingsAction.deleteSuccess,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          deleteInProgress: false,
          action: ProfileSettingsAction.deleteFailure,
          actionMessage: error.toString(),
        ),
      );
    }
  }

  void _onActionCleared(
    ProfileSettingsActionCleared event,
    Emitter<ProfileSettingsState> emit,
  ) {
    if (state.action == ProfileSettingsAction.none &&
        state.actionMessage == null) {
      return;
    }
    emit(
      state.copyWith(action: ProfileSettingsAction.none, actionMessage: null),
    );
  }

  void _onUserUpdated(
    ProfileSettingsUserUpdated event,
    Emitter<ProfileSettingsState> emit,
  ) {
    emit(state.copyWith(user: event.user));
  }

  ProfileSettingsUser? _mapProfile(UserProfile? profile) {
    if (profile == null) return null;
    return ProfileSettingsUser(
      displayName: profile.username,
      avatarUrl: profile.avatarUrl,
      avatarStoragePath: profile.avatarStoragePath,
    );
  }
}
