class UserProfile {
  final String userId;
  final String username;
  final String? avatarStoragePath;
  final String? avatarUrl;

  const UserProfile({
    required this.userId,
    required this.username,
    this.avatarStoragePath,
    this.avatarUrl,
  });

  factory UserProfile.fromJson(
    Map<String, dynamic> json, {
    String? avatarUrl,
  }) {
    return UserProfile(
      userId: json['user_id'] as String,
      username: json['username'] as String,
      avatarStoragePath: json['avatar_storage_path'] as String?,
      avatarUrl: avatarUrl,
    );
  }

  UserProfile copyWith({
    String? userId,
    String? username,
    String? avatarStoragePath,
    String? avatarUrl,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      avatarStoragePath: avatarStoragePath ?? this.avatarStoragePath,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
