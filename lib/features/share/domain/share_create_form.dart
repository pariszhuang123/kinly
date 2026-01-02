import 'dart:collection';

import 'package:equatable/equatable.dart';

import 'share_split_mode.dart';
import '../../../contracts/expenses/enums/expense_recurrence_interval.dart';
import '../../../core/time/date_only.dart';

class ShareCreateForm extends Equatable {
  ShareCreateForm({
    required this.description,
    required this.amountInput,
    required this.notes,
    required this.splitMode,
    required Set<String> selectedParticipantIds,
    required Map<String, String> customAmountInputs,
    required this.recurrence,
    required this.startDate,
  }) : selectedParticipantIds = Set.unmodifiable(
         selectedParticipantIds is LinkedHashSet<String>
             ? selectedParticipantIds
             : LinkedHashSet<String>.from(selectedParticipantIds),
       ),
       customAmountInputs = Map.unmodifiable(
         Map<String, String>.from(customAmountInputs),
       );

  factory ShareCreateForm.initial() {
    return ShareCreateForm(
      description: '',
      amountInput: '',
      notes: '',
      splitMode: null,
      selectedParticipantIds: const <String>{},
      customAmountInputs: const <String, String>{},
      recurrence: ExpenseRecurrenceInterval.none,
      startDate: dateOnly(DateTime.now()),
    );
  }

  final String description;
  final String amountInput;
  final String notes;
  final ShareSplitMode? splitMode;
  final Set<String> selectedParticipantIds;
  final Map<String, String> customAmountInputs;
  final ExpenseRecurrenceInterval recurrence;
  final DateTime startDate;

  ShareCreateForm copyWith({
    String? description,
    String? amountInput,
    String? notes,
    ShareSplitMode? splitMode,
    bool clearSplitMode = false,
    Set<String>? selectedParticipantIds,
    Map<String, String>? customAmountInputs,
    ExpenseRecurrenceInterval? recurrence,
    DateTime? startDate,
  }) {
    return ShareCreateForm(
      description: description ?? this.description,
      amountInput: amountInput ?? this.amountInput,
      notes: notes ?? this.notes,
      splitMode: clearSplitMode ? null : splitMode ?? this.splitMode,
      selectedParticipantIds:
          selectedParticipantIds != null
              ? LinkedHashSet<String>.from(selectedParticipantIds)
              : this.selectedParticipantIds,
      customAmountInputs: customAmountInputs ?? this.customAmountInputs,
      recurrence: recurrence ?? this.recurrence,
      startDate: startDate != null ? dateOnly(startDate) : this.startDate,
    );
  }

  bool get hasValidDescription => description.trim().isNotEmpty;

  int? get amountCents => parseCurrency(amountInput);

  static int? parseCurrency(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return null;
    final sanitized = trimmed.replaceAll(',', '');
    final match = RegExp(r'^\d+(\.\d{0,2})?$');
    if (!match.hasMatch(sanitized)) return null;
    final parts = sanitized.split('.');
    final whole = int.parse(parts[0]);
    var cents = 0;
    if (parts.length > 1) {
      final decimals = parts[1].padRight(2, '0');
      cents = int.parse(decimals.substring(0, 2));
    }
    return whole * 100 + cents;
  }

  ShareCreateForm updateSelection(String userId, bool isSelected) {
    final current = LinkedHashSet<String>.from(selectedParticipantIds);
    if (isSelected) {
      current.add(userId);
    } else {
      current.remove(userId);
    }
    return copyWith(selectedParticipantIds: current);
  }

  ShareCreateForm updateCustomAmount(String userId, String amount) {
    final next = Map<String, String>.from(customAmountInputs);
    if (amount.isEmpty) {
      next.remove(userId);
    } else {
      next[userId] = amount;
    }
    return copyWith(customAmountInputs: next);
  }

  ShareCreateForm selectAll(Iterable<String> participantIds) {
    return copyWith(
      selectedParticipantIds: LinkedHashSet<String>.from(participantIds),
    );
  }

  bool get isRecurring => recurrence != ExpenseRecurrenceInterval.none;

  String customAmountFor(String userId) => customAmountInputs[userId] ?? '';

  @override
  List<Object?> get props {
    final selection = selectedParticipantIds.toList()..sort();
    final customEntries =
        customAmountInputs.entries.toList()
          ..sort((a, b) => a.key.compareTo(b.key));
    return [
      description,
      amountInput,
      notes,
      splitMode,
      selection,
      customEntries,
      recurrence,
      startDate,
    ];
  }

}
