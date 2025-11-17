import '../../core/chores/models.dart';

/// Repository boundary for chore lifecycle operations.
/// Keep UI/BLoC isolated from Supabase specifics.
abstract class ChoresRepository {
  /// Creates a new chore within [homeId].
  Future<Chore> create({
    required String homeId,
    required String name,
    String? assigneeUserId,
    DateTime? startDate,
    ChoreRecurrence recurrence = ChoreRecurrence.none,
    String? notes,
    String? howToVideoUrl,
    String? expectationPhotoPath,
  });

  /// Updates chore metadata (name, assignee, cadence, media, notes).
  Future<Chore> update({
    required String choreId,
    required String name,
    required String assigneeUserId,
    required DateTime startDate,
    ChoreRecurrence? recurrence,
    String? notes,
    String? howToVideoUrl,
    String? expectationPhotoPath,
  });

  /// Completes the current occurrence.
  Future<ChoreCompletionResult> complete(String choreId);

  /// Cancels a chore (draft/active only).
  Future<Chore> cancel(String choreId);

  /// Lists actionable chores for a home (minimal view rows).
  Future<List<ChoreListEntry>> listForHome(String homeId);

  /// Lists chores for the Today flow filtered by [state].
  Future<List<TodayFlowEntry>> listTodayFlow({
    required String homeId,
    required ChoreState state,
  });

  /// Full chore + list of eligible assignees for edit/view.
  /// Wraps `chores_get_for_home`.
  Future<ChoreDetails> getForHome({
    required String homeId,
    required String choreId,
  });

  /// All active members that can be assigned chores in a home.
  /// Wraps `home_assignees_list`.
  Future<List<ChoreAssigneeSummary>> listAssigneesForHome(String homeId);
}
