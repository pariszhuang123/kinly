class TodayShoppingPhotoRouteArgs {
  const TodayShoppingPhotoRouteArgs({
    required this.photoUrl,
    required this.title,
    this.heroTag,
  });

  final String photoUrl;
  final String title;
  final Object? heroTag;
}
