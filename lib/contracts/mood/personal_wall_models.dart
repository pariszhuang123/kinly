import 'package:equatable/equatable.dart';
import 'enums/mood_scale.dart';
import 'package:kinly/contracts/time/timezone.dart';

class PersonalGratitudeStatus extends Equatable {
  final bool hasUnread;
  final DateTime? lastReadAt;

  const PersonalGratitudeStatus({
    required this.hasUnread,
    required this.lastReadAt,
  });

  factory PersonalGratitudeStatus.fromJson(Map<String, dynamic> json) {
    return PersonalGratitudeStatus(
      hasUnread: (json['has_unread'] as bool?) ?? false,
      lastReadAt: parseTimestampToLocal(json['last_read_at']),
    );
  }

  @override
  List<Object?> get props => [hasUnread, lastReadAt];
}

class PersonalGratitudeItem extends Equatable {
  final String id;
  final DateTime createdAt;
  final String homeId;
  final MoodScale mood;
  final String? message;
  final String sourceKind;
  final String? sourcePostId;
  final String sourceEntryId;
  final String authorUserId;
  final String authorUsername;
  final String? authorAvatarPath;

  const PersonalGratitudeItem({
    required this.id,
    required this.createdAt,
    required this.homeId,
    required this.mood,
    required this.message,
    required this.sourceKind,
    required this.sourcePostId,
    required this.sourceEntryId,
    required this.authorUserId,
    required this.authorUsername,
    required this.authorAvatarPath,
  });

  factory PersonalGratitudeItem.fromJson(Map<String, dynamic> json) {
    return PersonalGratitudeItem(
      id: json['id'] as String,
      createdAt: parseTimestampToLocal(json['created_at'])!,
      homeId: json['home_id'] as String,
      mood: MoodScale.fromWire(json['mood'] as String),
      message: json['message'] as String?,
      sourceKind: json['source_kind'] as String? ?? 'mention_only',
      sourcePostId: json['source_post_id'] as String?,
      sourceEntryId: json['source_entry_id'] as String? ?? '',
      authorUserId: json['author_user_id'] as String,
      authorUsername: (json['author_username'] as String?) ?? '',
      authorAvatarPath: json['author_avatar_path'] as String?,
    );
  }

  @override
  List<Object?> get props => [
    id,
    createdAt,
    homeId,
    mood,
    message,
    sourceKind,
    sourcePostId,
    sourceEntryId,
    authorUserId,
    authorUsername,
    authorAvatarPath,
  ];
}

class PersonalGratitudePage extends Equatable {
  final List<PersonalGratitudeItem> items;
  final DateTime? cursorCreatedAt;
  final String? cursorId;

  const PersonalGratitudePage({
    required this.items,
    required this.cursorCreatedAt,
    required this.cursorId,
  });

  @override
  List<Object?> get props => [items, cursorCreatedAt, cursorId];
}

class PersonalGratitudeStats extends Equatable {
  final int totalReceived;
  final int uniqueIndividuals;
  final int uniqueHomes;

  const PersonalGratitudeStats({
    required this.totalReceived,
    required this.uniqueIndividuals,
    required this.uniqueHomes,
  });

  factory PersonalGratitudeStats.fromJson(Map<String, dynamic> json) {
    return PersonalGratitudeStats(
      totalReceived: (json['total_received'] as num?)?.toInt() ?? 0,
      uniqueIndividuals: (json['unique_individuals'] as num?)?.toInt() ?? 0,
      uniqueHomes: (json['unique_homes'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  List<Object?> get props => [totalReceived, uniqueIndividuals, uniqueHomes];
}
