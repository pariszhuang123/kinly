import 'package:kinly/contracts/expenses/models.dart';

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
    String? evidencePhotoPath,
    ExpenseSplitType? splitType,
    List<String>? memberIds,
    List<ExpenseCustomSplitInput>? customSplits,
    int? recurrenceEvery,
    ExpenseRecurrenceUnit? recurrenceUnit,
    required DateTime startDate,
  });

  /// Updates an existing expense, promoting drafts to active when a split is provided.
  Future<Expense> edit({
    required String expenseId,
    required int amountCents,
    required String description,
    String? notes,
    String? evidencePhotoPath,
    ExpenseSplitType? splitType,
    List<String>? memberIds,
    List<ExpenseCustomSplitInput>? customSplits,
    int? recurrenceEvery,
    ExpenseRecurrenceUnit? recurrenceUnit,
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

  /// Terminates a recurring plan; stops future cycles.
  Future<ExpensePlan> terminatePlan(String planId);
}
