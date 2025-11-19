import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/repositories/account_repository.dart';

class SupabaseAccountRepository implements AccountRepository {
  SupabaseAccountRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<void> deleteAccount() async {
    // RPC is stubbed for now; once implemented it should perform the real
    // deletion and surface typed errors.
    await _client.rpc('profiles_delete_account');
  }
}
