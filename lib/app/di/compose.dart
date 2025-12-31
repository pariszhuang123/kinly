import 'package:kinly/core/di/locator.dart';

import '../../features/flow/flow_di.dart';
import '../../features/home/home_di.dart';
import '../../features/paywall/paywall_di.dart';
import '../../features/share/share_di.dart';

/// Central composition root for runtime dependencies.
/// Add new feature installers here; keep `main` free of per-feature wiring.
void composeDependencies() {
  // Core (shared) registrations.
  setupDependencies();

  // Feature-owned dependencies.
  installHomeDependencies(sl);
  installFlowDependencies(sl);
  installPaywallDependencies(sl);
  installShareDependencies(sl);
}
