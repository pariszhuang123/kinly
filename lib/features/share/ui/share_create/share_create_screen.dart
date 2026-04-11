import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/di/locator.dart';
import '../../../../contracts/share/share_create_route_args.dart';
import '../../../../contracts/expenses/models.dart';
import '../../../../core/supabase/storage_path_resolver.dart';
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
import '../../domain/share_split_mode.dart';
import '../share_edit_outcome.dart';
import '../widgets/share_create_body.dart';
import 'share_split_mismatch_message.dart';
import 'share_create_surface_contract.dart';
import 'share_create_surface_registry.dart';
import '../../../../core/ui/kinly_scaffold.dart';
import '../../../../core/ui/kinly_app_bar.dart';
import '../../../../core/ui/kinly_theme_access.dart';

const _splitValidationCodes = <ExpenseErrorCode>{
  ExpenseErrorCode.splitMembersRequired,
  ExpenseErrorCode.splitUnitsRequired,
  ExpenseErrorCode.invalidSplit,
  ExpenseErrorCode.invalidSplits,
  ExpenseErrorCode.splitRequired,
};

class ShareCreateScreen extends StatefulWidget {
  const ShareCreateScreen({
    super.key,
    required this.homeId,
    this.allowDelete = false,
    this.presentationMode = ShareCreatePresentationMode.standard,
  });

  final String homeId;
  final bool allowDelete;
  final ShareCreatePresentationMode presentationMode;

  @override
  State<ShareCreateScreen> createState() => _ShareCreateScreenState();
}

class _ShareCreateScreenState extends State<ShareCreateScreen> {
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  final _recurrenceEveryController = TextEditingController();
  final Map<String, TextEditingController> _customControllers = {};
  bool _baseHydrated = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    _recurrenceEveryController.dispose();
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
    _recurrenceEveryController.text = form.recurrenceEvery?.toString() ?? '';
    _baseHydrated = true;
  }

  void _syncRecurrenceController(ShareCreateForm form) {
    final desired = form.recurrenceEvery?.toString() ?? '';
    if (_recurrenceEveryController.text != desired) {
      _recurrenceEveryController.text = desired;
    }
  }

  void _syncCustomControllers(ShareCreateState state) {
    final activeIds =
        state.form.allocationTargetType == ExpenseAllocationTargetType.unitBased
            ? state.selectableUnits.map((unit) => unit.unitId).toSet()
            : state.participants.map((p) => p.userId).toSet();

    final staleIds = _customControllers.keys
        .where((id) => !activeIds.contains(id))
        .toList(growable: false);
    for (final id in staleIds) {
      _customControllers.remove(id)?.dispose();
    }

    final desiredIds =
        state.form.allocationTargetType == ExpenseAllocationTargetType.unitBased
            ? state.selectableUnits.map((unit) => unit.unitId)
            : state.participants.map((participant) => participant.userId);

    for (final id in desiredIds) {
      final controller = _customControllers.putIfAbsent(
        id,
        () => TextEditingController(),
      );
      final desired =
          state.form.allocationTargetType == ExpenseAllocationTargetType.unitBased
              ? state.form.unitCustomAmountFor(id)
              : state.form.customAmountFor(id);
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
      bulletExpensePhotos: s.paywallFeatureUnlimitedSharedExpensePhotos,
      bulletShoppingPhotos: s.paywallBulletShoppingPhotos,
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
                    current.planTerminationSuccessTick ||
                previous.evidencePhotoErrorTick != current.evidencePhotoErrorTick,
        listener: (context, state) {
          if (state.evidencePhotoErrorTick > 0) {
            _showEvidencePhotoError(context, state);
            return;
          }

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
                KinlyThemeAccess.of(
                  context,
                ).extension<KinlySections>()?.share.accent;
            KinlySnackBar.showError(context, snackText, accentColor: accent);
          }

          if (state.deletionErrorTick > 0) {
            final message =
                state.deletionErrorMessage ?? s.shareEditDeleteError;
            final accent =
                KinlyThemeAccess.of(
                  context,
                ).extension<KinlySections>()?.share.accent;
            KinlySnackBar.showError(context, message, accentColor: accent);
          }

          if (state.planTerminationErrorTick > 0) {
            final message =
                state.planTerminationErrorMessage ?? s.shareEditTerminateError;
            final accent =
                KinlyThemeAccess.of(
                  context,
                ).extension<KinlySections>()?.share.accent;
            KinlySnackBar.showError(context, message, accentColor: accent);
          }

          if (state.planTerminationSuccessTick > 0) {
            final accent =
                KinlyThemeAccess.of(
                  context,
                ).extension<KinlySections>()?.share.accent;
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
          _syncRecurrenceController(state.form);
          final resolver =
              sl.isRegistered<StoragePathResolver>()
                  ? sl<StoragePathResolver>()
                  : null;
          final evidencePhotoUrl = resolver?.toPublicUrl(
            state.form.evidencePhotoPath,
          );
          final showTerminatePlan =
              state.isEditing &&
              state.planId != null &&
              state.planStatus != 'terminated' &&
              state.form.isRecurring;

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
                evidencePhotoUrl,
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
    if (code == null) return _fallbackSubmissionMessage(s, state);
    if (_isSplitMismatchCode(code)) {
      return buildShareCreateSplitMismatchMessage(strings: s, state: state);
    }
    if (_splitValidationCodes.contains(code)) {
      return _mapSplitValidationError(s, state);
    }

    final messageByCode = <ExpenseErrorCode, String>{
      ExpenseErrorCode.invalidAmount: s.shareCreateValidationAmount,
      ExpenseErrorCode.invalidDescription: s.shareCreateValidationDescription,
      ExpenseErrorCode.invalidAllocationTarget: s.shareCreateErrorGeneric,
      ExpenseErrorCode.invalidRecurrence: s.shareCreateValidationRecurrence,
      ExpenseErrorCode.invalidRecurrenceDraft:
          s.shareCreateErrorRecurrenceDraft,
      ExpenseErrorCode.invalidStartDate: s.shareCreateValidationStartDate,
      ExpenseErrorCode.invalidStartDateRange:
          s.shareCreateValidationStartDateRange,
      ExpenseErrorCode.paywallActiveExpensesCap:
          s.shareCreateErrorPaywallActiveCap,
      ExpenseErrorCode.paywallExpensePhotosCap:
          s.shareCreateErrorPaywallActiveCap,
      ExpenseErrorCode.forbidden: s.shareCreateErrorForbidden,
      ExpenseErrorCode.notHomeMember: s.shareCreateErrorForbidden,
      ExpenseErrorCode.notCreator: s.shareCreateErrorForbidden,
      ExpenseErrorCode.invalidDebtor: s.shareCreateErrorForbidden,
      ExpenseErrorCode.invalidUnitTarget: s.shareCreateErrorGeneric,
      ExpenseErrorCode.editNotAllowed: s.shareEditNotAllowed,
      ExpenseErrorCode.invalidEvidencePhotoPath: s.flowChoreErrorInvalidPhoto,
      ExpenseErrorCode.photoDeleteNotAllowed: s.shareCreateErrorGeneric,
    };

    final mapped = messageByCode[code];
    return mapped ?? _fallbackSubmissionMessage(s, state);
  }

  bool _isSplitMismatchCode(ExpenseErrorCode code) {
    return code == ExpenseErrorCode.splitSumMismatch ||
        code == ExpenseErrorCode.invalidSplitsSum;
  }

  String _mapSplitValidationError(S s, ShareCreateState state) {
    if (state.form.splitMode == ShareSplitMode.custom) {
      return _mapCustomSplitValidationError(s, state);
    }
    if (state.hasEqualSinglePayer) {
      return s.shareCreateValidationCustomSinglePayer;
    }
    return s.shareCreateValidationEqualParticipants;
  }

  String _mapCustomSplitValidationError(S s, ShareCreateState state) {
    final summary = state.evaluateCustomSplit();
    if (summary.hasSinglePayer) {
      return s.shareCreateValidationCustomSinglePayer;
    }
    if (summary.hasInsufficientParticipants) {
      return s.shareCreateValidationCustomParticipants;
    }
    return _fallbackSubmissionMessage(
      s,
      state,
      fallback: s.shareCreateValidationCustomParticipants,
    );
  }

  String _fallbackSubmissionMessage(
    S s,
    ShareCreateState state, {
    String? fallback,
  }) {
    final message = state.submissionErrorMessage?.trim();
    if (message != null && message.isNotEmpty) {
      return message;
    }
    return fallback ?? s.shareCreateErrorGeneric;
  }

  void _showEvidencePhotoError(BuildContext context, ShareCreateState state) {
    final s = S.of(context);
    final isPermission = state.evidencePhotoErrorMessage == 'permission';
    final snackText =
        isPermission
            ? s.flowChorePhotoPermissionDenied
            : s.flowChorePhotoUploadError;
    final accent =
        KinlyThemeAccess.of(context).extension<KinlySections>()?.share.accent;
    final isPermanent = state.isCameraPermissionPermanentlyDenied;
    final actionLabel =
        isPermanent ? s.flowChorePhotoPermissionOpenSettings : null;
    final onAction = isPermanent ? openAppSettings : null;
    final showSnack =
        isPermission ? KinlySnackBar.showInfo : KinlySnackBar.showError;

    showSnack(
      context,
      snackText,
      accentColor: accent,
      actionLabel: actionLabel,
      onAction: onAction,
    );
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
    String? evidencePhotoUrl,
  ) {
    final actions = ShareCreateSurfaceActions(
      onRetry:
          () => context.read<ShareCreateBloc>().add(
            const ShareCreateParticipantsRequested(),
          ),
      onSubmit:
          () =>
              context.read<ShareCreateBloc>().add(const ShareCreateSubmitted()),
      onDeleteRequested:
          widget.allowDelete ? () => _confirmDelete(context) : null,
      onTerminatePlan: () => _confirmTerminatePlan(context),
      onPaywallOpened:
          state.paywallRequest == null
              ? null
              : () => context.read<ShareCreateBloc>().add(
                ShareCreatePaywallOpened(state.paywallRequest!.requestId),
              ),
      onEvidencePhotoCapture:
          () => context.read<ShareCreateBloc>().add(
            const ShareCreateEvidencePhotoCaptureRequested(),
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
      recurrenceEveryController: _recurrenceEveryController,
      customControllers: _customControllers,
      evidencePhotoUrl: evidencePhotoUrl,
      isUploadingEvidencePhoto: state.isUploadingEvidencePhoto,
      presentationMode: widget.presentationMode,
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
        recurrenceEveryController: scope.recurrenceEveryController,
        customControllers: scope.customControllers,
        evidencePhotoUrl: scope.evidencePhotoUrl,
        isUploadingEvidencePhoto: scope.isUploadingEvidencePhoto,
        onSubmit: scope.actions.onSubmit,
        onDeleteRequested: scope.actions.onDeleteRequested,
        onTerminatePlan: scope.actions.onTerminatePlan,
        onPaywallOpened: scope.actions.onPaywallOpened,
        onEvidencePhotoCapture: scope.actions.onEvidencePhotoCapture,
        presentationMode: scope.presentationMode,
      );
    }
    return Column(
      children: entries
          .map((entry) => entry.builder(scope))
          .toList(growable: false),
    );
  }
}
