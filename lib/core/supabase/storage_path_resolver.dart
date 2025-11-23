import 'package:supabase_flutter/supabase_flutter.dart';

/// Helpers for turning storage paths into public URLs.
/// Accepts:
///  - full URLs (returned as-is)
///  - `bucket/object_path`
///  - bare object paths (assumed to live in the households bucket)
String? storagePathToPublicUrl(SupabaseClient client, String? storagePath) {
  if (storagePath == null) return null;
  final trimmed = storagePath.trim();
  if (trimmed.isEmpty) return null;
  if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
    return trimmed;
  }

  final separatorIndex = trimmed.indexOf('/');
  String bucket = 'households';
  String objectPath = trimmed;

  if (separatorIndex != -1) {
    final candidateBucket = trimmed.substring(0, separatorIndex);
    final remainder = trimmed.substring(separatorIndex + 1);

    // If the candidate bucket matches a known bucket name, treat it as such.
    const knownBuckets = {'households', 'avatars'};
    if (knownBuckets.contains(candidateBucket)) {
      bucket = candidateBucket;
      objectPath = remainder;
    } else {
      // Otherwise, assume the path is bucket-less and the entire string is the object path.
      bucket = 'households';
      objectPath = trimmed;
    }
  }

  if (objectPath.isEmpty) return null;
  return client.storage.from(bucket).getPublicUrl(objectPath);
}
