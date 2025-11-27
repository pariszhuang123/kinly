enum NpsSubmitErrorCode {
  invalidScore,
  notEligible,
  notRequired,
  unauthorized,
  forbidden,
  unknown,
}

class NpsSubmitException implements Exception {
  final NpsSubmitErrorCode code;
  final String message;
  final Map<String, dynamic>? details;

  const NpsSubmitException(this.code, this.message, {this.details});

  @override
  String toString() => 'NpsSubmitException($code): $message';
}
