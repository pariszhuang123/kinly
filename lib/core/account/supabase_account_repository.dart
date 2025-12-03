import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/repositories/account_repository.dart';

class SupabaseAccountRepository implements AccountRepository {
  SupabaseAccountRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<void> deleteAccount() async {
    // Deactivate the profile and leave homes server-side; bubbles ownership
    // errors when the caller must transfer first.
    await _client.rpc('profiles_request_deactivation');
  }
}
