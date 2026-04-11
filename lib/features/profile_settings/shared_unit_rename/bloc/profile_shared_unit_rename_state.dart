part of 'profile_shared_unit_rename_bloc.dart';

enum ProfileSharedUnitRenameStatus { ready, submitting, success, failure }

class ProfileSharedUnitRenameState extends Equatable {
  const ProfileSharedUnitRenameState({
    required this.name,
    this.status = ProfileSharedUnitRenameStatus.ready,
    this.errorMessage,
  });

  final String name;
  final ProfileSharedUnitRenameStatus status;
  final String? errorMessage;

  String get trimmedName => name.trim();
  bool get isSubmitting => status == ProfileSharedUnitRenameStatus.submitting;
  bool get canSubmit => trimmedName.isNotEmpty && !isSubmitting;

  ProfileSharedUnitRenameState copyWith({
    String? name,
    ProfileSharedUnitRenameStatus? status,
    Object? errorMessage = _unset,
  }) {
    return ProfileSharedUnitRenameState(
      name: name ?? this.name,
      status: status ?? this.status,
      errorMessage:
          errorMessage == _unset ? this.errorMessage : errorMessage as String?,
    );
  }

  static const _unset = Object();

  @override
  List<Object?> get props => [name, status, errorMessage];
}
