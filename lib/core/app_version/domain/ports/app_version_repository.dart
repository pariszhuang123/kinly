class AppVersionStatusResult {
  const AppVersionStatusResult({
    required this.clientVersion,
    required this.currentVersion,
    required this.minSupportedVersion,
    required this.hardBlocked,
    required this.updateRecommended,
    this.notes,
    this.releasedAt,
  });

  final String clientVersion;
  final String currentVersion;
  final String minSupportedVersion;
  final bool hardBlocked;
  final bool updateRecommended;
  final String? notes;
  final DateTime? releasedAt;
}

abstract class AppVersionRepository {
  Future<AppVersionStatusResult> checkVersion({required String clientVersion});
}
