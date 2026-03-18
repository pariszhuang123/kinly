import 'models.dart';

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
  });

  final PersonalDirectoryNote? note;
  final bool canEdit;
}
