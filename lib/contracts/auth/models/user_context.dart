import 'package:equatable/equatable.dart';

class UserContext extends Equatable {
  const UserContext({
    required this.userId,
    required this.hasHome,
    required this.activeHomeId,
    required this.hasPreferenceReport,
    required this.hasPersonalMentions,
    this.avatarUrl,
    this.displayName,
  });

  final String userId;
  final bool hasHome;
  final String? activeHomeId;
  final bool hasPreferenceReport;
  final bool hasPersonalMentions;
  final String? avatarUrl;
  final String? displayName;

  @override
  List<Object?> get props => [
    userId,
    hasHome,
    activeHomeId,
    hasPreferenceReport,
    hasPersonalMentions,
    avatarUrl,
    displayName,
  ];
}
