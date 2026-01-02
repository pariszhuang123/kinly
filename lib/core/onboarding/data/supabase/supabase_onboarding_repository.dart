import 'package:kinly/contracts/onboarding/ports/onboarding_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase implementation backed by `today_onboarding_hints` SEC DEFINER RPC.
class SupabaseOnboardingRepository implements OnboardingRepository {
  SupabaseOnboardingRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<OnboardingHints> getTodayHints() async {
    final res = await _client.rpc('today_onboarding_hints');
    if (res is Map<String, dynamic>) {
      return OnboardingHints.fromJson(res);
    }
    if (res is Map) {
      return OnboardingHints.fromJson(res.cast<String, dynamic>());
    }
    // Fallback to empty hints on unexpected shapes to avoid blocking UI.
    return const OnboardingHints(
      activeChoreCount: 0,
      shouldPromptNotifications: false,
      shouldPromptFlatmateInviteShare: false,
      shouldPromptInviteShare: false,
    );
  }
}
