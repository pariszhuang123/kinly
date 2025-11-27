import 'package:equatable/equatable.dart';

import 'enums/mood_scale.dart';

class MoodStatus extends Equatable {
  final bool isSubmittedThisWeek;

  const MoodStatus({required this.isSubmittedThisWeek});

  factory MoodStatus.fromJson(Map<String, dynamic> json) {
    final value = json.values.isNotEmpty ? json.values.first : json['value'];
    return MoodStatus(isSubmittedThisWeek: (value as bool?) ?? false);
  }

  @override
  List<Object?> get props => [isSubmittedThisWeek];
}

class MoodSubmitResult extends Equatable {
  final String entryId;
  final String? gratitudePostId;

  const MoodSubmitResult({
    required this.entryId,
    this.gratitudePostId,
  });

  factory MoodSubmitResult.fromJson(Map<String, dynamic> json) {
    return MoodSubmitResult(
      entryId: json['entry_id'] as String,
      gratitudePostId: json['gratitude_post_id'] as String?,
    );
  }

  @override
  List<Object?> get props => [entryId, gratitudePostId];
}

class GratitudeWallPost extends Equatable {
  final String id;
  final String authorUserId;
  final MoodScale mood;
  final String? message;
  final DateTime createdAt;

  const GratitudeWallPost({
    required this.id,
    required this.authorUserId,
    required this.mood,
    required this.createdAt,
    this.message,
  });

  factory GratitudeWallPost.fromJson(Map<String, dynamic> json) {
    return GratitudeWallPost(
      id: json['post_id'] as String,
      authorUserId: json['author_user_id'] as String,
      mood: MoodScale.fromWire(json['mood'] as String),
      message: json['message'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  @override
  List<Object?> get props => [id, authorUserId, mood, message, createdAt];
}

class GratitudeWallPage extends Equatable {
  final List<GratitudeWallPost> posts;
  final DateTime? cursorCreatedAt;
  final String? cursorId;

  const GratitudeWallPage({
    required this.posts,
    required this.cursorCreatedAt,
    required this.cursorId,
  });

  GratitudeWallPage append(List<GratitudeWallPost> more) {
    if (more.isEmpty) return this;
    final last = more.last;
    return GratitudeWallPage(
      posts: [...posts, ...more],
      cursorCreatedAt: last.createdAt,
      cursorId: last.id,
    );
  }

  @override
  List<Object?> get props => [posts, cursorCreatedAt, cursorId];
}

class GratitudeWallStatus extends Equatable {
  final bool hasUnread;
  final DateTime? lastReadAt;

  const GratitudeWallStatus({required this.hasUnread, this.lastReadAt});

  factory GratitudeWallStatus.fromJson(Map<String, dynamic> json) {
    return GratitudeWallStatus(
      hasUnread: (json['has_unread'] as bool?) ?? false,
      lastReadAt: json['last_read_at'] == null
          ? null
          : DateTime.tryParse(json['last_read_at'] as String),
    );
  }

  @override
  List<Object?> get props => [hasUnread, lastReadAt];
}
