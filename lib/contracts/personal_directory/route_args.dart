import 'models.dart';

enum PersonalDirectoryRouteResult {
  bankSaved,
  noteSaved,
  noteArchived,
}

class PersonalDirectoryBankRouteArgs {
  const PersonalDirectoryBankRouteArgs({
    this.initial,
    required this.canEdit,
  });

  final PersonalDirectoryBankAccount? initial;
  final bool canEdit;
}

class PersonalDirectoryNoteRouteArgs {
  const PersonalDirectoryNoteRouteArgs({
    this.note,
    required this.canEdit,
    this.availableNoteTypes = PersonalDirectoryNoteType.values,
  });

  final PersonalDirectoryNote? note;
  final bool canEdit;
  final List<PersonalDirectoryNoteType> availableNoteTypes;
}

class PersonalDirectoryScreenRouteArgs {
  const PersonalDirectoryScreenRouteArgs({
    required this.target,
    this.canEdit = true,
  });

  final PersonalDirectoryMemberSummary target;
  final bool canEdit;
}
