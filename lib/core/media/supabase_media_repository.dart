import 'dart:math';
import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'media_repository.dart';

class SupabaseMediaRepository implements MediaRepository {
  SupabaseMediaRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;
  final _random = Random.secure();

  @override
  Future<MediaUploadResult> uploadExpectationPhoto({
    required String homeId,
    String? choreId,
    required Uint8List bytes,
  }) async {
    final objectPath = _buildObjectPath(homeId: homeId, choreId: choreId);
    await _client.storage
        .from(_bucket)
        .uploadBinary(
          objectPath,
          bytes,
          fileOptions: const FileOptions(
            contentType: 'image/jpeg',
            upsert: true,
          ),
        );
    final publicUrl = _client.storage.from(_bucket).getPublicUrl(objectPath);
    return MediaUploadResult(
      storagePath: '$_bucket/$objectPath',
      publicUrl: publicUrl,
    );
  }

  String _buildObjectPath({required String homeId, String? choreId}) {
    final safeHomeId = homeId.replaceAll('/', '_');
    final scopeId = choreId ?? 'temp-${_randomSuffix()}';
    final timestamp = DateTime.now().toUtc().millisecondsSinceEpoch;
    return 'flow/expectations/$safeHomeId/$scopeId/${timestamp}-${_randomSuffix()}.jpg';
  }

  String _randomSuffix() {
    final value = _random.nextInt(0x7fffffff);
    return value.toRadixString(36);
  }

  static const _bucket = 'households';
}
