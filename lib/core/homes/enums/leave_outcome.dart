/// Shared leave outcomes for homes.leave RPC responses.
/// Owned by Supabase/DB + Repositories; UI/BLoC should consume
/// via `lib/core/homes/models.dart`.
enum LeaveOutcome {
  leftOk,
  homeDeactivated,
}
