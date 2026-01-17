import 'package:kinly/contracts/mood/house_pulse_models.dart';
import 'package:kinly/contracts/mood/ports/house_pulse_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseHousePulseRepository implements HousePulseRepository {
  SupabaseHousePulseRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<HousePulsePayload?> getWeeklyPulse({required String homeId}) async {
    final response = await _client.rpc(
      'house_pulse_weekly_get',
      params: {'p_home_id': homeId},
    );

    if (response is Map<String, dynamic>) {
      return HousePulsePayload.fromJson(response);
    }
    if (response is Map) {
      return HousePulsePayload.fromJson(response.cast<String, dynamic>());
    }
    return null;
  }

  @override
  Future<HousePulseRead?> markSeen({required String homeId}) async {
    final response = await _client.rpc(
      'house_pulse_mark_seen',
      params: {'p_home_id': homeId},
    );

    if (response is Map<String, dynamic>) {
      return HousePulseRead.fromJson(response);
    }
    if (response is Map) {
      return HousePulseRead.fromJson(response.cast<String, dynamic>());
    }
    return null;
  }
}
