part of 'hub_bloc.dart';

enum HubStatus { initial, loading, success, failure }

class HubState extends Equatable {
  const HubState({
    required this.status,
    required this.members,
    required this.appLink,
    this.invite,
    this.inviteLink,
    this.isRefreshing = false,
    this.errorMessage,
  });

  factory HubState.initial({required String appLink}) => HubState(
    status: HubStatus.initial,
    members: const [],
    invite: null,
    inviteLink: null,
    appLink: appLink,
  );

  final HubStatus status;
  final List<HomeMemberSummary> members;
  final HomeInvite? invite;
  final String? inviteLink;
  final String appLink;
  final bool isRefreshing;
  final String? errorMessage;

  bool get isLoading =>
      status == HubStatus.loading || status == HubStatus.initial;
  bool get isFailure => status == HubStatus.failure;
  bool get hasInvite => invite != null && (inviteLink?.isNotEmpty ?? false);
  bool get hasMembers => members.isNotEmpty;
  String get inviteCode => invite?.code ?? '';

  HubState copyWith({
    HubStatus? status,
    List<HomeMemberSummary>? members,
    HomeInvite? invite,
    bool clearInvite = false,
    String? inviteLink,
    String? appLink,
    bool? isRefreshing,
    String? errorMessage,
  }) {
    return HubState(
      status: status ?? this.status,
      members: members ?? this.members,
      invite: clearInvite ? null : (invite ?? this.invite),
      inviteLink: clearInvite ? null : (inviteLink ?? this.inviteLink),
      appLink: appLink ?? this.appLink,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    members,
    invite,
    inviteLink,
    appLink,
    isRefreshing,
    errorMessage,
  ];
}
