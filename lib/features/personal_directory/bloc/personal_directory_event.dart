part of 'personal_directory_bloc.dart';

sealed class PersonalDirectoryEvent extends Equatable {
  const PersonalDirectoryEvent();

  @override
  List<Object?> get props => [];
}

class PersonalDirectoryStarted extends PersonalDirectoryEvent {
  const PersonalDirectoryStarted();
}

class PersonalDirectoryRefreshed extends PersonalDirectoryEvent {
  const PersonalDirectoryRefreshed();
}

class PersonalDirectoryBankAccountSaved extends PersonalDirectoryEvent {
  const PersonalDirectoryBankAccountSaved(this.input);

  final UpsertPersonalDirectoryBankAccountInput input;

  @override
  List<Object?> get props => [input];
}

class PersonalDirectoryNoteCreated extends PersonalDirectoryEvent {
  const PersonalDirectoryNoteCreated(this.input);

  final CreatePersonalDirectoryNoteInput input;

  @override
  List<Object?> get props => [input];
}

class PersonalDirectoryNoteUpdated extends PersonalDirectoryEvent {
  const PersonalDirectoryNoteUpdated(this.input);

  final UpdatePersonalDirectoryNoteInput input;

  @override
  List<Object?> get props => [input];
}

class PersonalDirectoryNoteArchived extends PersonalDirectoryEvent {
  const PersonalDirectoryNoteArchived(this.noteId);

  final String noteId;

  @override
  List<Object?> get props => [noteId];
}
