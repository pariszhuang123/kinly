part of 'share_created_list_bloc.dart';

enum ShareCreatedListStatus { initial, loading, success, failure }

class ShareCreatedListState extends Equatable {
  const ShareCreatedListState({
    this.status = ShareCreatedListStatus.initial,
    this.entries = const [],
    this.isRefreshing = false,
    this.errorMessage,
    this.lastUpdated,
  });

  final ShareCreatedListStatus status;
  final List<ShareCreatedListEntry> entries;
  final bool isRefreshing;
  final String? errorMessage;
  final DateTime? lastUpdated;

  ShareCreatedListState copyWith({
    ShareCreatedListStatus? status,
    List<ShareCreatedListEntry>? entries,
    bool? isRefreshing,
    String? errorMessage,
    bool clearError = false,
    DateTime? lastUpdated,
  }) {
    return ShareCreatedListState(
      status: status ?? this.status,
      entries: entries ?? this.entries,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  List<Object?> get props => [
    status,
    entries,
    isRefreshing,
    errorMessage,
    lastUpdated,
  ];
}

class ShareCreatedListEntry extends Equatable {
  const ShareCreatedListEntry({
    required this.expenseId,
    required this.description,
    required this.amountCents,
    required this.totalShares,
    required this.paidShares,
    required this.paidAmountCents,
    required this.status,
    required this.createdAt,
    this.allPaid = false,
  });

  final String expenseId;
  final String description;
  final int amountCents;
  final int totalShares;
  final int paidShares;
  final int paidAmountCents;
  final ExpenseStatus status;
  final DateTime createdAt;
  final bool allPaid;

  bool get isActive => status == ExpenseStatus.active;
  bool get isDraft => status == ExpenseStatus.draft;

  factory ShareCreatedListEntry.fromSummary(ExpenseCreatedSummary summary) {
    return ShareCreatedListEntry(
      expenseId: summary.expenseId,
      description: summary.description,
      amountCents: summary.amountCents,
      totalShares: summary.totalShares,
      paidShares: summary.paidShares,
      paidAmountCents: summary.paidAmountCents,
      status: summary.status,
      createdAt: summary.createdAt,
      allPaid: summary.allPaid,
    );
  }

  @override
  List<Object?> get props => [
    expenseId,
    description,
    amountCents,
    totalShares,
    paidShares,
    paidAmountCents,
    status,
    createdAt,
    allPaid,
  ];
}
