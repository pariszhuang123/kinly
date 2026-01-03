import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../contracts/expenses/enums/expense_recurrence_interval.dart';
import '../../../../core/supabase/supabase_error_mapper.dart';
import '../../../../core/theme/kinly_sections.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/ui/dialogs/kinly_dialogs.dart';
import '../../../../core/ui/snackbars/kinly_snackbar.dart';
import '../../../../generated/l10n.dart';
import 'package:kinly/core/ui/paywall/paywall_gate_listener.dart';
import 'package:kinly/core/ui/paywall/paywall_strings.dart';
import '../../bloc/share_create_bloc/share_create_bloc.dart';
import '../../domain/share_create_form.dart';
import '../share_edit_outcome.dart';
import '../widgets/share_create_body.dart';
import 'share_create_surface_contract.dart';
import 'share_create_surface_registry.dart';
import '../../../../core/ui/kinly_scaffold.dart';
import '../../../../core/ui/kinly_app_bar.dart';
import '../../../../core/ui/kinly_theme_access.dart';

class ShareCreateScreen extends StatefulWidget {
  const ShareCreateScreen({
    super.key,
    required this.homeId,
    this.allowDelete = false,
  });

  final String homeId;
  final bool allowDelete;

  @override
  State<ShareCreateScreen> createState() => _ShareCreateScreenState();
}

class _ShareCreateScreenState extends State<ShareCreateScreen> {
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  final Map<String, TextEditingController> _customControllers = {};
  bool _baseHydrated = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    for (final controller in _customControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _hydrateBaseControllers(ShareCreateForm form) {
    if (_baseHydrated) return;
    _descriptionController.text = form.description;
    _amountController.text = form.amountInput;
    _notesController.text = form.notes;
    _baseHydrated = true;
  }

  void _syncCustomControllers(ShareCreateState state) {
    final participantIds = state.participants.map((p) => p.userId).toSet();

    final staleIds = _customControllers.keys
        .where((id) => !participantIds.contains(id))
        .toList(growable: false);
    for (final id in staleIds) {
      _customControllers.remove(id)?.dispose();
    }

    for (final participant in state.participants) {
      final controller = _customControllers.putIfAbsent(
        participant.userId,
        () => TextEditingController(),
      );
      final desired = state.form.customAmountFor(participant.userId);
      if (controller.text != desired) {
        controller.text = desired;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ShareCreateRegistry.bootstrap();
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final sections = theme.extension<KinlySections>();
    final shareColors = sections?.share;
    final s = S.of(context);
    final paywallStrings = PaywallStrings(
      title: s.paywallTitle,
      subtitle: s.paywallSubtitle,
      bulletMembers: s.paywallBulletMembers,
      bulletFlows: s.paywallBulletFlows,
      bulletPhotos: s.paywallBulletPhotos,
      bulletShares: s.paywallBulletShares,
      unlimitedLabel: s.paywallSubtitle,
      priceCaption: s.paywallPriceCaption,
      priceUnavailableLabel: s.paywallPriceUnavailable,
      priceFormatter: (price) => s.paywallPricePerMonth(price),
      primaryCta: s.paywallPrimaryCta,
      secondaryCta: s.paywallSecondaryCta,
      purchaseFailed: s.paywallPurchaseFailed,
      purchaseSuccess: s.paywallPurchaseSuccess,
      restoreCta: s.paywallRestoreCta,
      errorTitle: s.paywallErrorTitle,
      retryLabel: s.paywallRetryLabel,
    );

    return PaywallGateListener<ShareCreateBloc, ShareCreateState>(
      strings: paywallStrings,
      requestSelector: (state) => state.paywallRequest,
      inFlightRequestIdSelector: (state) => state.paywallInFlightRequestId,
      onOpened:
          (requestId) => context.read<ShareCreateBloc>().add(
            ShareCreatePaywallOpened(requestId),
          ),
      onOutcome:
          (outcome) => context.read<ShareCreateBloc>().add(
            ShareCreatePaywallResolved(outcome),
          ),
      child: BlocConsumer<ShareCreateBloc, ShareCreateState>(
        listenWhen:
            (previous, current) =>
                previous.successExpenseId != current.successExpenseId ||
                previous.submissionErrorTick != current.submissionErrorTick ||
                previous.deletionErrorTick != current.deletionErrorTick ||
                previous.deletionSuccessTick != current.deletionSuccessTick ||
                previous.planTerminationErrorTick !=
                    current.planTerminationErrorTick ||
                previous.planTerminationSuccessTick !=
                    current.planTerminationSuccessTick,
        listener: (context, state) {
          if (state.deletionSuccessTick > 0) {
            Navigator.of(context).pop(ShareEditOutcome.deleted);
            return;
          }

          if (state.successExpenseId != null) {
            final result = state.isEditing ? ShareEditOutcome.updated : true;
            Navigator.of(context).pop(result);
            return;
          }

          if (state.submissionErrorTick > 0) {
            final snackText = _mapSubmissionError(context, state);
            final accent =
                KinlyThemeAccess.of(context).extension<KinlySections>()?.share.accent;
            KinlySnackBar.showError(context, snackText, accentColor: accent);
          }

          if (state.deletionErrorTick > 0) {
            final message =
                state.deletionErrorMessage ?? s.shareEditDeleteError;
            final accent =
                KinlyThemeAccess.of(context).extension<KinlySections>()?.share.accent;
            KinlySnackBar.showError(context, message, accentColor: accent);
          }

          if (state.planTerminationErrorTick > 0) {
            final message =
                state.planTerminationErrorMessage ?? s.shareEditTerminateError;
            final accent =
                KinlyThemeAccess.of(context).extension<KinlySections>()?.share.accent;
            KinlySnackBar.showError(context, message, accentColor: accent);
          }

          if (state.planTerminationSuccessTick > 0) {
            final accent =
                KinlyThemeAccess.of(context).extension<KinlySections>()?.share.accent;
            KinlySnackBar.showSuccess(
              context,
              s.shareEditTerminateSuccess,
              accentColor: accent,
            );
            Navigator.of(context).pop(ShareEditOutcome.updated);
            return;
          }
        },
        builder: (context, state) {
          _hydrateBaseControllers(state.form);
          _syncCustomControllers(state);
          final showTerminatePlan =
              state.isEditing &&
              state.planId != null &&
              state.planStatus != 'terminated' &&
              state.form.recurrence != ExpenseRecurrenceInterval.none;

          return KinlyScaffold(
            appBar: KinlyAppBar(
              title: Text(
                state.isEditing ? s.shareEditTitle : s.shareCreateTitle,
              ),
              // Delete now handled by primary button in the form.
            ),
            body: SafeArea(
              child: _buildShareCreateBody(
                context,
                state,
                spacing,
                shareColors,
                showTerminatePlan,
              ),
            ),
          );
        },
      ),
    );
  }

  String _mapSubmissionError(BuildContext context, ShareCreateState state) {
    final s = S.of(context);
    final code = state.submissionErrorCode;
    if (code == null) return s.shareCreateErrorGeneric;

    final messageByCode = <ExpenseErrorCode, String>{
      ExpenseErrorCode.invalidAmount: s.shareCreateValidationAmount,
      ExpenseErrorCode.invalidDescription: s.shareCreateValidationDescription,
      ExpenseErrorCode.invalidRecurrence: s.shareCreateValidationRecurrence,
      ExpenseErrorCode.invalidRecurrenceDraft:
          s.shareCreateErrorRecurrenceDraft,
      ExpenseErrorCode.invalidStartDate: s.shareCreateValidationStartDate,
      ExpenseErrorCode.invalidStartDateRange:
          s.shareCreateValidationStartDateRange,
      ExpenseErrorCode.paywallActiveExpensesCap:
          s.shareCreateErrorPaywallActiveCap,
      ExpenseErrorCode.splitMembersRequired:
          s.shareCreateValidationEqualParticipants,
      ExpenseErrorCode.invalidSplit: s.shareCreateValidationEqualParticipants,
      ExpenseErrorCode.splitSumMismatch: s.shareCreateValidationCustomSum,
      ExpenseErrorCode.forbidden: s.shareCreateErrorForbidden,
      ExpenseErrorCode.notHomeMember: s.shareCreateErrorForbidden,
      ExpenseErrorCode.notCreator: s.shareCreateErrorForbidden,
      ExpenseErrorCode.invalidDebtor: s.shareCreateErrorForbidden,
      ExpenseErrorCode.editNotAllowed: s.shareEditNotAllowed,
    };

    return messageByCode[code] ?? s.shareCreateErrorGeneric;
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final s = S.of(context);
    final confirmed = await showKinlyConfirmDialog(
      context,
      title: s.shareEditDeleteConfirmTitle,
      message: s.shareEditDeleteConfirmMessage,
      confirmLabel: s.shareEditDeleteConfirm,
      destructive: true,
    );
    if (confirmed != true) return;
    if (!context.mounted) return;
    context.read<ShareCreateBloc>().add(const ShareCreateDeleted());
  }

  Future<void> _confirmTerminatePlan(BuildContext context) async {
    final s = S.of(context);
    final confirmed = await showKinlyConfirmDialog(
      context,
      title: s.shareEditTerminatePlanTitle,
      message: s.shareEditTerminatePlanMessage,
      confirmLabel: s.shareEditTerminatePlanConfirm,
      destructive: true,
    );
    if (confirmed != true) return;
    if (!context.mounted) return;
    context.read<ShareCreateBloc>().add(
      const ShareCreatePlanTerminationRequested(),
    );
  }

  Widget _buildShareCreateBody(
    BuildContext context,
    ShareCreateState state,
    Spacing spacing,
    SectionColors? shareColors,
    bool showTerminatePlan,
  ) {
    final actions = ShareCreateSurfaceActions(
      onRetry:
          () => context.read<ShareCreateBloc>().add(
            const ShareCreateParticipantsRequested(),
          ),
      onSubmit:
          () => context.read<ShareCreateBloc>().add(
            const ShareCreateSubmitted(),
          ),
      onDeleteRequested:
          widget.allowDelete ? () => _confirmDelete(context) : null,
      onTerminatePlan: () => _confirmTerminatePlan(context),
      onPaywallOpened:
          state.paywallRequest == null
              ? null
              : () => context.read<ShareCreateBloc>().add(
                ShareCreatePaywallOpened(state.paywallRequest!.requestId),
              ),
    );
    final scope = ShareCreateSurfaceScope(
      context: context,
      state: state,
      spacing: spacing,
      sections: KinlyThemeAccess.of(context).extension<KinlySections>(),
      strings: S.of(context),
      actions: actions,
      allowDelete: widget.allowDelete,
      showTerminatePlan: showTerminatePlan,
      descriptionController: _descriptionController,
      amountController: _amountController,
      notesController: _notesController,
      customControllers: _customControllers,
    );
    final slots = ShareCreateSurfaceSlots(
      body: _buildShareCreateSections(scope, shareColors),
    );
    return slots.body;
  }

  Widget _buildShareCreateSections(
    ShareCreateSurfaceScope scope,
    SectionColors? shareColors,
  ) {
    final entries = ShareCreateRegistry.bodySections;
    if (entries.length == 1) {
      return ShareCreateBody(
        spacing: scope.spacing,
        state: scope.state,
        shareColors: shareColors,
        allowDelete: scope.allowDelete,
        showTerminatePlan: scope.showTerminatePlan,
        onRetry: scope.actions.onRetry,
        descriptionController: scope.descriptionController,
        amountController: scope.amountController,
        notesController: scope.notesController,
        customControllers: scope.customControllers,
        onSubmit: scope.actions.onSubmit,
        onDeleteRequested: scope.actions.onDeleteRequested,
        onTerminatePlan: scope.actions.onTerminatePlan,
        onPaywallOpened: scope.actions.onPaywallOpened,
      );
    }
    return Column(
      children:
          entries.map((entry) => entry.builder(scope)).toList(growable: false),
    );
  }
}




