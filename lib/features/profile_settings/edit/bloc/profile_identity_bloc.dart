import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/profile/models.dart';
import '../../../../core/profile/enums/profile_error_code.dart';
import '../../../../core/profile/profile_error_mapper.dart';
import '../../../../data/repositories/profile_repository.dart';

part 'profile_identity_event.dart';
part 'profile_identity_state.dart';

class ProfileIdentityBloc
    extends Bloc<ProfileIdentityEvent, ProfileIdentityState> {
  ProfileIdentityBloc({
    required ProfileRepository profileRepository,
    required String homeId,
    String? initialUsername,
    String? initialAvatarStoragePath,
    String? initialAvatarUrl,
  }) : _profileRepository = profileRepository,
       _homeId = homeId,
       super(
         ProfileIdentityState.initial(
           username: initialUsername ?? '',
           avatarStoragePath: initialAvatarStoragePath,
           avatarUrl: initialAvatarUrl,
         ),
       ) {
    on<ProfileIdentityStarted>(_onStarted);
    on<ProfileIdentityUsernameChanged>(_onUsernameChanged);
    on<ProfileIdentityAvatarSelected>(_onAvatarSelected);
    on<ProfileIdentitySubmitted>(_onSubmitted);
  }

  final ProfileRepository _profileRepository;
  final String _homeId;

  Future<void> _onStarted(
    ProfileIdentityStarted event,
    Emitter<ProfileIdentityState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        loadErrorMessage: null,
        action: ProfileIdentityAction.none,
        actionMessage: null,
        actionError: null,
        updatedProfile: null,
      ),
    );
    try {
      final profileFuture = _profileRepository.getCurrentProfile();
      final avatarsFuture = _profileRepository.listAvailableAvatars(_homeId);

      final profile = await profileFuture;
      final avatars = await avatarsFuture;

      final username = profile?.username ?? state.username;
      final avatarStoragePath =
          profile?.avatarStoragePath ?? state.initialAvatarStoragePath;
      final selectedAvatarId = _resolveAvatarId(avatars, avatarStoragePath);
      emit(
        state.copyWith(
          isLoading: false,
          avatars: avatars,
          username: username,
          initialUsername: username,
          usernameError: _validateUsername(username),
          selectedAvatarId: selectedAvatarId,
          selectedAvatarUrl:
              _resolveAvatarUrl(avatars, selectedAvatarId) ??
              state.selectedAvatarUrl,
          initialAvatarId: selectedAvatarId,
          initialAvatarStoragePath: avatarStoragePath,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(isLoading: false, loadErrorMessage: error.toString()),
      );
    }
  }

  void _onUsernameChanged(
    ProfileIdentityUsernameChanged event,
    Emitter<ProfileIdentityState> emit,
  ) {
    final nextUsername = event.username.trim().toLowerCase();
    emit(
      state.copyWith(
        username: nextUsername,
        usernameError: _validateUsername(nextUsername),
      ),
    );
  }

  void _onAvatarSelected(
    ProfileIdentityAvatarSelected event,
    Emitter<ProfileIdentityState> emit,
  ) {
    final avatar = state.avatars.firstWhere(
      (item) => item.id == event.avatarId,
      orElse: () => const ProfileAvatar(id: '', storagePath: '', category: ''),
    );
    emit(
      state.copyWith(
        selectedAvatarId: event.avatarId,
        selectedAvatarUrl:
            avatar.id.isEmpty ? state.selectedAvatarUrl : avatar.imageUrl,
      ),
    );
  }

  Future<void> _onSubmitted(
    ProfileIdentitySubmitted event,
    Emitter<ProfileIdentityState> emit,
  ) async {
    if (!state.canSubmit || state.selectedAvatarId == null) return;
    final trimmedUsername = state.username.trim();
    emit(
      state.copyWith(
        isSubmitting: true,
        action: ProfileIdentityAction.none,
        actionMessage: null,
        actionError: null,
        updatedProfile: null,
      ),
    );
    try {
      final profile = await _profileRepository.updateIdentity(
        username: trimmedUsername,
        avatarId: state.selectedAvatarId!,
      );
      emit(
        state.copyWith(
          isSubmitting: false,
          action: ProfileIdentityAction.success,
          updatedProfile: profile,
          initialUsername: trimmedUsername,
          initialAvatarId: state.selectedAvatarId,
          initialAvatarStoragePath: profile.avatarStoragePath,
          username: trimmedUsername,
          actionError: null,
        ),
      );
    } catch (error) {
      final mapped =
          error is ProfileIdentityException
              ? error
              : ProfileErrorMapper.map(error);
      emit(
        state.copyWith(
          isSubmitting: false,
          action: ProfileIdentityAction.failure,
          actionMessage: mapped.message,
          actionError: mapped.code,
        ),
      );
    }
  }

  ProfileIdentityValidationError? _validateUsername(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return ProfileIdentityValidationError.empty;
    final regex = RegExp(r'^[a-z0-9](?:[a-z0-9._]{1,28})[a-z0-9]$');
    if (!regex.hasMatch(trimmed)) {
      return ProfileIdentityValidationError.invalidFormat;
    }
    return null;
  }

  String? _resolveAvatarId(List<ProfileAvatar> avatars, String? storagePath) {
    if (storagePath == null || storagePath.isEmpty) return null;
    for (final avatar in avatars) {
      if (avatar.storagePath == storagePath) return avatar.id;
    }
    return null;
  }

  String? _resolveAvatarUrl(List<ProfileAvatar> avatars, String? avatarId) {
    if (avatarId == null) return null;
    for (final avatar in avatars) {
      if (avatar.id == avatarId) {
        return avatar.imageUrl;
      }
    }
    return null;
  }
}
