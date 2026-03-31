import 'package:kinly/contracts/house_directory/models.dart';

enum HouseDirectoryRouteResult {
  serviceCreated,
  serviceUpdated,
  serviceArchived,
  noteCreated,
  noteUpdated,
  noteArchived,
  tutorialCreated,
  tutorialUpdated,
  tutorialArchived,
}

class HouseDirectoryServiceRouteArgs {
  const HouseDirectoryServiceRouteArgs({
    this.serviceId,
    this.reminderId,
    this.startInEditMode = false,
  });

  final String? serviceId;
  final String? reminderId;
  final bool startInEditMode;
}

class HouseDirectoryWifiRouteArgs {
  const HouseDirectoryWifiRouteArgs({this.wifi});

  final HouseDirectoryWifi? wifi;
}

class HouseDirectoryNoteRouteArgs {
  const HouseDirectoryNoteRouteArgs({
    this.noteId,
    this.initialNoteType = HouseDirectoryNoteType.general,
    this.startInEditMode = false,
  });

  final String? noteId;
  final HouseDirectoryNoteType initialNoteType;
  final bool startInEditMode;
}

class HouseDirectoryPhotoRouteArgs {
  const HouseDirectoryPhotoRouteArgs({
    required this.photoUrl,
    required this.heroTag,
    this.title,
  });

  final String photoUrl;
  final Object heroTag;
  final String? title;
}
