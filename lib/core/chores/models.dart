import 'enums/chore_completion_status.dart';
import 'enums/chore_recurrence.dart';
import 'enums/chore_state.dart';

export 'enums/chore_completion_status.dart';
export 'enums/chore_recurrence.dart';
export 'enums/chore_state.dart';

// -----------------------------------------------------------------------------
// Core entity: Chore (matches public.chores row)
// -----------------------------------------------------------------------------

class Chore {
  final String id;
  final String homeId;
  final String createdByUserId;
  final String? assigneeUserId;
  final String name;
  final DateTime startDate;
  final ChoreRecurrence recurrence;
  final DateTime? recurrenceCursor;
  final DateTime? nextOccurrence;
  final String? expectationPhotoPath;
  final String? howToVideoUrl;
  final String? notes;
  final ChoreState state;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Chore({
    required this.id,
    required this.homeId,
    required this.createdByUserId,
    required this.assigneeUserId,
    required this.name,
    required this.startDate,
    required this.recurrence,
    required this.recurrenceCursor,
    required this.nextOccurrence,
    required this.expectationPhotoPath,
    required this.howToVideoUrl,
    required this.notes,
    required this.state,
    required this.completedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Chore.fromJson(Map<String, dynamic> json) {
    return Chore(
      id: json['id'] as String,
      homeId: json['home_id'] as String,
      createdByUserId: json['created_by_user_id'] as String,
      assigneeUserId: json['assignee_user_id'] as String?,
      name: json['name'] as String,
      startDate: _parseDate(json['start_date'])!,
      recurrence: ChoreRecurrenceWire.fromWire(json['recurrence'] as String?),
      recurrenceCursor: _parseTimestamp(json['recurrence_cursor']),
      nextOccurrence: _parseDate(json['next_occurrence']),
      expectationPhotoPath: json['expectation_photo_path'] as String?,
      howToVideoUrl: json['how_to_video_url'] as String?,
      notes: json['notes'] as String?,
      state: ChoreStateWire.fromWire(json['state'] as String?),
      completedAt: _parseTimestamp(json['completed_at']),
      createdAt: _parseTimestamp(json['created_at'])!,
      updatedAt: _parseTimestamp(json['updated_at'])!,
    );
  }
}

// -----------------------------------------------------------------------------
// List entry: chores_list_for_home
// -----------------------------------------------------------------------------

class ChoreListEntry {
  final String id;
  final String homeId;
  final String name;
  final DateTime startDate;
  final String? assigneeUserId;
  final String? assigneeFullName;
  final String? assigneeAvatarStoragePath;

  const ChoreListEntry({
    required this.id,
    required this.homeId,
    required this.name,
    required this.startDate,
    this.assigneeUserId,
    this.assigneeFullName,
    this.assigneeAvatarStoragePath,
  });

  factory ChoreListEntry.fromJson(Map<String, dynamic> json) {
    return ChoreListEntry(
      id: json['id'] as String,
      homeId: json['home_id'] as String,
      name: json['name'] as String,
      startDate: _parseDate(json['start_date'])!,
      assigneeUserId: json['assignee_user_id'] as String?,
      assigneeFullName: json['assignee_full_name'] as String?,
      assigneeAvatarStoragePath:
          json['assignee_avatar_storage_path'] as String?,
    );
  }

  ChoreListEntry copyWith({
    String? assigneeUserId,
    String? assigneeFullName,
    String? assigneeAvatarStoragePath,
  }) {
    return ChoreListEntry(
      id: id,
      homeId: homeId,
      name: name,
      startDate: startDate,
      assigneeUserId: assigneeUserId ?? this.assigneeUserId,
      assigneeFullName: assigneeFullName ?? this.assigneeFullName,
      assigneeAvatarStoragePath:
          assigneeAvatarStoragePath ?? this.assigneeAvatarStoragePath,
    );
  }
}

// -----------------------------------------------------------------------------
// Today flow entry: today_flow_list
// -----------------------------------------------------------------------------

class TodayFlowEntry {
  final String id;
  final String homeId;
  final String name;
  final DateTime startDate;
  final ChoreState state;

  const TodayFlowEntry({
    required this.id,
    required this.homeId,
    required this.name,
    required this.startDate,
    required this.state,
  });

  factory TodayFlowEntry.fromJson(Map<String, dynamic> json) {
    return TodayFlowEntry(
      id: json['id'] as String,
      homeId: json['home_id'] as String,
      name: json['name'] as String,
      startDate: _parseDate(json['start_date'])!,
      state: ChoreStateWire.fromWire(json['state'] as String?),
    );
  }

  bool get isDraft => state == ChoreState.draft;
  bool get isActive => state == ChoreState.active;
}

// -----------------------------------------------------------------------------
// Assignee summary + details: chores_get_for_home, home_assignees_list
// -----------------------------------------------------------------------------

/// Represents a potential assignee in a home.
/// Used by:
/// - home_assignees_list (user_id, full_name, avatar_storage_path)
/// - chores_get_for_home "assignees" array.
class ChoreAssigneeSummary {
  final String userId;
  final String? fullName;
  final String? avatarStoragePath;

  const ChoreAssigneeSummary({
    required this.userId,
    this.fullName,
    this.avatarStoragePath,
  });

  factory ChoreAssigneeSummary.fromJson(Map<String, dynamic> json) {
    return ChoreAssigneeSummary(
      // Supports both "user_id" and "id" just in case.
      userId: (json['user_id'] ?? json['id']) as String,
      fullName: json['full_name'] as String?,
      avatarStoragePath: json['avatar_storage_path'] as String?,
    );
  }

  ChoreAssigneeSummary copyWith({String? fullName, String? avatarStoragePath}) {
    return ChoreAssigneeSummary(
      userId: userId,
      fullName: fullName ?? this.fullName,
      avatarStoragePath: avatarStoragePath ?? this.avatarStoragePath,
    );
  }
}

/// Wrapper for chores_get_for_home result:
/// {
///   "chore": { ...partial/full chore json... },
///   "assignees": [ { "user_id": ..., "full_name": ..., "avatar_storage_path": ... }, ... ]
/// }
class ChoreDetails {
  final Chore chore;
  final List<ChoreAssigneeSummary> assignees;

  const ChoreDetails({required this.chore, required this.assignees});

  factory ChoreDetails.fromJson(Map<String, dynamic> json) {
    final choreJson = json['chore'] as Map<String, dynamic>;
    final assigneesJson = json['assignees'] as List<dynamic>? ?? const [];

    return ChoreDetails(
      chore: Chore.fromJson(choreJson),
      assignees:
          assigneesJson
              .map(
                (e) => ChoreAssigneeSummary.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
    );
  }
}

// -----------------------------------------------------------------------------
// Completion: chore_complete result
// -----------------------------------------------------------------------------

/// Matches the JSON returned by public.chore_complete(_chore_id uuid)
class ChoreCompletionResult {
  final ChoreCompletionStatus status;
  final String choreId;
  final String homeId;
  final ChoreState? state;
  final ChoreRecurrence? recurrence;
  final DateTime? previousNextOccurrence;
  final DateTime? newNextOccurrence;
  final int? stepsAdvanced;

  const ChoreCompletionResult({
    required this.status,
    required this.choreId,
    required this.homeId,
    this.state,
    this.recurrence,
    this.previousNextOccurrence,
    this.newNextOccurrence,
    this.stepsAdvanced,
  });

  factory ChoreCompletionResult.fromJson(Map<String, dynamic> json) {
    return ChoreCompletionResult(
      status: ChoreCompletionStatus.fromWire(json['status'] as String?),
      choreId: json['chore_id'] as String,
      homeId: json['home_id'] as String,
      state: (json['state'] as String?)?.let(
        (value) => ChoreStateWire.fromWire(value),
      ),
      recurrence: (json['recurrence'] as String?)?.let(
        (value) => ChoreRecurrenceWire.fromWire(value),
      ),
      previousNextOccurrence: _parseDate(json['previous_next_occurrence']),
      newNextOccurrence: _parseDate(json['new_next_occurrence']),
      stepsAdvanced: (json['steps_advanced'] as num?)?.toInt(),
    );
  }
}

// -----------------------------------------------------------------------------
// Helpers
// -----------------------------------------------------------------------------

DateTime? _parseDate(Object? value) {
  if (value == null) return null;
  final raw = value as String;
  if (raw.contains('T')) {
    final dt = DateTime.parse(raw);
    return dt.isUtc ? dt : dt.toUtc();
  }
  // Date-only string; normalize to midnight UTC.
  return DateTime.parse('${raw}T00:00:00.000Z');
}

DateTime? _parseTimestamp(Object? value) {
  if (value == null) return null;
  final dt = DateTime.parse(value as String);
  return dt.isUtc ? dt : dt.toUtc();
}

extension NullableLet<T> on T? {
  R? let<R>(R Function(T value) transform) {
    final self = this;
    if (self == null) return null;
    return transform(self);
  }
}
