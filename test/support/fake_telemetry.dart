import 'package:kinly/core/telemetry/telemetry.dart';

class RecordedEvent {
  final String name;
  final Map<String, Object?> properties;

  RecordedEvent(this.name, this.properties);
}

/// Test helper to assert telemetry output.
class FakeTelemetry implements Telemetry {
  final List<RecordedEvent> events = [];

  @override
  void track(String event, {Map<String, Object?> properties = const {}}) {
    events.add(RecordedEvent(event, Map<String, Object?>.from(properties)));
  }

  void clear() => events.clear();
}
