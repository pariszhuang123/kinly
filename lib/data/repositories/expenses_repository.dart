import '../../core/expenses/models.dart';
import '../../core/time/timezone.dart';

/// Repository boundary for expense/share workflows.
abstract class ExpensesRepository {
  /// Creates a new expense tied to [homeId].
  ///
  /// Provide [memberIds] when splitting equally. Provide [customSplits] when
  /// using a custom split strategy. The backend enforces all validation rules.
  Future<Expense> create({
    required String homeId,
    int? amountCents,
    required String description,
    String? notes,
    ExpenseSplitType? splitType,
    List<String>? memberIds,
    List<ExpenseCustomSplitInput>? customSplits,
  });

  /// Updates an existing expense, promoting drafts to active when a split is provided.
  Future<Expense> edit({
    required String expenseId,
    required int amountCents,
    required String description,
    String? notes,
    ExpenseSplitType? splitType,
    List<String>? memberIds,
    List<ExpenseCustomSplitInput>? customSplits,
  });

  /// Lists unpaid shares for the current member grouped by expense creator.
  Future<List<ExpenseOwedGroup>> listCurrentOwed({required String homeId});

  /// Lists live expenses (draft + active) created by the current member.
  Future<List<ExpenseCreatedSummary>> listCreatedByMe({required String homeId});

  /// Fetches an expense with split details for editing flows.
  Future<ExpenseForEdit> getForEdit(String expenseId);

  /// Marks the caller's share as paid for the given [expenseId].
  ///
  /// Returns the updated split payload (`deduped` true when already paid).
  Future<ExpenseMarkSharePaidResult> markSharePaid(String expenseId);

  /// Lists paid shares owed to the caller (who is the expense creator).
  Future<List<ExpensePaidToMeDebtor>> listPaidToMeDebtors({
    required String homeId,
  });

  /// Lists paid items from a specific debtor owed to the caller.
  Future<List<ExpensePaidToMeItem>> listPaidToMeByDebtor({
    required String homeId,
    required String debtorUserId,
  });

  /// Marks paid items from a debtor as viewed by the caller.
  Future<int> markPaidReceivedViewedForDebtor({
    required String homeId,
    required String debtorUserId,
  });

  /// Cancels an expense created by the caller (draft or active without payments).
  Future<Expense> cancel(String expenseId);
}

/// Payload for custom split entries accepted by Supabase RPCs.
class ExpenseCustomSplitInput {
  const ExpenseCustomSplitInput({
    required this.userId,
    required this.amountCents,
  });

  final String userId;
  final int amountCents;

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'amount_cents': amountCents,
  };
}

/// Result for markSharePaid RPC.
class ExpenseMarkSharePaidResult {
  ExpenseMarkSharePaidResult({
    required this.deduped,
    required this.split,
  });

  final bool deduped;
  final ExpensePaidSplit split;

  factory ExpenseMarkSharePaidResult.fromJson(Map<String, dynamic> json) {
    return ExpenseMarkSharePaidResult(
      deduped: json['deduped'] as bool? ?? false,
      split: ExpensePaidSplit.fromJson(
        (json['split'] as Map).cast<String, dynamic>(),
      ),
    );
  }
}

class ExpensePaidSplit {
  ExpensePaidSplit({
    required this.expenseId,
    required this.debtorUserId,
    required this.status,
    required this.amountCents,
    required this.markedPaidAt,
    required this.recipientViewedAt,
  });

  final String expenseId;
  final String debtorUserId;
  final ExpenseShareStatus status;
  final int amountCents;
  final DateTime? markedPaidAt;
  final DateTime? recipientViewedAt;

  factory ExpensePaidSplit.fromJson(Map<String, dynamic> json) {
    return ExpensePaidSplit(
      expenseId: json['expenseId'] as String,
      debtorUserId: json['debtorUserId'] as String,
      status: ExpenseShareStatusWire.fromWire(json['status'] as String?),
      amountCents: (json['amountCents'] as num).toInt(),
      markedPaidAt: parseTimestampToLocal(json['markedPaidAt']),
      recipientViewedAt: parseTimestampToLocal(json['recipientViewedAt']),
    );
  }
}

class ExpensePaidToMeDebtor {
  ExpensePaidToMeDebtor({
    required this.debtorUserId,
    required this.debtorUsername,
    required this.totalPaidCents,
    required this.unseenCount,
    required this.latestPaidAt,
  });

  final String debtorUserId;
  final String debtorUsername;
  final int totalPaidCents;
  final int unseenCount;
  final DateTime? latestPaidAt;

  factory ExpensePaidToMeDebtor.fromJson(Map<String, dynamic> json) {
    return ExpensePaidToMeDebtor(
      debtorUserId: json['debtorUserId'] as String,
      debtorUsername: json['debtorUsername'] as String? ?? '',
      totalPaidCents: (json['totalPaidCents'] as num?)?.toInt() ?? 0,
      unseenCount: (json['unseenCount'] as num?)?.toInt() ?? 0,
      latestPaidAt: parseTimestampToLocal(json['latestPaidAt']),
    );
  }
}

class ExpensePaidToMeItem {
  ExpensePaidToMeItem({
    required this.expenseId,
    required this.description,
    required this.amountCents,
    required this.markedPaidAt,
    this.notes,
  });

  final String expenseId;
  final String description;
  final int amountCents;
  final DateTime? markedPaidAt;
  final String? notes;

  factory ExpensePaidToMeItem.fromJson(Map<String, dynamic> json) {
    return ExpensePaidToMeItem(
      expenseId: json['expenseId'] as String,
      description: (json['description'] as String?) ?? '',
      amountCents: (json['amountCents'] as num).toInt(),
      markedPaidAt: parseTimestampToLocal(json['markedPaidAt']),
      notes: json['notes'] as String?,
    );
  }
}
