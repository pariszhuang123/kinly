import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/repositories/profile_repository.dart';
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
    return UserProfile.fromJson(payload, avatarUrl: _publicUrlFor(storagePath));
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

  String? _publicUrlFor(String? storagePath) {
    if (storagePath == null || storagePath.isEmpty) return null;
    final normalized = storagePath.trim();
    if (normalized.startsWith('http://') || normalized.startsWith('https://')) {
      return normalized;
    }
    final separatorIndex = storagePath.indexOf('/');
    final bucket =
        separatorIndex == -1
            ? 'avatars'
            : storagePath.substring(0, separatorIndex);
    final objectPath =
        separatorIndex == -1
            ? storagePath
            : storagePath.substring(separatorIndex + 1);
    if (objectPath.isEmpty) return null;
    return _client.storage.from(bucket).getPublicUrl(objectPath);
  }
}
