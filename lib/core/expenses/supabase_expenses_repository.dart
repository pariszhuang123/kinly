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

  Map<String, dynamic>? _coerceMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return value.cast<String, dynamic>();
    return null;
  }
}
