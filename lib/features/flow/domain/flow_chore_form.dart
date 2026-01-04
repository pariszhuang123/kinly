import '../../../contracts/chores/models.dart';
import '../../../core/time/date_only.dart';
import '../../../core/utils/url_validator.dart';

const _unset = Object();

class FlowChoreForm {
  final String title;
  final String? assigneeUserId;
  final DateTime startDate;
  final int? recurrenceEvery;
  final ChoreRecurrenceUnit? recurrenceUnit;
  final String notes;
  final String howToVideoUrl;
  final String expectationPhotoPath;

  const FlowChoreForm({
    required this.title,
    required this.assigneeUserId,
    required this.startDate,
    required this.recurrenceEvery,
    required this.recurrenceUnit,
    required this.notes,
    required this.howToVideoUrl,
    required this.expectationPhotoPath,
  });

  factory FlowChoreForm.initial({DateTime? startDate}) {
    final normalizedStart = dateOnly(startDate ?? DateTime.now());
    return FlowChoreForm(
      title: '',
      assigneeUserId: null,
      startDate: normalizedStart,
      recurrenceEvery: null,
      recurrenceUnit: null,
      notes: '',
      howToVideoUrl: '',
      expectationPhotoPath: '',
    );
  }

  factory FlowChoreForm.fromChore(Chore chore) {
    return FlowChoreForm(
      title: chore.name,
      assigneeUserId: chore.assigneeUserId,
      startDate: dateOnly(chore.startDate),
      recurrenceEvery: chore.recurrenceEvery,
      recurrenceUnit: chore.recurrenceUnit,
      notes: chore.notes ?? '',
      howToVideoUrl: chore.howToVideoUrl ?? '',
      expectationPhotoPath: chore.expectationPhotoPath ?? '',
    );
  }

  FlowChoreForm copyWith({
    String? title,
    Object? assigneeUserId = _unset,
    DateTime? startDate,
    int? recurrenceEvery,
    ChoreRecurrenceUnit? recurrenceUnit,
    String? notes,
    String? howToVideoUrl,
    String? expectationPhotoPath,
    bool clearRecurrence = false,
  }) {
    return FlowChoreForm(
      title: title ?? this.title,
      assigneeUserId:
          identical(assigneeUserId, _unset)
              ? this.assigneeUserId
              : assigneeUserId as String?,
      startDate:
          startDate != null ? dateOnly(startDate) : this.startDate,
      recurrenceEvery:
          clearRecurrence
              ? null
              : recurrenceEvery ?? this.recurrenceEvery,
      recurrenceUnit:
          clearRecurrence
              ? null
              : recurrenceUnit ?? this.recurrenceUnit,
      notes: notes ?? this.notes,
      howToVideoUrl: howToVideoUrl ?? this.howToVideoUrl,
      expectationPhotoPath: expectationPhotoPath ?? this.expectationPhotoPath,
    );
  }

  bool get isTitleValid => title.trim().isNotEmpty;
  bool get isHowToUrlValid =>
      howToVideoUrl.trim().isEmpty ||
      normalizeHttpUrlOrNull(howToVideoUrl) != null;
  String? get normalizedHowToUrl => normalizeHttpUrlOrNull(howToVideoUrl);

  bool isEqualTo(FlowChoreForm other) {
    return title == other.title &&
        assigneeUserId == other.assigneeUserId &&
        startDate.isAtSameMomentAs(other.startDate) &&
        recurrenceEvery == other.recurrenceEvery &&
        recurrenceUnit == other.recurrenceUnit &&
        notes == other.notes &&
        howToVideoUrl == other.howToVideoUrl &&
        expectationPhotoPath == other.expectationPhotoPath;
  }

  bool isStartDateInRange(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final lastAllowed = DateTime(today.year + 1, today.month, today.day);
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    return !start.isAfter(lastAllowed);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlowChoreForm &&
          title == other.title &&
          assigneeUserId == other.assigneeUserId &&
          startDate.isAtSameMomentAs(other.startDate) &&
          recurrenceEvery == other.recurrenceEvery &&
          recurrenceUnit == other.recurrenceUnit &&
          notes == other.notes &&
          howToVideoUrl == other.howToVideoUrl &&
          expectationPhotoPath == other.expectationPhotoPath;

  @override
  int get hashCode => Object.hash(
    title,
    assigneeUserId,
    startDate.toIso8601String(),
    recurrenceEvery,
    recurrenceUnit,
    notes,
    howToVideoUrl,
    expectationPhotoPath,
  );

  bool get isRecurring =>
      recurrenceEvery != null && recurrenceUnit != null;

  bool get isRecurrenceValid =>
      !isRecurring || (recurrenceEvery != null && recurrenceEvery! >= 1);
}
