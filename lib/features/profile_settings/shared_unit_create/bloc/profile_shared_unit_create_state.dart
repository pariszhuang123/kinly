part of 'profile_shared_unit_create_bloc.dart';

enum ProfileSharedUnitCreateStatus {
  initial,
  loading,
  ready,
  submitting,
  success,
  failure,
}

class ProfileSharedUnitCreateState extends Equatable {
  const ProfileSharedUnitCreateState({
    this.name = '',
    this.candidates = const <HomeUnitMemberCandidate>[],
    this.selectedMembershipIds = const <String>{},
    this.status = ProfileSharedUnitCreateStatus.initial,
    this.errorMessage,
  });

  final String name;
  final List<HomeUnitMemberCandidate> candidates;
  final Set<String> selectedMembershipIds;
  final ProfileSharedUnitCreateStatus status;
  final String? errorMessage;

  String get trimmedName => name.trim();
  bool get isLoading => status == ProfileSharedUnitCreateStatus.loading;
  bool get isSubmitting => status == ProfileSharedUnitCreateStatus.submitting;
  bool get canSubmit =>
      trimmedName.isNotEmpty &&
      selectedMembershipIds.isNotEmpty &&
      !isLoading &&
      !isSubmitting;
  bool get hasBlockingLoadError =>
      status == ProfileSharedUnitCreateStatus.failure && candidates.isEmpty;

  ProfileSharedUnitCreateState copyWith({
    String? name,
    Object? candidates = _unset,
    Object? selectedMembershipIds = _unset,
    ProfileSharedUnitCreateStatus? status,
    Object? errorMessage = _unset,
  }) {
    return ProfileSharedUnitCreateState(
      name: name ?? this.name,
      candidates:
          candidates == _unset
              ? this.candidates
              : List<HomeUnitMemberCandidate>.unmodifiable(
                candidates as List<HomeUnitMemberCandidate>,
              ),
      selectedMembershipIds:
          selectedMembershipIds == _unset
              ? this.selectedMembershipIds
              : Set<String>.unmodifiable(
                selectedMembershipIds as Set<String>,
              ),
      status: status ?? this.status,
      errorMessage:
          errorMessage == _unset ? this.errorMessage : errorMessage as String?,
    );
  }

  static const _unset = Object();

  @override
  List<Object?> get props => [
    name,
    candidates,
    selectedMembershipIds.toList(growable: false)..sort(),
    status,
    errorMessage,
  ];
}
