import '../models.dart';

abstract class HouseVibeRepository {
  Future<HouseVibePayload> getHomeVibe({
    required String homeId,
    bool force = false,
    bool includeAxes = false,
  });
}
