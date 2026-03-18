import '../models.dart';

abstract class PersonalDirectoryRepository {
  Future<PersonalDirectoryBankAccount?> getOwnBankAccount();

  Future<PersonalDirectoryBankAccount?> getMemberBankAccount({
    required String targetUserId,
  });

  Future<PersonalDirectoryBankAccount> upsertOwnBankAccount(
    UpsertPersonalDirectoryBankAccountInput input,
  );

  Future<List<PersonalDirectoryNote>> getNotes({String? targetUserId});

  Future<PersonalDirectoryNote> createNote(CreatePersonalDirectoryNoteInput input);

  Future<PersonalDirectoryNote> updateNote(UpdatePersonalDirectoryNoteInput input);

  Future<void> archiveNote(String noteId);

  Future<PersonalDirectoryNudge?> getNudge();

  Future<void> dismissNudge();
}
