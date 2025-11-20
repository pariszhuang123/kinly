import 'dart:async';

import 'package:flutter/foundation.dart';

/// Bridges one or more streams to GoRouter via [Listenable] notifications.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) : this.multi([stream]);

  GoRouterRefreshStream.multi(Iterable<Stream<dynamic>> streams) {
    _subscriptions = [
      for (final stream in streams)
        stream.listen((_) => notifyListeners()),
    ];
  }

  late final List<StreamSubscription<dynamic>> _subscriptions;

  @override
  void dispose() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    super.dispose();
  }
}
