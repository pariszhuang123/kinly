import 'package:supabase_flutter/supabase_flutter.dart';

/// Helpers for turning `bucket/object_path` strings into public URLs.
String? storagePathToPublicUrl(SupabaseClient client, String? storagePath) {
  if (storagePath == null) return null;
  final trimmed = storagePath.trim();
  if (trimmed.isEmpty) return null;
  if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
    return trimmed;
  }

  final separatorIndex = trimmed.indexOf('/');
  final bucket =
      separatorIndex == -1 ? 'avatars' : trimmed.substring(0, separatorIndex);
  final objectPath =
      separatorIndex == -1 ? trimmed : trimmed.substring(separatorIndex + 1);
  if (objectPath.isEmpty) return null;
  return client.storage.from(bucket).getPublicUrl(objectPath);
}
