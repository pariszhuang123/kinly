import '../../core/profile/models.dart';

/// Repository boundary for user profile lookups scoped to the caller.
/// Keeps UI/BLoC unaware of Supabase specifics.
abstract class ProfileRepository {
  /// Returns the authenticated caller's profile, or null if none exists/active.
  Future<UserProfile?> getCurrentProfile();

  /// Lists avatars available to the caller for the given home.
  Future<List<ProfileAvatar>> listAvailableAvatars(String homeId);

  /// Updates the caller's username + avatar selection and returns the new
  /// identity.
  Future<UserProfile> updateIdentity({
    required String username,
    required String avatarId,
  });
}
