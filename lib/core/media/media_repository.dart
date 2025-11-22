import 'dart:typed_data';

/// Uploads media files to backing storage and returns both storage path and
/// public URL (the households bucket is public for this feature).
class MediaUploadResult {
  const MediaUploadResult({required this.storagePath, required this.publicUrl});

  /// Full `bucket/object_path` string (e.g. households/flow/...).
  final String storagePath;

  /// Publicly accessible URL for the uploaded asset.
  final String publicUrl;
}

abstract class MediaRepository {
  /// Uploads an expectation photo for a chore.
  ///
  /// The caller should supply the scoped home/chore IDs so the path is
  /// namespaced and obfuscated.
  Future<MediaUploadResult> uploadExpectationPhoto({
    required String homeId,
    String? choreId,
    required Uint8List bytes,
  });
}
