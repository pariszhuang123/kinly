import 'package:intl/intl.dart';
import 'package:kinly/contracts/chores/models.dart';
import 'package:kinly/core/supabase/storage_path_resolver.dart';
import 'package:kinly/core/supabase/supabase_error_mapper.dart';
import 'package:kinly/core/utils/url_validator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:kinly/features/flow/flow.dart';

class SupabaseChoresRepository implements ChoresRepository {
  SupabaseChoresRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;
  final _dateFormatter = DateFormat('yyyy-MM-dd');

  @override
  Future<Chore> create({
    required String homeId,
    required String name,
    String? assigneeUserId,
    DateTime? startDate,
    int? recurrenceEvery,
    ChoreRecurrenceUnit? recurrenceUnit,
    String? notes,
    String? howToVideoUrl,
    String? expectationPhotoPath,
  }) async {
    try {
      final sanitizedHowTo =
          howToVideoUrl == null ? null : normalizeHttpUrlOrNull(howToVideoUrl);
      final response = await _client.rpc(
        'chores_create_v2',
        params: {
          'p_home_id': homeId,
          'p_name': name,
          if (assigneeUserId != null) 'p_assignee_user_id': assigneeUserId,
          if (startDate != null)
            'p_start_date': _dateFormatter.format(startDate),
          if (recurrenceEvery != null) 'p_recurrence_every': recurrenceEvery,
          if (recurrenceUnit != null)
            'p_recurrence_unit': recurrenceUnit.wireValue,
          if (notes != null) 'p_notes': notes,
          'p_how_to_video_url': sanitizedHowTo,
          if (expectationPhotoPath != null)
            'p_expectation_photo_path': expectationPhotoPath,
        },
      );
      return _extractChore(response);
    } catch (error) {
      throw SupabaseErrorMapper.mapChore(error);
    }
  }

  @override
  Future<Chore> update({
    required String choreId,
    required String name,
    required String assigneeUserId,
    required DateTime startDate,
    int? recurrenceEvery,
    ChoreRecurrenceUnit? recurrenceUnit,
    String? notes,
    String? howToVideoUrl,
    String? expectationPhotoPath,
  }) async {
    try {
      final sanitizedHowTo =
          howToVideoUrl == null ? null : normalizeHttpUrlOrNull(howToVideoUrl);
      final response = await _client.rpc(
        'chores_update_v2',
        params: {
          'p_chore_id': choreId,
          'p_name': name,
          'p_assignee_user_id': assigneeUserId,
          'p_start_date': _dateFormatter.format(startDate),
          if (recurrenceEvery != null) 'p_recurrence_every': recurrenceEvery,
          if (recurrenceUnit != null)
            'p_recurrence_unit': recurrenceUnit.wireValue,
          if (notes != null) 'p_notes': notes,
          'p_how_to_video_url': sanitizedHowTo,
          if (expectationPhotoPath != null)
            'p_expectation_photo_path': expectationPhotoPath,
        },
      );
      return _extractChore(response);
    } catch (error) {
      throw SupabaseErrorMapper.mapChore(error);
    }
  }

  @override
  Future<ChoreCompletionResult> complete(String choreId) async {
    try {
      final response = await _client.rpc(
        'chore_complete',
        params: {'_chore_id': choreId},
      );
      final payload = _coerceMap(response);
      if (payload != null) {
        return ChoreCompletionResult.fromJson(payload);
      }
      throw const ChoreException(
        ChoreErrorCode.unknown,
        'Malformed chore completion payload from Supabase.',
      );
    } catch (error) {
      throw SupabaseErrorMapper.mapChore(error);
    }
  }

  @override
  Future<Chore> cancel(String choreId) async {
    try {
      final response = await _client.rpc(
        'chores_cancel',
        params: {'p_chore_id': choreId},
      );
      return _extractChore(response);
    } catch (error) {
      throw SupabaseErrorMapper.mapChore(error);
    }
  }

  @override
  Future<List<ChoreListEntry>> listForHome(String homeId) async {
    try {
      final response = await _client.rpc(
        'chores_list_for_home',
        params: {'p_home_id': homeId},
      );
      if (response is List) {
        return response
            .map((raw) {
              final entry = ChoreListEntry.fromJson(
                (raw as Map).cast<String, dynamic>(),
              );
              final avatarUrl = storagePathToPublicUrl(
                _client,
                entry.assigneeAvatarStoragePath,
              );
              return entry.copyWith(
                assigneeAvatarStoragePath:
                    avatarUrl ?? entry.assigneeAvatarStoragePath,
              );
            })
            .toList(growable: false);
      }
      throw const ChoreException(
        ChoreErrorCode.unknown,
        'Malformed chores list payload from Supabase.',
      );
    } catch (error) {
      throw SupabaseErrorMapper.mapChore(error);
    }
  }

  @override
  Future<List<TodayFlowEntry>> listTodayFlow({
    required String homeId,
    required ChoreState state,
  }) async {
    try {
      final response = await _client.rpc(
        'today_flow_list',
        params: {
          'p_home_id': homeId,
          'p_state': state.wireValue,
          'p_local_date': _dateFormatter.format(DateTime.now()),
        },
      );
      if (response is List) {
        return response
            .map(
              (raw) =>
                  TodayFlowEntry.fromJson((raw as Map).cast<String, dynamic>()),
            )
            .toList(growable: false);
      }
      throw const ChoreException(
        ChoreErrorCode.unknown,
        'Malformed today flow payload from Supabase.',
      );
    } catch (error) {
      throw SupabaseErrorMapper.mapChore(error);
    }
  }

  @override
  Future<ChoreDetails> getForHome({
    required String homeId,
    required String choreId,
  }) async {
    try {
      final response = await _client.rpc(
        'chores_get_for_home',
        params: {'p_home_id': homeId, 'p_chore_id': choreId},
      );
      final payload = _coerceMap(response);
      if (payload != null) {
        return ChoreDetails.fromJson(payload);
      }
      throw const ChoreException(
        ChoreErrorCode.unknown,
        'Malformed chore details payload from Supabase.',
      );
    } catch (error) {
      throw SupabaseErrorMapper.mapChore(error);
    }
  }

  @override
  Future<List<ChoreAssigneeSummary>> listAssigneesForHome(String homeId) async {
    try {
      final response = await _client.rpc(
        'home_assignees_list_v2',
        params: {'p_home_id': homeId},
      );
      if (response is List) {
        return response
            .map((raw) {
              final summary = ChoreAssigneeSummary.fromJson(
                (raw as Map).cast<String, dynamic>(),
              );
              final avatarUrl = storagePathToPublicUrl(
                _client,
                summary.avatarStoragePath,
              );
              return summary.copyWith(
                avatarStoragePath: avatarUrl ?? summary.avatarStoragePath,
              );
            })
            .toList(growable: false);
      }
      throw const ChoreException(
        ChoreErrorCode.unknown,
        'Malformed assignee list payload from Supabase.',
      );
    } catch (error) {
      throw SupabaseErrorMapper.mapChore(error);
    }
  }

  Chore _extractChore(dynamic rpcResult) {
    if (rpcResult is Map<String, dynamic>) {
      if (rpcResult.containsKey('chore')) {
        final payload = rpcResult['chore'];
        final mapPayload = _coerceMap(payload);
        if (mapPayload != null) {
          return Chore.fromJson(mapPayload);
        }
      }
      return Chore.fromJson(rpcResult);
    }
    if (rpcResult is Map) {
      return _extractChore(Map<String, dynamic>.from(rpcResult));
    }
    throw const ChoreException(
      ChoreErrorCode.unknown,
      'Malformed chore payload from Supabase.',
    );
  }

  Map<String, dynamic>? _coerceMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.cast<String, dynamic>();
    }
    return null;
  }
}
