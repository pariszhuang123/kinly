import 'package:kinly/contracts/mood/enums/mood_scale.dart';
import 'package:kinly/contracts/mood/models.dart';

abstract class MoodRepository {
  /// Returns true if the current user already submitted a mood for this ISO week.
  Future<bool> isSubmittedThisWeek(String homeId);

  /// Submit a mood entry; optionally add to gratitude wall (only respected for sunny/partially_sunny).
  Future<MoodSubmitResult> submit({
    required String homeId,
    required MoodScale mood,
    String? comment,
    bool addToWall = false,
  });

  /// Paginated gratitude wall.
  Future<GratitudeWallPage> listWall({
    required String homeId,
    int limit = 20,
    DateTime? cursorCreatedAt,
    String? cursorId,
  });

  /// Stats for gratitude wall (total + unread count).
  Future<GratitudeWallStats> getWallStats(String homeId);

  /// Mark gratitude wall as read.
  Future<void> markWallRead(String homeId);

  /// Fetch unread status for the gratitude wall.
  Future<GratitudeWallStatus> getWallStatus(String homeId);

  /// Returns true if an NPS answer is currently required for the user/home.
  Future<bool> isNpsRequired(String homeId);

  /// Submit an NPS score (0-10) for the current user/home.
  Future<void> submitNps({required String homeId, required int score});
}
