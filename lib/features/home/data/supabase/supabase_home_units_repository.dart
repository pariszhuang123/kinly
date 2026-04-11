import 'package:kinly/contracts/homes/home_units_models.dart';
import 'package:kinly/contracts/homes/ports/home_units_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseHomeUnitsRepository implements HomeUnitsRepository {
  SupabaseHomeUnitsRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<HomeUnitContext> getMyUnitContext({required String homeId}) async {
    final response = await _client.rpc(
      'home_units_get_my_context',
      params: {'p_home_id': homeId},
    );
    final payload = _coerceMap(response);
    if (payload == null) {
      throw StateError('Malformed home unit context payload.');
    }
    return HomeUnitContext.fromJson(payload);
  }

  @override
  Future<List<HomeUnitSummary>> listSelectableExpenseUnits({
    required String homeId,
  }) async {
    final response = await _client.rpc(
      'home_units_list_selectable_expense_units',
      params: {'p_home_id': homeId},
    );
    final payload = _coerceList(response);
    return payload
        .map((entry) => HomeUnitSummary.fromJson(entry))
        .toList(growable: false);
  }

  @override
  Future<List<HomeUnitMemberCandidate>> listCreateSharedUnitCandidates({
    required String homeId,
  }) async {
    final response = await _client.rpc(
      'home_units_list_create_shared_candidates',
      params: {'p_home_id': homeId},
    );
    final payload = _coerceList(response);
    return payload
        .map((entry) => HomeUnitMemberCandidate.fromJson(entry))
        .toList(growable: false);
  }

  @override
  Future<List<HomeUnitSummary>> listJoinableSharedUnits({
    required String homeId,
  }) async {
    final response = await _client.rpc(
      'home_units_list_joinable_shared_units',
      params: {'p_home_id': homeId},
    );
    final payload = _coerceList(response);
    return payload
        .map((entry) => HomeUnitSummary.fromJson(entry))
        .toList(growable: false);
  }

  @override
  Future<String> createSharedUnit({
    required String homeId,
    required String name,
    required List<String> membershipIds,
  }) async {
    final response = await _client.rpc(
      'home_units_create_shared',
      params: {
        'p_home_id': homeId,
        'p_name': name,
        'p_membership_ids': membershipIds,
      },
    );
    if (response is String && response.trim().isNotEmpty) {
      return response;
    }
    final payload = _coerceMap(response);
    final unitId =
        payload?['unit_id'] as String? ??
        payload?['unitId'] as String? ??
        payload?['id'] as String?;
    if (unitId == null || unitId.trim().isEmpty) {
      throw StateError('Malformed create shared unit payload.');
    }
    return unitId;
  }

  @override
  Future<String> renameSharedUnit({
    required String unitId,
    required String name,
  }) async {
    final response = await _client.rpc(
      'home_units_update_shared',
      params: {'p_unit_id': unitId, 'p_name': name},
    );
    return _coerceUnitId(response, errorMessage: 'Malformed rename shared unit payload.');
  }

  @override
  Future<String> joinSharedUnit({required String unitId}) async {
    final response = await _client.rpc(
      'home_units_join_shared',
      params: {'p_unit_id': unitId},
    );
    return _coerceUnitId(response, errorMessage: 'Malformed join shared unit payload.');
  }

  @override
  Future<String> leaveSharedUnit({required String unitId}) async {
    final response = await _client.rpc(
      'home_units_leave_shared',
      params: {'p_unit_id': unitId},
    );
    return _coerceUnitId(response, errorMessage: 'Malformed leave shared unit payload.');
  }

  Map<String, dynamic>? _coerceMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return value.cast<String, dynamic>();
    return null;
  }

  List<Map<String, dynamic>> _coerceList(dynamic value) {
    if (value is List<Map<String, dynamic>>) return value;
    if (value is List) {
      return value
          .whereType<Map>()
          .map((entry) => entry.cast<String, dynamic>())
          .toList(growable: false);
    }
    return const <Map<String, dynamic>>[];
  }

  String _coerceUnitId(dynamic response, {required String errorMessage}) {
    if (response is String && response.trim().isNotEmpty) {
      return response;
    }
    final payload = _coerceMap(response);
    final unitId =
        payload?['unit_id'] as String? ??
        payload?['unitId'] as String? ??
        payload?['id'] as String?;
    if (unitId == null || unitId.trim().isEmpty) {
      throw StateError(errorMessage);
    }
    return unitId;
  }
}
