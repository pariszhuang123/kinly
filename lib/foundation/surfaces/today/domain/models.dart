import 'package:equatable/equatable.dart';
import 'package:kinly/contracts/chores/models.dart';
export 'package:kinly/contracts/share/models.dart';

/// A minimal representation of a task shown on the Today page.
class TodayFlowTask extends Equatable {
  final String id;
  final String title;
  final ChoreState state;
  final bool isNewToday;

  const TodayFlowTask({
    required this.id,
    required this.title,
    required this.state,
    this.isNewToday = false,
  });

  TodayFlowTask copyWith({
    String? id,
    String? title,
    ChoreState? state,
    bool? isNewToday,
  }) {
    return TodayFlowTask(
      id: id ?? this.id,
      title: title ?? this.title,
      state: state ?? this.state,
      isNewToday: isNewToday ?? this.isNewToday,
    );
  }

  bool get isDraft => state == ChoreState.draft;
  bool get isActive => state == ChoreState.active;

  @override
  List<Object?> get props => [id, title, state, isNewToday];
}

/// View model representing the current user shown in the Today header.
class TodayUserProfile extends Equatable {
  final String userId;
  final String username;
  final String? avatarUrl;
  final bool isOwner;

  const TodayUserProfile({
    required this.userId,
    required this.username,
    this.avatarUrl,
    this.isOwner = false,
  });

  @override
  List<Object?> get props => [userId, username, avatarUrl, isOwner];
}
