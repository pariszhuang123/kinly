enum HouseNormPublishErrorCode {
  artifactSyncFailed,
  revalidateFailed,
  unauthorized,
  forbidden,
  unknown,
}

class HouseNormPublishException implements Exception {
  const HouseNormPublishException({
    required this.code,
    required this.message,
    this.details,
  });

  final HouseNormPublishErrorCode code;
  final String message;
  final Map<String, dynamic>? details;
}
