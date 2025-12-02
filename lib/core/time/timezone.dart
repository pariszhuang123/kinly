// Timezone utilities shared across repositories/models.
// Ensures all writes go out as UTC and reads are converted to local once.

abstract class Clock {
  DateTime nowUtc();
  DateTime nowLocal();
}

class SystemClock implements Clock {
  const SystemClock();

  @override
  DateTime nowUtc() => DateTime.now().toUtc();

  @override
  DateTime nowLocal() => DateTime.now().toLocal();
}

DateTime? parseTimestampToLocal(Object? value) {
  if (value == null) return null;
  final dt = value is DateTime ? value : DateTime.parse(value as String);
  return dt.toLocal();
}

DateTime? parseDateToLocal(Object? value) {
  if (value == null) return null;
  final raw = value as String;
  if (raw.contains('T')) {
    return DateTime.parse(raw).toLocal();
  }
  // Date-only: treat as midnight local.
  final local = DateTime.parse('${raw}T00:00:00.000Z').toLocal();
  return DateTime(local.year, local.month, local.day);
}

String toUtcIsoString(DateTime value) => value.toUtc().toIso8601String();

({DateTime startUtc, DateTime endUtc}) localDayBoundsUtc(DateTime localNow) {
  final startLocal = DateTime(localNow.year, localNow.month, localNow.day);
  final endLocal = startLocal.add(const Duration(days: 1));
  return (startUtc: startLocal.toUtc(), endUtc: endLocal.toUtc());
}
