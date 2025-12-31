import '../../utils/avatar_cache_buster.dart';
import 'package:kinly/core/profile/models.dart';
import 'package:kinly/core/profile/profile_error_mapper.dart';
import 'package:kinly/core/supabase/storage_path_resolver.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../profile_settings.dart';

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
    final avatarVersion = storagePath;
    final avatarUrl = cacheBustAvatarUrl(
      storagePathToPublicUrl(_client, storagePath),
      version: avatarVersion,
    );
    return UserProfile.fromJson(
      payload,
      avatarUrl: avatarUrl,
      avatarVersion: avatarVersion,
    );
  }

  @override
  Future<List<ProfileAvatar>> listAvailableAvatars(String homeId) async {
    final response = await _client.rpc(
      'avatars_list_for_home',
      params: {'p_home_id': homeId},
    );
    final rows = _coerceList(response);
    if (rows == null) return const [];
    return rows
        .map((row) {
          final storagePath = row['storage_path'] as String?;
          return ProfileAvatar.fromJson(
            row,
            imageUrl: storagePathToPublicUrl(_client, storagePath),
          );
        })
        .toList(growable: false);
  }

  @override
  Future<UserProfile> updateIdentity({
    required String username,
    required String avatarId,
  }) async {
    try {
      final response = await _client.rpc(
        'profile_identity_update',
        params: {'p_username': username, 'p_avatar_id': avatarId},
      );
      final payload = _coerceFirstRow(response);
      if (payload == null) {
        throw StateError('Failed to update profile identity.');
      }
      final storagePath = payload['avatar_storage_path'] as String?;
      final avatarVersion = storagePath;
      final avatarUrl = cacheBustAvatarUrl(
        storagePathToPublicUrl(_client, storagePath),
        version: avatarVersion,
      );
      final authUserId =
          _client.auth.currentUser?.id ?? _client.auth.currentSession?.user.id;
      if (authUserId == null) {
        throw StateError('Missing authenticated user for profile identity.');
      }
      return UserProfile(
        userId: authUserId,
        username: payload['username'] as String,
        avatarId: payload['avatar_id'] as String?,
        avatarStoragePath: storagePath,
        avatarUrl: avatarUrl,
        avatarVersion: avatarVersion,
      );
    } catch (error) {
      if (error is ProfileIdentityException) rethrow;
      throw ProfileErrorMapper.map(error);
    }
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

  List<Map<String, dynamic>>? _coerceList(dynamic response) {
    if (response is List) {
      return response
          .where((row) => row is Map || row is Map<String, dynamic>)
          .map((row) {
            if (row is Map<String, dynamic>) return row;
            if (row is Map) return row.cast<String, dynamic>();
            return <String, dynamic>{};
          })
          .toList(growable: false);
    }
    return null;
  }
}
