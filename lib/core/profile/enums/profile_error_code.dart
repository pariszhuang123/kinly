/// Error codes emitted when updating a user's profile identity via Supabase.
enum ProfileErrorCode {
  usernameTaken,
  avatarNotFound,
  avatarNotAllowedForPlan,
  avatarInUse,
  invalidUsername,
  profileNotFound,
  unauthorized,
  forbidden,
  unknown,
}
