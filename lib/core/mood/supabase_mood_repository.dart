import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/repositories/mood_repository.dart';
import 'enums/mood_scale.dart';
import 'models.dart';
import '../supabase/supabase_error_mapper.dart';

class SupabaseMoodRepository implements MoodRepository {
  final SupabaseClient _client;

  SupabaseMoodRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

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
      final res = await _client.rpc(
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
          'p_cursor_created_at': cursorCreatedAt.toUtc().toIso8601String(),
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
    if (res is Map<String, dynamic>) {
      return GratitudeWallStatus.fromJson(res);
    }
    if (res is Map) {
      return GratitudeWallStatus.fromJson(res.cast<String, dynamic>());
    }
    // fallback: no status info
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
