part of 'profile_shared_unit_join_bloc.dart';

enum ProfileSharedUnitJoinStatus {
  initial,
  loading,
  ready,
  submitting,
  success,
  failure,
}

class ProfileSharedUnitJoinState extends Equatable {
  const ProfileSharedUnitJoinState({
    this.units = const <HomeUnitSummary>[],
    this.selectedUnitId,
    this.status = ProfileSharedUnitJoinStatus.initial,
    this.errorMessage,
  });

  final List<HomeUnitSummary> units;
  final String? selectedUnitId;
  final ProfileSharedUnitJoinStatus status;
  final String? errorMessage;

  bool get isLoading => status == ProfileSharedUnitJoinStatus.loading;
  bool get isSubmitting => status == ProfileSharedUnitJoinStatus.submitting;
  bool get canSubmit => selectedUnitId != null && !isLoading && !isSubmitting;

  ProfileSharedUnitJoinState copyWith({
    Object? units = _unset,
    Object? selectedUnitId = _unset,
    ProfileSharedUnitJoinStatus? status,
    Object? errorMessage = _unset,
  }) {
    return ProfileSharedUnitJoinState(
      units:
          units == _unset
              ? this.units
              : List<HomeUnitSummary>.unmodifiable(
                units as List<HomeUnitSummary>,
              ),
      selectedUnitId:
          selectedUnitId == _unset ? this.selectedUnitId : selectedUnitId as String?,
      status: status ?? this.status,
      errorMessage:
          errorMessage == _unset ? this.errorMessage : errorMessage as String?,
    );
  }

  static const _unset = Object();

  @override
  List<Object?> get props => [units, selectedUnitId, status, errorMessage];
}
