import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/expenses/enums/expense_recurrence_interval.dart';
import '../../../../core/supabase/supabase_error_mapper.dart';
import '../../../../core/theme/kinly_sections.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/ui/dialogs/kinly_dialogs.dart';
import '../../../../core/ui/kinly_loader.dart';
import '../../../../core/ui/snackbars/kinly_snackbar.dart';
import '../../../../core/ui/scroll/kinly_scroll_fade.dart';
import '../../../../generated/l10n.dart';
import 'package:kinly/features/paywall/paywall.dart';
import '../../bloc/share_create_bloc/share_create_bloc.dart';
import '../../domain/share_create_form.dart';
import '../share_edit_outcome.dart';
import '../widgets/share_create_error.dart';
import '../widgets/share_create_form_view.dart';
import '../widgets/share_create_action_bar.dart';

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
    final theme = Theme.of(context);
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
                Theme.of(context).extension<KinlySections>()?.share.accent;
            KinlySnackBar.showError(context, snackText, accentColor: accent);
          }

          if (state.deletionErrorTick > 0) {
            final message =
                state.deletionErrorMessage ?? s.shareEditDeleteError;
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
              child: _ShareCreateBody(
                spacing: spacing,
                state: state,
                shareColors: shareColors,
                allowDelete: widget.allowDelete,
                showTerminatePlan: showTerminatePlan,
                onRetry:
                    () => context.read<ShareCreateBloc>().add(
                      const ShareCreateParticipantsRequested(),
                    ),
                descriptionController: _descriptionController,
                amountController: _amountController,
                notesController: _notesController,
                customControllers: _customControllers,
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
                          ShareCreatePaywallOpened(
                            state.paywallRequest!.requestId,
                          ),
                        ),
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
}

class _ShareCreateBody extends StatelessWidget {
  const _ShareCreateBody({
    required this.spacing,
    required this.state,
    required this.shareColors,
    required this.allowDelete,
    required this.showTerminatePlan,
    required this.onRetry,
    required this.descriptionController,
    required this.amountController,
    required this.notesController,
    required this.customControllers,
    required this.onSubmit,
    required this.onDeleteRequested,
    required this.onTerminatePlan,
    required this.onPaywallOpened,
  });

  final Spacing spacing;
  final ShareCreateState state;
  final SectionColors? shareColors;
  final bool allowDelete;
  final bool showTerminatePlan;
  final VoidCallback onRetry;
  final TextEditingController descriptionController;
  final TextEditingController amountController;
  final TextEditingController notesController;
  final Map<String, TextEditingController> customControllers;
  final VoidCallback onSubmit;
  final VoidCallback? onDeleteRequested;
  final VoidCallback onTerminatePlan;
  final VoidCallback? onPaywallOpened;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    if (state.isLoading) {
      return const Center(child: KinlyLoader(size: 40));
    }
    if (state.loadErrorMessage != null) {
      return Padding(
        padding: EdgeInsetsDirectional.all(spacing.lg),
        child: ShareCreateError(
          message: s.shareCreateLoadError,
          onRetry: onRetry,
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsetsDirectional.all(spacing.lg),
            child: KinlyScrollFade(
              child: ShareCreateFormView(
                state: state,
                shareColors: shareColors,
                descriptionController: descriptionController,
                amountController: amountController,
                notesController: notesController,
                customControllers: customControllers,
                allowDelete: false,
                onDeleteRequested: null,
                showTerminatePlan: false,
                showPrimaryActions: false,
              ),
            ),
          ),
        ),
        ShareCreateActionBar(
          state: state,
          allowDelete: allowDelete,
          onDeleteRequested: onDeleteRequested,
          onSubmit: onSubmit,
          showTerminatePlan: showTerminatePlan,
          isTerminatingPlan: state.isTerminatingPlan,
          onTerminatePlan: onTerminatePlan,
          onPaywallOpened: onPaywallOpened,
        ),
      ],
    );
  }
}
