import 'package:flutter/widgets.dart';

const notificationPrefsRefreshRetryDelay = Duration(milliseconds: 350);

bool shouldSkipNotificationPrefsRefresh({
  required bool mounted,
  required AppLifecycleState? lifecycleState,
}) {
  if (!mounted) return true;
  if (lifecycleState == null) return false;

  switch (lifecycleState) {
    case AppLifecycleState.resumed:
      return false;
    case AppLifecycleState.inactive:
    case AppLifecycleState.hidden:
    case AppLifecycleState.paused:
    case AppLifecycleState.detached:
      return true;
  }
}

bool isRetryableNotificationPrefsRefreshError(Object error) {
  final normalized = error.toString().toLowerCase();
  return normalized.contains('clientexception') &&
      normalized.contains('bad file descriptor');
}

