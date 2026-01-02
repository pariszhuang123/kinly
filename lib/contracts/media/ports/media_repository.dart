import 'dart:typed_data';

/// Uploads media files to backing storage and returns both the stored object
/// path and a public URL constructed from it.
class MediaUploadResult {
  const MediaUploadResult({required this.storagePath, required this.publicUrl});

  /// Object path within the bucket (no scheme/host), e.g. `flow/expectations/...`.
  final String storagePath;

  /// Publicly accessible URL for the uploaded asset.
  final String publicUrl;
}

abstract class MediaRepository {
  /// Uploads an expectation photo for a chore or related flow feature.
  ///
  /// The caller should supply the scoped home/chore IDs so the path is
  /// namespaced and obfuscated.
  Future<MediaUploadResult> uploadExpectationPhoto({
    required String homeId,
    String? choreId,
    String featureSegment = 'expectations',
    required Uint8List bytes,
  });
}
