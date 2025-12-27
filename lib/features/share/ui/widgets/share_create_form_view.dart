import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/kinly_sections.dart';
import '../../../../../core/theme/spacing.dart';
import '../../../../../core/ui/kinly_circle_avatar.dart';
import '../../../../../core/ui/kinly_loader.dart';
import '../../../../../core/ui/buttons/kinly_filled_button.dart';
import '../../../../../core/ui/buttons/kinly_outlined_button.dart';
import '../../../../../core/ui/inputs/kinly_dropdown_field.dart';
import '../../../../../core/ui/inputs/kinly_text_field.dart';
import '../../../../../core/ui/kinly_date_picker.dart';
import '../../../../../core/ui/kinly_tab_bar.dart';
import '../../../../../core/ui/members/kinly_selectable_member_avatar_row.dart';
import '../../../../../core/ui/feedback/kinly_info_banner.dart';
import '../../../../../core/ui/enums/kinly_banner_type.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../core/theme/color_tokens.dart';
import '../../../../../core/homes/models.dart';
import '../../../../../core/expenses/enums/expense_recurrence_interval.dart';
import '../../domain/share_participant.dart';
import '../../domain/share_split_mode.dart';
import '../../bloc/share_create_bloc/share_create_bloc.dart';

class ShareCreateFormView extends StatelessWidget {
  const ShareCreateFormView({
    super.key,
    required this.state,
    required this.shareColors,
    required this.descriptionController,
    required this.amountController,
    required this.notesController,
    required this.customControllers,
    required this.allowDelete,
    required this.onDeleteRequested,
    this.showTerminatePlan = false,
    this.isTerminatingPlan = false,
    this.onTerminatePlan,
    this.showPrimaryActions = true,
  });

  final ShareCreateState state;
  final SectionColors? shareColors;
  final TextEditingController descriptionController;
  final TextEditingController amountController;
  final TextEditingController notesController;
  final Map<String, TextEditingController> customControllers;

  /// Whether delete is allowed at all for this screen.
  final bool allowDelete;

  /// Callback to trigger delete (shows confirm dialog + dispatches event).
  final VoidCallback? onDeleteRequested;
  final bool showTerminatePlan;
  final bool isTerminatingPlan;
  final VoidCallback? onTerminatePlan;
  final bool showPrimaryActions;

  String _mapEditDisabledReason(BuildContext context, String code) {
    final s = S.of(context);
    switch (code) {
      case 'CONVERTED_TO_PLAN':
        return s.shareEditDisabledConverted;
      case 'RECURRING_CYCLE_IMMUTABLE':
        return s.shareEditDisabledRecurringCycle;
      case 'ACTIVE_IMMUTABLE':
        return s.shareEditDisabledActive;
      default:
        return s.shareEditDisabledGeneric;
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;
    final showValidation = state.showValidationErrors;
    final customSummary = state.evaluateCustomSplit();
    final editingDisabled = state.isEditing && !state.canEdit;
    final locked = state.isAmountLocked || editingDisabled;
    final fullyPaid = state.allPaid;
    final deleteBlocked = state.paidByOther || locked || fullyPaid;
    final recurrenceNeedsSplit =
        showValidation &&
        state.form.recurrence != ExpenseRecurrenceInterval.none &&
        state.form.splitMode == null;

    // ------------------------------------------------------------------
    // Primary button behaviour:
    // - Create mode: always "Create"
    // - Edit, pristine, allowDelete: "Delete"
    // - Edit, dirty: "Update"
    // ------------------------------------------------------------------
    final isEditing = state.isEditing;
    final isPristineEdit = isEditing && !state.hasUserEdits;
    final canDelete =
        allowDelete && isPristineEdit && !deleteBlocked && !editingDisabled;
    final isDeleteAction = canDelete;
    final hidePrimary = fullyPaid || editingDisabled;

    final String primaryLabel;
    if (!isEditing) {
      primaryLabel = s.shareCreateSubmit;
    } else if (canDelete) {
      primaryLabel = s.shareEditDeleteButton;
    } else {
      primaryLabel = s.shareEditSubmit;
    }

    final bool shouldDisable =
        state.isSubmitting ||
        state.isDeleting ||
        editingDisabled ||
        // Only require splitMode when doing create/update.
        (!canDelete && isEditing && state.form.splitMode == null);

    final periodLabel = _formattedPeriod();

    void handlePrimaryPressed() {
      if (shouldDisable) return;
      if (canDelete) {
        onDeleteRequested?.call();
      } else {
        context.read<ShareCreateBloc>().add(const ShareCreateSubmitted());
      }
    }

    return ListView(
      padding: EdgeInsetsDirectional.only(bottom: spacing.lg),
      children: [
        SizedBox(height: spacing.lg),
        if (editingDisabled && state.editDisabledReason != null)
          Padding(
            padding: EdgeInsets.only(bottom: spacing.md),
            child: KinlyInfoBanner(
              message:
                  _mapEditDisabledReason(context, state.editDisabledReason!),
              type: KinlyBannerType.warning,
            ),
          ),
        _DescriptionField(
          controller: descriptionController,
          state: state,
          showValidation: showValidation,
        ),
        SizedBox(height: spacing.lg),
        _AmountField(
          controller: amountController,
          state: state,
          showValidation: showValidation,
          locked: locked,
        ),
        SizedBox(height: spacing.lg),
        _StartDateField(
          state: state,
          locked: locked,
        ),
        if (periodLabel != null) ...[
          SizedBox(height: spacing.xs),
          Text(
            s.shareCreateCyclePeriod(periodLabel),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        SizedBox(height: spacing.lg),
        _RecurrenceField(
          state: state,
          locked: locked,
          recurrenceNeedsSplit: recurrenceNeedsSplit,
        ),
        SizedBox(height: spacing.lg),
        _SplitModeSelector(state: state, locked: locked),
        SizedBox(height: spacing.lg),
        if (state.participants.isEmpty)
          _EmptyParticipantsText()
        else
          _ParticipantsSection(
            state: state,
            shareColors: shareColors,
            spacing: spacing,
            customSummary: customSummary,
            showValidation: showValidation,
            locked: locked,
            customControllers: customControllers,
          ),
        SizedBox(height: spacing.lg),
        _NotesField(controller: notesController),
        SizedBox(height: spacing.xl),
        if (showPrimaryActions && !hidePrimary)
          _PrimaryActionButton(
            label: primaryLabel,
            shareColors: shareColors,
            isBusy: state.isSubmitting || state.isDeleting,
            shouldDisable: shouldDisable,
            destructive: isDeleteAction,
            onPressed: handlePrimaryPressed,
          ),
        if (showTerminatePlan) ...[
          SizedBox(height: spacing.md),
          KinlyFilledButton.destructiveText(
            fullWidth: true,
            onPressed: isTerminatingPlan ? null : onTerminatePlan,
            label: isTerminatingPlan
                ? s.shareEditTerminatePlanBusy
                : s.shareEditTerminatePlan,
          ),
        ],
      ],
    );
  }

  String? _formattedPeriod() {
    final recurrence = state.form.recurrence;
    final start = state.form.startDate;
    if (recurrence == ExpenseRecurrenceInterval.none || start == null) {
      return null;
    }

    DateTime end;
    switch (recurrence) {
      case ExpenseRecurrenceInterval.weekly:
        end = start.add(const Duration(days: 6));
        break;
      case ExpenseRecurrenceInterval.every2Weeks:
        end = start.add(const Duration(days: 13));
        break;
      case ExpenseRecurrenceInterval.monthly:
        end = DateTime(start.year, start.month + 1, start.day)
            .subtract(const Duration(days: 1));
        break;
      case ExpenseRecurrenceInterval.every2Months:
        end = DateTime(start.year, start.month + 2, start.day)
            .subtract(const Duration(days: 1));
        break;
      case ExpenseRecurrenceInterval.annual:
        end = DateTime(start.year + 1, start.month, start.day)
            .subtract(const Duration(days: 1));
        break;
      case ExpenseRecurrenceInterval.none:
        return null;
    }

    final sameMonth = start.month == end.month && start.year == end.year;
    final formatter = DateFormat.MMMMd();
    final startStr = formatter.format(start);
    final endStr = sameMonth ? DateFormat.d().format(end) : formatter.format(end);

    if (start.year == end.year) {
      return '$startStr - $endStr, ${start.year}';
    }

    return '$startStr, ${start.year} - $endStr, ${end.year}';
  }
}

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
                        context
                            .read<ShareCreateBloc>()
                            .add(ShareCreateStartDateChanged(picked));
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
              members:
                  state.participants
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
