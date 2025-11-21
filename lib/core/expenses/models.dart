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

DateTime? _parseTimestamp(Object? value) {
  if (value == null) return null;
  final dt = DateTime.parse(value as String);
  return dt.isUtc ? dt : dt.toUtc();
}
