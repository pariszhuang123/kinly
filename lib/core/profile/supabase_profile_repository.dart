import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/repositories/profile_repository.dart';
import '../supabase/storage_path_resolver.dart';
import 'models.dart';

class SupabaseProfileRepository implements ProfileRepository {
  SupabaseProfileRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<UserProfile?> getCurrentProfile() async {
    final response = await _client.rpc('profile_me');
    final payload = _coerceFirstRow(response);
    if (payload == null) return null;

    final storagePath =
        (payload['avatar_storage_path'] as String?)?.trim().isEmpty ?? true
            ? null
            : payload['avatar_storage_path'] as String?;
    return UserProfile.fromJson(
      payload,
      avatarUrl: storagePathToPublicUrl(_client, storagePath),
    );
  }

  Map<String, dynamic>? _coerceFirstRow(dynamic response) {
    if (response is List && response.isNotEmpty) {
      final first = response.first;
      if (first is Map<String, dynamic>) return first;
      if (first is Map) return first.cast<String, dynamic>();
    } else if (response is Map<String, dynamic>) {
      return response;
    } else if (response is Map) {
      return response.cast<String, dynamic>();
    }
    return null;
  }

  // Left here because other repositories still rely on the helper, but
  // profile repository now defers to [storagePathToPublicUrl].
}
