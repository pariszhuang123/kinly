import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/supabase/supabase_error_mapper.dart';
import '../../../../core/theme/kinly_sections.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/ui/kinly_loader.dart';
import '../../../../core/ui/dialogs/kinly_dialogs.dart';
import '../../../../core/ui/snackbars/kinly_snackbar.dart';
import '../../../../core/ui/scroll/kinly_scroll_fade.dart';
import '../../../../core/ui/buttons/kinly_filled_button.dart';
import '../../../../generated/l10n.dart';
import '../../../paywall/ui/paywall_screen.dart';
import '../../bloc/share_create_bloc/share_create_bloc.dart';
import '../../domain/share_create_form.dart';
import '../share_edit_outcome.dart';
import '../widgets/share_create_form_view.dart';
import '../widgets/share_create_error.dart';
import '../../../../core/expenses/enums/expense_recurrence_interval.dart';

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

    // Dispose stale controllers
    final staleIds = _customControllers.keys
        .where((id) => !participantIds.contains(id))
        .toList(growable: false);
    for (final id in staleIds) {
      _customControllers.remove(id)?.dispose();
    }

    // Ensure controller exists + is in sync for each participant
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
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;
    final sections = theme.extension<KinlySections>();
    final shareColors = sections?.share;

    return BlocConsumer<ShareCreateBloc, ShareCreateState>(
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
        final s = S.of(context);

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
          if (state.submissionErrorCode ==
              ExpenseErrorCode.paywallActiveExpensesCap) {
            _showPaywallAndMaybeRetry(context);
            return;
          }
          final snackText = _mapSubmissionError(context, state);
          final accent =
              Theme.of(context).extension<KinlySections>()?.share.accent;
          KinlySnackBar.showError(context, snackText, accentColor: accent);
        }

        if (state.deletionErrorTick > 0) {
          final message = state.deletionErrorMessage ?? s.shareEditDeleteError;
          final accent =
              Theme.of(context).extension<KinlySections>()?.share.accent;
          KinlySnackBar.showError(context, message, accentColor: accent);
        }

        if (state.planTerminationErrorTick > 0) {
          final message =
              state.planTerminationErrorMessage ?? s.shareEditTerminateError;
          final accent =
              Theme.of(context).extension<KinlySections>()?.share.accent;
          KinlySnackBar.showError(context, message, accentColor: accent);
        }

        if (state.planTerminationSuccessTick > 0) {
          final accent =
              Theme.of(context).extension<KinlySections>()?.share.accent;
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
        final s = S.of(context);
        final showTerminatePlan =
            state.isEditing &&
            state.planId != null &&
            state.planStatus != 'terminated' &&
            state.form.recurrence != ExpenseRecurrenceInterval.none;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              state.isEditing ? s.shareEditTitle : s.shareCreateTitle,
            ),
            // Delete now handled by primary button in the form.
          ),
          body: SafeArea(
            child:
                state.isLoading
                    ? const Center(child: KinlyLoader(size: 40))
                    : state.loadErrorMessage != null
                    ? Padding(
                      padding: EdgeInsetsDirectional.all(spacing.lg),
                      child: ShareCreateError(
                        message: s.shareCreateLoadError,
                        onRetry:
                            () => context.read<ShareCreateBloc>().add(
                              const ShareCreateParticipantsRequested(),
                            ),
                      ),
                    )
                    : Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.all(spacing.lg),
                          child: KinlyScrollFade(
                            child: ShareCreateFormView(
                              state: state,
                              shareColors: shareColors,
                              descriptionController: _descriptionController,
                              amountController: _amountController,
                              notesController: _notesController,
                              customControllers: _customControllers,
                              allowDelete: false,
                              onDeleteRequested: null,
                              showTerminatePlan: false,
                              showPrimaryActions: false,
                            ),
                          ),
                        ),
                        ),
                        _ActionBar(
                          state: state,
                          allowDelete: widget.allowDelete,
                          onDeleteRequested:
                              widget.allowDelete
                                  ? () => _confirmDelete(context)
                                  : null,
                          onSubmit: () => context
                              .read<ShareCreateBloc>()
                              .add(const ShareCreateSubmitted()),
                          showTerminatePlan: showTerminatePlan,
                          isTerminatingPlan: state.isTerminatingPlan,
                          onTerminatePlan: () => _confirmTerminatePlan(context),
                        ),
                      ],
                    ),
          ),
        );
      },
    );
  }

  String _mapSubmissionError(BuildContext context, ShareCreateState state) {
    final s = S.of(context);
    switch (state.submissionErrorCode) {
      case ExpenseErrorCode.invalidAmount:
        return s.shareCreateValidationAmount;
      case ExpenseErrorCode.invalidDescription:
        return s.shareCreateValidationDescription;
      case ExpenseErrorCode.invalidRecurrence:
        return s.shareCreateValidationRecurrence;
      case ExpenseErrorCode.invalidRecurrenceDraft:
        return s.shareCreateErrorRecurrenceDraft;
      case ExpenseErrorCode.invalidStartDate:
        return s.shareCreateValidationStartDate;
      case ExpenseErrorCode.invalidStartDateRange:
        return s.shareCreateValidationStartDateRange;
      case ExpenseErrorCode.paywallActiveExpensesCap:
        return s.shareCreateErrorPaywallActiveCap;
      case ExpenseErrorCode.splitMembersRequired:
      case ExpenseErrorCode.invalidSplit:
        return s.shareCreateValidationEqualParticipants;
      case ExpenseErrorCode.splitSumMismatch:
        return s.shareCreateValidationCustomSum;
      case ExpenseErrorCode.homeInactive:
      case ExpenseErrorCode.forbidden:
      case ExpenseErrorCode.unauthorized:
        return s.shareCreateErrorForbidden;
      default:
        return state.submissionErrorMessage ?? s.shareCreateErrorGeneric;
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    if (!widget.allowDelete) return;

    final bloc = context.read<ShareCreateBloc>();
    final s = S.of(context);

    final shouldDelete = await showKinlyConfirmDialog(
      context,
      title: s.shareEditDeleteConfirmTitle,
      message: s.shareEditDeleteConfirmMessage,
      confirmLabel: s.shareEditDeleteConfirm,
      destructive: true,
    );

    if (shouldDelete == true && mounted) {
      bloc.add(const ShareCreateDeleted());
    }
  }

  Future<void> _confirmTerminatePlan(BuildContext context) async {
    final bloc = context.read<ShareCreateBloc>();
    final s = S.of(context);

    final shouldTerminate = await showKinlyConfirmDialog(
      context,
      title: s.shareEditTerminatePlanTitle,
      message: s.shareEditTerminatePlanMessage,
      confirmLabel: s.shareEditTerminatePlanConfirm,
      destructive: true,
    );

    if (shouldTerminate == true && mounted) {
      bloc.add(const ShareCreatePlanTerminationRequested());
    }
  }

  Future<void> _showPaywallAndMaybeRetry(BuildContext context) async {
    final s = S.of(context);
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder:
            (_) => KinlyPaywallScreen(
              homeId: widget.homeId,
              strings: PaywallStrings(
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
              ),
              source: 'share_create',
            ),
      ),
    );
    if (!context.mounted) return;
    if (result == true) {
      context.read<ShareCreateBloc>().add(const ShareCreateSubmitted());
    }
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.state,
    required this.allowDelete,
    required this.onDeleteRequested,
    required this.onSubmit,
    required this.showTerminatePlan,
    required this.isTerminatingPlan,
    required this.onTerminatePlan,
  });

  final ShareCreateState state;
  final bool allowDelete;
  final VoidCallback? onDeleteRequested;
  final VoidCallback onSubmit;
  final bool showTerminatePlan;
  final bool isTerminatingPlan;
  final VoidCallback onTerminatePlan;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final spacing = Theme.of(context).extension<Spacing>()!;

    final editingDisabled = state.isEditing && !state.canEdit;
    final locked = state.isAmountLocked || editingDisabled;
    final fullyPaid = state.allPaid;
    final deleteBlocked = state.paidByOther || locked || fullyPaid;

    final isEditing = state.isEditing;
    final isPristineEdit = isEditing && !state.hasUserEdits;
    final canDelete =
        allowDelete && isPristineEdit && !deleteBlocked && !editingDisabled;
    final isDeleteAction = canDelete;
    final hidePrimary = fullyPaid || editingDisabled;
    final primaryLabel =
        !isEditing
            ? s.shareCreateSubmit
            : canDelete
            ? s.shareEditDeleteButton
            : s.shareEditSubmit;
    final shouldDisable =
        state.isSubmitting ||
        state.isDeleting ||
        editingDisabled ||
        (!canDelete && isEditing && state.form.splitMode == null);

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(
          spacing.lg,
          spacing.md,
          spacing.lg,
          spacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!hidePrimary)
              KinlyFilledButton.text(
                fullWidth: true,
                onPressed: shouldDisable
                    ? null
                    : canDelete
                    ? onDeleteRequested
                    : onSubmit,
                label: primaryLabel,
                destructive: isDeleteAction,
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
        ),
      ),
    );
  }
}
