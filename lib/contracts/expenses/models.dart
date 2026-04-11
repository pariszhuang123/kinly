import 'package:kinly/contracts/time/timezone.dart';

import 'enums/expense_recurrence_interval.dart';
import 'enums/expense_recurrence_unit.dart';
import 'enums/expense_share_status.dart';
import 'enums/expense_split_type.dart';
import 'enums/expense_status.dart';

export 'enums/expense_share_status.dart';
export 'enums/expense_split_type.dart';
export 'enums/expense_status.dart';
export 'enums/expense_recurrence_interval.dart';
export 'enums/expense_recurrence_unit.dart';

enum ExpenseAllocationTargetType {
  debtorBased('debtor_based'),
  unitBased('unit_based');

  const ExpenseAllocationTargetType(this.wireValue);

  final String wireValue;

  static ExpenseAllocationTargetType? fromWire(String? value) {
    switch ((value ?? '').trim().toLowerCase()) {
      case 'debtor_based':
        return ExpenseAllocationTargetType.debtorBased;
      case 'unit_based':
        return ExpenseAllocationTargetType.unitBased;
      default:
        return null;
    }
  }
}

enum ExpenseLiabilityKind {
  personal('personal'),
  shared('shared');

  const ExpenseLiabilityKind(this.wireValue);

  final String wireValue;

  static ExpenseLiabilityKind? fromWire(String? value) {
    switch ((value ?? '').trim().toLowerCase()) {
      case 'personal':
        return ExpenseLiabilityKind.personal;
      case 'shared':
        return ExpenseLiabilityKind.shared;
      default:
        return null;
    }
  }
}

enum ExpenseLiabilityScope {
  personalUnit('personal_unit'),
  sharedUnit('shared_unit');

  const ExpenseLiabilityScope(this.wireValue);

  final String wireValue;

  static ExpenseLiabilityScope? fromWire(String? value) {
    switch ((value ?? '').trim().toLowerCase()) {
      case 'personal_unit':
        return ExpenseLiabilityScope.personalUnit;
      case 'shared_unit':
        return ExpenseLiabilityScope.sharedUnit;
      default:
        return null;
    }
  }
}

/// Top-level expense record returned by Supabase RPCs.
class Expense {
  const Expense({
    required this.id,
    required this.homeId,
    required this.createdByUserId,
    required this.status,
    this.allocationTargetType,
    required this.splitType,
    required this.amountCents,
    required this.description,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.recurrenceEvery,
    required this.recurrenceUnit,
    required this.startDate,
    this.planId,
    this.fullyPaidAt,
    this.evidencePhotoPath,
  });

  final String id;
  final String homeId;
  final String createdByUserId;
  final ExpenseStatus status;
  final ExpenseAllocationTargetType? allocationTargetType;
  final ExpenseSplitType? splitType;
  final int amountCents;
  final String description;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? planId;
  final int? recurrenceEvery;
  final ExpenseRecurrenceUnit? recurrenceUnit;
  final DateTime startDate;
  final DateTime? fullyPaidAt;
  final String? evidencePhotoPath;

  factory Expense.fromJson(Map<String, dynamic> json) {
    final id = json['id'] ?? json['expenseId'];
    final homeId = json['home_id'] ?? json['homeId'];
    final createdBy = json['created_by_user_id'] ?? json['createdByUserId'];
    final allocationTargetTypeRaw =
        json['allocation_target_type'] ?? json['allocationTargetType'];
    final splitTypeRaw = json['split_type'] ?? json['splitType'];
    final amountRaw = json['amount_cents'] ?? json['amountCents'];
    final description = json['description'] ?? json['description'];
    final notes = json['notes'];
    final createdAtRaw = json['created_at'] ?? json['createdAt'];
    final updatedAtRaw = json['updated_at'] ?? json['updatedAt'];
    final recurrence = _parseRecurrence(json);
    final startDateRaw = json['startDate'] ?? json['start_date'];
    final planId = json['planId'] ?? json['plan_id'];
    final fullyPaidRaw = json['fullyPaidAt'] ?? json['fully_paid_at'];
    final evidencePhotoPath =
        json['evidencePhotoPath'] ?? json['evidence_photo_path'];

    return Expense(
      id: id as String,
      homeId: homeId as String,
      createdByUserId: createdBy as String,
      status: ExpenseStatusWire.fromWire(json['status'] as String?),
      allocationTargetType: ExpenseAllocationTargetType.fromWire(
        allocationTargetTypeRaw as String?,
      ),
      splitType: ExpenseSplitTypeWire.fromWire(splitTypeRaw as String?),
      amountCents: (amountRaw as num?)?.toInt() ?? 0,
      description: (description as String?) ?? '',
      notes: notes as String?,
      createdAt: parseTimestampToLocal(createdAtRaw)!,
      updatedAt: parseTimestampToLocal(updatedAtRaw)!,
      planId: planId as String?,
      recurrenceEvery: recurrence.every,
      recurrenceUnit: recurrence.unit,
      startDate:
          parseDateToLocal(startDateRaw) ??
          parseTimestampToLocal(startDateRaw) ??
          parseTimestampToLocal(json['created_at'])!,
      fullyPaidAt: parseTimestampToLocal(fullyPaidRaw),
      evidencePhotoPath: evidencePhotoPath as String?,
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

class ExpenseUnitSplit {
  const ExpenseUnitSplit({
    required this.expenseId,
    required this.homeId,
    required this.unitId,
    required this.amountCents,
    required this.paidCents,
    required this.fullyPaidAt,
    this.unitName,
  });

  final String expenseId;
  final String homeId;
  final String unitId;
  final int amountCents;
  final int paidCents;
  final DateTime? fullyPaidAt;
  final String? unitName;

  factory ExpenseUnitSplit.fromJson(Map<String, dynamic> json) {
    return ExpenseUnitSplit(
      expenseId:
          json['expense_id'] as String? ?? json['expenseId'] as String? ?? '',
      homeId: json['home_id'] as String? ?? json['homeId'] as String? ?? '',
      unitId: json['unit_id'] as String? ?? json['unitId'] as String? ?? '',
      amountCents:
          (json['amount_cents'] as num?)?.toInt() ??
          (json['amountCents'] as num?)?.toInt() ??
          0,
      paidCents:
          (json['paid_cents'] as num?)?.toInt() ??
          (json['paidCents'] as num?)?.toInt() ??
          0,
      fullyPaidAt: parseTimestampToLocal(
        json['fully_paid_at'] ?? json['fullyPaidAt'],
      ),
      unitName: json['unit_name'] as String? ?? json['unitName'] as String?,
    );
  }
}

/// Wrapper for edit/detail payloads containing the base expense and splits.
class ExpenseForEdit {
  const ExpenseForEdit({
    required this.expense,
    required this.splits,
    this.unitSplits = const <ExpenseUnitSplit>[],
    required this.amountLocked,
    required this.canEdit,
    required this.editDisabledReason,
    this.planStatus,
    this.terminationReason,
  });

  final Expense expense;
  final List<ExpenseSplit> splits;
  final List<ExpenseUnitSplit> unitSplits;
  final bool amountLocked;
  final bool canEdit;
  final String? editDisabledReason;
  final String? planStatus;
  final String? terminationReason;

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
    final rawUnitSplits = json['unitSplits'] ?? json['unit_splits'];
    final unitSplits =
        rawUnitSplits is Iterable
            ? rawUnitSplits
                .map(
                  (entry) => ExpenseUnitSplit.fromJson(
                    (entry as Map).cast<String, dynamic>(),
                  ),
                )
                .toList(growable: false)
            : const <ExpenseUnitSplit>[];
    return ExpenseForEdit(
      expense: Expense.fromJson(json),
      splits: splits,
      unitSplits: unitSplits,
      amountLocked: json['amount_locked'] as bool? ?? false,
      canEdit: json['canEdit'] as bool? ?? true,
      editDisabledReason: json['editDisabledReason'] as String?,
      planStatus: json['planStatus'] as String?,
      terminationReason:
          json['terminationReason'] as String? ??
          json['termination_reason'] as String?,
    );
  }
}

/// Owed entry returned by `expenses_get_current_owed`.
class ExpenseOwedItem {
  const ExpenseOwedItem({
    required this.expenseId,
    required this.description,
    required this.amountCents,
    required this.recurrenceEvery,
    required this.recurrenceUnit,
    required this.startDate,
    this.notes,
    this.evidencePhotoPath,
    this.liabilityKind,
    this.liabilityScope,
    this.displayMode,
    this.unitId,
    this.unitName,
    this.paidCents,
    this.remainingCents,
    this.containsSharedUnitBalance = false,
  });

  final String expenseId;
  final String description;
  final int amountCents;
  final int? recurrenceEvery;
  final ExpenseRecurrenceUnit? recurrenceUnit;
  final DateTime startDate;
  final String? notes;
  final String? evidencePhotoPath;
  final ExpenseLiabilityKind? liabilityKind;
  final ExpenseLiabilityScope? liabilityScope;
  final String? displayMode;
  final String? unitId;
  final String? unitName;
  final int? paidCents;
  final int? remainingCents;
  final bool containsSharedUnitBalance;

  factory ExpenseOwedItem.fromJson(Map<String, dynamic> json) {
    final recurrence = _parseRecurrence(json);
    final startDateRaw = json['startDate'] ?? json['start_date'];
    final evidencePhotoPath =
        json['evidencePhotoPath'] ?? json['evidence_photo_path'];

    return ExpenseOwedItem(
      expenseId: json['expenseId'] as String,
      description: (json['description'] as String?) ?? '',
      amountCents: (json['amountCents'] as num).toInt(),
      recurrenceEvery: recurrence.every,
      recurrenceUnit: recurrence.unit,
      startDate:
          parseDateToLocal(startDateRaw) ??
          parseTimestampToLocal(startDateRaw) ??
          DateTime.now(),
      notes: json['notes'] as String?,
      evidencePhotoPath: evidencePhotoPath as String?,
      liabilityKind: ExpenseLiabilityKind.fromWire(
        json['liabilityKind'] as String? ?? json['liability_kind'] as String?,
      ),
      liabilityScope: ExpenseLiabilityScope.fromWire(
        json['liabilityScope'] as String? ??
            json['liability_scope'] as String?,
      ),
      displayMode:
          json['displayMode'] as String? ?? json['display_mode'] as String?,
      unitId: json['unitId'] as String? ?? json['unit_id'] as String?,
      unitName: json['unitName'] as String? ?? json['unit_name'] as String?,
      paidCents:
          (json['paidCents'] as num?)?.toInt() ??
          (json['paid_cents'] as num?)?.toInt(),
      remainingCents:
          (json['remainingCents'] as num?)?.toInt() ??
          (json['remaining_cents'] as num?)?.toInt(),
      containsSharedUnitBalance:
          json['containsSharedUnitBalance'] as bool? ??
          json['contains_shared_unit_balance'] as bool? ??
          false,
    );
  }
}

class ExpenseOwedGroup {
  const ExpenseOwedGroup({
    required this.payerUserId,
    required this.payerDisplay,
    required this.totalOwedCents,
    required this.items,
    this.payerUsername,
    this.payerAvatarUrl,
  });

  final String payerUserId;
  final String payerDisplay;
  final String? payerUsername;
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
      payerUsername: json['payerUsername'] as String?,
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
    this.allocationTargetType,
    required this.totalShares,
    required this.paidShares,
    required this.paidAmountCents,
    required this.allPaid,
    required this.createdAt,
    required this.recurrenceEvery,
    required this.recurrenceUnit,
    required this.startDate,
    this.planId,
    this.splitType,
    this.fullyPaidAt,
    this.evidencePhotoPath,
  });

  final String expenseId;
  final String homeId;
  final String createdByUserId;
  final String description;
  final int amountCents;
  final ExpenseStatus status;
  final ExpenseAllocationTargetType? allocationTargetType;
  final ExpenseSplitType? splitType;
  final int totalShares;
  final int paidShares;
  final int paidAmountCents;
  final bool allPaid;
  final DateTime createdAt;
  final DateTime? fullyPaidAt;
  final String? planId;
  final int? recurrenceEvery;
  final ExpenseRecurrenceUnit? recurrenceUnit;
  final DateTime startDate;
  final String? evidencePhotoPath;

  factory ExpenseCreatedSummary.fromJson(Map<String, dynamic> json) {
    final recurrence = _parseRecurrence(json);
    final startDateRaw = json['startDate'] ?? json['start_date'];
    final planId = json['planId'] ?? json['plan_id'];
    final evidencePhotoPath =
        json['evidencePhotoPath'] ?? json['evidence_photo_path'];

    return ExpenseCreatedSummary(
      expenseId: json['expenseId'] as String,
      homeId: json['homeId'] as String,
      createdByUserId: json['createdByUserId'] as String,
      description: (json['description'] as String?) ?? '',
      amountCents: (json['amountCents'] as num?)?.toInt() ?? 0,
      status: ExpenseStatusWire.fromWire(json['status'] as String?),
      allocationTargetType: ExpenseAllocationTargetType.fromWire(
        json['allocationTargetType'] as String? ??
            json['allocation_target_type'] as String?,
      ),
      splitType: ExpenseSplitTypeWire.fromWire(json['splitType'] as String?),
      totalShares: (json['totalShares'] as num?)?.toInt() ?? 0,
      paidShares: (json['paidShares'] as num?)?.toInt() ?? 0,
      paidAmountCents: (json['paidAmountCents'] as num?)?.toInt() ?? 0,
      allPaid: json['allPaid'] as bool? ?? false,
      createdAt: parseTimestampToLocal(json['createdAt'])!,
      fullyPaidAt: parseTimestampToLocal(json['fullyPaidAt']),
      planId: planId as String?,
      recurrenceEvery: recurrence.every,
      recurrenceUnit: recurrence.unit,
      startDate:
          parseDateToLocal(startDateRaw) ??
          parseTimestampToLocal(startDateRaw) ??
          parseTimestampToLocal(json['createdAt'])!,
      evidencePhotoPath: evidencePhotoPath as String?,
    );
  }
}

/// Payload for custom split entries accepted by Supabase RPCs.
class ExpenseCustomSplitInput {
  const ExpenseCustomSplitInput({
    required this.memberId,
    required this.amountCents,
  });

  final String memberId;
  final int amountCents;

  Map<String, dynamic> toJson() => {
    'member_id': memberId,
    'amount_cents': amountCents,
  };
}

class ExpenseUnitSplitInput {
  const ExpenseUnitSplitInput({
    required this.unitId,
    required this.amountCents,
  });

  final String unitId;
  final int amountCents;

  Map<String, dynamic> toJson() => {
    'unit_id': unitId,
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
    required this.recurrenceEvery,
    required this.recurrenceUnit,
    required this.startDate,
    this.debtorUsername,
    this.debtorAvatarUrl,
    this.isOwner = false,
    this.notes,
    this.evidencePhotoPath,
  });

  final String expenseId;
  final String description;
  final int amountCents;
  final DateTime? markedPaidAt;
  final int? recurrenceEvery;
  final ExpenseRecurrenceUnit? recurrenceUnit;
  final DateTime startDate;
  final String? debtorUsername;
  final String? debtorAvatarUrl;
  final bool isOwner;
  final String? notes;
  final String? evidencePhotoPath;

  factory ExpensePaidToMeItem.fromJson(Map<String, dynamic> json) {
    final recurrence = _parseRecurrence(json);
    final startDateRaw = json['startDate'] ?? json['start_date'];
    final evidencePhotoPath =
        json['evidencePhotoPath'] ?? json['evidence_photo_path'];

    return ExpensePaidToMeItem(
      expenseId: json['expenseId'] as String,
      description: (json['description'] as String?) ?? '',
      amountCents: (json['amountCents'] as num).toInt(),
      markedPaidAt: parseTimestampToLocal(json['markedPaidAt']),
      recurrenceEvery: recurrence.every,
      recurrenceUnit: recurrence.unit,
      startDate:
          parseDateToLocal(startDateRaw) ??
          parseTimestampToLocal(startDateRaw) ??
          DateTime.now(),
      debtorUsername: json['debtorUsername'] as String?,
      debtorAvatarUrl: json['debtorAvatarUrl'] as String?,
      isOwner: json['isOwner'] as bool? ?? false,
      notes: json['notes'] as String?,
      evidencePhotoPath: evidencePhotoPath as String?,
    );
  }
}

class ExpensesPayUnitDueResult {
  ExpensesPayUnitDueResult({
    required this.expenseId,
    required this.unitId,
    required this.amountCents,
    required this.remainingCents,
    required this.expenseFullyPaid,
  });

  final String expenseId;
  final String unitId;
  final int amountCents;
  final int remainingCents;
  final bool expenseFullyPaid;

  factory ExpensesPayUnitDueResult.fromJson(Map<String, dynamic> json) {
    return ExpensesPayUnitDueResult(
      expenseId:
          json['expenseId'] as String? ?? json['expense_id'] as String? ?? '',
      unitId: json['unitId'] as String? ?? json['unit_id'] as String? ?? '',
      amountCents:
          (json['amountCents'] as num?)?.toInt() ??
          (json['amount_cents'] as num?)?.toInt() ??
          0,
      remainingCents:
          (json['remainingCents'] as num?)?.toInt() ??
          (json['remaining_cents'] as num?)?.toInt() ??
          0,
      expenseFullyPaid:
          json['expenseFullyPaid'] as bool? ??
          json['expense_fully_paid'] as bool? ??
          false,
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
    required this.recurrenceEvery,
    required this.recurrenceUnit,
    required this.startDate,
    required this.status,
    this.terminatedAt,
    this.evidencePhotoPath,
    this.terminationReason,
  });

  final String id;
  final String homeId;
  final String createdByUserId;
  final ExpenseSplitType splitType;
  final int amountCents;
  final String description;
  final String? notes;
  final int recurrenceEvery;
  final ExpenseRecurrenceUnit recurrenceUnit;
  final DateTime startDate;
  final String status;
  final DateTime? terminatedAt;
  final String? evidencePhotoPath;
  final String? terminationReason;

  factory ExpensePlan.fromJson(Map<String, dynamic> json) {
    final recurrence = _parseRecurrence(json);
    final startDateRaw = json['startDate'] ?? json['start_date'];
    final terminatedRaw = json['terminatedAt'] ?? json['terminated_at'];
    final evidencePhotoPath =
        json['evidencePhotoPath'] ?? json['evidence_photo_path'];

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
      recurrenceEvery: recurrence.every ?? 1,
      recurrenceUnit: recurrence.unit ?? ExpenseRecurrenceUnit.week,
      startDate:
          parseDateToLocal(startDateRaw) ??
          parseTimestampToLocal(startDateRaw) ??
          DateTime.now(),
      status: json['status'] as String? ?? '',
      terminatedAt: parseTimestampToLocal(terminatedRaw),
      evidencePhotoPath: evidencePhotoPath as String?,
      terminationReason:
          json['terminationReason'] as String? ??
          json['termination_reason'] as String?,
    );
  }
}

class _ParsedRecurrence {
  const _ParsedRecurrence(this.every, this.unit);

  final int? every;
  final ExpenseRecurrenceUnit? unit;
}

_ParsedRecurrence _parseRecurrence(Map<String, dynamic> json) {
  final everyRaw = json['recurrenceEvery'] ?? json['recurrence_every'];
  final unitRaw = json['recurrenceUnit'] ?? json['recurrence_unit'];
  final every = (everyRaw as num?)?.toInt();
  final unit = ExpenseRecurrenceUnitWire.fromWire(unitRaw as String?);
  if (every != null || unit != null) {
    return _ParsedRecurrence(every, unit);
  }

  final intervalRaw = json['recurrenceInterval'] ?? json['recurrence_interval'];
  final interval = ExpenseRecurrenceIntervalWire.fromWire(
    intervalRaw as String?,
  );

  switch (interval) {
    case ExpenseRecurrenceInterval.weekly:
      return const _ParsedRecurrence(1, ExpenseRecurrenceUnit.week);
    case ExpenseRecurrenceInterval.every2Weeks:
      return const _ParsedRecurrence(2, ExpenseRecurrenceUnit.week);
    case ExpenseRecurrenceInterval.monthly:
      return const _ParsedRecurrence(1, ExpenseRecurrenceUnit.month);
    case ExpenseRecurrenceInterval.every2Months:
      return const _ParsedRecurrence(2, ExpenseRecurrenceUnit.month);
    case ExpenseRecurrenceInterval.annual:
      return const _ParsedRecurrence(1, ExpenseRecurrenceUnit.year);
    case ExpenseRecurrenceInterval.none:
      return const _ParsedRecurrence(null, null);
  }
}
