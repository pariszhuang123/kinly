import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/repositories/chores_repository.dart';
import '../supabase/supabase_error_mapper.dart';
import 'models.dart';

class SupabaseChoresRepository implements ChoresRepository {
  final SupabaseClient _client;

  SupabaseChoresRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  // ---------------------------------------------------------------------------
  // CREATE
  // ---------------------------------------------------------------------------

  @override
  Future<Chore> create({
    required String homeId,
    required String name,
    String? assigneeUserId,
    DateTime? startDate,
    ChoreRecurrence recurrence = ChoreRecurrence.none,
    String? notes,
    String? howToVideoUrl,
    String? expectationPhotoPath,
  }) async {
    try {
      final response = await _client.rpc(
        'chores_create',
        params: {
          'p_home_id': homeId,
          'p_name': name,
          if (assigneeUserId != null) 'p_assignee_user_id': assigneeUserId,
          if (startDate != null) 'p_start_date': _toIsoDate(startDate),
          'p_recurrence': recurrence.wireValue,
          if (notes != null) 'p_notes': notes,
          if (howToVideoUrl != null) 'p_how_to_video_url': howToVideoUrl,
          if (expectationPhotoPath != null)
            'p_expectation_photo_path': expectationPhotoPath,
        },
      );
      return _extractChore(response);
    } catch (error) {
      throw SupabaseErrorMapper.mapChore(error);
    }
  }

  // ---------------------------------------------------------------------------
  // UPDATE
  // ---------------------------------------------------------------------------

  @override
  Future<Chore> update({
    required String choreId,
    required String name,
    required String assigneeUserId,
    required DateTime startDate,
    ChoreRecurrence? recurrence,
    String? notes,
    String? howToVideoUrl,
    String? expectationPhotoPath,
  }) async {
    try {
      final response = await _client.rpc(
        'chores_update',
        params: {
          'p_chore_id': choreId,
          'p_name': name,
          'p_assignee_user_id': assigneeUserId,
          'p_start_date': _toIsoDate(startDate),
          if (recurrence != null) 'p_recurrence': recurrence.wireValue,
          if (notes != null) 'p_notes': notes,
          if (howToVideoUrl != null) 'p_how_to_video_url': howToVideoUrl,
          if (expectationPhotoPath != null)
            'p_expectation_photo_path': expectationPhotoPath,
        },
      );
      return _extractChore(response);
    } catch (error) {
      throw SupabaseErrorMapper.mapChore(error);
    }
  }

  // ---------------------------------------------------------------------------
  // COMPLETE
  // ---------------------------------------------------------------------------

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

  // ---------------------------------------------------------------------------
  // CANCEL
  // ---------------------------------------------------------------------------

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

  // ---------------------------------------------------------------------------
  // LIST FOR HOME (chores_list_for_home)
  // ---------------------------------------------------------------------------

  @override
  Future<List<ChoreListEntry>> listForHome(String homeId) async {
    try {
      final response = await _client.rpc(
        'chores_list_for_home',
        params: {'p_home_id': homeId},
      );

      if (response is List) {
        return response
            .map(
              (raw) =>
                  ChoreListEntry.fromJson((raw as Map).cast<String, dynamic>()),
            )
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

  // ---------------------------------------------------------------------------
  // GET FOR HOME (single chore + assignees) - chores_get_for_home
  // ---------------------------------------------------------------------------

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

  // ---------------------------------------------------------------------------
  // OPTIONAL: list all potential assignees in a home (home_assignees_list)
  // ---------------------------------------------------------------------------

  @override
  Future<List<ChoreAssigneeSummary>> listAssigneesForHome(String homeId) async {
    try {
      final response = await _client.rpc(
        'home_assignees_list',
        params: {'p_home_id': homeId},
      );

      if (response is List) {
        return response
            .map(
              (raw) => ChoreAssigneeSummary.fromJson(
                (raw as Map).cast<String, dynamic>(),
              ),
            )
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

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  Chore _extractChore(dynamic rpcResult) {
    if (rpcResult is Map<String, dynamic>) {
      // Handle shape: { "chore": { ... } }
      if (rpcResult.containsKey('chore')) {
        final payload = rpcResult['chore'];
        final mapPayload = _coerceMap(payload);
        if (mapPayload != null) {
          return Chore.fromJson(mapPayload);
        }
      }

      // Or direct row: { id, home_id, ... }
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

  String _toIsoDate(DateTime date) {
    final utc = date.toUtc();
    // We only want YYYY-MM-DD for Postgres date columns.
    return utc.toIso8601String().split('T').first;
  }

  Map<String, dynamic>? _coerceMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.cast<String, dynamic>();
    }
    return null;
  }
}
