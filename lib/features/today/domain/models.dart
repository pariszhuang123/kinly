import 'package:equatable/equatable.dart';

import '../../../core/chores/models.dart';
import '../../../core/expenses/models.dart';

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

class TodayShareOwedItem extends Equatable {
  const TodayShareOwedItem({
    required this.expenseId,
    required this.description,
    required this.amountCents,
  });

  final String expenseId;
  final String description;
  final int amountCents;

  factory TodayShareOwedItem.fromModel(ExpenseOwedItem model) {
    return TodayShareOwedItem(
      expenseId: model.expenseId,
      description: model.description,
      amountCents: model.amountCents,
    );
  }

  double get amount => amountCents / 100.0;

  @override
  List<Object?> get props => [expenseId, description, amountCents];
}

class TodayShareOwed extends Equatable {
  const TodayShareOwed({
    required this.payerUserId,
    required this.displayName,
    required this.totalOwedCents,
    required this.items,
    this.avatarUrl,
    this.isOwner = false,
  });

  final String payerUserId;
  final String displayName;
  final String? avatarUrl;
  final int totalOwedCents;
  final List<TodayShareOwedItem> items;
  final bool isOwner;

  factory TodayShareOwed.fromModel(
    ExpenseOwedGroup group, {
    String? ownerUserId,
  }) {
    return TodayShareOwed(
      payerUserId: group.payerUserId,
      displayName: group.payerDisplay,
      avatarUrl: group.payerAvatarUrl,
      totalOwedCents: group.totalOwedCents,
      items: group.items
          .map(TodayShareOwedItem.fromModel)
          .toList(growable: false),
      isOwner: ownerUserId != null && group.payerUserId == ownerUserId,
    );
  }

  double get totalOwed => totalOwedCents / 100.0;

  @override
  List<Object?> get props => [
    payerUserId,
    displayName,
    avatarUrl,
    totalOwedCents,
    items,
  ];
}

class TodayShareDraft extends Equatable {
  const TodayShareDraft({
    required this.expenseId,
    required this.description,
    required this.amountCents,
    required this.createdAt,
  });

  final String expenseId;
  final String description;
  final int amountCents;
  final DateTime createdAt;

  factory TodayShareDraft.fromSummary(ExpenseCreatedSummary summary) {
    return TodayShareDraft(
      expenseId: summary.expenseId,
      description: summary.description,
      amountCents: summary.amountCents,
      createdAt: summary.createdAt,
    );
  }

  double get amount => amountCents / 100.0;

  @override
  List<Object?> get props => [expenseId, description, amountCents, createdAt];
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
