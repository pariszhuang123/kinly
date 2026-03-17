class HouseDirectoryServiceRouteArgs {
  const HouseDirectoryServiceRouteArgs({this.serviceId});

  final String? serviceId;
}

class HouseDirectoryNoteRouteArgs {
  const HouseDirectoryNoteRouteArgs({this.noteId});

  final String? noteId;
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
