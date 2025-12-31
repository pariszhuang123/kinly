/// Repository boundary for account-scoped operations such as deleting
/// the authenticated user.
abstract class AccountRepository {
  /// Deletes the caller's account (and associated profile data).
  ///
  /// Implementations should ensure that Supabase auth + profile records
  /// are removed and that related cleanup is handled server-side.
  Future<void> deleteAccount();
}
