import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:kinly/contracts/expenses/models.dart';

import 'share_split_mode.dart';
import '../../../core/time/date_only.dart';

class ShareCreateForm extends Equatable {
  ShareCreateForm({
    required this.description,
    required this.amountInput,
    required this.notes,
    required this.allocationTargetType,
    required this.splitMode,
    required Set<String> selectedParticipantIds,
    required Map<String, String> customAmountInputs,
    required Set<String> selectedUnitIds,
    required Map<String, String> unitCustomAmountInputs,
    required this.recurrenceEvery,
    required this.recurrenceUnit,
    required this.startDate,
    this.evidencePhotoPath = '',
  }) : selectedParticipantIds = Set.unmodifiable(
         selectedParticipantIds is LinkedHashSet<String>
             ? selectedParticipantIds
             : LinkedHashSet<String>.from(selectedParticipantIds),
       ),
       customAmountInputs = Map.unmodifiable(
         Map<String, String>.from(customAmountInputs),
       ),
       selectedUnitIds = Set.unmodifiable(
         selectedUnitIds is LinkedHashSet<String>
             ? selectedUnitIds
             : LinkedHashSet<String>.from(selectedUnitIds),
       ),
       unitCustomAmountInputs = Map.unmodifiable(
         Map<String, String>.from(unitCustomAmountInputs),
       );

  factory ShareCreateForm.initial() {
    return ShareCreateForm(
      description: '',
      amountInput: '',
      notes: '',
      allocationTargetType: ExpenseAllocationTargetType.debtorBased,
      splitMode: null,
      selectedParticipantIds: const <String>{},
      customAmountInputs: const <String, String>{},
      selectedUnitIds: const <String>{},
      unitCustomAmountInputs: const <String, String>{},
      recurrenceEvery: null,
      recurrenceUnit: null,
      startDate: dateOnly(DateTime.now()),
      evidencePhotoPath: '',
    );
  }

  final String description;
  final String amountInput;
  final String notes;
  final ExpenseAllocationTargetType allocationTargetType;
  final ShareSplitMode? splitMode;
  final Set<String> selectedParticipantIds;
  final Map<String, String> customAmountInputs;
  final Set<String> selectedUnitIds;
  final Map<String, String> unitCustomAmountInputs;
  final int? recurrenceEvery;
  final ExpenseRecurrenceUnit? recurrenceUnit;
  final DateTime startDate;
  final String evidencePhotoPath;

  ShareCreateForm copyWith({
    String? description,
    String? amountInput,
    String? notes,
    ExpenseAllocationTargetType? allocationTargetType,
    ShareSplitMode? splitMode,
    bool clearSplitMode = false,
    Set<String>? selectedParticipantIds,
    Map<String, String>? customAmountInputs,
    Set<String>? selectedUnitIds,
    Map<String, String>? unitCustomAmountInputs,
    int? recurrenceEvery,
    bool clearRecurrenceEvery = false,
    ExpenseRecurrenceUnit? recurrenceUnit,
    bool clearRecurrenceUnit = false,
    DateTime? startDate,
    String? evidencePhotoPath,
  }) {
    return ShareCreateForm(
      description: description ?? this.description,
      amountInput: amountInput ?? this.amountInput,
      notes: notes ?? this.notes,
      allocationTargetType: allocationTargetType ?? this.allocationTargetType,
      splitMode: clearSplitMode ? null : splitMode ?? this.splitMode,
      selectedParticipantIds:
          selectedParticipantIds != null
              ? LinkedHashSet<String>.from(selectedParticipantIds)
              : this.selectedParticipantIds,
      customAmountInputs: customAmountInputs ?? this.customAmountInputs,
      selectedUnitIds:
          selectedUnitIds != null
              ? LinkedHashSet<String>.from(selectedUnitIds)
              : this.selectedUnitIds,
      unitCustomAmountInputs:
          unitCustomAmountInputs ?? this.unitCustomAmountInputs,
      recurrenceEvery:
          clearRecurrenceEvery ? null : recurrenceEvery ?? this.recurrenceEvery,
      recurrenceUnit:
          clearRecurrenceUnit ? null : recurrenceUnit ?? this.recurrenceUnit,
      startDate: startDate != null ? dateOnly(startDate) : this.startDate,
      evidencePhotoPath: evidencePhotoPath ?? this.evidencePhotoPath,
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

  ShareCreateForm updateUnitSelection(String unitId, bool isSelected) {
    final current = LinkedHashSet<String>.from(selectedUnitIds);
    if (isSelected) {
      current.add(unitId);
    } else {
      current.remove(unitId);
    }
    return copyWith(selectedUnitIds: current);
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

  ShareCreateForm updateUnitCustomAmount(String unitId, String amount) {
    final next = Map<String, String>.from(unitCustomAmountInputs);
    if (amount.isEmpty) {
      next.remove(unitId);
    } else {
      next[unitId] = amount;
    }
    return copyWith(unitCustomAmountInputs: next);
  }

  ShareCreateForm selectAll(Iterable<String> participantIds) {
    return copyWith(
      selectedParticipantIds: LinkedHashSet<String>.from(participantIds),
    );
  }

  ShareCreateForm selectAllUnits(Iterable<String> unitIds) {
    return copyWith(selectedUnitIds: LinkedHashSet<String>.from(unitIds));
  }

  bool get isRecurring => recurrenceEvery != null && recurrenceUnit != null;

  String customAmountFor(String userId) => customAmountInputs[userId] ?? '';

  String unitCustomAmountFor(String unitId) => unitCustomAmountInputs[unitId] ?? '';

  @override
  List<Object?> get props {
    final selection = selectedParticipantIds.toList()..sort();
    final customEntries =
        customAmountInputs.entries.toList()
          ..sort((a, b) => a.key.compareTo(b.key));
    final unitSelection = selectedUnitIds.toList()..sort();
    final unitCustomEntries =
        unitCustomAmountInputs.entries.toList()
          ..sort((a, b) => a.key.compareTo(b.key));
    return [
      description,
      amountInput,
      notes,
      allocationTargetType,
      splitMode,
      selection,
      customEntries,
      unitSelection,
      unitCustomEntries,
      recurrenceEvery,
      recurrenceUnit,
      startDate,
      evidencePhotoPath,
    ];
  }
}
