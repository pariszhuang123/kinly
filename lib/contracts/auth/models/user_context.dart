import 'package:equatable/equatable.dart';

class UserContext extends Equatable {
  const UserContext({
    required this.userId,
    required this.hasPreferenceReport,
    required this.hasPersonalMentions,
    required this.hasPersonalDirectoryContent,
    this.avatarUrl,
    this.displayName,
  });

  final String userId;
  final bool hasPreferenceReport;
  final bool hasPersonalMentions;
  final bool hasPersonalDirectoryContent;
  final String? avatarUrl;
  final String? displayName;

  @override
  List<Object?> get props => [
    userId,
    hasPreferenceReport,
    hasPersonalMentions,
    hasPersonalDirectoryContent,
    avatarUrl,
    displayName,
  ];
}
