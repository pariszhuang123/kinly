import 'package:kinly/contracts/mood/house_pulse_models.dart';

abstract class HousePulseRepository {
  Future<HousePulsePayload?> getWeeklyPulse({required String homeId});

  Future<HousePulseRead?> markSeen({required String homeId});
}
