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
    required ExpenseRecurrenceInterval recurrence,
    required DateTime startDate,
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
    required ExpenseRecurrenceInterval recurrence,
    required DateTime startDate,
  });

  /// Lists unpaid shares for the current member grouped by expense creator.
  Future<List<ExpenseOwedGroup>> listCurrentOwed({required String homeId});

  /// Lists live expenses (draft + active) created by the current member.
  Future<List<ExpenseCreatedSummary>> listCreatedByMe({required String homeId});

  /// Fetches an expense with split details for editing flows.
  Future<ExpenseForEdit> getForEdit(String expenseId);

  /// Bulk-pays all unpaid splits the caller owes to [recipientUserId].
  ///
  /// Uses the `expenses_pay_my_due` RPC; returns a summary of affected rows.
  Future<ExpensesPayMyDueResult> payMyDue({required String recipientUserId});

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

class ExpensePaidToMeDebtor {
  ExpensePaidToMeDebtor({
    required this.debtorUserId,
    required this.debtorUsername,
    this.debtorAvatarUrl,
    this.isOwner = false,
    required this.totalPaidCents,
    required this.unseenCount,
    required this.latestPaidAt,
  });

  final String debtorUserId;
  final String debtorUsername;
  final String? debtorAvatarUrl;
  final bool isOwner;
  final int totalPaidCents;
  final int unseenCount;
  final DateTime? latestPaidAt;

  factory ExpensePaidToMeDebtor.fromJson(Map<String, dynamic> json) {
    return ExpensePaidToMeDebtor(
      debtorUserId: json['debtorUserId'] as String,
      debtorUsername: json['debtorUsername'] as String? ?? '',
      debtorAvatarUrl: json['debtorAvatarUrl'] as String?,
      isOwner: json['isOwner'] as bool? ?? false,
      totalPaidCents: (json['totalPaidCents'] as num?)?.toInt() ?? 0,
      unseenCount: (json['unseenCount'] as num?)?.toInt() ?? 0,
      latestPaidAt: parseTimestampToLocal(json['latestPaidAt']),
    );
  }
}

/// Summary payload for expenses_pay_my_due.
class ExpensesPayMyDueResult {
  ExpensesPayMyDueResult({
    required this.recipientUserId,
    required this.splitsPaid,
    required this.expensesTouched,
    required this.expensesNewlyFullyPaid,
  });

  final String recipientUserId;
  final int splitsPaid;
  final int expensesTouched;
  final int expensesNewlyFullyPaid;

  factory ExpensesPayMyDueResult.fromJson(Map<String, dynamic> json) {
    return ExpensesPayMyDueResult(
      recipientUserId: json['recipientUserId'] as String,
      splitsPaid: (json['splitsPaid'] as num?)?.toInt() ?? 0,
      expensesTouched: (json['expensesTouched'] as num?)?.toInt() ?? 0,
      expensesNewlyFullyPaid:
          (json['expensesNewlyFullyPaid'] as num?)?.toInt() ?? 0,
    );
  }
}

class ExpensePaidToMeItem {
  ExpensePaidToMeItem({
    required this.expenseId,
    required this.description,
    required this.amountCents,
    required this.markedPaidAt,
    this.debtorUsername,
    this.debtorAvatarUrl,
    this.isOwner = false,
    this.notes,
  });

  final String expenseId;
  final String description;
  final int amountCents;
  final DateTime? markedPaidAt;
  final String? debtorUsername;
  final String? debtorAvatarUrl;
  final bool isOwner;
  final String? notes;

  factory ExpensePaidToMeItem.fromJson(Map<String, dynamic> json) {
    return ExpensePaidToMeItem(
      expenseId: json['expenseId'] as String,
      description: (json['description'] as String?) ?? '',
      amountCents: (json['amountCents'] as num).toInt(),
      markedPaidAt: parseTimestampToLocal(json['markedPaidAt']),
      debtorUsername: json['debtorUsername'] as String?,
      debtorAvatarUrl: json['debtorAvatarUrl'] as String?,
      isOwner: json['isOwner'] as bool? ?? false,
      notes: json['notes'] as String?,
    );
  }
}
