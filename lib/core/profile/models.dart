import 'package:equatable/equatable.dart';

class UserProfile {
  final String userId;
  final String username;
  final String? avatarId;
  final String? avatarStoragePath;
  final String? avatarUrl;

  const UserProfile({
    required this.userId,
    required this.username,
    this.avatarId,
    this.avatarStoragePath,
    this.avatarUrl,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json, {String? avatarUrl}) {
    return UserProfile(
      userId: json['user_id'] as String,
      username: json['username'] as String,
      avatarId: json['avatar_id'] as String?,
      avatarStoragePath: json['avatar_storage_path'] as String?,
      avatarUrl: avatarUrl,
    );
  }

  UserProfile copyWith({
    String? userId,
    String? username,
    String? avatarId,
    String? avatarStoragePath,
    String? avatarUrl,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      avatarId: avatarId ?? this.avatarId,
      avatarStoragePath: avatarStoragePath ?? this.avatarStoragePath,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}

class ProfileAvatar extends Equatable {
  const ProfileAvatar({
    required this.id,
    required this.storagePath,
    required this.category,
    this.imageUrl,
  });

  final String id;
  final String storagePath;
  final String category;
  final String? imageUrl;

  ProfileAvatar copyWith({String? imageUrl}) {
    return ProfileAvatar(
      id: id,
      storagePath: storagePath,
      category: category,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  factory ProfileAvatar.fromJson(
    Map<String, dynamic> json, {
    String? imageUrl,
  }) {
    return ProfileAvatar(
      id: json['id'] as String,
      storagePath: json['storage_path'] as String,
      category: json['category'] as String,
      imageUrl: imageUrl,
    );
  }

  @override
  List<Object?> get props => [id, storagePath, category, imageUrl];
}
