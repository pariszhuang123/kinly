import 'package:kinly/contracts/mood/house_pulse_models.dart';

bool hasUnseenHousePulse(HousePulsePayload? payload) {
  if (payload == null) return false;
  final seen = payload.seen;
  if (seen == null) return true;
  if (payload.pulse.pulseState != seen.lastSeenPulseState) return true;
  return payload.pulse.computedAt.isAfter(seen.lastSeenComputedAt);
}
