import 'package:kinly/contracts/house_directory/models.dart';

class HouseDirectoryServiceRouteArgs {
  const HouseDirectoryServiceRouteArgs({this.serviceId});

  final String? serviceId;
}

class HouseDirectoryNoteRouteArgs {
  const HouseDirectoryNoteRouteArgs({
    this.noteId,
    this.initialNoteType = HouseDirectoryNoteType.general,
  });

  final String? noteId;
  final HouseDirectoryNoteType initialNoteType;
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
