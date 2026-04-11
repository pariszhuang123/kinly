part of 'share_create_bloc.dart';

Future<void> _handleParticipantsRequested(
  ShareCreateBloc bloc,
  Emitter<ShareCreateState> emit,
) async {
  emit(bloc.state.copyWith(isLoading: true, clearLoadError: true));
  try {
    final members = await bloc._homeRepository.listActiveMembers(
      bloc._homeId,
      excludeSelf: false,
    );
    final selectableUnits = await bloc._homeUnitsRepository
        .listSelectableExpenseUnits(homeId: bloc._homeId);
    final participants = members
        .map(
          (member) => ShareParticipant(
            membershipId: member.membershipId,
            userId: member.userId,
            displayName: member.username,
            avatarUrl: member.avatarUrl,
            isOwner: member.isOwner,
          ),
        )
        .toList(growable: false);
    final currentUserId = await _resolveCurrentUserId(bloc);
    final nextForm = _buildHydratedForm(
      bloc,
      participants: participants,
      selectableUnits: selectableUnits,
    );

    emit(
      bloc.state.copyWith(
        isLoading: false,
        participants: participants,
        selectableUnits: selectableUnits,
        currentUserId: currentUserId,
        form: nextForm,
        clearLoadError: true,
      ),
    );
  } catch (error) {
    emit(
      bloc.state.copyWith(isLoading: false, loadErrorMessage: error.toString()),
    );
  }
}

Future<String?> _resolveCurrentUserId(ShareCreateBloc bloc) async {
  final currentUserId = bloc.state.currentUserId;
  if (currentUserId != null) {
    return currentUserId;
  }
  try {
    return (await bloc._homeRepository.getCurrentMembership())?.userId;
  } catch (_) {
    return null;
  }
}

ShareCreateForm _buildHydratedForm(
  ShareCreateBloc bloc, {
  required List<ShareParticipant> participants,
  required List<HomeUnitSummary> selectableUnits,
}) {
  final availableIds = participants.map((p) => p.userId).toList(growable: false);
  final nextSelection = _resolveHydratedParticipantSelection(bloc, availableIds);
  final filteredAmounts = Map.fromEntries(
    bloc.state.form.customAmountInputs.entries.where(
      (entry) => availableIds.contains(entry.key),
    ),
  );
  return bloc.state.form.copyWith(
    selectedParticipantIds: nextSelection,
    customAmountInputs: filteredAmounts,
    selectedUnitIds: _resolveHydratedUnitSelection(bloc, selectableUnits),
  );
}

Set<String> _resolveHydratedParticipantSelection(
  ShareCreateBloc bloc,
  List<String> availableIds,
) {
  final nextSelection = bloc.state.form.selectedParticipantIds
      .where((id) => availableIds.contains(id))
      .toSet();
  if (nextSelection.isNotEmpty ||
      availableIds.isEmpty ||
      bloc.state.form.splitMode == ShareSplitMode.custom) {
    return nextSelection;
  }
  return LinkedHashSet<String>.from(availableIds);
}

Set<String> _resolveHydratedUnitSelection(
  ShareCreateBloc bloc,
  List<HomeUnitSummary> selectableUnits,
) {
  final shouldSelectAll =
      bloc.state.form.selectedUnitIds.isEmpty &&
      selectableUnits.isNotEmpty &&
      bloc.state.form.allocationTargetType ==
          ExpenseAllocationTargetType.unitBased &&
      bloc.state.form.splitMode != ShareSplitMode.custom;
  if (!shouldSelectAll) {
    return bloc.state.form.selectedUnitIds;
  }
  return selectableUnits.map((unit) => unit.unitId).toSet();
}

ShareCreateForm _resolveAllocationTargetForm(
  ShareCreateBloc bloc,
  ExpenseAllocationTargetType value,
) {
  var nextForm = bloc.state.form.copyWith(allocationTargetType: value);
  final shouldSelectAllUnits =
      value == ExpenseAllocationTargetType.unitBased &&
      nextForm.selectedUnitIds.isEmpty &&
      bloc.state.selectableUnits.isNotEmpty &&
      nextForm.splitMode != ShareSplitMode.custom;
  if (shouldSelectAllUnits) {
    nextForm = nextForm.selectAllUnits(
      bloc.state.selectableUnits.map((unit) => unit.unitId),
    );
  }
  return nextForm;
}

ShareCreateForm _resolveSplitModeForm(
  ShareCreateBloc bloc,
  ShareSplitMode? mode,
) {
  final nextForm = bloc.state.form.copyWith(
    splitMode: mode,
    clearRecurrenceEvery: mode == null,
    clearRecurrenceUnit: mode == null,
  );
  if (mode == ShareSplitMode.equal) {
    return _applyEqualSplitSelection(bloc, nextForm);
  }
  if (mode == ShareSplitMode.custom) {
    return _applyCustomSplitSelection(bloc, nextForm);
  }
  return nextForm;
}

ShareCreateForm _applyEqualSplitSelection(
  ShareCreateBloc bloc,
  ShareCreateForm form,
) {
  if (form.allocationTargetType == ExpenseAllocationTargetType.unitBased) {
    if (form.selectedUnitIds.isNotEmpty || bloc.state.selectableUnits.isEmpty) {
      return form;
    }
    return form.copyWith(selectedUnitIds: _allUnitIds(bloc));
  }
  if (form.selectedParticipantIds.isNotEmpty || bloc.state.participants.isEmpty) {
    return form;
  }
  return form.copyWith(selectedParticipantIds: _allParticipantIds(bloc));
}

ShareCreateForm _applyCustomSplitSelection(
  ShareCreateBloc bloc,
  ShareCreateForm form,
) {
  if (form.allocationTargetType == ExpenseAllocationTargetType.unitBased) {
    final idsWithAmount = _selectedUnitIdsWithAmount(form);
    if (idsWithAmount.isNotEmpty) {
      return form.copyWith(selectedUnitIds: idsWithAmount);
    }
    if (form.selectedUnitIds.isNotEmpty || bloc.state.selectableUnits.isEmpty) {
      return form;
    }
    return form.copyWith(selectedUnitIds: _allUnitIds(bloc));
  }
  final idsWithAmount = _selectedParticipantIdsWithAmount(form);
  if (idsWithAmount.isNotEmpty) {
    return form.copyWith(selectedParticipantIds: idsWithAmount);
  }
  if (form.selectedParticipantIds.isNotEmpty || bloc.state.participants.isEmpty) {
    return form;
  }
  return form.copyWith(selectedParticipantIds: _allParticipantIds(bloc));
}

LinkedHashSet<String> _selectedParticipantIdsWithAmount(ShareCreateForm form) {
  return LinkedHashSet<String>.from(
    form.customAmountInputs.entries
        .where(_hasPositiveCustomAmount)
        .map((entry) => entry.key),
  );
}

LinkedHashSet<String> _selectedUnitIdsWithAmount(ShareCreateForm form) {
  return LinkedHashSet<String>.from(
    form.unitCustomAmountInputs.entries
        .where(_hasPositiveCustomAmount)
        .map((entry) => entry.key),
  );
}

bool _hasPositiveCustomAmount(MapEntry<String, String> entry) {
  final cents = ShareCreateForm.parseCurrency(entry.value);
  return cents != null && cents > 0;
}

LinkedHashSet<String> _allParticipantIds(ShareCreateBloc bloc) {
  return LinkedHashSet<String>.from(
    bloc.state.participants.map((participant) => participant.userId),
  );
}

LinkedHashSet<String> _allUnitIds(ShareCreateBloc bloc) {
  return LinkedHashSet<String>.from(
    bloc.state.selectableUnits.map((unit) => unit.unitId),
  );
}
