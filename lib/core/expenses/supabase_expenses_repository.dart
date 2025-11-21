import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/repositories/expenses_repository.dart';
import '../supabase/supabase_error_mapper.dart';
import 'models.dart';

class SupabaseExpensesRepository implements ExpensesRepository {
  SupabaseExpensesRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<Expense> create({
    required String homeId,
    required int amountCents,
    required String description,
    String? notes,
    ExpenseSplitType? splitType,
    List<String>? memberIds,
    List<ExpenseCustomSplitInput>? customSplits,
  }) async {
    try {
      final response = await _client.rpc(
        'expenses_create',
        params: {
          'p_home_id': homeId,
          'p_amount_cents': amountCents,
          'p_description': description,
          if (notes != null) 'p_notes': notes,
          if (splitType != null) 'p_split_mode': splitType.wireValue,
          if (memberIds != null && memberIds.isNotEmpty)
            'p_member_ids': memberIds,
          if (customSplits != null && customSplits.isNotEmpty)
            'p_splits': customSplits.map((split) => split.toJson()).toList(),
        },
      );

      final payload = _coerceMap(response);
      if (payload != null) {
        return Expense.fromJson(payload);
      }

      throw const ExpenseException(
        ExpenseErrorCode.unknown,
        'Malformed expense payload from Supabase.',
      );
    } catch (error) {
      throw SupabaseErrorMapper.mapExpense(error);
    }
  }

  @override
  Future<Expense> edit({
    required String expenseId,
    required int amountCents,
    required String description,
    String? notes,
    ExpenseSplitType? splitType,
    List<String>? memberIds,
    List<ExpenseCustomSplitInput>? customSplits,
  }) async {
    try {
      final response = await _client.rpc(
        'expenses_edit',
        params: {
          'p_expense_id': expenseId,
          'p_amount_cents': amountCents,
          'p_description': description,
          if (notes != null) 'p_notes': notes,
          if (splitType != null) 'p_split_mode': splitType.wireValue,
          if (memberIds != null && memberIds.isNotEmpty)
            'p_member_ids': memberIds,
          if (customSplits != null && customSplits.isNotEmpty)
            'p_splits': customSplits.map((split) => split.toJson()).toList(),
        },
      );

      final payload = _coerceMap(response);
      if (payload != null) {
        return Expense.fromJson(payload);
      }

      throw const ExpenseException(
        ExpenseErrorCode.unknown,
        'Malformed expense payload from Supabase.',
      );
    } catch (error) {
      throw SupabaseErrorMapper.mapExpense(error);
    }
  }

  @override
  Future<List<ExpenseOwedGroup>> listCurrentOwed({
    required String homeId,
  }) async {
    try {
      final response = await _client.rpc(
        'expenses_get_current_owed',
        params: {'p_home_id': homeId},
      );
      final list = _coerceList(response);
      if (list == null) return const [];
      return list
          .map((entry) => ExpenseOwedGroup.fromJson(entry))
          .toList(growable: false);
    } catch (error) {
      throw SupabaseErrorMapper.mapExpense(error);
    }
  }

  @override
  Future<List<ExpenseCreatedSummary>> listCreatedByMe({
    required String homeId,
  }) async {
    try {
      final response = await _client.rpc(
        'expenses_get_created_by_me',
        params: {'p_home_id': homeId},
      );
      final list = _coerceList(response);
      if (list == null) return const [];
      return list
          .map((entry) => ExpenseCreatedSummary.fromJson(entry))
          .toList(growable: false);
    } catch (error) {
      throw SupabaseErrorMapper.mapExpense(error);
    }
  }

  @override
  Future<ExpenseForEdit> getForEdit(String expenseId) async {
    try {
      final response = await _client.rpc(
        'expenses_get_for_edit',
        params: {'p_expense_id': expenseId},
      );
      final payload = _coerceMap(response);
      if (payload == null) {
        throw const ExpenseException(
          ExpenseErrorCode.unknown,
          'Malformed expense payload from Supabase.',
        );
      }
      return ExpenseForEdit.fromJson(payload);
    } catch (error) {
      throw SupabaseErrorMapper.mapExpense(error);
    }
  }

  @override
  Future<void> markSharePaid(String expenseId) async {
    try {
      await _client.rpc(
        'expenses_mark_share_paid',
        params: {'p_expense_id': expenseId},
      );
    } catch (error) {
      throw SupabaseErrorMapper.mapExpense(error);
    }
  }

  Map<String, dynamic>? _coerceMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return value.cast<String, dynamic>();
    return null;
  }

  List<Map<String, dynamic>>? _coerceList(dynamic value) {
    if (value is List<Map<String, dynamic>>) {
      return value;
    }
    if (value is List) {
      return value
          .whereType<Map>()
          .map((entry) => entry.cast<String, dynamic>())
          .toList();
    }
    if (value is Map) {
      // rpc may return jsonb array already decoded as List<dynamic>
      final root = value['_data'];
      if (root is List) {
        return root
            .whereType<Map>()
            .map((entry) => entry.cast<String, dynamic>())
            .toList();
      }
    }
    return null;
  }
}
