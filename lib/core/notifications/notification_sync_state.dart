import 'notification_token_bootstrap.dart';

/// In-memory cache of the latest notification preference snapshot for token sync.
class NotificationSyncState {
  NotificationSyncPayload? _current;

  NotificationSyncPayload? get current => _current;

  void setPayload(NotificationSyncPayload payload) {
    _current = payload;
  }
}
