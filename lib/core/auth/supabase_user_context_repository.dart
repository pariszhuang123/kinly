import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:kinly/contracts/auth/ports/user_context_repository.dart';
import 'package:kinly/contracts/auth/models/user_context.dart';

class SupabaseUserContextRepository implements UserContextRepository {
  SupabaseUserContextRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<UserContext> fetch() async {
    final response = await _client.rpc('user_context_v1');
    final row = _coerceRow(response);
    return UserContext(
      userId: row['user_id'] as String? ?? '',
      hasHome: row['has_home'] as bool? ?? false,
      activeHomeId: row['active_home_id']?.toString(),
      hasPreferenceReport: row['has_preference_report'] as bool? ?? false,
      hasPersonalMentions: row['has_personal_mentions'] as bool? ?? false,
      avatarUrl: row['avatar_storage_path'] as String?,
      displayName: row['display_name'] as String?,
    );
  }

  Map<String, dynamic> _coerceRow(dynamic response) {
    if (response is Map<String, dynamic>) return response;
    if (response is Map) return response.cast<String, dynamic>();
    if (response is List && response.isNotEmpty) {
      final first = response.first;
      if (first is Map<String, dynamic>) return first;
      if (first is Map) return first.cast<String, dynamic>();
    }
    throw StateError('Unexpected user_context_v1 response shape.');
  }
}
