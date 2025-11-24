part of 'profile_identity_bloc.dart';

enum ProfileIdentityAction { none, success, failure }

enum ProfileIdentityValidationError { empty, invalidFormat }

class ProfileIdentityState extends Equatable {
  const ProfileIdentityState({
    required this.username,
    required this.initialUsername,
    required this.usernameError,
    required this.avatars,
    required this.selectedAvatarId,
    required this.selectedAvatarUrl,
    required this.initialAvatarId,
    required this.initialAvatarStoragePath,
    required this.isLoading,
    required this.isSubmitting,
    required this.loadErrorMessage,
    required this.action,
    required this.actionMessage,
    required this.actionError,
    required this.updatedProfile,
  });

  factory ProfileIdentityState.initial({
    required String username,
    String? avatarStoragePath,
    String? avatarUrl,
  }) {
    return ProfileIdentityState(
      username: username,
      initialUsername: username.isEmpty ? null : username,
      usernameError: null,
      avatars: const [],
      selectedAvatarId: null,
      selectedAvatarUrl: avatarUrl,
      initialAvatarId: null,
      initialAvatarStoragePath: avatarStoragePath,
      isLoading: true,
      isSubmitting: false,
      loadErrorMessage: null,
      action: ProfileIdentityAction.none,
      actionMessage: null,
      actionError: null,
      updatedProfile: null,
    );
  }

  final String username;
  final String? initialUsername;
  final ProfileIdentityValidationError? usernameError;
  final List<ProfileAvatar> avatars;
  final String? selectedAvatarId;
  final String? selectedAvatarUrl;
  final String? initialAvatarId;
  final String? initialAvatarStoragePath;
  final bool isLoading;
  final bool isSubmitting;
  final String? loadErrorMessage;
  final ProfileIdentityAction action;
  final String? actionMessage;
  final ProfileErrorCode? actionError;
  final UserProfile? updatedProfile;

  bool get canSubmit {
    final trimmed = username.trim();
    if (isLoading || isSubmitting || loadErrorMessage != null) return false;
    if (usernameError != null) return false;
    if (trimmed.isEmpty || selectedAvatarId == null) return false;
    final usernameChanged = (initialUsername ?? '').trim() != trimmed;
    final avatarChanged = initialAvatarId != selectedAvatarId;
    return usernameChanged || avatarChanged;
  }

  ProfileIdentityState copyWith({
    String? username,
    Object? initialUsername = _unset,
    Object? usernameError = _unset,
    List<ProfileAvatar>? avatars,
    Object? selectedAvatarId = _unset,
    Object? selectedAvatarUrl = _unset,
    Object? initialAvatarId = _unset,
    String? initialAvatarStoragePath,
    bool? isLoading,
    bool? isSubmitting,
    Object? loadErrorMessage = _unset,
    ProfileIdentityAction? action,
    Object? actionMessage = _unset,
    Object? actionError = _unset,
    Object? updatedProfile = _unset,
  }) {
    return ProfileIdentityState(
      username: username ?? this.username,
      initialUsername:
          initialUsername == _unset
              ? this.initialUsername
              : initialUsername as String?,
      usernameError:
          usernameError == _unset
              ? this.usernameError
              : usernameError as ProfileIdentityValidationError?,
      avatars: avatars ?? this.avatars,
      selectedAvatarId:
          selectedAvatarId == _unset
              ? this.selectedAvatarId
              : selectedAvatarId as String?,
      selectedAvatarUrl:
          selectedAvatarUrl == _unset
              ? this.selectedAvatarUrl
              : selectedAvatarUrl as String?,
      initialAvatarId:
          initialAvatarId == _unset
              ? this.initialAvatarId
              : initialAvatarId as String?,
      initialAvatarStoragePath:
          initialAvatarStoragePath ?? this.initialAvatarStoragePath,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      loadErrorMessage:
          loadErrorMessage == _unset
              ? this.loadErrorMessage
              : loadErrorMessage as String?,
      action: action ?? this.action,
      actionMessage:
          actionMessage == _unset
              ? this.actionMessage
              : actionMessage as String?,
      actionError:
          actionError == _unset
              ? this.actionError
              : actionError as ProfileErrorCode?,
      updatedProfile:
          updatedProfile == _unset
              ? this.updatedProfile
              : updatedProfile as UserProfile?,
    );
  }

  static const _unset = Object();

  @override
  List<Object?> get props => [
    username,
    initialUsername,
    usernameError,
    avatars,
    selectedAvatarId,
    selectedAvatarUrl,
    initialAvatarId,
    initialAvatarStoragePath,
    isLoading,
    isSubmitting,
    loadErrorMessage,
    action,
    actionMessage,
    actionError,
    updatedProfile,
  ];
}
