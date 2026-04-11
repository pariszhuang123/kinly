import 'package:intl/intl.dart';
import 'package:kinly/contracts/expenses/models.dart';
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
    String? evidencePhotoPath,
    ExpenseAllocationTargetType? allocationTargetType,
    ExpenseSplitType? splitType,
    List<String>? memberIds,
    List<ExpenseCustomSplitInput>? customSplits,
    List<String>? unitIds,
    List<ExpenseUnitSplitInput>? unitSplits,
    int? recurrenceEvery,
    ExpenseRecurrenceUnit? recurrenceUnit,
    required DateTime startDate,
  }) async {
    try {
      final response = await _client.rpc(
        'expenses_create_v5',
        params: _buildExpenseParams(
          homeId: homeId,
          description: description,
          amountCents: amountCents,
          notes: notes,
          evidencePhotoPath: evidencePhotoPath,
          allocationTargetType: allocationTargetType,
          splitType: splitType,
          memberIds: memberIds,
          customSplits: customSplits,
          unitIds: unitIds,
          unitSplits: unitSplits,
          recurrenceEvery: recurrenceEvery,
          recurrenceUnit: recurrenceUnit,
          startDate: startDate,
        ),
      );
      return _parseExpense(response);
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
    String? evidencePhotoPath,
    ExpenseAllocationTargetType? allocationTargetType,
    ExpenseSplitType? splitType,
    List<String>? memberIds,
    List<ExpenseCustomSplitInput>? customSplits,
    List<String>? unitIds,
    List<ExpenseUnitSplitInput>? unitSplits,
    int? recurrenceEvery,
    ExpenseRecurrenceUnit? recurrenceUnit,
    DateTime? startDate,
  }) async {
    try {
      final response = await _client.rpc(
        'expenses_edit_v5',
        params: _buildExpenseParams(
          expenseId: expenseId,
          description: description,
          amountCents: amountCents,
          notes: notes,
          evidencePhotoPath: evidencePhotoPath,
          allocationTargetType: allocationTargetType,
          splitType: splitType,
          memberIds: memberIds,
          customSplits: customSplits,
          unitIds: unitIds,
          unitSplits: unitSplits,
          recurrenceEvery: recurrenceEvery,
          recurrenceUnit: recurrenceUnit,
          startDate: startDate,
        ),
      );
      return _parseExpense(response);
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
        'expenses_get_for_edit_v3',
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
  Future<ExpensesPayUnitDueResult> payUnitDue({
    required String expenseId,
    required String unitId,
    required int amountCents,
  }) async {
    try {
      final response = await _client.rpc(
        'expenses_pay_unit_due_v2',
        params: {
          'p_expense_id': expenseId,
          'p_unit_id': unitId,
          'p_amount_cents': amountCents,
        },
      );
      final payload = _coerceMap(response);
      if (payload != null) {
        return ExpensesPayUnitDueResult.fromJson(payload);
      }
      throw const ExpenseException(
        ExpenseErrorCode.unknown,
        'Malformed payUnitDue payload from Supabase.',
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

  Map<String, dynamic> _buildExpenseParams({
    String? homeId,
    String? expenseId,
    required String description,
    int? amountCents,
    String? notes,
    String? evidencePhotoPath,
    ExpenseAllocationTargetType? allocationTargetType,
    ExpenseSplitType? splitType,
    List<String>? memberIds,
    List<ExpenseCustomSplitInput>? customSplits,
    List<String>? unitIds,
    List<ExpenseUnitSplitInput>? unitSplits,
    int? recurrenceEvery,
    ExpenseRecurrenceUnit? recurrenceUnit,
    DateTime? startDate,
  }) {
    final params = <String, dynamic>{
      'p_description': description,
    };
    if (startDate != null) {
      params['p_start_date'] = _dateFormatter.format(startDate);
    }
    _putIfPresent(params, 'p_home_id', homeId);
    _putIfPresent(params, 'p_expense_id', expenseId);
    _putIfPresent(params, 'p_amount_cents', amountCents);
    _putIfPresent(params, 'p_notes', notes);
    _putIfPresent(params, 'p_evidence_photo_path', evidencePhotoPath);
    _putIfPresent(
      params,
      'p_allocation_target_type',
      allocationTargetType?.wireValue,
    );
    _putIfPresent(params, 'p_split_mode', splitType?.wireValue);
    _putIfNotEmpty(params, 'p_member_ids', memberIds);
    _putIfNotEmpty(
      params,
      'p_splits',
      customSplits?.map((split) => split.toJson()).toList(growable: false),
    );
    _putIfNotEmpty(params, 'p_unit_ids', unitIds);
    _putIfNotEmpty(
      params,
      'p_unit_splits',
      unitSplits?.map((split) => split.toJson()).toList(growable: false),
    );
    _putIfPresent(params, 'p_recurrence_every', recurrenceEvery);
    _putIfPresent(params, 'p_recurrence_unit', recurrenceUnit?.wireValue);
    return params;
  }

  Expense _parseExpense(dynamic response) {
    final payload = _coerceMap(response);
    if (payload != null) {
      return Expense.fromJson(payload);
    }
    throw const ExpenseException(
      ExpenseErrorCode.unknown,
      'Malformed expense payload from Supabase.',
    );
  }

  void _putIfPresent(
    Map<String, dynamic> params,
    String key,
    Object? value,
  ) {
    if (value != null) {
      params[key] = value;
    }
  }

  void _putIfNotEmpty(
    Map<String, dynamic> params,
    String key,
    List<dynamic>? value,
  ) {
    if (value != null && value.isNotEmpty) {
      params[key] = value;
    }
  }
}
