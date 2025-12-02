// Repository boundary for Home membership operations.
// UI/BLoC should depend on this interface only.
import '../../core/homes/models.dart';

abstract class HomeRepository {
  /// Join a home via invite code.
  ///
  /// Throws a domain-specific exception on failure (e.g., [HomeJoinException]).
  Future<void> join(String code);

  /// Creates a new home owned by the caller and returns the created record.
  Future<HomeCreationResult> create();

  /// Revoke the current active invite for a home (owner-only).
  /// Idempotent when no active invite exists.
  Future<void> revokeInvite(String homeId);

  /// Rotate the invite for a home (owner-only) and return the new code.
  Future<String> rotateInvite(String homeId);

  /// Returns the current active invite for a home without creating a new one.
  /// Any active member may call this. Throws if no active invite exists.
  Future<HomeInvite> getActiveInvite(String homeId);

  /// Returns the active invite for a home, creating one if missing (owner-only).
  Future<HomeInvite> getOrCreateInvite(String homeId);

  /// Transfer ownership to another active member.
  Future<void> transferOwner(String homeId, String newOwnerId);

  /// Leave the specified home; returns details about outcome.
  Future<LeaveResult> leave(String homeId);

  /// Remove a member from the given home (owner-only).
  Future<void> kickMember(String homeId, String userId);

  /// Lists active members for the given home.
  Future<List<HomeMemberSummary>> listActiveMembers(
    String homeId, {
    bool excludeSelf = false,
  });

  /// Returns the caller's current membership, or null if none.
  Future<CurrentMembership?> getCurrentMembership();

  /// Logs a share attempt for the given home/feature/channel.
  Future<void> logShareEvent({
    required String feature,
    required String channel,
    String? homeId,
  });
}
