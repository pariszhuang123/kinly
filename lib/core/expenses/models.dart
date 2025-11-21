import 'enums/expense_share_status.dart';
import 'enums/expense_split_type.dart';
import 'enums/expense_status.dart';

export 'enums/expense_share_status.dart';
export 'enums/expense_split_type.dart';
export 'enums/expense_status.dart';

/// Top-level expense record returned by Supabase RPCs.
class Expense {
  const Expense({
    required this.id,
    required this.homeId,
    required this.createdByUserId,
    required this.status,
    required this.splitType,
    required this.amountCents,
    required this.description,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String homeId;
  final String createdByUserId;
  final ExpenseStatus status;
  final ExpenseSplitType? splitType;
  final int amountCents;
  final String description;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as String,
      homeId: json['home_id'] as String,
      createdByUserId: json['created_by_user_id'] as String,
      status: ExpenseStatusWire.fromWire(json['status'] as String?),
      splitType: ExpenseSplitTypeWire.fromWire(json['split_type'] as String?),
      amountCents: (json['amount_cents'] as num).toInt(),
      description: json['description'] as String,
      notes: json['notes'] as String?,
      createdAt: _parseTimestamp(json['created_at'])!,
      updatedAt: _parseTimestamp(json['updated_at'])!,
    );
  }
}

/// Details for each debtor share.
class ExpenseSplit {
  const ExpenseSplit({
    required this.expenseId,
    required this.debtorUserId,
    required this.amountCents,
    required this.status,
    required this.markedPaidAt,
  });

  final String expenseId;
  final String debtorUserId;
  final int amountCents;
  final ExpenseShareStatus status;
  final DateTime? markedPaidAt;

  factory ExpenseSplit.fromJson(Map<String, dynamic> json) {
    return ExpenseSplit(
      expenseId: json['expense_id'] as String,
      debtorUserId: json['debtor_user_id'] as String,
      amountCents: (json['amount_cents'] as num).toInt(),
      status: ExpenseShareStatusWire.fromWire(json['status'] as String?),
      markedPaidAt: _parseTimestamp(json['marked_paid_at']),
    );
  }
}

/// Wrapper for edit/detail payloads containing the base expense and splits.
class ExpenseForEdit {
  const ExpenseForEdit({
    required this.expense,
    required this.splits,
    required this.amountLocked,
  });

  final Expense expense;
  final List<ExpenseSplit> splits;
  final bool amountLocked;

  factory ExpenseForEdit.fromJson(Map<String, dynamic> json) {
    final rawSplits = json['splits'];
    final splits =
        rawSplits is Iterable
            ? rawSplits
                .map(
                  (entry) => ExpenseSplit.fromJson(
                    (entry as Map).cast<String, dynamic>(),
                  ),
                )
                .toList(growable: false)
            : const <ExpenseSplit>[];
    return ExpenseForEdit(
      expense: Expense.fromJson(json),
      splits: splits,
      amountLocked: json['amount_locked'] as bool? ?? false,
    );
  }
}

/// Owed entry returned by `expenses_get_current_owed`.
class ExpenseOwedItem {
  const ExpenseOwedItem({
    required this.expenseId,
    required this.description,
    required this.amountCents,
  });

  final String expenseId;
  final String description;
  final int amountCents;

  factory ExpenseOwedItem.fromJson(Map<String, dynamic> json) {
    return ExpenseOwedItem(
      expenseId: json['expenseId'] as String,
      description: (json['description'] as String?) ?? '',
      amountCents: (json['amountCents'] as num).toInt(),
    );
  }
}

class ExpenseOwedGroup {
  const ExpenseOwedGroup({
    required this.payerUserId,
    required this.payerDisplay,
    required this.totalOwedCents,
    required this.items,
    this.payerAvatarUrl,
  });

  final String payerUserId;
  final String payerDisplay;
  final String? payerAvatarUrl;
  final int totalOwedCents;
  final List<ExpenseOwedItem> items;

  factory ExpenseOwedGroup.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    final coercedItems =
        rawItems is Iterable
            ? rawItems
                .map(
                  (entry) => ExpenseOwedItem.fromJson(
                    (entry as Map).cast<String, dynamic>(),
                  ),
                )
                .toList(growable: false)
            : const <ExpenseOwedItem>[];
    return ExpenseOwedGroup(
      payerUserId: json['payerUserId'] as String,
      payerDisplay: (json['payerDisplay'] as String?) ?? '',
      payerAvatarUrl: json['payerAvatarUrl'] as String?,
      totalOwedCents: (json['totalOwedCents'] as num?)?.toInt() ?? 0,
      items: coercedItems,
    );
  }
}

/// Summary returned by `expenses_get_created_by_me`.
class ExpenseCreatedSummary {
  const ExpenseCreatedSummary({
    required this.expenseId,
    required this.homeId,
    required this.createdByUserId,
    required this.description,
    required this.amountCents,
    required this.status,
    required this.totalShares,
    required this.paidShares,
    required this.paidAmountCents,
    required this.allPaid,
    required this.createdAt,
    this.splitType,
    this.fullyPaidAt,
  });

  final String expenseId;
  final String homeId;
  final String createdByUserId;
  final String description;
  final int amountCents;
  final ExpenseStatus status;
  final ExpenseSplitType? splitType;
  final int totalShares;
  final int paidShares;
  final int paidAmountCents;
  final bool allPaid;
  final DateTime createdAt;
  final DateTime? fullyPaidAt;

  bool get isDraft => status == ExpenseStatus.draft;

  factory ExpenseCreatedSummary.fromJson(Map<String, dynamic> json) {
    return ExpenseCreatedSummary(
      expenseId: json['expenseId'] as String,
      homeId: json['homeId'] as String,
      createdByUserId: json['createdByUserId'] as String,
      description: (json['description'] as String?) ?? '',
      amountCents: (json['amountCents'] as num).toInt(),
      status: ExpenseStatusWire.fromWire(json['status'] as String?),
      splitType: ExpenseSplitTypeWire.fromWire(json['splitType'] as String?),
      totalShares: (json['totalShares'] as num?)?.toInt() ?? 0,
      paidShares: (json['paidShares'] as num?)?.toInt() ?? 0,
      paidAmountCents: (json['paidAmountCents'] as num?)?.toInt() ?? 0,
      allPaid: json['allPaid'] as bool? ?? false,
      createdAt: _parseTimestamp(json['createdAt'])!,
      fullyPaidAt: _parseTimestamp(json['fullyPaidAt']),
    );
  }
}

DateTime? _parseTimestamp(Object? value) {
  if (value == null) return null;
  final dt = DateTime.parse(value as String);
  return dt.isUtc ? dt : dt.toUtc();
}
