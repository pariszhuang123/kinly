import 'package:equatable/equatable.dart';

import '../../../core/chores/models.dart';

/// A minimal representation of a task shown on the Today page.
/// This is a *view model* for the Today feature –
/// the Flow feature can have a richer FlowTask entity if needed.
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

/// A minimal representation of an expense shown on the Today page.
/// Again, this is a Today-facing model; the Share feature
/// can use a more detailed domain entity if it wants.
class TodayShareExpense extends Equatable {
  final String id;
  final String title;
  final double amount;
  final bool isUpcoming;

  const TodayShareExpense({
    required this.id,
    required this.title,
    required this.amount,
    this.isUpcoming = false,
  });

  TodayShareExpense copyWith({
    String? id,
    String? title,
    double? amount,
    bool? isUpcoming,
  }) {
    return TodayShareExpense(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      isUpcoming: isUpcoming ?? this.isUpcoming,
    );
  }

  @override
  List<Object?> get props => [id, title, amount, isUpcoming];
}

/// View model representing the current user shown in the Today header.
class TodayUserProfile extends Equatable {
  final String userId;
  final String username;
  final String? avatarUrl;

  const TodayUserProfile({
    required this.userId,
    required this.username,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [userId, username, avatarUrl];
}
