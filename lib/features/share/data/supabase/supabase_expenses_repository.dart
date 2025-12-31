import 'package:intl/intl.dart';
import 'package:kinly/core/expenses/models.dart';
import 'package:kinly/core/supabase/supabase_error_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../share.dart';

class SupabaseExpensesRepository implements ExpensesRepository {
  SupabaseExpensesRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;
  final _dateFormatter = DateFormat('yyyy-MM-dd');

  @override
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
  }) async {
    try {
      final response = await _client.rpc(
        'expenses_create',
        params: {
          'p_home_id': homeId,
          'p_description': description,
          if (amountCents != null) 'p_amount_cents': amountCents,
          if (notes != null) 'p_notes': notes,
          if (splitType != null) 'p_split_mode': splitType.wireValue,
          if (memberIds != null && memberIds.isNotEmpty)
            'p_member_ids': memberIds,
          if (customSplits != null && customSplits.isNotEmpty)
            'p_splits': customSplits.map((split) => split.toJson()).toList(),
          'p_recurrence': recurrence.wireValue,
          'p_start_date': _dateFormatter.format(startDate),
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
    required ExpenseRecurrenceInterval recurrence,
    required DateTime startDate,
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
          'p_recurrence': recurrence.wireValue,
          'p_start_date': _dateFormatter.format(startDate),
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
  Future<ExpensesPayMyDueResult> payMyDue({
    required String recipientUserId,
  }) async {
    try {
      final response = await _client.rpc(
        'expenses_pay_my_due',
        params: {'p_recipient_user_id': recipientUserId},
      );

      final payload = _coerceMap(response);
      if (payload != null) {
        return ExpensesPayMyDueResult.fromJson(payload);
      }

      throw const ExpenseException(
        ExpenseErrorCode.unknown,
        'Malformed payMyDue payload from Supabase.',
      );
    } catch (error) {
      throw SupabaseErrorMapper.mapExpense(error);
    }
  }

  @override
  Future<List<ExpensePaidToMeDebtor>> listPaidToMeDebtors({
    required String homeId,
  }) async {
    try {
      final response = await _client.rpc(
        'expenses_get_current_paid_to_me_debtors',
        params: {'p_home_id': homeId},
      );
      final list = _coerceList(response);
      if (list == null) return const [];
      return list
          .map((entry) => ExpensePaidToMeDebtor.fromJson(entry))
          .toList(growable: false);
    } catch (error) {
      throw SupabaseErrorMapper.mapExpense(error);
    }
  }

  @override
  Future<List<ExpensePaidToMeItem>> listPaidToMeByDebtor({
    required String homeId,
    required String debtorUserId,
  }) async {
    try {
      final response = await _client.rpc(
        'expenses_get_current_paid_to_me_by_debtor_details',
        params: {'p_home_id': homeId, 'p_debtor_user_id': debtorUserId},
      );
      final list = _coerceList(response);
      if (list == null) return const [];
      return list
          .map((entry) => ExpensePaidToMeItem.fromJson(entry))
          .toList(growable: false);
    } catch (error) {
      throw SupabaseErrorMapper.mapExpense(error);
    }
  }

  @override
  Future<int> markPaidReceivedViewedForDebtor({
    required String homeId,
    required String debtorUserId,
  }) async {
    try {
      final response = await _client.rpc(
        'expenses_mark_paid_received_viewed_for_debtor',
        params: {'p_home_id': homeId, 'p_debtor_user_id': debtorUserId},
      );
      final payload = _coerceMap(response);
      return (payload?['updated'] as num?)?.toInt() ?? 0;
    } catch (error) {
      throw SupabaseErrorMapper.mapExpense(error);
    }
  }

  @override
  Future<Expense> cancel(String expenseId) async {
    try {
      final response = await _client.rpc(
        'expenses_cancel',
        params: {'p_expense_id': expenseId},
      );
      final payload = _coerceMap(response);
      if (payload == null) {
        throw const ExpenseException(
          ExpenseErrorCode.unknown,
          'Malformed expense payload from Supabase.',
        );
      }
      return Expense.fromJson(payload);
    } catch (error) {
      throw SupabaseErrorMapper.mapExpense(error);
    }
  }

  @override
  Future<ExpensePlan> terminatePlan(String planId) async {
    try {
      final response = await _client.rpc(
        'expense_plans_terminate',
        params: {'p_plan_id': planId},
      );
      final payload = _coerceMap(response);
      if (payload != null) {
        return ExpensePlan.fromJson(payload);
      }

      throw const ExpenseException(
        ExpenseErrorCode.unknown,
        'Malformed terminate plan payload from Supabase.',
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
