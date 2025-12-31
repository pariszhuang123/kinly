import 'dart:async';

import 'package:kinly/core/mood/enums/mood_scale.dart';
import 'package:kinly/core/mood/models.dart';
import 'package:kinly/core/supabase/supabase_error_mapper.dart';
import 'package:kinly/core/time/timezone.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../harmony.dart';

typedef RpcInvoker =
    FutureOr<dynamic> Function(String fn, {Map<String, dynamic>? params});

class SupabaseMoodRepository implements MoodRepository {
  final SupabaseClient _client;
  final RpcInvoker _rpc;

  SupabaseMoodRepository({SupabaseClient? client, RpcInvoker? rpc})
    : _client = client ?? Supabase.instance.client,
      _rpc =
          rpc ??
          ((fn, {params}) =>
              (client ?? Supabase.instance.client).rpc(fn, params: params));

  @override
  Future<bool> isSubmittedThisWeek(String homeId) async {
    final res = await _client.rpc(
      'mood_get_current_weekly',
      params: {'p_home_id': homeId},
    );
    if (res is bool) return res;
    if (res is Map) {
      final status = MoodStatus.fromJson(res.cast<String, dynamic>());
      return status.isSubmittedThisWeek;
    }
    return false;
  }

  @override
  Future<MoodSubmitResult> submit({
    required String homeId,
    required MoodScale mood,
    String? comment,
    bool addToWall = false,
  }) async {
    try {
      final res = await _rpc(
        'mood_submit',
        params: {
          'p_home_id': homeId,
          'p_mood': mood.wireValue,
          if (comment != null) 'p_comment': comment,
          'p_add_to_wall': addToWall,
        },
      );
      if (res is Map<String, dynamic>) {
        return MoodSubmitResult.fromJson(res);
      }
      if (res is Map) {
        return MoodSubmitResult.fromJson(res.cast<String, dynamic>());
      }
      if (res is List && res.isNotEmpty) {
        final first = res.first;
        if (first is Map<String, dynamic>) {
          return MoodSubmitResult.fromJson(first);
        }
        if (first is Map) {
          return MoodSubmitResult.fromJson(first.cast<String, dynamic>());
        }
      }
      throw const MoodSubmitException(
        MoodSubmitErrorCode.unknown,
        'Unexpected response submitting mood.',
      );
    } catch (error) {
      if (error is MoodSubmitException) rethrow;
      throw SupabaseErrorMapper.mapMoodSubmit(error);
    }
  }

  @override
  Future<GratitudeWallPage> listWall({
    required String homeId,
    int limit = 20,
    DateTime? cursorCreatedAt,
    String? cursorId,
  }) async {
    final res = await _client.rpc(
      'gratitude_wall_list',
      params: {
        'p_home_id': homeId,
        'p_limit': limit,
        if (cursorCreatedAt != null)
          'p_cursor_created_at': toUtcIsoString(cursorCreatedAt),
        if (cursorId != null) 'p_cursor_id': cursorId,
      },
    );
    if (res is List) {
      final posts = res
          .map(
            (raw) => GratitudeWallPost.fromJson(
              (raw as Map).cast<String, dynamic>(),
            ),
          )
          .toList(growable: false);
      DateTime? newCursorCreated;
      String? newCursorId;
      if (posts.isNotEmpty) {
        final last = posts.last;
        newCursorCreated = last.createdAt;
        newCursorId = last.id;
      }
      return GratitudeWallPage(
        posts: posts,
        cursorCreatedAt: newCursorCreated,
        cursorId: newCursorId,
      );
    }
    throw const MoodSubmitException(
      MoodSubmitErrorCode.unknown,
      'Unexpected wall response.',
    );
  }

  @override
  Future<GratitudeWallStats> getWallStats(String homeId) async {
    final res = await _client.rpc(
      'gratitude_wall_stats',
      params: {'p_home_id': homeId},
    );

    if (res is List && res.isNotEmpty) {
      final row = (res.first as Map).cast<String, dynamic>();
      return GratitudeWallStats.fromJson(row);
    }
    if (res is Map<String, dynamic>) {
      return GratitudeWallStats.fromJson(res);
    }
    if (res is Map) {
      return GratitudeWallStats.fromJson(res.cast<String, dynamic>());
    }

    return const GratitudeWallStats(
      totalPosts: 0,
      unreadCount: 0,
      lastReadAt: null,
    );
  }

  @override
  Future<void> markWallRead(String homeId) async {
    await _client.rpc(
      'gratitude_wall_mark_read',
      params: {'p_home_id': homeId},
    );
  }

  @override
  Future<GratitudeWallStatus> getWallStatus(String homeId) async {
    final res = await _client.rpc(
      'gratitude_wall_status',
      params: {'p_home_id': homeId},
    );

    if (res is List && res.isNotEmpty) {
      final row = (res.first as Map).cast<String, dynamic>();
      return GratitudeWallStatus.fromJson(row);
    }
    if (res is Map<String, dynamic>) {
      return GratitudeWallStatus.fromJson(res);
    }
    if (res is Map) {
      return GratitudeWallStatus.fromJson(res.cast<String, dynamic>());
    }

    return const GratitudeWallStatus(hasUnread: false);
  }

  @override
  Future<bool> isNpsRequired(String homeId) async {
    final res = await _client.rpc(
      'home_nps_get_status',
      params: {'p_home_id': homeId},
    );
    if (res is bool) return res;
    return false;
  }

  @override
  Future<void> submitNps({required String homeId, required int score}) async {
    try {
      await _client.rpc(
        'home_nps_submit',
        params: {'p_home_id': homeId, 'p_score': score},
      );
    } catch (error) {
      throw SupabaseErrorMapper.mapNpsSubmit(error);
    }
  }
}
