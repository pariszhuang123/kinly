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
    final theme = KinlyThemeAccess.of(context);
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
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final dateLabel = DateFormat.yMMMMd().format(state.form.startDate);
    final today = todayDateOnly();
    final firstDate = today.subtract(const Duration(days: 90));
    final lastDate = today.add(const Duration(days: 365));

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
                    final picked = await showKinlyDateOnlyPicker(
                      context: context,
                      initialDate: dateOnly(state.form.startDate),
                      firstDate: firstDate,
                      lastDate: lastDate,
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
    required this.recurrenceInvalid,
    required this.controller,
  });

  final ShareCreateState state;
  final bool locked;
  final bool recurrenceNeedsSplit;
  final bool recurrenceInvalid;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final isRecurring = state.form.isRecurring;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(s.shareCreateRecurrenceLabel, style: theme.textTheme.titleMedium),
        SizedBox(height: spacing.xs),
        Opacity(
          opacity: locked ? 0.6 : 1.0,
          child: IgnorePointer(
            ignoring: locked,
            child: Row(
              children: [
                KinlyCheckbox(
                  value: isRecurring,
                  onChanged:
                      (value) => context.read<ShareCreateBloc>().add(
                        ShareCreateRecurrenceToggled(value ?? false),
                      ),
                ),
                SizedBox(width: spacing.xs),
                Text(s.shareCreateRecurrenceToggleLabel),
              ],
            ),
          ),
        ),
        if (isRecurring) ...[
          SizedBox(height: spacing.xs),
          Opacity(
            opacity: locked ? 0.6 : 1.0,
            child: IgnorePointer(
              ignoring: locked,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.shareCreateRecurrenceEveryLabel),
                  SizedBox(width: spacing.sm),
                  SizedBox(
                    width: 72,
                    child: KinlyTextField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged:
                          (value) => context.read<ShareCreateBloc>().add(
                            ShareCreateRecurrenceEveryChanged(value),
                          ),
                      errorText:
                          recurrenceInvalid
                              ? s.shareCreateValidationRecurrence
                              : null,
                    ),
                  ),
                  SizedBox(width: spacing.sm),
                  Expanded(
                    child: KinlyDropdownField<ExpenseRecurrenceUnit>(
                      value: state.form.recurrenceUnit,
                      items:
                          ExpenseRecurrenceUnit.values
                              .map(
                                (value) => KinlyDropdownMenuItem.item(
                                  value: value,
                                  child: Text(_recurrenceUnitLabel(context, value)),
                                ),
                              )
                              .toList(),
                      onChanged:
                          (value) => context.read<ShareCreateBloc>().add(
                            ShareCreateRecurrenceUnitChanged(value!),
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        if (recurrenceNeedsSplit || recurrenceInvalid)
          Padding(
            padding: EdgeInsets.only(top: spacing.xs),
            child: Text(
              recurrenceNeedsSplit
                  ? s.shareCreateValidationRecurrenceSplit
                  : s.shareCreateValidationRecurrence,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }

  String _recurrenceUnitLabel(
    BuildContext context,
    ExpenseRecurrenceUnit unit,
  ) {
    final s = S.of(context);
    switch (unit) {
      case ExpenseRecurrenceUnit.day:
        return s.shareCreateRecurrenceUnitDay;
      case ExpenseRecurrenceUnit.week:
        return s.shareCreateRecurrenceUnitWeek;
      case ExpenseRecurrenceUnit.month:
        return s.shareCreateRecurrenceUnitMonth;
      case ExpenseRecurrenceUnit.year:
        return s.shareCreateRecurrenceUnitYear;
    }
  }
}

class _EmptyParticipantsText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = KinlyThemeAccess.of(context);

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

