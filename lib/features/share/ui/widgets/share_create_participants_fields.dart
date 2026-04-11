part of 'share_create_form_view.dart';

class _ParticipantsSection extends StatelessWidget {
  const _ParticipantsSection({
    required this.state,
    required this.shareColors,
    required this.spacing,
    required this.customSummary,
    required this.showValidation,
    required this.locked,
    required this.customControllers,
  });

  final ShareCreateState state;
  final SectionColors? shareColors;
  final Spacing spacing;
  final ShareCustomSplitSummary customSummary;
  final bool showValidation;
  final bool locked;
  final Map<String, TextEditingController> customControllers;

  @override
  Widget build(BuildContext context) {
    final splitMode = state.form.splitMode;
    if (splitMode == null) {
      return const SizedBox.shrink();
    }
    if (splitMode == ShareSplitMode.custom) {
      return _buildCustomSplit(context);
    }
    return _buildEqualSplit(context);
  }

  Widget _buildCustomSplit(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final s = S.of(context);
    final errorText = _customErrorText(s, customSummary, showValidation);
    final rows =
        _usesUnits
            ? _buildUnitCustomRows(context)
            : _buildParticipantCustomRows(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          s.shareCreateCustomHelper,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: spacing.sm),
        ...rows,
        if (errorText != null)
          Padding(
            padding: EdgeInsets.only(top: spacing.xs),
            child: Text(
              errorText,
              style: theme.textTheme.bodySmall?.copyWith(
                color: _validationColor(theme),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildEqualSplit(BuildContext context) {
    final children = <Widget>[
      if (locked) _buildLockedHint(context),
      _usesUnits
          ? _buildUnitEqualRows(context)
          : _buildMemberEqualRows(context),
    ];
    final theme = KinlyThemeAccess.of(context);
    final errorText = _equalSplitErrorText(S.of(context));
    if (errorText != null) {
      children.add(
        Padding(
          padding: EdgeInsets.only(top: spacing.xs),
          child: Text(
            errorText,
            style: theme.textTheme.bodySmall?.copyWith(
              color: _validationColor(theme),
            ),
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Widget _buildLockedHint(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: spacing.xs),
      child: Text(
        S.of(context).shareEditSplitsLocked,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  List<Widget> _buildUnitCustomRows(BuildContext context) {
    return state.selectableUnits
        .map((unit) => _buildUnitCustomRow(context, unit))
        .toList(growable: false);
  }

  Widget _buildUnitCustomRow(BuildContext context, HomeUnitSummary unit) {
    final controller = customControllers[unit.unitId]!;
    final isSelected = state.form.selectedUnitIds.contains(unit.unitId);
    return _CustomSplitRow(
      label: unit.name,
      avatarUrl: null,
      isOwner: false,
      controller: controller,
      selected: isSelected,
      canToggle: !locked,
      canEditAmount: !locked,
      onToggled: locked ? null : _onUnitToggled(context, unit.unitId),
      onAmountChanged:
          locked ? null : _onUnitCustomAmountChanged(context, unit.unitId),
    );
  }

  List<Widget> _buildParticipantCustomRows(BuildContext context) {
    return state.participants
        .map((participant) => _buildParticipantCustomRow(context, participant))
        .toList(growable: false);
  }

  Widget _buildParticipantCustomRow(
    BuildContext context,
    dynamic participant,
  ) {
    final controller = customControllers[participant.userId]!;
    final isSelected = state.form.selectedParticipantIds.contains(
      participant.userId,
    );
    return _CustomSplitRow(
      label: participant.displayName,
      avatarUrl: participant.avatarUrl,
      isOwner: participant.isOwner,
      controller: controller,
      selected: isSelected,
      canToggle: !locked,
      canEditAmount: !locked,
      onToggled:
          locked ? null : _onParticipantToggled(context, participant.userId),
      onAmountChanged:
          locked
              ? null
              : _onParticipantAmountChanged(context, participant.userId),
    );
  }

  Widget _buildUnitEqualRows(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    return Column(
      children: state.selectableUnits
          .map((unit) => _buildUnitEqualRow(context, theme, unit))
          .toList(growable: false),
    );
  }

  Widget _buildUnitEqualRow(
    BuildContext context,
    dynamic theme,
    HomeUnitSummary unit,
  ) {
    final isSelected = state.form.selectedUnitIds.contains(unit.unitId);
    return Container(
      margin: EdgeInsets.only(bottom: spacing.sm),
      padding: EdgeInsetsDirectional.all(spacing.sm),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: theme.colorScheme.surfaceContainerHighest,
      ),
      child: Row(
        children: [
          KinlyCheckbox(
            value: isSelected,
            onChanged: locked ? null : _onUnitToggled(context, unit.unitId),
          ),
          SizedBox(width: spacing.sm),
          Expanded(
            child: Text(unit.name, style: theme.textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberEqualRows(BuildContext context) {
    return IgnorePointer(
      ignoring: locked,
      child: Opacity(
        opacity: locked ? 0.6 : 1.0,
        child: KinlySelectableMemberAvatarRow(
          members: state.participants
              .map<HomeMemberSummary>(
                (participant) => _toHomeMemberSummary(participant),
              )
              .toList(growable: false),
          selectedMemberIds: state.form.selectedParticipantIds,
          onToggle: (memberId) {
            context.read<ShareCreateBloc>().add(
              ShareCreateParticipantToggled(
                memberId,
                !state.form.selectedParticipantIds.contains(memberId),
              ),
            );
          },
        ),
      ),
    );
  }

  HomeMemberSummary _toHomeMemberSummary(dynamic participant) {
    return HomeMemberSummary(
      membershipId: participant.membershipId,
      userId: participant.userId,
      username: participant.displayName,
      role: participant.isOwner ? 'owner' : 'member',
      validFrom: DateTime.fromMillisecondsSinceEpoch(0).toLocal(),
      avatarUrl: participant.avatarUrl,
      isOwner: participant.isOwner,
    );
  }

  String? _equalSplitErrorText(S s) {
    if (locked || !showValidation || state.form.splitMode != ShareSplitMode.equal) {
      return null;
    }
    if (_usesUnits) {
      return state.hasEqualUnitSelection
          ? null
          : s.shareCreateValidationEqualParticipants;
    }
    if (state.hasEqualSinglePayer) {
      return s.shareCreateValidationCustomSinglePayer;
    }
    if (!state.hasEqualSelection) {
      return s.shareCreateValidationEqualParticipants;
    }
    return null;
  }

  bool get _usesUnits =>
      state.form.allocationTargetType == ExpenseAllocationTargetType.unitBased;

  ValueChanged<bool> _onUnitToggled(BuildContext context, String unitId) {
    return (value) => context.read<ShareCreateBloc>().add(
      ShareCreateUnitToggled(unitId, value),
    );
  }

  ValueChanged<String> _onUnitCustomAmountChanged(
    BuildContext context,
    String unitId,
  ) {
    return (value) => context.read<ShareCreateBloc>().add(
      ShareCreateUnitCustomAmountChanged(unitId, value),
    );
  }

  ValueChanged<bool> _onParticipantToggled(
    BuildContext context,
    String userId,
  ) {
    return (value) => context.read<ShareCreateBloc>().add(
      ShareCreateParticipantToggled(userId, value),
    );
  }

  ValueChanged<String> _onParticipantAmountChanged(
    BuildContext context,
    String userId,
  ) {
    return (value) => context.read<ShareCreateBloc>().add(
      ShareCreateCustomAmountChanged(userId, value),
    );
  }

  String? _customErrorText(
    S s,
    ShareCustomSplitSummary summary,
    bool showValidation,
  ) {
    if (!showValidation) return null;
    if (summary.missingTotal) return s.shareCreateValidationAmount;
    if (summary.hasInvalidAmounts) {
      return s.shareCreateValidationCustomAmounts;
    }
    if (summary.hasInsufficientParticipants) {
      return s.shareCreateValidationCustomParticipants;
    }
    if (summary.hasSinglePayer) {
      return s.shareCreateValidationCustomSinglePayer;
    }
    if (!summary.sumMatchesTotal) {
      return buildShareCreateSplitMismatchMessage(strings: s, state: state);
    }
    return null;
  }
}

class _CustomSplitRow extends StatelessWidget {
  const _CustomSplitRow({
    required this.label,
    required this.avatarUrl,
    required this.isOwner,
    required this.controller,
    required this.selected,
    required this.canToggle,
    required this.canEditAmount,
    required this.onToggled,
    required this.onAmountChanged,
  });

  final String label;
  final String? avatarUrl;
  final bool isOwner;
  final TextEditingController controller;
  final bool selected;
  final bool canToggle;
  final bool canEditAmount;
  final ValueChanged<bool>? onToggled;
  final ValueChanged<String>? onAmountChanged;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final s = S.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: spacing.sm),
      padding: EdgeInsetsDirectional.all(spacing.sm),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: theme.colorScheme.surfaceContainerHighest,
      ),
      child: Row(
        children: [
          IgnorePointer(
            ignoring: !canToggle,
            child: Opacity(
              opacity: canToggle ? 1.0 : 0.6,
              child: KinlyCheckbox(
                value: selected,
                onChanged: (value) => onToggled?.call(value),
              ),
            ),
          ),
          KinlyCircleAvatar(
            avatarUrl: avatarUrl,
            radius: 20,
            isOwner: isOwner,
          ),
          SizedBox(width: spacing.sm),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyLarge,
            ),
          ),
          SizedBox(
            width: 110,
            child: KinlyTextField(
              controller: controller,
              enabled: canEditAmount,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              labelText: s.shareCreateCustomAmountLabel,
              onChanged: onAmountChanged,
            ),
          ),
        ],
      ),
    );
  }
}

Color _validationColor(dynamic theme) {
  final tokens = theme.extension<KinlyColorTokens>();
  final scheme = theme.colorScheme;
  // Use the same high-contrast error color in both themes to keep helper text visible.
  return tokens?.error ?? scheme.error;
}
