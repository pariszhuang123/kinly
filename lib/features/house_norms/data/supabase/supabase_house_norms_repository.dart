import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:kinly/contracts/house_norms/models.dart';
import 'package:kinly/contracts/house_norms/ports/house_norms_repository.dart';

class SupabaseHouseNormsRepository implements HouseNormsRepository {
  SupabaseHouseNormsRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<HouseNormDocument?> getForHome({
    required String homeId,
    required String locale,
  }) async {
    final response = await _client.rpc(
      'house_norms_get_for_home',
      params: {
        'p_home_id': homeId,
        'p_locale': locale,
      },
    );
    final payload = _coerceMap(response);
    if (payload == null) {
      throw StateError('Missing house norms response.');
    }
    final normsRaw = payload['house_norms'];
    if (normsRaw == null || normsRaw is! Map) {
      return null;
    }
    return HouseNormDocument.fromJson(
      homeId: payload['home_id'] as String? ?? homeId,
      json: normsRaw.cast<String, dynamic>(),
    );
  }

  @override
  Future<HouseNormDocument> generateForHome({
    required String homeId,
    String templateKey = 'house_norms_v1',
    required String locale,
    required Map<String, int> inputs,
    bool force = false,
  }) async {
    await _client.rpc(
      'house_norms_generate_for_home',
      params: {
        'p_home_id': homeId,
        'p_template_key': templateKey,
        'p_locale': locale,
        'p_inputs': inputs,
        'p_force': force,
      },
    );
    final refreshed = await getForHome(homeId: homeId, locale: locale);
    if (refreshed == null) {
      throw StateError('House norms generate completed but document is missing.');
    }
    return refreshed;
  }

  @override
  Future<HouseNormDocument> editSectionText({
    required String homeId,
    required String locale,
    required String sectionKey,
    required String text,
    String? changeSummary,
  }) async {
    await _client.rpc(
      'house_norms_edit_section_text',
      params: {
        'p_home_id': homeId,
        'p_locale': locale,
        'p_section_key': sectionKey,
        'p_new_text': text,
        'p_change_summary': changeSummary,
      },
    );
    final refreshed = await getForHome(homeId: homeId, locale: locale);
    if (refreshed == null) {
      throw StateError('House norms edit completed but document is missing.');
    }
    return refreshed;
  }

  @override
  Future<HouseNormDocument> publishForHome({
    required String homeId,
    required String locale,
  }) async {
    final response = await _client.rpc(
      'house_norms_publish_for_home',
      params: {
        'p_home_id': homeId,
        'p_locale': locale,
      },
    );
    final payload = _coerceMap(response);
    if (payload == null) {
      throw StateError('Missing house norms publish response.');
    }
    final refreshed = await getForHome(homeId: homeId, locale: locale);
    if (refreshed == null) {
      // Fall back to payload shape if read-after-write is unavailable.
      return HouseNormDocument.fromJson(homeId: homeId, json: payload);
    }
    return refreshed;
  }

  Map<String, dynamic>? _coerceMap(dynamic response) {
    if (response is Map<String, dynamic>) return response;
    if (response is Map) return response.cast<String, dynamic>();
    if (response is List && response.isNotEmpty) {
      final first = response.first;
      if (first is Map<String, dynamic>) return first;
      if (first is Map) return first.cast<String, dynamic>();
    }
    return null;
  }
}
