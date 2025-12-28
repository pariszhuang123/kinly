part of 'share_create_form_view.dart';

// ----------------------------------------------------------------------
// Sub-widgets: fields + sections
// ----------------------------------------------------------------------

class _DescriptionField extends StatelessWidget {
  const _DescriptionField({
    required this.controller,
    required this.state,
    required this.showValidation,
  });

  final TextEditingController controller;
  final ShareCreateState state;
  final bool showValidation;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return KinlyTextField(
      controller: controller,
      labelText: s.shareCreateDescriptionLabel,
      hintText: s.shareCreateDescriptionHint,
      errorText:
          showValidation && !state.form.hasValidDescription
              ? s.shareCreateValidationDescription
              : null,
      onChanged:
          (value) => context.read<ShareCreateBloc>().add(
            ShareCreateDescriptionChanged(value),
          ),
    );
  }
}

class _AmountField extends StatelessWidget {
  const _AmountField({
    required this.controller,
    required this.state,
    required this.showValidation,
    required this.locked,
  });

  final TextEditingController controller;
  final ShareCreateState state;
  final bool showValidation;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final requiresAmount =
        state.isEditing ? !state.isAmountLocked : state.form.splitMode != null;

    return KinlyTextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      enabled: !locked,
      labelText: s.shareCreateAmountLabel,
      hintText: s.shareCreateAmountHint,
      errorText:
          showValidation &&
                  requiresAmount &&
                  (state.form.amountCents == null ||
                      state.form.amountCents! <= 0)
              ? s.shareCreateValidationAmount
              : null,
      onChanged:
          (value) => context.read<ShareCreateBloc>().add(
            ShareCreateAmountChanged(value),
          ),
    );
  }
}

class _SplitModeSelector extends StatelessWidget {
  const _SplitModeSelector({required this.state, required this.locked});

  final ShareCreateState state;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;

    final splitMode = state.form.splitMode; // ShareSplitMode?

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(s.shareCreateSplitLabel, style: theme.textTheme.titleMedium),
        SizedBox(height: spacing.sm),
        Opacity(
          opacity: locked ? 0.6 : 1.0,
          child: IgnorePointer(
            ignoring: locked,
            child: KinlyTabBar<ShareSplitMode>(
              tabs: {
                ShareSplitMode.equal: s.shareCreateSplitEqual,
                ShareSplitMode.custom: s.shareCreateSplitCustom,
              },
              selected: splitMode, // nullable
              emptySelectionAllowed: true, // key line
              onChanged: (mode) {
                // mode is ShareSplitMode? (can be null)
                context.read<ShareCreateBloc>().add(
                  ShareCreateSplitModeChanged(mode),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _StartDateField extends StatelessWidget {
  const _StartDateField({required this.state, required this.locked});

  final ShareCreateState state;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;
    final dateLabel = DateFormat.yMMMMd().format(state.form.startDate);
    final now = DateTime.now();
    final firstDate = now.subtract(const Duration(days: 90));
    final lastDate = now.add(const Duration(days: 365));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(s.shareCreateStartLabel, style: theme.textTheme.titleMedium),
        SizedBox(height: spacing.xs),
        KinlyOutlinedButton.text(
          onPressed:
              locked
                  ? null
                  : () async {
                    final picked = await showKinlyDatePicker(
                      context: context,
                      initialDate: state.form.startDate,
                      firstDate: DateTime(
                        firstDate.year,
                        firstDate.month,
                        firstDate.day,
                      ),
                      lastDate: DateTime(
                        lastDate.year,
                        lastDate.month,
                        lastDate.day,
                      ),
                    );
                    if (picked != null && context.mounted) {
                      context.read<ShareCreateBloc>().add(
                        ShareCreateStartDateChanged(picked),
                      );
                    }
                  },
          label: dateLabel,
        ),
      ],
    );
  }
}

class _RecurrenceField extends StatelessWidget {
  const _RecurrenceField({
    required this.state,
    required this.locked,
    required this.recurrenceNeedsSplit,
  });

  final ShareCreateState state;
  final bool locked;
  final bool recurrenceNeedsSplit;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(s.shareCreateRecurrenceLabel, style: theme.textTheme.titleMedium),
        SizedBox(height: spacing.xs),
        Opacity(
          opacity: locked ? 0.6 : 1.0,
          child: IgnorePointer(
            ignoring: locked,
            child: KinlyDropdownField<ExpenseRecurrenceInterval>(
              value: state.form.recurrence,
              items:
                  ExpenseRecurrenceInterval.values
                      .map(
                        (value) => DropdownMenuItem(
                          value: value,
                          child: Text(_recurrenceLabel(context, value)),
                        ),
                      )
                      .toList(),
              onChanged:
                  (value) => context.read<ShareCreateBloc>().add(
                    ShareCreateRecurrenceChanged(value!),
                  ),
            ),
          ),
        ),
        if (recurrenceNeedsSplit)
          Padding(
            padding: EdgeInsets.only(top: spacing.xs),
            child: Text(
              s.shareCreateValidationRecurrenceSplit,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }

  String _recurrenceLabel(
    BuildContext context,
    ExpenseRecurrenceInterval recurrence,
  ) {
    final s = S.of(context);
    switch (recurrence) {
      case ExpenseRecurrenceInterval.none:
        return s.shareCreateRecurrenceNone;
      case ExpenseRecurrenceInterval.weekly:
        return s.shareCreateRecurrenceWeekly;
      case ExpenseRecurrenceInterval.every2Weeks:
        return s.shareCreateRecurrenceEvery2Weeks;
      case ExpenseRecurrenceInterval.monthly:
        return s.shareCreateRecurrenceMonthly;
      case ExpenseRecurrenceInterval.every2Months:
        return s.shareCreateRecurrenceEvery2Months;
      case ExpenseRecurrenceInterval.annual:
        return s.shareCreateRecurrenceAnnual;
    }
  }
}

class _EmptyParticipantsText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return Text(
      s.shareCreateParticipantsEmpty,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class _NotesField extends StatelessWidget {
  const _NotesField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return KinlyTextField(
      controller: controller,
      minLines: 3,
      maxLines: 4,
      labelText: s.shareCreateNotesLabel,
      hintText: s.shareCreateNotesHint,
      onChanged:
          (value) => context.read<ShareCreateBloc>().add(
            ShareCreateNotesChanged(value),
          ),
    );
  }
}

class _PrimaryActionButton extends StatelessWidget {
  const _PrimaryActionButton({
    required this.label,
    required this.shareColors,
    required this.isBusy,
    required this.shouldDisable,
    this.destructive = false,
    required this.onPressed,
  });

  final String label;
  final SectionColors? shareColors;
  final bool isBusy;
  final bool shouldDisable;
  final bool destructive;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final button =
        destructive
            ? KinlyFilledButton.destructiveText(
              fullWidth: true,
              onPressed: shouldDisable ? null : onPressed,
              label: label,
            )
            : KinlyFilledButton.text(
              fullWidth: true,
              onPressed: shouldDisable ? null : onPressed,
              label: label,
            );

    if (!isBusy) return button;

    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(opacity: 0.6, child: button),
        const SizedBox(height: 20, width: 20, child: KinlyLoader(size: 20)),
      ],
    );
  }
}

// ----------------------------------------------------------------------
// Participants section + row
// ----------------------------------------------------------------------

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
    final theme = Theme.of(context);
    final s = S.of(context);
    final splitMode = state.form.splitMode;

    if (splitMode == null) {
      return const SizedBox.shrink();
    }

    if (splitMode == ShareSplitMode.custom) {
      final errorText = _customErrorText(
        s,
        customSummary,
        showValidation,
        theme,
      );

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
          ...state.participants.map((participant) {
            final controller = customControllers[participant.userId]!;
            final isSelected = state.form.selectedParticipantIds.contains(
              participant.userId,
            );
            return _CustomSplitRow(
              participant: participant,
              controller: controller,
              selected: isSelected,
              canToggle: !locked,
              canEditAmount: !locked && isSelected,
              onToggled:
                  locked
                      ? null
                      : (value) => context.read<ShareCreateBloc>().add(
                        ShareCreateParticipantToggled(
                          participant.userId,
                          value,
                        ),
                      ),
              onAmountChanged:
                  locked
                      ? null
                      : (value) => context.read<ShareCreateBloc>().add(
                        ShareCreateCustomAmountChanged(
                          participant.userId,
                          value,
                        ),
                      ),
            );
          }),
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

    // Equal split
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (locked)
          Padding(
            padding: EdgeInsets.only(bottom: spacing.xs),
            child: Text(
              s.shareEditSplitsLocked,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        IgnorePointer(
          ignoring: locked,
          child: Opacity(
            opacity: locked ? 0.6 : 1.0,
            child: KinlySelectableMemberAvatarRow(
              members: state.participants
                  .map(
                    (participant) => HomeMemberSummary(
                      userId: participant.userId,
                      username: participant.displayName,
                      role: participant.isOwner ? 'owner' : 'member',
                      validFrom:
                          DateTime.fromMillisecondsSinceEpoch(0).toLocal(),
                      avatarUrl: participant.avatarUrl,
                    ),
                  )
                  .toList(growable: false),
              selectedMemberIds: state.form.selectedParticipantIds,
              onToggle:
                  (memberId) => context.read<ShareCreateBloc>().add(
                    ShareCreateParticipantToggled(
                      memberId,
                      !state.form.selectedParticipantIds.contains(memberId),
                    ),
                  ),
            ),
          ),
        ),
        if (!locked &&
            showValidation &&
            splitMode == ShareSplitMode.equal &&
            !state.hasEqualSelection)
          Padding(
            padding: EdgeInsets.only(top: spacing.xs),
            child: Text(
              s.shareCreateValidationEqualParticipants,
              style: theme.textTheme.bodySmall?.copyWith(
                color: _validationColor(theme),
              ),
            ),
          ),
      ],
    );
  }

  String? _customErrorText(
    S s,
    ShareCustomSplitSummary summary,
    bool showValidation,
    ThemeData theme,
  ) {
    if (!showValidation) return null;
    if (summary.missingTotal) return s.shareCreateValidationAmount;
    if (summary.hasInvalidAmounts) {
      return s.shareCreateValidationCustomAmounts;
    }
    if (summary.hasInsufficientParticipants) {
      return s.shareCreateValidationCustomParticipants;
    }
    if (!summary.sumMatchesTotal) {
      return s.shareCreateValidationCustomSum;
    }
    if (summary.hasSinglePayer) {
      return s.shareCreateValidationCustomSinglePayer;
    }
    return null;
  }
}

class _CustomSplitRow extends StatelessWidget {
  const _CustomSplitRow({
    required this.participant,
    required this.controller,
    required this.selected,
    required this.canToggle,
    required this.canEditAmount,
    required this.onToggled,
    required this.onAmountChanged,
  });

  final ShareParticipant participant;
  final TextEditingController controller;
  final bool selected;
  final bool canToggle;
  final bool canEditAmount;
  final ValueChanged<bool>? onToggled;
  final ValueChanged<String>? onAmountChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;
    final s = S.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.only(bottom: spacing.sm),
      padding: EdgeInsetsDirectional.all(spacing.sm),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: theme.colorScheme.surfaceContainerHighest,
      ),
      child: Row(
        children: [
          Checkbox(
            value: selected,
            activeColor: colorScheme.primaryContainer,
            checkColor: colorScheme.onPrimaryContainer,
            onChanged:
                canToggle ? (value) => onToggled?.call(value ?? false) : null,
          ),
          KinlyCircleAvatar(
            avatarUrl: participant.avatarUrl,
            radius: 20,
            isOwner: participant.isOwner,
          ),
          SizedBox(width: spacing.sm),
          Expanded(
            child: Text(
              participant.displayName,
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

Color _validationColor(ThemeData theme) {
  final tokens = theme.extension<KinlyColorTokens>();
  final scheme = theme.colorScheme;
  // Use the same high-contrast error color in both themes to keep helper text visible.
  return tokens?.error ?? scheme.error;
}
