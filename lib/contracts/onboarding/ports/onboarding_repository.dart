/// Boundary for cross-feature onboarding hints surfaced on Today.
abstract class OnboardingRepository {
  /// Returns a prioritized set of onboarding prompts for the current user.
  Future<OnboardingHints> getTodayHints();
}

/// Hints returned by `today_onboarding_hints` RPC.
class OnboardingHints {
  const OnboardingHints({
    required this.activeChoreCount,
    required this.shouldPromptNotifications,
    required this.shouldPromptFlatmateInviteShare,
    required this.shouldPromptInviteShare,
    this.memberCapJoinRequests,
    this.memberCapJoinResolution,
  });

  final int activeChoreCount;
  final bool shouldPromptNotifications;
  final bool shouldPromptFlatmateInviteShare;
  final bool shouldPromptInviteShare;
  final MemberCapJoinRequests? memberCapJoinRequests;
  final MemberCapJoinResolution? memberCapJoinResolution;

  factory OnboardingHints.fromJson(Map<String, dynamic> json) {
    final memberCapRaw = json['memberCapJoinRequests'];
    final memberCapMap =
        memberCapRaw is Map ? memberCapRaw.cast<String, dynamic>() : null;
    final memberCapResolutionRaw = json['memberCapJoinResolution'];
    final memberCapResolutionMap =
        memberCapResolutionRaw is Map
            ? memberCapResolutionRaw.cast<String, dynamic>()
            : null;
    return OnboardingHints(
      activeChoreCount: json['activeChoreCount'] as int? ?? 0,
      shouldPromptNotifications:
          json['shouldPromptNotifications'] as bool? ?? false,
      shouldPromptFlatmateInviteShare:
          json['shouldPromptFlatmateInviteShare'] as bool? ?? false,
      shouldPromptInviteShare:
          json['shouldPromptInviteShare'] as bool? ?? false,
      memberCapJoinRequests:
          memberCapMap == null
              ? null
              : MemberCapJoinRequests.fromJson(memberCapMap),
      memberCapJoinResolution:
          memberCapResolutionMap == null
              ? null
              : MemberCapJoinResolution.fromJson(memberCapResolutionMap),
    );
  }
}

class MemberCapJoinRequests {
  const MemberCapJoinRequests({
    required this.homeId,
    required this.pendingCount,
    required this.joinerNames,
    required this.requestIds,
  });

  final String homeId;
  final int pendingCount;
  final List<String> joinerNames;
  final List<String> requestIds;

  factory MemberCapJoinRequests.fromJson(Map<String, dynamic> json) {
    final joinerNamesRaw = json['joinerNames'];
    final requestIdsRaw = json['requestIds'];
    return MemberCapJoinRequests(
      homeId: json['homeId'] as String? ?? '',
      pendingCount: (json['pendingCount'] as num?)?.toInt() ?? 0,
      joinerNames:
          joinerNamesRaw is List
              ? joinerNamesRaw.map((e) => e.toString()).toList()
              : const [],
      requestIds:
          requestIdsRaw is List
              ? requestIdsRaw.map((e) => e.toString()).toList()
              : const [],
    );
  }
}

class MemberCapJoinResolution {
  const MemberCapJoinResolution({
    required this.requestId,
    required this.joinerName,
    required this.resolvedReason,
  });

  final String requestId;
  final String joinerName;
  final String resolvedReason;

  factory MemberCapJoinResolution.fromJson(Map<String, dynamic> json) {
    return MemberCapJoinResolution(
      requestId: json['requestId'] as String? ?? '',
      joinerName: json['joinerName'] as String? ?? '',
      resolvedReason: json['resolvedReason'] as String? ?? '',
    );
  }
}
