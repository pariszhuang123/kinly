part of 'house_directory_bloc.dart';

enum HouseDirectoryStatus { initial, loading, success, failure, working }

enum HouseDirectoryNotice {
  loadFailed,
  wifiSaved,
  serviceSaved,
  serviceArchived,
  linkSaved,
  linkArchived,
  reminderAcknowledged,
  reminderDismissed,
  actionFailed,
}

class HouseDirectoryState extends Equatable {
  const HouseDirectoryState({
    required this.status,
    required this.isOwner,
    required this.services,
    required this.links,
    required this.reminders,
    this.wifi,
    this.notice,
    this.errorMessage,
    this.isRefreshing = false,
  });

  factory HouseDirectoryState.initial({required bool isOwner}) {
    return HouseDirectoryState(
      status: HouseDirectoryStatus.initial,
      isOwner: isOwner,
      services: const [],
      links: const [],
      reminders: const [],
    );
  }

  final HouseDirectoryStatus status;
  final bool isOwner;
  final HouseDirectoryWifi? wifi;
  final List<HouseDirectoryService> services;
  final List<HouseDirectoryLink> links;
  final List<HouseDirectoryReminder> reminders;
  final HouseDirectoryNotice? notice;
  final String? errorMessage;
  final bool isRefreshing;

  bool get isLoading =>
      status == HouseDirectoryStatus.initial ||
      status == HouseDirectoryStatus.loading;
  bool get isFailure => status == HouseDirectoryStatus.failure;
  bool get isWorking => status == HouseDirectoryStatus.working;
  bool get hasLoaded =>
      status == HouseDirectoryStatus.success ||
      status == HouseDirectoryStatus.working;
  bool get hasContent =>
      wifi != null ||
      services.isNotEmpty ||
      links.isNotEmpty ||
      reminders.isNotEmpty;
  List<HouseDirectoryService> get rentServices =>
      services
          .where(
            (entry) => entry.serviceType == HouseDirectoryServiceType.rent,
          )
          .toList(growable: false);
  List<HouseDirectoryService> get utilityServices =>
      services
          .where(
            (entry) => entry.serviceType != HouseDirectoryServiceType.rent,
          )
          .toList(growable: false);

  HouseDirectoryState copyWith({
    HouseDirectoryStatus? status,
    bool? isOwner,
    Object? wifi = _unset,
    List<HouseDirectoryService>? services,
    List<HouseDirectoryLink>? links,
    List<HouseDirectoryReminder>? reminders,
    Object? notice = _unset,
    Object? errorMessage = _unset,
    bool? isRefreshing,
  }) {
    return HouseDirectoryState(
      status: status ?? this.status,
      isOwner: isOwner ?? this.isOwner,
      wifi: wifi == _unset ? this.wifi : wifi as HouseDirectoryWifi?,
      services: services ?? this.services,
      links: links ?? this.links,
      reminders: reminders ?? this.reminders,
      notice:
          notice == _unset ? this.notice : notice as HouseDirectoryNotice?,
      errorMessage:
          errorMessage == _unset ? this.errorMessage : errorMessage as String?,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  static const _unset = Object();

  @override
  List<Object?> get props => [
    status,
    isOwner,
    wifi,
    services,
    links,
    reminders,
    notice,
    errorMessage,
    isRefreshing,
  ];
}
