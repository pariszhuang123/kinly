part of 'house_directory_service_screen.dart';

List<Widget> buildHouseDirectoryServiceAppBarActions({
  required bool isCreating,
  required bool isOwner,
  required bool isEditing,
  required String editLabel,
  required VoidCallback onEdit,
}) {
  if (isCreating || !isOwner || isEditing) {
    return const <Widget>[];
  }
  return [
    Padding(
      padding: const EdgeInsetsDirectional.only(end: 8),
      child: Center(
        child: KinlyFilledButton.text(
          onPressed: onEdit,
          label: editLabel,
          compact: true,
          fullWidth: false,
        ),
      ),
    ),
  ];
}

VoidCallback? buildHouseDirectoryCreateTaskAction({
  required bool isOwner,
  required bool isEditing,
  required HouseDirectoryService? service,
  required HouseDirectoryReminder? reminder,
  required Future<void> Function(
    HouseDirectoryService service,
    HouseDirectoryReminder reminder,
  ) onCreateTask,
}) {
  if (!isOwner || isEditing || service == null || reminder == null) {
    return null;
  }
  return () => onCreateTask(service, reminder);
}

HouseDirectoryService? resolveHouseDirectoryService({
  required HouseDirectoryState state,
  required String? serviceId,
}) {
  if (serviceId == null) return null;
  for (final service in state.services) {
    if (service.id == serviceId) return service;
  }
  return null;
}

HouseDirectoryReminder? resolveHouseDirectoryReminder({
  required HouseDirectoryState state,
  required String? reminderId,
  required HouseDirectoryService? service,
}) {
  if (reminderId != null) {
    for (final reminder in state.reminders) {
      if (reminder.id == reminderId) return reminder;
    }
  }
  return service?.reminder;
}

HouseDirectoryReminderOffsetUnit defaultHouseDirectoryReminderOffsetUnit({
  required DateTime endDate,
  required DateTime today,
  required int daysPerMonth,
}) {
  final normalizedToday = DateTime(today.year, today.month, today.day);
  final normalizedEnd = DateTime(endDate.year, endDate.month, endDate.day);
  final daysUntilEnd = normalizedEnd.difference(normalizedToday).inDays;
  if (daysUntilEnd <= daysPerMonth) {
    return HouseDirectoryReminderOffsetUnit.day;
  }
  return HouseDirectoryReminderOffsetUnit.month;
}

String buildHouseDirectoryTaskNotes({
  required S strings,
  required HouseDirectoryService service,
  required HouseDirectoryReminder reminder,
}) {
  final format = DateFormat.yMMMd();
  final lines = <String>[
    strings.todayHouseDirectoryReminderDue(
      format.format(reminder.dueAt),
    ),
  ];
  if (service.termStartDate != null || service.termEndDate != null) {
    lines.add(
      strings.houseDirectoryTermRange(
        service.termStartDate == null
            ? strings.houseDirectoryDateUnknown
            : format.format(service.termStartDate!),
        service.termEndDate == null
            ? strings.houseDirectoryDateUnknown
            : format.format(service.termEndDate!),
      ),
    );
  }
  final reference = service.accountReference?.trim();
  if (reference != null && reference.isNotEmpty) {
    lines.add(reference);
  }
  final notes = service.notes?.trim();
  if (notes != null && notes.isNotEmpty) {
    lines.add(notes);
  }
  return lines.join('\n');
}

String? _emptyToNull(String value) {
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}
