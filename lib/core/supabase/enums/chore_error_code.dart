/// Error codes thrown by chore RPC helpers.
enum ChoreErrorCode {
  invalidInput,
  invalidName,
  invalidStart,
  invalidState,
  invalidMediaPath,
  assigneeNotMember,
  alreadyFinalized,
  paywallActiveCap,
  paywallMediaCap,
  notFound,
  notHomeMember,
  forbidden,
  unauthorized,
  unknown,
}
