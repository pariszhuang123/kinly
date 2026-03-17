import '../models.dart';

abstract class HouseDirectoryRepository {
  Future<HouseDirectoryWifi?> getWifi({required String homeId});

  Future<HouseDirectoryWifi> upsertWifi(UpsertHouseDirectoryWifiInput input);

  Future<HouseDirectoryContent> getContent({required String homeId});

  Future<HouseDirectoryService> upsertService(
    UpsertHouseDirectoryServiceInput input,
  );

  Future<void> archiveService({
    required String homeId,
    required String serviceId,
  });

  Future<HouseDirectoryNote> upsertNote(UpsertHouseDirectoryNoteInput input);

  Future<void> archiveNote({required String homeId, required String noteId});

  Future<String?> captureAndUploadNotePhoto({required String homeId});

  String? toPublicPhotoUrl(String? photoPath);

  Future<List<HouseDirectoryReminder>> listDueReminders({
    required String homeId,
  });

  Future<void> acknowledgeReminder({
    required String homeId,
    required String reminderId,
  });

  Future<void> dismissReminder({
    required String homeId,
    required String reminderId,
  });
}
