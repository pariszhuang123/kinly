import 'package:flutter/foundation.dart';

/// Simple clock abstraction to make time deterministic in tests.
abstract class Clock {
  DateTime now();
}

class SystemClock implements Clock {
  const SystemClock();

  @override
  DateTime now() => DateTime.now();
}
