class NavigationIntents {
  static String? _pendingJoinCode;

  static String? takePendingJoinCode() {
    final code = _pendingJoinCode;
    _pendingJoinCode = null;
    return code;
  }

  static void setPendingJoinCode(String code) {
    _pendingJoinCode = code;
  }
}

