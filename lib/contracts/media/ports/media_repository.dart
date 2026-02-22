import 'dart:io';

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
  /// namespaced and obfuscated. Accepts a [File] to enable streamed uploads
  /// without buffering the entire image in memory.
  Future<MediaUploadResult> uploadExpectationPhoto({
    required String homeId,
    String? choreId,
    String rootSegment = 'flow',
    String featureSegment = 'expectations',
    required File file,
  });
}
