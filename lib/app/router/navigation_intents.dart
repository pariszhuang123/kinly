import 'package:kinly/core/di/locator.dart';
import 'package:kinly/core/links/join_intent_coordinator.dart';

class NavigationIntents {
  static Future<bool> captureInvite(Uri uri) async {
    if (!sl.isRegistered<JoinIntentCoordinator>()) return false;
    return sl<JoinIntentCoordinator>().capture(uri);
  }
}
