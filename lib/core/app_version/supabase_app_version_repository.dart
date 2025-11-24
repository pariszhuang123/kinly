import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/repositories/app_version_repository.dart';

class SupabaseAppVersionRepository implements AppVersionRepository {
  SupabaseAppVersionRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<AppVersionStatusResult> checkVersion({
    required String clientVersion,
  }) async {
    final response = await _client.rpc(
      'check_app_version',
      params: {'client_version': clientVersion},
    );
    if (response is! Map<String, dynamic>) {
      throw StateError('Unexpected payload from check_app_version RPC.');
    }
    return AppVersionStatusResult(
      clientVersion: clientVersion,
      currentVersion: response['currentVersion'] as String? ?? clientVersion,
      minSupportedVersion:
          response['minSupportedVersion'] as String? ?? clientVersion,
      hardBlocked: response['hardBlocked'] as bool? ?? false,
      updateRecommended: response['updateRecommended'] as bool? ?? false,
      notes: response['notes'] as String?,
      releasedAt: _parseDate(response['releasedAt']),
    );
  }

  DateTime? _parseDate(dynamic value) {
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
