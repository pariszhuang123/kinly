/// Error codes emitted by database RPCs via public.api_error/api_assert.
/// Keep these in sync with Supabase migrations.
enum JoinErrorCode {
  invalidCode,
  inactiveInvite,
  alreadyInOtherHome,
  paywallLimitActiveMembers,
  unauthorized,
  forbidden,
  unknown,
}

enum CreateHomeErrorCode {
  alreadyInOtherHome,
  unauthorized,
  forbidden,
  unknown,
}

enum RotateErrorCode { forbidden, unauthorized, unknown }

enum RevokeErrorCode { forbidden, unauthorized, unknown }

enum InviteGetOrCreateErrorCode {
  forbidden,
  inactiveHome,
  unauthorized,
  unknown,
}

enum TransferErrorCode {
  invalidNewOwner,
  newOwnerNotMember,
  forbidden,
  stateChangedRetry,
  unauthorized,
  unknown,
}

enum LeaveErrorCode {
  notMember,
  ownerMustTransferFirst,
  stateChangedRetry,
  forbidden,
  unauthorized,
  unknown,
}
