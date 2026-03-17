enum HouseDirectoryPhotoCaptureErrorKind {
  permission,
  upload,
}

class HouseDirectoryPhotoCaptureException implements Exception {
  const HouseDirectoryPhotoCaptureException({
    required this.kind,
    required this.message,
    this.permanentlyDenied = false,
  });

  final HouseDirectoryPhotoCaptureErrorKind kind;
  final String message;
  final bool permanentlyDenied;
}
