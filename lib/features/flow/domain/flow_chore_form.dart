import '../../../core/chores/models.dart';

const _unset = Object();

class FlowChoreForm {
  final String title;
  final String? assigneeUserId;
  final DateTime startDate;
  final ChoreRecurrence recurrence;
  final String notes;
  final String howToVideoUrl;
  final String expectationPhotoPath;

  const FlowChoreForm({
    required this.title,
    required this.assigneeUserId,
    required this.startDate,
    required this.recurrence,
    required this.notes,
    required this.howToVideoUrl,
    required this.expectationPhotoPath,
  });

  factory FlowChoreForm.initial({DateTime? startDate}) {
    return FlowChoreForm(
      title: '',
      assigneeUserId: null,
      startDate: startDate ?? DateTime.now(),
      recurrence: ChoreRecurrence.none,
      notes: '',
      howToVideoUrl: '',
      expectationPhotoPath: '',
    );
  }

  factory FlowChoreForm.fromChore(Chore chore) {
    return FlowChoreForm(
      title: chore.name,
      assigneeUserId: chore.assigneeUserId,
      startDate: chore.startDate,
      recurrence: chore.recurrence,
      notes: chore.notes ?? '',
      howToVideoUrl: chore.howToVideoUrl ?? '',
      expectationPhotoPath: chore.expectationPhotoPath ?? '',
    );
  }

  FlowChoreForm copyWith({
    String? title,
    Object? assigneeUserId = _unset,
    DateTime? startDate,
    ChoreRecurrence? recurrence,
    String? notes,
    String? howToVideoUrl,
    String? expectationPhotoPath,
  }) {
    return FlowChoreForm(
      title: title ?? this.title,
      assigneeUserId:
          identical(assigneeUserId, _unset)
              ? this.assigneeUserId
              : assigneeUserId as String?,
      startDate: startDate ?? this.startDate,
      recurrence: recurrence ?? this.recurrence,
      notes: notes ?? this.notes,
      howToVideoUrl: howToVideoUrl ?? this.howToVideoUrl,
      expectationPhotoPath: expectationPhotoPath ?? this.expectationPhotoPath,
    );
  }

  bool get isTitleValid => title.trim().isNotEmpty;

  bool isEqualTo(FlowChoreForm other) {
    return title == other.title &&
        assigneeUserId == other.assigneeUserId &&
        startDate.isAtSameMomentAs(other.startDate) &&
        recurrence == other.recurrence &&
        notes == other.notes &&
        howToVideoUrl == other.howToVideoUrl &&
        expectationPhotoPath == other.expectationPhotoPath;
  }

  bool isStartDateInRange(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final lastAllowed = DateTime(today.year + 1, today.month, today.day);
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    return !start.isBefore(today) && !start.isAfter(lastAllowed);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlowChoreForm &&
          title == other.title &&
          assigneeUserId == other.assigneeUserId &&
          startDate.isAtSameMomentAs(other.startDate) &&
          recurrence == other.recurrence &&
          notes == other.notes &&
          howToVideoUrl == other.howToVideoUrl &&
          expectationPhotoPath == other.expectationPhotoPath;

  @override
  int get hashCode => Object.hash(
    title,
    assigneeUserId,
    startDate.toIso8601String(),
    recurrence,
    notes,
    howToVideoUrl,
    expectationPhotoPath,
  );
}
