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
  Future<CurrentMembership?> getCurrentMembership() async {
    try {
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
    } catch (e) {
      // This is a non-critical call for routing; treat errors as no-membership.
      return null;
    }
  }
}
