enum ShoppingPhotoCaptureErrorKind {
  permission,
  upload,
}

class ShoppingPhotoCaptureException implements Exception {
  const ShoppingPhotoCaptureException({
    required this.kind,
    required this.message,
    this.permanentlyDenied = false,
  });

  final ShoppingPhotoCaptureErrorKind kind;
  final String message;
  final bool permanentlyDenied;
}
