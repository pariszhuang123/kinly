import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../contracts/chores/models.dart';
import '../../../core/di/locator.dart';
import '../../../core/supabase/storage_path_resolver.dart';
import '../../../core/theme/kinly_sections.dart';
import '../../../core/theme/opacity.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/ui/action_bar/kinly_action_bar.dart';
import '../../../core/ui/buttons/kinly_filled_button.dart';
import '../../../core/ui/buttons/kinly_outlined_button.dart';
import '../../../core/ui/dialogs/kinly_dialogs.dart';
import '../../../core/ui/inputs/kinly_dropdown_field.dart';
import '../../../core/ui/inputs/kinly_text_field.dart';
import '../../../core/ui/kinly_date_picker.dart';
import '../../../core/ui/kinly_dropdown_menu_item.dart';
import '../../../core/ui/kinly_expansion_tile.dart';
import '../../../core/ui/kinly_icons.dart';
import '../../../core/ui/selector/kinly_expand_badge.dart';
import '../../../core/ui/kinly_loader.dart';
import '../../../core/ui/kinly_tap_target.dart';
import '../../../core/ui/toggles/kinly_checkbox.dart';
import '../../../core/ui/members/kinly_selectable_member_avatar_row.dart';
import '../../../core/ui/snackbars/kinly_snackbar.dart';
import '../../../core/ui/scroll/kinly_scroll_fade.dart';
import '../../../core/time/date_only.dart';
import '../../../core/supabase/supabase_error_mapper.dart';
import '../../../generated/l10n.dart';
import '../../../contracts/homes/models.dart';
import 'package:kinly/core/ui/paywall/paywall_gate_listener.dart';
import 'package:kinly/core/ui/paywall/paywall_strings.dart';
import '../bloc/flow_chore_bloc.dart';
import '../domain/flow_chore_form.dart';
import '../domain/flow_chore_outcome.dart';
import '../../../core/ui/kinly_scaffold.dart';
import '../../../core/ui/kinly_app_bar.dart';
import '../../../core/ui/kinly_theme_access.dart';

part 'widgets/flow_chore_form_view.dart';
part 'widgets/flow_chore_action_bar.dart';
part 'widgets/flow_chore_photo_picker.dart';
part 'widgets/flow_chore_error.dart';

class FlowChoreScreen extends StatefulWidget {
  const FlowChoreScreen({super.key, required this.homeId});

  final String homeId;

  @override
  State<FlowChoreScreen> createState() => _FlowChoreScreenState();
}

class _FlowChoreScreenState extends State<FlowChoreScreen> {
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  final _howToController = TextEditingController();
  final _recurrenceEveryController = TextEditingController();
  bool _hasHydratedControllers = false;

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    _howToController.dispose();
    _recurrenceEveryController.dispose();
    super.dispose();
  }

  void _hydrateControllers(FlowChoreForm form) {
    if (_hasHydratedControllers) return;
    _titleController.text = form.title;
    _notesController.text = form.notes;
    _howToController.text = form.howToVideoUrl;
    _recurrenceEveryController.text = form.recurrenceEvery?.toString() ?? '';
    _hasHydratedControllers = true;
  }

  void _syncRecurrenceController(FlowChoreForm form) {
    final desired = form.recurrenceEvery?.toString() ?? '';
    if (_recurrenceEveryController.text != desired) {
      _recurrenceEveryController.text = desired;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
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

    return PaywallGateListener<FlowChoreBloc, FlowChoreState>(
      strings: paywallStrings,
      requestSelector: (state) => state.paywallRequest,
      inFlightRequestIdSelector: (state) => state.paywallInFlightRequestId,
      onOpened:
          (requestId) => context.read<FlowChoreBloc>().add(
            FlowChorePaywallOpened(requestId),
          ),
      onOutcome:
          (outcome) => context.read<FlowChoreBloc>().add(
            FlowChorePaywallResolved(outcome),
          ),
      child: BlocConsumer<FlowChoreBloc, FlowChoreState>(
        listenWhen:
            (previous, current) =>
                previous.successChoreId != current.successChoreId ||
                previous.submissionErrorTick != current.submissionErrorTick ||
                previous.photoErrorTick != current.photoErrorTick,
        listener: (context, state) {
          if (state.photoErrorTick > 0) {
            _showPhotoError(context, state);
            return;
          }

          if (state.successChoreId != null) {
            Navigator.of(context).pop(
              FlowChoreOutcome(
                choreId: state.successChoreId!,
                isUpdate: state.isEditMode && !state.successWasDelete,
                isDeleted: state.successWasDelete,
              ),
            );
            return;
          }

          if (state.submissionErrorTick > 0) {
            final snackText = _mapSubmissionError(context, state);
            final accent =
                KinlyThemeAccess.of(
                  context,
                ).extension<KinlySections>()?.flow.accent;
            KinlySnackBar.showError(context, snackText, accentColor: accent);
          }
        },
        builder: (context, state) {
          if (!state.isLoading) {
            _hydrateControllers(state.form);
            _syncRecurrenceController(state.form);
          }

          final spacing = theme.extension<Spacing>();
          final sections = theme.extension<KinlySections>();
          final SectionColors? flowColors = sections?.flow;
          final expectationPhotoUrl = sl<StoragePathResolver>().toPublicUrl(
            state.form.expectationPhotoPath,
          );

          final content = _buildContent(
            context: context,
            state: state,
            spacing: spacing,
            flowColors: flowColors,
            expectationPhotoUrl: expectationPhotoUrl,
            strings: s,
          );

          return KinlyScaffold(
            appBar: KinlyAppBar(
              title: Text(
                state.isEditMode
                    ? s.flowChoreEditTitle
                    : s.flowChoreCreateTitle,
              ),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsetsDirectional.all(spacing?.lg ?? 16),
                      child: content,
                    ),
                  ),
                  if (!state.isLoading && state.loadErrorMessage == null)
                    _ChoreActionBar(
                      state: state,
                      onSubmit:
                          () => context.read<FlowChoreBloc>().add(
                            const FlowChoreSubmitted(),
                          ),
                      onDeleteRequested:
                          state.isEditMode && state.canEditOrDelete
                              ? () => _confirmDelete(context)
                              : null,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showPhotoError(BuildContext context, FlowChoreState state) {
    final s = S.of(context);
    final isPermission = state.photoErrorMessage == 'permission';
    final snackText =
        isPermission
            ? s.flowChorePhotoPermissionDenied
            : s.flowChorePhotoUploadError;
    final accent =
        KinlyThemeAccess.of(context).extension<KinlySections>()?.flow.accent;
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

  Widget _buildContent({
    required BuildContext context,
    required FlowChoreState state,
    required Spacing? spacing,
    required SectionColors? flowColors,
    required String? expectationPhotoUrl,
    required S strings,
  }) {
    if (state.isLoading) {
      return const Center(child: KinlyLoader(size: 40));
    }
    if (state.loadErrorMessage != null) {
      return _FlowChoreError(
        message: strings.flowChoreLoadError,
        onRetry:
            () => context.read<FlowChoreBloc>().add(const FlowChoreStarted()),
      );
    }
    return KinlyScrollFade(
      child: _FlowChoreFormView(
        titleController: _titleController,
        notesController: _notesController,
        howToController: _howToController,
        state: state,
        spacing: spacing,
        flowColors: flowColors,
        isUploadingPhoto: state.isUploadingPhoto,
        expectationPhotoUrl: expectationPhotoUrl,
        recurrenceEveryController: _recurrenceEveryController,
        onPhotoCapture:
            () => context.read<FlowChoreBloc>().add(
              const FlowChorePhotoCaptureRequested(),
            ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final s = S.of(context);
    final shouldDelete = await showKinlyConfirmDialog(
      context,
      title: s.flowChoreDeleteDialogTitle,
      message: s.flowChoreDeleteDialogMessage,
      confirmLabel: s.flowChoreDeleteConfirm,
      destructive: true,
    );
    if (!context.mounted) return;
    if (shouldDelete == true) {
      context.read<FlowChoreBloc>().add(const FlowChoreDeleted());
    }
  }

  String _mapSubmissionError(BuildContext context, FlowChoreState state) {
    final s = S.of(context);
    final code = state.submissionErrorCode;
    const forbiddenCodes = {
      ChoreErrorCode.forbidden,
      ChoreErrorCode.unauthorized,
      ChoreErrorCode.notHomeMember,
    };
    final codeToMessage = {
      ChoreErrorCode.paywallActiveCap: s.flowChoreErrorPaywallActiveCap,
      ChoreErrorCode.paywallMediaCap: s.flowChoreErrorPaywallMediaCap,
      ChoreErrorCode.assigneeNotMember: s.flowChoreErrorAssigneeNotMember,
      ChoreErrorCode.invalidMediaPath: s.flowChoreErrorInvalidPhoto,
      ChoreErrorCode.invalidName: s.flowChoreValidationName,
      ChoreErrorCode.invalidStart: s.flowChoreErrorInvalidStart,
      ChoreErrorCode.invalidState: s.flowChoreErrorInvalidState,
    };

    if (code != null && codeToMessage.containsKey(code)) {
      return codeToMessage[code]!;
    }
    if (code != null && forbiddenCodes.contains(code)) {
      return s.flowChoreErrorForbidden;
    }

    return state.submissionErrorMessage ?? s.flowChoreErrorGeneric;
  }
}
