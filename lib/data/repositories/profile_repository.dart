import '../../core/profile/models.dart';

/// Repository boundary for user profile lookups scoped to the caller.
/// Keeps UI/BLoC unaware of Supabase specifics.
abstract class ProfileRepository {
  /// Returns the authenticated caller's profile, or null if none exists/active.
  Future<UserProfile?> getCurrentProfile();
}
