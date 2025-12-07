/// Minimal telemetry abstraction so UI/BLoC code can emit events and tests can assert.
abstract class Telemetry {
  void track(String event, {Map<String, Object?> properties = const {}});
}

/// Default no-op telemetry (useful when no sink is wired).
class NullTelemetry implements Telemetry {
  const NullTelemetry();

  @override
  void track(String event, {Map<String, Object?> properties = const {}}) {}
}
