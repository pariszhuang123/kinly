import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/repositories/home_repository.dart';
import '../homes/models.dart';
import '../supabase/supabase_error_mapper.dart';

class SupabaseHomeRepository implements HomeRepository {
  final SupabaseClient _client;
  SupabaseHomeRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  @override
  Future<void> join(String code) async {
    if (code.trim().isEmpty) {
      throw HomeJoinException(
        JoinErrorCode.invalidCode,
        'Invite code cannot be empty',
      );
    }
    try {
      // SQL function name: public.homes_join(p_code text)
      await _client.rpc('homes_join', params: {'p_code': code});
    } catch (e) {
      throw SupabaseErrorMapper.mapJoin(e);
    }
  }

  @override
  Future<HomeCreationResult> create() async {
    try {
      final res = await _client.rpc('homes_create_with_invite');
      if (res is Map<String, dynamic>) {
        return HomeCreationResult.fromJson(res);
      }
      if (res is Map) {
        return HomeCreationResult.fromJson(res.cast<String, dynamic>());
      }
      throw HomeCreateException(
        CreateHomeErrorCode.unknown,
        'Unexpected response creating home',
      );
    } catch (e) {
      if (e is HomeCreateException) rethrow;
      throw SupabaseErrorMapper.mapCreate(e);
    }
  }

  @override
  Future<void> revokeInvite(String homeId) async {
    try {
      await _client.rpc('invites_revoke', params: {'p_home_id': homeId});
    } catch (e) {
      throw SupabaseErrorMapper.mapRevoke(e);
    }
  }

  @override
  Future<String> rotateInvite(String homeId) async {
    try {
      final res = await _client.rpc(
        'invites_rotate',
        params: {'p_home_id': homeId},
      );
      if (res is Map && res['invite_code'] is String) {
        return res['invite_code'] as String;
      }
      // If shape changes unexpectedly, still surface a typed error
      throw InviteRotateException(
        RotateErrorCode.unknown,
        'Missing invite_code in response',
      );
    } catch (e) {
      if (e is InviteRotateException) rethrow;
      throw SupabaseErrorMapper.mapRotate(e);
    }
  }

  @override
  Future<HomeInvite> getActiveInvite(String homeId) async {
    try {
      final res = await _client.rpc(
        'invites_get_active',
        params: {'p_home_id': homeId},
      );
      if (res is Map<String, dynamic>) {
        return HomeInvite.fromJson(res);
      }
      if (res is Map) {
        return HomeInvite.fromJson(res.cast<String, dynamic>());
      }
      throw InviteGetOrCreateException(
        InviteGetOrCreateErrorCode.unknown,
        'Unexpected response fetching active invite',
      );
    } catch (e) {
      if (e is InviteGetOrCreateException) rethrow;
      throw SupabaseErrorMapper.mapInviteGetOrCreate(e);
    }
  }

  @override
  Future<HomeInvite> getOrCreateInvite(String homeId) async {
    try {
      final res = await _client.rpc(
        'invites_get_or_create',
        params: {'p_home_id': homeId},
      );
      if (res is Map<String, dynamic>) {
        return HomeInvite.fromJson(res);
      }
      if (res is Map) {
        return HomeInvite.fromJson(res.cast<String, dynamic>());
      }
      throw InviteGetOrCreateException(
        InviteGetOrCreateErrorCode.unknown,
        'Unexpected response fetching invite',
      );
    } catch (e) {
      if (e is InviteGetOrCreateException) rethrow;
      throw SupabaseErrorMapper.mapInviteGetOrCreate(e);
    }
  }

  @override
  Future<void> transferOwner(String homeId, String newOwnerId) async {
    try {
      await _client.rpc(
        'homes_transfer_owner',
        params: {'p_home_id': homeId, 'p_new_owner_id': newOwnerId},
      );
    } catch (e) {
      throw SupabaseErrorMapper.mapTransfer(e);
    }
  }

  @override
  Future<List<HomeMemberSummary>> listActiveMembers(
    String homeId, {
    bool excludeSelf = false,
  }) async {
    try {
      final res = await _client.rpc(
        'members_list_active_by_home',
        params: {'p_home_id': homeId, 'p_exclude_self': excludeSelf},
      );
      if (res is List) {
        return res
            .map(
              (raw) => HomeMemberSummary.fromJson(
                (raw as Map).cast<String, dynamic>(),
              ),
            )
            .toList(growable: false);
      }
      throw Exception('Unexpected response when listing members');
    } catch (error) {
      throw Exception('Failed to load members: $error');
    }
  }

  @override
  Future<LeaveResult> leave(String homeId) async {
    try {
      final res = await _client.rpc(
        'homes_leave',
        params: {'p_home_id': homeId},
      );
      if (res is Map<String, dynamic>) {
        return LeaveResult.fromJson(res);
      }
      if (res is Map) {
        return LeaveResult.fromJson(res.cast<String, dynamic>());
      }
      throw LeaveException(LeaveErrorCode.unknown, 'Unexpected response');
    } catch (e) {
      if (e is LeaveException) rethrow;
      throw SupabaseErrorMapper.mapLeave(e);
    }
  }

  @override
  Future<void> kickMember(String homeId, String userId) async {
    try {
      await _client.rpc(
        'members_kick',
        params: {'p_home_id': homeId, 'p_target_user_id': userId},
      );
    } catch (e) {
      throw SupabaseErrorMapper.mapKick(e);
    }
  }

  @override
  Future<CurrentMembership?> getCurrentMembership() async {
    final res = await _client.rpc('membership_me_current');
    if (res is Map<String, dynamic>) {
      final current = res['current'];
      if (current == null) return null;
      if (current is Map<String, dynamic>) {
        return CurrentMembership.fromJson(current);
      }
      if (current is Map) {
        return CurrentMembership.fromJson(current.cast<String, dynamic>());
      }
    }
    if (res is Map) {
      final current = res['current'];
      if (current == null) return null;
      if (current is Map) {
        return CurrentMembership.fromJson(current.cast<String, dynamic>());
      }
    }
    return null;
  }

  @override
  Future<void> logShareEvent({
    required String feature,
    required String channel,
    String? homeId,
  }) async {
    await _client.rpc(
      'share_log_event',
      params: {
        'p_home_id': homeId,
        'p_feature': feature,
        'p_channel': channel,
      },
    );
  }
}
