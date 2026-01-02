import 'dart:async';

import 'package:kinly/contracts/profile/models.dart';

/// Broadcasts profile updates so other features (e.g., Today) can refresh
/// without depending on navigation rebuilds.
class ProfileUpdateNotifier {
  final _controller = StreamController<UserProfile>.broadcast();

  Stream<UserProfile> get stream => _controller.stream;

  void notify(UserProfile profile) {
    if (_controller.isClosed) return;
    _controller.add(profile);
  }

  Future<void> dispose() async {
    await _controller.close();
  }
}
