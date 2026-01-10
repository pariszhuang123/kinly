part of 'hub_bloc.dart';

class HubState extends Equatable {
  const HubState({
    required this.status,
    required this.members,
    required this.preferenceReports,
    required this.currentUserId,
    required this.appLink,
    required this.isOwner,
    this.invite,
    this.inviteLink,
    this.isRefreshing = false,
    this.notice,
  });

  factory HubState.initial({required String appLink}) => HubState(
        status: HubStatus.initial,
        members: const [],
        preferenceReports: const [],
        currentUserId: '',
        invite: null,
        inviteLink: null,
        appLink: appLink,
        isOwner: false,
      );

  final HubStatus status;
  final List<HomeMemberSummary> members;
  final List<PreferenceReportListItem> preferenceReports;
  final String currentUserId;
  final HomeInvite? invite;
  final String? inviteLink;
  final String appLink;
  final bool isOwner;
  final bool isRefreshing;
  final HubNotice? notice;

  bool get isLoading =>
      status == HubStatus.loading || status == HubStatus.initial;
  bool get isFailure => status == HubStatus.failure;
  bool get hasInvite => invite != null && (inviteLink?.isNotEmpty ?? false);
  bool get hasMembers => members.isNotEmpty;
  bool get hasPreferenceReports => preferenceReports.isNotEmpty;
  String get inviteCode => invite?.code ?? '';

  HubState copyWith({
    HubStatus? status,
    List<HomeMemberSummary>? members,
    List<PreferenceReportListItem>? preferenceReports,
    String? currentUserId,
    HomeInvite? invite,
    bool clearInvite = false,
    String? inviteLink,
    String? appLink,
    bool? isOwner,
    bool? isRefreshing,
    HubNotice? notice,
  }) {
    return HubState(
      status: status ?? this.status,
      members: members ?? this.members,
      preferenceReports: preferenceReports ?? this.preferenceReports,
      currentUserId: currentUserId ?? this.currentUserId,
      invite: clearInvite ? null : (invite ?? this.invite),
      inviteLink: clearInvite ? null : (inviteLink ?? this.inviteLink),
      appLink: appLink ?? this.appLink,
      isOwner: isOwner ?? this.isOwner,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      notice: notice,
    );
  }

  @override
  List<Object?> get props => [
        status,
        members,
        preferenceReports,
        currentUserId,
        invite,
        inviteLink,
        appLink,
        isOwner,
        isRefreshing,
        notice,
      ];
}
