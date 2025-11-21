import 'package:equatable/equatable.dart';

/// UI-friendly participant metadata for share creation.
class ShareParticipant extends Equatable {
  const ShareParticipant({
    required this.userId,
    required this.displayName,
    this.avatarUrl,
  });

  final String userId;
  final String displayName;
  final String? avatarUrl;

  @override
  List<Object?> get props => [userId, displayName, avatarUrl];
}
