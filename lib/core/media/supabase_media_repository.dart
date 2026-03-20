import 'dart:io';
import 'dart:math';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:kinly/contracts/media/ports/media_repository.dart';

class SupabaseMediaRepository implements MediaRepository {
  SupabaseMediaRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;
  final _random = Random.secure();

  @override
  Future<MediaUploadResult> uploadExpectationPhoto({
    required String homeId,
    String? choreId, // optional: reserved for future path scoping
    String rootSegment = 'flow',
    String featureSegment = 'expectations',
    required File file,
  }) async {
    // Build a path that only depends on the home, timestamp, and randomness
    final objectPath = _buildObjectPath(
      homeId: homeId,
      rootSegment: rootSegment,
      featureSegment: featureSegment,
    );

    await _client.storage
        .from(_bucket)
        .upload(
          objectPath,
          file,
          fileOptions: const FileOptions(
            contentType: 'image/jpeg',
            upsert: true,
          ),
        );

    final publicUrl = _client.storage.from(_bucket).getPublicUrl(objectPath);

    return MediaUploadResult(
      // Store ONLY the object path in the DB
      storagePath: objectPath,
      publicUrl: publicUrl,
    );
  }

  String _buildObjectPath({
    required String homeId,
    required String rootSegment,
    required String featureSegment,
  }) {
    final safeHomeId = homeId.replaceAll('/', '_');
    final safeRoot = _sanitizeSegment(rootSegment);
    final safeFeature = _sanitizeFeature(featureSegment);
    final timestamp = DateTime.now().toUtc().millisecondsSinceEpoch;
    return '$safeRoot/$safeFeature/$safeHomeId/'
        '$timestamp-${_randomSuffix()}.jpg';
  }

  String _randomSuffix() {
    final value = _random.nextInt(0x7fffffff);
    return value.toRadixString(36);
  }

  String _sanitizeFeature(String value) {
    return _sanitizeSegment(value);
  }

  String _sanitizeSegment(String value) {
    final sanitized = value.toLowerCase().replaceAll(
      RegExp(r'[^a-z0-9_-]'),
      '',
    );
    return sanitized.isEmpty ? 'media' : sanitized;
  }

  static const _bucket = 'households';
}
