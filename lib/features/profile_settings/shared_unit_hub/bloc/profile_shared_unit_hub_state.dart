part of 'profile_shared_unit_hub_bloc.dart';

enum ProfileSharedUnitHubStatus { initial, loading, ready, failure, leaving }

class ProfileSharedUnitHubState extends Equatable {
  const ProfileSharedUnitHubState({
    this.status = ProfileSharedUnitHubStatus.initial,
    this.homeUnitContext,
    this.createCandidates = const <HomeUnitMemberCandidate>[],
    this.joinableUnits = const <HomeUnitSummary>[],
    this.errorMessage,
  });

  final ProfileSharedUnitHubStatus status;
  final HomeUnitContext? homeUnitContext;
  final List<HomeUnitMemberCandidate> createCandidates;
  final List<HomeUnitSummary> joinableUnits;
  final String? errorMessage;

  bool get isLoading => status == ProfileSharedUnitHubStatus.loading;
  bool get isLeaving => status == ProfileSharedUnitHubStatus.leaving;
  bool get hasBlockingError =>
      status == ProfileSharedUnitHubStatus.failure && homeUnitContext == null;
  bool get hasSharedUnit => homeUnitContext?.hasSharedUnit == true;
  HomeUnitSummary? get activeSharedUnit => homeUnitContext?.activeSharedUnit;

  ProfileSharedUnitHubState copyWith({
    ProfileSharedUnitHubStatus? status,
    Object? homeUnitContext = _unset,
    Object? createCandidates = _unset,
    Object? joinableUnits = _unset,
    Object? errorMessage = _unset,
  }) {
    return ProfileSharedUnitHubState(
      status: status ?? this.status,
      homeUnitContext: homeUnitContext == _unset
          ? this.homeUnitContext
          : homeUnitContext as HomeUnitContext?,
      createCandidates: createCandidates == _unset
          ? this.createCandidates
          : List<HomeUnitMemberCandidate>.unmodifiable(
              createCandidates as List<HomeUnitMemberCandidate>,
            ),
      joinableUnits: joinableUnits == _unset
          ? this.joinableUnits
          : List<HomeUnitSummary>.unmodifiable(
              joinableUnits as List<HomeUnitSummary>,
            ),
      errorMessage: errorMessage == _unset
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  static const _unset = Object();

  @override
  List<Object?> get props => [
    status,
    homeUnitContext,
    createCandidates,
    joinableUnits,
    errorMessage,
  ];
}
