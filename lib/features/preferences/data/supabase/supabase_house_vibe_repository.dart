import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:kinly/contracts/preferences/models.dart';
import 'package:kinly/contracts/preferences/ports/house_vibe_repository.dart';

class SupabaseHouseVibeRepository implements HouseVibeRepository {
  SupabaseHouseVibeRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<HouseVibePayload> getHomeVibe({
    required String homeId,
    bool force = false,
    bool includeAxes = false,
  }) async {
    final response = await _client.rpc(
      'house_vibe_compute',
      params: {
        'p_home_id': homeId,
        'p_force': force,
        'p_include_axes': includeAxes,
      },
    );
    final payload = _coerceMap(response);
    if (payload == null) {
      throw StateError('Missing house vibe payload.');
    }
    return HouseVibePayload.fromJson(payload);
  }

  Map<String, dynamic>? _coerceMap(dynamic response) {
    if (response is Map<String, dynamic>) return response;
    if (response is Map) return response.cast<String, dynamic>();
    return null;
  }
}
