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

part 'share_create_form_fields.dart';

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
    final viewState = _FormViewState.fromBloc(
      state: state,
      allowDelete: allowDelete,
    );
    final periodLabel = _formattedPeriod();

    return ListView(
      padding: EdgeInsetsDirectional.only(bottom: spacing.lg),
      children: [
        SizedBox(height: spacing.lg),
        if (viewState.editingDisabled && state.editDisabledReason != null)
          Padding(
            padding: EdgeInsets.only(bottom: spacing.md),
            child: KinlyInfoBanner(
              message: _mapEditDisabledReason(
                context,
                state.editDisabledReason!,
              ),
              type: KinlyBannerType.warning,
            ),
          ),
        _DescriptionField(
          controller: descriptionController,
          state: state,
          showValidation: viewState.showValidation,
        ),
        SizedBox(height: spacing.lg),
        _AmountField(
          controller: amountController,
          state: state,
          showValidation: viewState.showValidation,
          locked: viewState.locked,
        ),
        SizedBox(height: spacing.lg),
        _StartDateField(state: state, locked: viewState.locked),
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
          locked: viewState.locked,
          recurrenceNeedsSplit: viewState.recurrenceNeedsSplit,
        ),
        SizedBox(height: spacing.lg),
        _SplitModeSelector(state: state, locked: viewState.locked),
        SizedBox(height: spacing.lg),
        if (state.participants.isEmpty)
          _EmptyParticipantsText()
        else
          _ParticipantsSection(
            state: state,
            shareColors: shareColors,
            spacing: spacing,
            customSummary: state.evaluateCustomSplit(),
            showValidation: viewState.showValidation,
            locked: viewState.locked,
            customControllers: customControllers,
          ),
        SizedBox(height: spacing.lg),
        _NotesField(controller: notesController),
        SizedBox(height: spacing.xl),
        if (showPrimaryActions && !viewState.hidePrimary)
          _PrimaryActionButton(
            label: viewState.primaryLabel(s),
            shareColors: shareColors,
            isBusy: viewState.isBusy,
            shouldDisable: viewState.shouldDisable,
            destructive: viewState.isDeleteAction,
            onPressed:
                () => _handlePrimaryPressed(
                  blocContext: context,
                  viewState: viewState,
                  onDeleteRequested: onDeleteRequested,
                ),
          ),
        if (showTerminatePlan) ...[
          SizedBox(height: spacing.md),
          KinlyFilledButton.destructiveText(
            fullWidth: true,
            onPressed: isTerminatingPlan ? null : onTerminatePlan,
            label:
                isTerminatingPlan
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
    if (recurrence == ExpenseRecurrenceInterval.none) {
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
        end = DateTime(
          start.year,
          start.month + 1,
          start.day,
        ).subtract(const Duration(days: 1));
        break;
      case ExpenseRecurrenceInterval.every2Months:
        end = DateTime(
          start.year,
          start.month + 2,
          start.day,
        ).subtract(const Duration(days: 1));
        break;
      case ExpenseRecurrenceInterval.annual:
        end = DateTime(
          start.year + 1,
          start.month,
          start.day,
        ).subtract(const Duration(days: 1));
        break;
      case ExpenseRecurrenceInterval.none:
        return null;
    }

    final sameMonth = start.month == end.month && start.year == end.year;
    final formatter = DateFormat.MMMMd();
    final startStr = formatter.format(start);
    final endStr =
        sameMonth ? DateFormat.d().format(end) : formatter.format(end);

    if (start.year == end.year) {
      return '$startStr - $endStr, ${start.year}';
    }

    return '$startStr, ${start.year} - $endStr, ${end.year}';
  }
}

class _FormViewState {
  _FormViewState({
    required this.showValidation,
    required this.editingDisabled,
    required this.locked,
    required this.recurrenceNeedsSplit,
    required this.canDelete,
    required this.isDeleteAction,
    required this.hidePrimary,
    required this.shouldDisable,
    required this.isBusy,
    required this.isEditing,
  });

  final bool showValidation;
  final bool editingDisabled;
  final bool locked;
  final bool recurrenceNeedsSplit;
  final bool canDelete;
  final bool isDeleteAction;
  final bool hidePrimary;
  final bool shouldDisable;
  final bool isBusy;
  final bool isEditing;

  factory _FormViewState.fromBloc({
    required ShareCreateState state,
    required bool allowDelete,
  }) {
    final showValidation = state.showValidationErrors;
    final editingDisabled = _isEditingDisabled(state);
    final locked = _isLocked(state, editingDisabled);
    final fullyPaid = state.allPaid;
    final recurrenceNeedsSplit = _needsSplit(
      state,
      showValidation: showValidation,
    );
    final isEditing = state.isEditing;
    final canDelete = _canDelete(
      state,
      allowDelete: allowDelete,
      locked: locked,
      fullyPaid: fullyPaid,
      editingDisabled: editingDisabled,
    );
    final hidePrimary = _shouldHidePrimary(
      fullyPaid: fullyPaid,
      editingDisabled: editingDisabled,
    );
    final shouldDisable = _shouldDisable(
      state,
      editingDisabled: editingDisabled,
      canDelete: canDelete,
    );

    return _FormViewState(
      showValidation: showValidation,
      locked: locked,
      recurrenceNeedsSplit: recurrenceNeedsSplit,
      canDelete: canDelete,
      isDeleteAction: canDelete,
      hidePrimary: hidePrimary,
      shouldDisable: shouldDisable,
      isBusy: state.isSubmitting || state.isDeleting,
      editingDisabled: editingDisabled,
      isEditing: isEditing,
    );
  }

  String primaryLabel(S s) {
    if (isDeleteAction) return s.shareEditDeleteButton;
    if (isEditing) return s.shareEditSubmit;
    return s.shareCreateSubmit;
  }

  static bool _isEditingDisabled(ShareCreateState state) =>
      state.isEditing && !state.canEdit;

  static bool _isLocked(ShareCreateState state, bool editingDisabled) =>
      state.isAmountLocked || editingDisabled;

  static bool _needsSplit(
    ShareCreateState state, {
    required bool showValidation,
  }) {
    if (!showValidation) return false;
    final recurrence = state.form.recurrence;
    return recurrence != ExpenseRecurrenceInterval.none &&
        state.form.splitMode == null;
  }

  static bool _canDelete(
    ShareCreateState state, {
    required bool allowDelete,
    required bool locked,
    required bool fullyPaid,
    required bool editingDisabled,
  }) {
    final isPristineEdit = state.isEditing && !state.hasUserEdits;
    final deleteBlocked = state.paidByOther || locked || fullyPaid;
    return allowDelete && isPristineEdit && !deleteBlocked && !editingDisabled;
  }

  static bool _shouldHidePrimary({
    required bool fullyPaid,
    required bool editingDisabled,
  }) => fullyPaid || editingDisabled;

  static bool _isBusy(ShareCreateState state) =>
      state.isSubmitting || state.isDeleting;

  static bool _shouldDisable(
    ShareCreateState state, {
    required bool editingDisabled,
    required bool canDelete,
  }) =>
      _isBusy(state) ||
      editingDisabled ||
      (!canDelete && state.isEditing && state.form.splitMode == null);
}

void _handlePrimaryPressed({
  required BuildContext blocContext,
  required _FormViewState viewState,
  required VoidCallback? onDeleteRequested,
}) {
  if (viewState.shouldDisable) return;
  if (viewState.isDeleteAction) {
    onDeleteRequested?.call();
    return;
  }
  blocContext.read<ShareCreateBloc>().add(const ShareCreateSubmitted());
}
