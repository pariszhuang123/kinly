part of 'personal_directory_bloc.dart';

enum PersonalDirectoryStatus { initial, loading, success, failure, working }

enum PersonalDirectoryNotice {
  loadFailed,
  bankAccountSaved,
  noteSaved,
  noteArchived,
  actionFailed,
}

class PersonalDirectoryState extends Equatable {
  const PersonalDirectoryState({
    required this.status,
    required this.target,
    required this.currentUserId,
    required this.notes,
    this.homeId,
    this.bankAccount,
    this.notice,
    this.errorMessage,
  });

  factory PersonalDirectoryState.initial({
    required PersonalDirectoryMemberSummary target,
    required String currentUserId,
    String? homeId,
  }) {
    return PersonalDirectoryState(
      status: PersonalDirectoryStatus.initial,
      target: target,
      currentUserId: currentUserId,
      homeId: homeId,
      notes: const [],
    );
  }

  final PersonalDirectoryStatus status;
  final PersonalDirectoryMemberSummary target;
  final String currentUserId;
  final String? homeId;
  final PersonalDirectoryBankAccount? bankAccount;
  final List<PersonalDirectoryNote> notes;
  final PersonalDirectoryNotice? notice;
  final String? errorMessage;

  bool get isSelf => target.userId == currentUserId;
  bool get isLoading =>
      status == PersonalDirectoryStatus.initial ||
      status == PersonalDirectoryStatus.loading;
  bool get hasLoaded =>
      status == PersonalDirectoryStatus.success ||
      status == PersonalDirectoryStatus.working;

  PersonalDirectoryState copyWith({
    PersonalDirectoryStatus? status,
    PersonalDirectoryMemberSummary? target,
    String? currentUserId,
    Object? homeId = _unset,
    Object? bankAccount = _unset,
    List<PersonalDirectoryNote>? notes,
    Object? notice = _unset,
    Object? errorMessage = _unset,
  }) {
    return PersonalDirectoryState(
      status: status ?? this.status,
      target: target ?? this.target,
      currentUserId: currentUserId ?? this.currentUserId,
      homeId: homeId == _unset ? this.homeId : homeId as String?,
      bankAccount:
          bankAccount == _unset
              ? this.bankAccount
              : bankAccount as PersonalDirectoryBankAccount?,
      notes: notes ?? this.notes,
      notice:
          notice == _unset ? this.notice : notice as PersonalDirectoryNotice?,
      errorMessage:
          errorMessage == _unset ? this.errorMessage : errorMessage as String?,
    );
  }

  static const _unset = Object();

  @override
  List<Object?> get props => [
    status,
    target,
    currentUserId,
    homeId,
    bankAccount,
    notes,
    notice,
    errorMessage,
  ];
}
