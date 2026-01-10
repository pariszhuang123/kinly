import 'package:kinly/contracts/homes/models.dart';
import 'package:kinly/core/supabase/supabase_error_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:kinly/features/home/home.dart';

class SupabaseHomeRepository implements HomeRepository {
  SupabaseHomeRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<HomeCreationResult> create({String? name}) async {
    try {
      final response = await _client.rpc(
        'homes_create_with_invite',
        params: {if (name != null) 'p_name': name},
      );
      return HomeCreationResult.fromJson(response);
    } catch (error) {
      throw SupabaseErrorMapper.mapCreate(error);
    }
  }

  @override
  Future<HomeInvite> getOrCreateInvite({required String homeId}) async {
    try {
      final response = await _client.rpc(
        'invites_get_or_create',
        params: {'p_home_id': homeId},
      );
      return _parseInvite(response);
    } catch (error) {
      throw SupabaseErrorMapper.mapInviteGetOrCreate(error);
    }
  }

  @override
  Future<HomeInvite> revokeInvite({required String homeId}) async {
    try {
      final response = await _client.rpc(
        'invites_revoke',
        params: {'p_home_id': homeId},
      );
      return _parseInvite(response);
    } catch (error) {
      throw SupabaseErrorMapper.mapRevoke(error);
    }
  }

  @override
  Future<HomeJoinResult> join(String code) async {
    return joinHome(code);
  }

  @override
  Future<HomeJoinResult> joinHome(String code) async {
    try {
      final response = await _client.rpc(
        'homes_join',
        params: {'p_code': code},
      );
      final payload =
          (response is Map
              ? response.cast<String, dynamic>()
              : <String, dynamic>{});
      return HomeJoinResult.fromJson(payload);
    } catch (error) {
      throw SupabaseErrorMapper.mapJoin(error);
    }
  }

  @override
  Future<void> transferOwner({
    required String homeId,
    required String newOwnerId,
  }) async {
    try {
      await _client.rpc(
        'homes_transfer_owner',
        params: {'p_home_id': homeId, 'p_new_owner_id': newOwnerId},
      );
    } catch (error) {
      throw SupabaseErrorMapper.mapTransfer(error);
    }
  }

  @override
  Future<void> kickMember({
    required String homeId,
    required String userId,
  }) async {
    try {
      await _client.rpc(
        'members_kick',
        params: {'p_home_id': homeId, 'p_target_user_id': userId},
      );
    } catch (error) {
      throw SupabaseErrorMapper.mapKick(error);
    }
  }

  @override
  Future<LeaveResult> leave({required String homeId}) async {
    try {
      final response = await _client.rpc(
        'homes_leave',
        params: {'p_home_id': homeId},
      );
      return LeaveResult.fromJson((response as Map).cast<String, dynamic>());
    } catch (error) {
      throw SupabaseErrorMapper.mapLeave(error);
    }
  }

  @override
  Future<List<HomeMemberSummary>> listActiveMembers(
    String homeId, {
    bool excludeSelf = false,
  }) async {
    try {
      final response = await _client.rpc(
        'members_list_active_by_home',
        params: {'p_home_id': homeId, 'p_exclude_self': excludeSelf},
      );
      var members = _mapMembers(response);
      if (excludeSelf) {
        members = await _excludeSelf(members);
      }
      return members;
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<HomeInvite> getActiveInvite(String homeId) async {
    try {
      final response = await _client.rpc(
        'invites_get_active',
        params: {'p_home_id': homeId},
      );
      return HomeInvite.fromJson((response as Map).cast<String, dynamic>());
    } catch (error) {
      throw SupabaseErrorMapper.mapInviteGetOrCreate(error);
    }
  }

  @override
  Future<HomeInvite> rotateInvite(String homeId) async {
    try {
      final response = await _client.rpc(
        'invites_rotate',
        params: {'p_home_id': homeId},
      );
      return _parseInvite(response);
    } catch (error) {
      throw SupabaseErrorMapper.mapRotate(error);
    }
  }

  @override
  Future<void> logShareEvent({
    required String homeId,
    required String feature,
    required String channel,
  }) async {
    try {
      await _client.rpc(
        'share_log_event',
        params: {
          'p_home_id': homeId,
          'p_feature': feature,
          'p_channel': channel,
        },
      );
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> dismissMemberCapJoinRequests({required String homeId}) async {
    try {
      await _client.rpc(
        'member_cap_owner_dismiss',
        params: {'p_home_id': homeId},
      );
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<CurrentMembership?> getCurrentMembership({
    bool excludeSelf = false,
  }) async {
    try {
      final response = await _client.rpc('membership_me_current');
      final map =
          response is Map
              ? response.cast<String, dynamic>()
              : <String, dynamic>{};
      final currentRaw = map['current'];
      final current =
          currentRaw is Map ? currentRaw.cast<String, dynamic>() : null;
      if (current == null) return null;
      final membership = CurrentMembership.fromJson(current);
      if (excludeSelf) {
        final userId = Supabase.instance.client.auth.currentUser?.id;
        if (userId != null && membership.userId == userId) {
          return null;
        }
      }
      return membership;
    } catch (error) {
      rethrow;
    }
  }

  HomeInvite _parseInvite(dynamic response) {
    final map =
        response is Map
            ? response.cast<String, dynamic>()
            : <String, dynamic>{};
    final inviteRaw = map['invite'];
    if (inviteRaw is! Map) {
      throw Exception('Missing invite payload');
    }
    return HomeInvite.fromJson(inviteRaw.cast<String, dynamic>());
  }

  List<HomeMemberSummary> _mapMembers(dynamic response) {
    final rows = response is List ? response : const <dynamic>[];
    return rows
        .map((raw) => (raw as Map).cast<String, dynamic>())
        .map(HomeMemberSummary.fromJson)
        .toList(growable: false);
  }

  Future<List<HomeMemberSummary>> _excludeSelf(
    List<HomeMemberSummary> members,
  ) async {
    final self = await getCurrentMembership(excludeSelf: false);
    final userId = self?.userId;
    if (userId == null) return members;
    return members
        .where((member) => member.userId != userId)
        .toList(growable: false);
  }
}
