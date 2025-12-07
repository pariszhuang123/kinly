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
  });

  final int activeChoreCount;
  final bool shouldPromptNotifications;
  final bool shouldPromptFlatmateInviteShare;
  final bool shouldPromptInviteShare;

  factory OnboardingHints.fromJson(Map<String, dynamic> json) {
    return OnboardingHints(
      activeChoreCount: json['activeChoreCount'] as int? ?? 0,
      shouldPromptNotifications:
          json['shouldPromptNotifications'] as bool? ?? false,
      shouldPromptFlatmateInviteShare:
          json['shouldPromptFlatmateInviteShare'] as bool? ?? false,
      shouldPromptInviteShare: json['shouldPromptInviteShare'] as bool? ?? false,
    );
  }
}
