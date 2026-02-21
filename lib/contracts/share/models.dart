import 'package:equatable/equatable.dart';

import '../expenses/models.dart';

class TodayShareOwedItem extends Equatable {
  const TodayShareOwedItem({
    required this.expenseId,
    required this.description,
    required this.amountCents,
    required this.recurrenceEvery,
    required this.recurrenceUnit,
    required this.startDate,
    this.notes,
    this.evidencePhotoPath,
  });

  final String expenseId;
  final String description;
  final int amountCents;
  final int? recurrenceEvery;
  final ExpenseRecurrenceUnit? recurrenceUnit;
  final DateTime startDate;
  final String? notes;
  final String? evidencePhotoPath;

  factory TodayShareOwedItem.fromModel(ExpenseOwedItem model) {
    return TodayShareOwedItem(
      expenseId: model.expenseId,
      description: model.description,
      amountCents: model.amountCents,
      recurrenceEvery: model.recurrenceEvery,
      recurrenceUnit: model.recurrenceUnit,
      startDate: model.startDate,
      notes: model.notes,
      evidencePhotoPath: model.evidencePhotoPath,
    );
  }

  @override
  List<Object?> get props => [
    expenseId,
    description,
    amountCents,
    recurrenceEvery,
    recurrenceUnit,
    startDate,
    notes,
    evidencePhotoPath,
  ];
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
    required this.createdByUserId,
  });

  final String expenseId;
  final String description;
  final int amountCents;
  final DateTime createdAt;
  final String createdByUserId;

  factory TodayShareDraft.fromSummary(ExpenseCreatedSummary summary) {
    return TodayShareDraft(
      expenseId: summary.expenseId,
      description: summary.description,
      amountCents: summary.amountCents,
      createdAt: summary.createdAt,
      createdByUserId: summary.createdByUserId,
    );
  }

  @override
  List<Object?> get props => [
    expenseId,
    description,
    amountCents,
    createdAt,
    createdByUserId,
  ];
}

class TodaySharePaidToMe extends Equatable {
  const TodaySharePaidToMe({
    required this.debtorUserId,
    required this.debtorUsername,
    this.debtorAvatarUrl,
    this.isOwner = false,
    required this.totalPaidCents,
    required this.unseenCount,
    this.latestPaidAt,
  });

  final String debtorUserId;
  final String debtorUsername;
  final String? debtorAvatarUrl;
  final bool isOwner;
  final int totalPaidCents;
  final int unseenCount;
  final DateTime? latestPaidAt;

  factory TodaySharePaidToMe.fromModel(ExpensePaidToMeDebtor model) {
    return TodaySharePaidToMe(
      debtorUserId: model.debtorUserId,
      debtorUsername: model.debtorUsername,
      debtorAvatarUrl: model.debtorAvatarUrl,
      isOwner: model.isOwner,
      totalPaidCents: model.totalPaidCents,
      unseenCount: model.unseenCount,
      latestPaidAt: model.latestPaidAt,
    );
  }

  @override
  List<Object?> get props => [
    debtorUserId,
    debtorUsername,
    debtorAvatarUrl,
    isOwner,
    totalPaidCents,
    unseenCount,
    latestPaidAt,
  ];
}
