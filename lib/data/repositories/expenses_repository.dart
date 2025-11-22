import '../../core/expenses/models.dart';

/// Repository boundary for expense/share workflows.
abstract class ExpensesRepository {
  /// Creates a new expense tied to [homeId].
  ///
  /// Provide [memberIds] when splitting equally. Provide [customSplits] when
  /// using a custom split strategy. The backend enforces all validation rules.
  Future<Expense> create({
    required String homeId,
    required int amountCents,
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
  Future<void> markSharePaid(String expenseId);

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
