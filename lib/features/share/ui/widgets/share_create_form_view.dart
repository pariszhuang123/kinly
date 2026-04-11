import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../contracts/share/share_create_route_args.dart';
import '../../../../../core/theme/kinly_sections.dart';
import '../../../../../core/theme/spacing.dart';
import '../../../../../core/theme/opacity.dart';
import '../../../../../core/ui/kinly_circle_avatar.dart';
import '../../../../../core/ui/kinly_expansion_tile.dart';
import '../../../../../core/ui/kinly_icons.dart';
import '../../../../../core/ui/kinly_loader.dart';
import '../../../../../core/ui/kinly_tap_target.dart';
import '../../../../../core/ui/buttons/kinly_filled_button.dart';
import '../../../../../core/ui/buttons/kinly_outlined_button.dart';
import '../../../../../core/ui/inputs/kinly_dropdown_field.dart';
import '../../../../../core/ui/inputs/kinly_text_field.dart';
import '../../../../../core/ui/kinly_date_picker.dart';
import '../../../../../core/ui/kinly_dropdown_menu_item.dart';
import '../../../../../core/ui/kinly_tab_bar.dart';
import '../../../../../core/ui/members/kinly_selectable_member_avatar_row.dart';
import '../../../../../core/ui/feedback/kinly_info_banner.dart';
import '../../../../../core/ui/enums/kinly_banner_type.dart';
import '../../../../../core/ui/toggles/kinly_checkbox.dart';
import '../../../../../core/ui/selector/kinly_expand_badge.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../core/theme/color_tokens.dart';
import '../../../../../contracts/expenses/models.dart';
import '../../../../../contracts/homes/home_units_models.dart';
import '../../../../../contracts/homes/models.dart';
import '../../../../../core/time/date_only.dart';
import '../../domain/share_split_mode.dart';
import '../../bloc/share_create_bloc/share_create_bloc.dart';
import '../share_create/share_split_mismatch_message.dart';
import '../../../../core/ui/kinly_theme_access.dart';

part 'share_create_form_fields.dart';
part 'share_create_participants_fields.dart';

class ShareCreateFormView extends StatelessWidget {
  const ShareCreateFormView({
    super.key,
    required this.state,
    required this.shareColors,
    required this.descriptionController,
    required this.amountController,
    required this.notesController,
    required this.recurrenceEveryController,
    required this.customControllers,
    required this.evidencePhotoUrl,
    required this.isUploadingEvidencePhoto,
    required this.onEvidencePhotoCapture,
    required this.allowDelete,
    required this.onDeleteRequested,
    this.showTerminatePlan = false,
    this.isTerminatingPlan = false,
    this.onTerminatePlan,
    this.showPrimaryActions = true,
    this.presentationMode = ShareCreatePresentationMode.standard,
  });

  final ShareCreateState state;
  final SectionColors? shareColors;
  final TextEditingController descriptionController;
  final TextEditingController amountController;
  final TextEditingController notesController;
  final TextEditingController recurrenceEveryController;
  final Map<String, TextEditingController> customControllers;
  final String? evidencePhotoUrl;
  final bool isUploadingEvidencePhoto;
  final VoidCallback onEvidencePhotoCapture;

  /// Whether delete is allowed at all for this screen.
  final bool allowDelete;

  /// Callback to trigger delete (shows confirm dialog + dispatches event).
  final VoidCallback? onDeleteRequested;
  final bool showTerminatePlan;
  final bool isTerminatingPlan;
  final VoidCallback? onTerminatePlan;
  final bool showPrimaryActions;
  final ShareCreatePresentationMode presentationMode;

  String _mapEditDisabledReason(BuildContext context, String code) {
    final s = S.of(context);
    final messageByCode = <String, String>{
      'CONVERTED_TO_PLAN': s.shareEditDisabledConverted,
      'RECURRING_CYCLE_IMMUTABLE': s.shareEditDisabledRecurringCycle,
      'ACTIVE_IMMUTABLE': s.shareEditDisabledActive,
    };
    return messageByCode[code] ?? s.shareEditDisabledGeneric;
  }

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final viewState = _FormViewState.fromBloc(
      state: state,
      allowDelete: allowDelete,
    );
    final periodLabel = _formattedPeriod();
    final expandOptional =
        state.form.notes.trim().isNotEmpty ||
        state.form.evidencePhotoPath.trim().isNotEmpty;
    final isShoppingQuickCreate =
        presentationMode == ShareCreatePresentationMode.shoppingQuickCreate;
    final children = <Widget>[
      SizedBox(height: spacing.lg),
      ..._buildEditDisabledBanner(
        context: context,
        viewState: viewState,
        spacing: spacing,
      ),
      ..._buildDescriptionSection(
        isShoppingQuickCreate: isShoppingQuickCreate,
        viewState: viewState,
        spacing: spacing,
      ),
      _AmountField(
        controller: amountController,
        state: state,
        showValidation: viewState.showValidation,
        locked: viewState.locked,
      ),
      ..._buildScheduleSection(
        context: context,
        isShoppingQuickCreate: isShoppingQuickCreate,
        viewState: viewState,
        periodLabel: periodLabel,
        spacing: spacing,
      ),
      _AllocationTargetSelector(state: state, locked: viewState.locked),
      SizedBox(height: spacing.lg),
      _SplitModeSelector(state: state, locked: viewState.locked),
      SizedBox(height: spacing.lg),
      _buildParticipantsSection(spacing: spacing, viewState: viewState),
      ..._buildOptionalDetailsSection(
        context: context,
        isShoppingQuickCreate: isShoppingQuickCreate,
        viewState: viewState,
        spacing: spacing,
        expandOptional: expandOptional,
      ),
      SizedBox(height: spacing.xl),
      ..._buildPrimaryActions(
        context: context,
        viewState: viewState,
        spacing: spacing,
      ),
    ];

    return ListView(
      padding: EdgeInsetsDirectional.only(bottom: spacing.lg),
      children: children,
    );
  }

  List<Widget> _buildEditDisabledBanner({
    required BuildContext context,
    required _FormViewState viewState,
    required Spacing spacing,
  }) {
    if (!viewState.editingDisabled || state.editDisabledReason == null) {
      return const [];
    }
    return [
      Padding(
        padding: EdgeInsets.only(bottom: spacing.md),
        child: KinlyInfoBanner(
          message: _mapEditDisabledReason(context, state.editDisabledReason!),
          type: KinlyBannerType.warning,
        ),
      ),
    ];
  }

  List<Widget> _buildDescriptionSection({
    required bool isShoppingQuickCreate,
    required _FormViewState viewState,
    required Spacing spacing,
  }) {
    if (isShoppingQuickCreate) {
      return const [];
    }
    return [
      _DescriptionField(
        controller: descriptionController,
        state: state,
        showValidation: viewState.showValidation,
        enabled: !viewState.editingDisabled,
      ),
      SizedBox(height: spacing.lg),
    ];
  }

  List<Widget> _buildScheduleSection({
    required BuildContext context,
    required bool isShoppingQuickCreate,
    required _FormViewState viewState,
    required String? periodLabel,
    required Spacing spacing,
  }) {
    if (isShoppingQuickCreate) {
      return [SizedBox(height: spacing.lg)];
    }
    final theme = KinlyThemeAccess.of(context);
    final s = S.of(context);
    return [
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
        recurrenceInvalid: viewState.recurrenceInvalid,
        controller: recurrenceEveryController,
      ),
      SizedBox(height: spacing.lg),
    ];
  }

  Widget _buildParticipantsSection({
    required Spacing spacing,
    required _FormViewState viewState,
  }) {
    if (_showEmptyParticipants()) {
      return _EmptyParticipantsText();
    }
    return _ParticipantsSection(
      state: state,
      shareColors: shareColors,
      spacing: spacing,
      customSummary: _resolveCustomSummary(),
      showValidation: viewState.showValidation,
      locked: viewState.locked,
      customControllers: customControllers,
    );
  }

  bool _showEmptyParticipants() {
    final isUnitBased =
        state.form.allocationTargetType ==
        ExpenseAllocationTargetType.unitBased;
    return isUnitBased
        ? state.selectableUnits.isEmpty
        : state.participants.isEmpty;
  }

  ShareCustomSplitSummary _resolveCustomSummary() {
    if (state.form.allocationTargetType ==
        ExpenseAllocationTargetType.unitBased) {
      return state.evaluateUnitCustomSplit();
    }
    return state.evaluateCustomSplit();
  }

  List<Widget> _buildOptionalDetailsSection({
    required BuildContext context,
    required bool isShoppingQuickCreate,
    required _FormViewState viewState,
    required Spacing spacing,
    required bool expandOptional,
  }) {
    if (isShoppingQuickCreate) {
      return const [];
    }
    final s = S.of(context);
    return [
      SizedBox(height: spacing.lg),
      _OptionalDetailsExpansion(
        spacing: spacing,
        title: s.flowChoreDetailMoreInfoTitle,
        notesController: notesController,
        notesEnabled: !viewState.editingDisabled,
        isUploadingEvidencePhoto: isUploadingEvidencePhoto,
        evidencePhotoUrl: evidencePhotoUrl,
        evidencePhotoEnabled: !viewState.locked,
        onEvidencePhotoCapture: onEvidencePhotoCapture,
        shareColors: shareColors,
        initiallyExpanded: expandOptional,
      ),
    ];
  }

  List<Widget> _buildPrimaryActions({
    required BuildContext context,
    required _FormViewState viewState,
    required Spacing spacing,
  }) {
    final s = S.of(context);
    final actions = <Widget>[];
    if (showPrimaryActions && !viewState.hidePrimary) {
      actions.add(
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
      );
    }
    if (showTerminatePlan) {
      actions.add(SizedBox(height: spacing.md));
      actions.add(
        KinlyFilledButton.destructiveText(
          fullWidth: true,
          onPressed: isTerminatingPlan ? null : onTerminatePlan,
          label:
              isTerminatingPlan
                  ? s.shareEditTerminatePlanBusy
                  : s.shareEditTerminatePlan,
        ),
      );
    }
    return actions;
  }

  String? _formattedPeriod() {
    final start = state.form.startDate;
    final every = state.form.recurrenceEvery;
    final unit = state.form.recurrenceUnit;
    if (every == null || unit == null) {
      return null;
    }

    final end = _periodEndDate(start, every, unit);

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

  DateTime _periodEndDate(
    DateTime start,
    int every,
    ExpenseRecurrenceUnit unit,
  ) {
    switch (unit) {
      case ExpenseRecurrenceUnit.day:
        return start.add(Duration(days: every - 1));
      case ExpenseRecurrenceUnit.week:
        return start.add(Duration(days: (every * 7) - 1));
      case ExpenseRecurrenceUnit.month:
        return DateTime(
          start.year,
          start.month + every,
          start.day,
        ).subtract(const Duration(days: 1));
      case ExpenseRecurrenceUnit.year:
        return DateTime(
          start.year + every,
          start.month,
          start.day,
        ).subtract(const Duration(days: 1));
    }
  }
}

class _AllocationTargetSelector extends StatelessWidget {
  const _AllocationTargetSelector({required this.state, required this.locked});

  final ShareCreateState state;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final unitLabel = _resolveUnitLabel(s);
    return KinlyTabBar<ExpenseAllocationTargetType>(
      tabs: {
        ExpenseAllocationTargetType.debtorBased: s.gratitudeWallStatsPeople,
        ExpenseAllocationTargetType.unitBased: unitLabel,
      },
      selected: state.form.allocationTargetType,
      emptySelectionAllowed: false,
      onChanged: (value) {
        if (locked || value == null) return;
        context.read<ShareCreateBloc>().add(
          ShareCreateAllocationTargetChanged(value),
        );
      },
    );
  }

  String _resolveUnitLabel(S s) {
    if (state.selectableUnits.length == 1) {
      final name = state.selectableUnits.first.name.trim();
      if (name.isNotEmpty) return name;
      return state.selectableUnits.first.unitType == HomeUnitType.shared
          ? s.houseNormSectionSharedSpacesTitle
          : s.gratitudeWallPersonalTab;
    }

    final sharedUnit = state.selectableUnits.where(
      (unit) => unit.unitType == HomeUnitType.shared,
    );
    if (sharedUnit.isNotEmpty) {
      final sharedName = sharedUnit.first.name.trim();
      if (sharedName.isNotEmpty) return sharedName;
      return s.houseNormSectionSharedSpacesTitle;
    }

    return s.gratitudeWallPersonalTab;
  }
}

class _FormViewState {
  _FormViewState({
    required this.showValidation,
    required this.editingDisabled,
    required this.locked,
    required this.recurrenceNeedsSplit,
    required this.recurrenceInvalid,
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
  final bool recurrenceInvalid;
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
    final recurrenceInvalid = _recurrenceInvalid(
      state,
      showValidation: showValidation,
    );
    final isEditing = state.isEditing;
    final canDelete = _canDelete(
      state,
      allowDelete: allowDelete,
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
      recurrenceInvalid: recurrenceInvalid,
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
      state.isEditing && (state.isAmountLocked || editingDisabled);

  static bool _needsSplit(
    ShareCreateState state, {
    required bool showValidation,
  }) {
    if (!showValidation) return false;
    return state.form.isRecurring && state.form.splitMode == null;
  }

  static bool _recurrenceInvalid(
    ShareCreateState state, {
    required bool showValidation,
  }) {
    if (!showValidation) return false;
    if (!state.form.isRecurring) return false;
    final every = state.form.recurrenceEvery;
    final unit = state.form.recurrenceUnit;
    return every == null || every < 1 || unit == null;
  }

  static bool _canDelete(
    ShareCreateState state, {
    required bool allowDelete,
    required bool fullyPaid,
    required bool editingDisabled,
  }) {
    final isPristineEdit = state.isEditing && !state.hasUserEdits;
    final deleteBlocked = state.paidByOther || fullyPaid;
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
