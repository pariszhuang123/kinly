import 'package:equatable/equatable.dart';

/// UI-friendly participant metadata for share creation.
class ShareParticipant extends Equatable {
  const ShareParticipant({
    required this.membershipId,
    required this.userId,
    required this.displayName,
    this.avatarUrl,
    this.isOwner = false,
  });

  final String membershipId;
  final String userId;
  final String displayName;
  final String? avatarUrl;
  final bool isOwner;

  @override
  List<Object?> get props => [
    membershipId,
    userId,
    displayName,
    avatarUrl,
    isOwner,
  ];
}
