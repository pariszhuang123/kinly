import 'package:kinly/contracts/time/timezone.dart';

import 'enums/expense_recurrence_interval.dart';
import 'enums/expense_share_status.dart';
import 'enums/expense_split_type.dart';
import 'enums/expense_status.dart';

export 'enums/expense_share_status.dart';
export 'enums/expense_split_type.dart';
export 'enums/expense_status.dart';
export 'enums/expense_recurrence_interval.dart';

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
    required this.recurrenceInterval,
    required this.startDate,
    this.planId,
    this.fullyPaidAt,
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
  final String? planId;
  final ExpenseRecurrenceInterval recurrenceInterval;
  final DateTime startDate;
  final DateTime? fullyPaidAt;

  factory Expense.fromJson(Map<String, dynamic> json) {
    final id = json['id'] ?? json['expenseId'];
    final homeId = json['home_id'] ?? json['homeId'];
    final createdBy = json['created_by_user_id'] ?? json['createdByUserId'];
    final splitTypeRaw = json['split_type'] ?? json['splitType'];
    final amountRaw = json['amount_cents'] ?? json['amountCents'];
    final description = json['description'] ?? json['description'];
    final notes = json['notes'];
    final createdAtRaw = json['created_at'] ?? json['createdAt'];
    final updatedAtRaw = json['updated_at'] ?? json['updatedAt'];
    final recurrenceWire =
        json['recurrenceInterval'] ?? json['recurrence_interval'];
    final startDateRaw = json['startDate'] ?? json['start_date'];
    final planId = json['planId'] ?? json['plan_id'];
    final fullyPaidRaw = json['fullyPaidAt'] ?? json['fully_paid_at'];

    return Expense(
      id: id as String,
      homeId: homeId as String,
      createdByUserId: createdBy as String,
      status: ExpenseStatusWire.fromWire(json['status'] as String?),
      splitType: ExpenseSplitTypeWire.fromWire(splitTypeRaw as String?),
      amountCents: (amountRaw as num?)?.toInt() ?? 0,
      description: (description as String?) ?? '',
      notes: notes as String?,
      createdAt: parseTimestampToLocal(createdAtRaw)!,
      updatedAt: parseTimestampToLocal(updatedAtRaw)!,
      planId: planId as String?,
      recurrenceInterval: ExpenseRecurrenceIntervalWire.fromWire(
        recurrenceWire as String?,
      ),
      startDate:
          parseDateToLocal(startDateRaw) ??
          parseTimestampToLocal(startDateRaw) ??
          parseTimestampToLocal(json['created_at'])!,
      fullyPaidAt: parseTimestampToLocal(fullyPaidRaw),
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
    final expenseId = json['expense_id'] ?? json['expenseId'];
    final debtorId = json['debtor_user_id'] ?? json['debtorUserId'];
    final amountRaw = json['amount_cents'] ?? json['amountCents'];
    final markedPaidRaw = json['marked_paid_at'] ?? json['markedPaidAt'];

    return ExpenseSplit(
      expenseId: expenseId as String,
      debtorUserId: debtorId as String,
      amountCents: (amountRaw as num).toInt(),
      status: ExpenseShareStatusWire.fromWire(json['status'] as String?),
      markedPaidAt: parseTimestampToLocal(markedPaidRaw),
    );
  }
}

/// Wrapper for edit/detail payloads containing the base expense and splits.
class ExpenseForEdit {
  const ExpenseForEdit({
    required this.expense,
    required this.splits,
    required this.amountLocked,
    required this.canEdit,
    required this.editDisabledReason,
    this.planStatus,
  });

  final Expense expense;
  final List<ExpenseSplit> splits;
  final bool amountLocked;
  final bool canEdit;
  final String? editDisabledReason;
  final String? planStatus;

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
      canEdit: json['canEdit'] as bool? ?? true,
      editDisabledReason: json['editDisabledReason'] as String?,
      planStatus: json['planStatus'] as String?,
    );
  }
}

/// Owed entry returned by `expenses_get_current_owed`.
class ExpenseOwedItem {
  const ExpenseOwedItem({
    required this.expenseId,
    required this.description,
    required this.amountCents,
    required this.recurrenceInterval,
    required this.startDate,
    this.notes,
  });

  final String expenseId;
  final String description;
  final int amountCents;
  final ExpenseRecurrenceInterval recurrenceInterval;
  final DateTime startDate;
  final String? notes;

  factory ExpenseOwedItem.fromJson(Map<String, dynamic> json) {
    final recurrenceWire =
        json['recurrenceInterval'] ?? json['recurrence_interval'];
    final startDateRaw = json['startDate'] ?? json['start_date'];

    return ExpenseOwedItem(
      expenseId: json['expenseId'] as String,
      description: (json['description'] as String?) ?? '',
      amountCents: (json['amountCents'] as num).toInt(),
      recurrenceInterval: ExpenseRecurrenceIntervalWire.fromWire(
        recurrenceWire as String?,
      ),
      startDate:
          parseDateToLocal(startDateRaw) ??
          parseTimestampToLocal(startDateRaw) ??
          DateTime.now(),
      notes: json['notes'] as String?,
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
    required this.recurrenceInterval,
    required this.startDate,
    this.planId,
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
  final String? planId;
  final ExpenseRecurrenceInterval recurrenceInterval;
  final DateTime startDate;

  factory ExpenseCreatedSummary.fromJson(Map<String, dynamic> json) {
    final recurrenceWire =
        json['recurrenceInterval'] ?? json['recurrence_interval'];
    final startDateRaw = json['startDate'] ?? json['start_date'];
    final planId = json['planId'] ?? json['plan_id'];

    return ExpenseCreatedSummary(
      expenseId: json['expenseId'] as String,
      homeId: json['homeId'] as String,
      createdByUserId: json['createdByUserId'] as String,
      description: (json['description'] as String?) ?? '',
      amountCents: (json['amountCents'] as num?)?.toInt() ?? 0,
      status: ExpenseStatusWire.fromWire(json['status'] as String?),
      splitType: ExpenseSplitTypeWire.fromWire(json['splitType'] as String?),
      totalShares: (json['totalShares'] as num?)?.toInt() ?? 0,
      paidShares: (json['paidShares'] as num?)?.toInt() ?? 0,
      paidAmountCents: (json['paidAmountCents'] as num?)?.toInt() ?? 0,
      allPaid: json['allPaid'] as bool? ?? false,
      createdAt: parseTimestampToLocal(json['createdAt'])!,
      fullyPaidAt: parseTimestampToLocal(json['fullyPaidAt']),
      planId: planId as String?,
      recurrenceInterval: ExpenseRecurrenceIntervalWire.fromWire(
        recurrenceWire as String?,
      ),
      startDate:
          parseDateToLocal(startDateRaw) ??
          parseTimestampToLocal(startDateRaw) ??
          parseTimestampToLocal(json['createdAt'])!,
    );
  }
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
    required this.recurrenceInterval,
    required this.startDate,
    this.debtorUsername,
    this.debtorAvatarUrl,
    this.isOwner = false,
    this.notes,
  });

  final String expenseId;
  final String description;
  final int amountCents;
  final DateTime? markedPaidAt;
  final ExpenseRecurrenceInterval recurrenceInterval;
  final DateTime startDate;
  final String? debtorUsername;
  final String? debtorAvatarUrl;
  final bool isOwner;
  final String? notes;

  factory ExpensePaidToMeItem.fromJson(Map<String, dynamic> json) {
    final recurrenceWire =
        json['recurrenceInterval'] ?? json['recurrence_interval'];
    final startDateRaw = json['startDate'] ?? json['start_date'];

    return ExpensePaidToMeItem(
      expenseId: json['expenseId'] as String,
      description: (json['description'] as String?) ?? '',
      amountCents: (json['amountCents'] as num).toInt(),
      markedPaidAt: parseTimestampToLocal(json['markedPaidAt']),
      recurrenceInterval: ExpenseRecurrenceIntervalWire.fromWire(
        recurrenceWire as String?,
      ),
      startDate:
          parseDateToLocal(startDateRaw) ??
          parseTimestampToLocal(startDateRaw) ??
          DateTime.now(),
      debtorUsername: json['debtorUsername'] as String?,
      debtorAvatarUrl: json['debtorAvatarUrl'] as String?,
      isOwner: json['isOwner'] as bool? ?? false,
      notes: json['notes'] as String?,
    );
  }
}

class ExpensePlan {
  ExpensePlan({
    required this.id,
    required this.homeId,
    required this.createdByUserId,
    required this.splitType,
    required this.amountCents,
    required this.description,
    this.notes,
    required this.recurrenceInterval,
    required this.startDate,
    required this.status,
    this.terminatedAt,
  });

  final String id;
  final String homeId;
  final String createdByUserId;
  final ExpenseSplitType splitType;
  final int amountCents;
  final String description;
  final String? notes;
  final ExpenseRecurrenceInterval recurrenceInterval;
  final DateTime startDate;
  final String status;
  final DateTime? terminatedAt;

  factory ExpensePlan.fromJson(Map<String, dynamic> json) {
    final recurrenceRaw =
        json['recurrenceInterval'] ?? json['recurrence_interval'];
    final startDateRaw = json['startDate'] ?? json['start_date'];
    final terminatedRaw = json['terminatedAt'] ?? json['terminated_at'];

    return ExpensePlan(
      id: json['id'] as String,
      homeId: json['home_id'] as String,
      createdByUserId: json['created_by_user_id'] as String,
      splitType:
          ExpenseSplitTypeWire.fromWire(json['split_type'] as String?) ??
              ExpenseSplitType.equal,
      amountCents: (json['amount_cents'] as num?)?.toInt() ?? 0,
      description: json['description'] as String? ?? '',
      notes: json['notes'] as String?,
      recurrenceInterval: ExpenseRecurrenceIntervalWire.fromWire(
        recurrenceRaw as String?,
      ),
      startDate:
          parseDateToLocal(startDateRaw) ??
          parseTimestampToLocal(startDateRaw) ??
          DateTime.now(),
      status: json['status'] as String? ?? '',
      terminatedAt: parseTimestampToLocal(terminatedRaw),
    );
  }
}
