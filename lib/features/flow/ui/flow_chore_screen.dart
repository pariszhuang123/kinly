import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/chores/models.dart';
import '../../../core/supabase/storage_path_resolver.dart';
import '../../../core/theme/kinly_sections.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/ui/buttons/kinly_filled_button.dart';
import '../../../core/ui/buttons/kinly_outlined_button.dart';
import '../../../core/ui/dialogs/kinly_dialogs.dart';
import '../../../core/ui/inputs/kinly_choice_chip.dart';
import '../../../core/ui/inputs/kinly_dropdown_field.dart';
import '../../../core/ui/inputs/kinly_text_field.dart';
import '../../../core/ui/kinly_circle_avatar.dart';
import '../../../core/ui/kinly_date_picker.dart';
import '../../../core/ui/kinly_loader.dart';
import '../../../core/ui/snackbars/kinly_snackbar.dart';
import '../../paywall/ui/paywall_screen.dart';
import '../../../core/ui/scroll/kinly_scroll_fade.dart';
import '../../../core/supabase/supabase_error_mapper.dart';
import '../../../generated/l10n.dart';
import '../bloc/flow_chore_bloc.dart';
import '../domain/flow_chore_form.dart';
import '../domain/flow_chore_outcome.dart';

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
  bool _hasHydratedControllers = false;

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    _howToController.dispose();
    super.dispose();
  }

  void _hydrateControllers(FlowChoreForm form) {
    if (_hasHydratedControllers) return;
    _titleController.text = form.title;
    _notesController.text = form.notes;
    _howToController.text = form.howToVideoUrl;
    _hasHydratedControllers = true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<FlowChoreBloc, FlowChoreState>(
      listenWhen:
          (previous, current) =>
              previous.successChoreId != current.successChoreId ||
              previous.submissionErrorTick != current.submissionErrorTick ||
              previous.photoErrorTick != current.photoErrorTick,
      listener: (context, state) {
        if (state.photoErrorTick > 0) {
          final s = S.of(context);
          final isPermission = state.photoErrorMessage == 'permission';
          final snackText =
              isPermission
                  ? s.flowChorePhotoPermissionDenied
                  : s.flowChorePhotoUploadError;
          KinlySnackBar.showError(
            context,
            snackText,
            actionLabel:
                state.isCameraPermissionPermanentlyDenied
                    ? s.flowChorePhotoPermissionOpenSettings
                    : null,
            onAction:
                state.isCameraPermissionPermanentlyDenied
                    ? openAppSettings
                    : null,
          );
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
          if (state.submissionErrorCode == ChoreErrorCode.paywallActiveCap ||
              state.submissionErrorCode == ChoreErrorCode.paywallMediaCap) {
            _showPaywallAndMaybeRetry(context);
            return;
          }
          final snackText = _mapSubmissionError(context, state);
          KinlySnackBar.showError(context, snackText);
        }
      },
      builder: (context, state) {
        if (!state.isLoading) {
          _hydrateControllers(state.form);
        }

        final s = S.of(context);
        final spacing = theme.extension<Spacing>();
        final sections = theme.extension<KinlySections>();
        final flowColors = sections?.flow;
        final expectationPhotoUrl = storagePathToPublicUrl(
          Supabase.instance.client,
          state.form.expectationPhotoPath,
        );

        Widget content;
        if (state.isLoading) {
          content = const Center(child: KinlyLoader(size: 40));
        } else if (state.loadErrorMessage != null) {
          content = _FlowChoreError(
            message: s.flowChoreLoadError,
            onRetry:
                () => context.read<FlowChoreBloc>().add(
                  const FlowChoreStarted(),
                ),
          );
        } else {
          content = KinlyScrollFade(
            child: _FlowChoreFormView(
              titleController: _titleController,
              notesController: _notesController,
              howToController: _howToController,
              state: state,
              spacing: spacing,
              flowColors: flowColors,
              isUploadingPhoto: state.isUploadingPhoto,
              expectationPhotoUrl: expectationPhotoUrl,
              onPhotoCapture:
                  () => context.read<FlowChoreBloc>().add(
                    const FlowChorePhotoCaptureRequested(),
                  ),
              onDeleteRequested:
                  state.isEditMode ? () => _confirmDelete(context) : null,
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              state.isEditMode ? s.flowChoreEditTitle : s.flowChoreCreateTitle,
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsetsDirectional.all(spacing?.lg ?? 16),
              child: content,
            ),
          ),
        );
      },
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
    switch (state.submissionErrorCode) {
      case ChoreErrorCode.paywallActiveCap:
        return s.flowChoreErrorPaywallActiveCap;
      case ChoreErrorCode.paywallMediaCap:
        return s.flowChoreErrorPaywallMediaCap;
      case ChoreErrorCode.assigneeNotMember:
        return s.flowChoreErrorAssigneeNotMember;
      case ChoreErrorCode.forbidden:
      case ChoreErrorCode.unauthorized:
      case ChoreErrorCode.notHomeMember:
        return s.flowChoreErrorForbidden;
      case ChoreErrorCode.invalidMediaPath:
        return s.flowChoreErrorInvalidPhoto;
      case ChoreErrorCode.invalidName:
        return s.flowChoreValidationName;
      case ChoreErrorCode.invalidStart:
        return s.flowChoreErrorInvalidStart;
      case ChoreErrorCode.invalidState:
        return s.flowChoreErrorInvalidState;
      default:
        return state.submissionErrorMessage ?? s.flowChoreErrorGeneric;
    }
  }

  Future<void> _showPaywallAndMaybeRetry(BuildContext context) async {
    final s = S.of(context);
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => KinlyPaywallScreen(
          homeId: widget.homeId,
          strings: PaywallStrings(
            title: s.paywallTitle,
            subtitle: s.paywallSubtitle,
            bulletMembers: s.paywallBulletMembers,
            bulletFlows: s.paywallBulletFlows,
            bulletPhotos: s.paywallBulletPhotos,
            bulletShares: s.paywallBulletShares,
            unlimitedLabel: s.paywallSubtitle,
            primaryCta: s.paywallPrimaryCta,
            secondaryCta: s.paywallSecondaryCta,
            purchaseFailed: s.paywallPurchaseFailed,
            purchaseSuccess: s.paywallPurchaseSuccess,
            restoreCta: s.paywallRestoreCta,
            errorTitle: s.paywallErrorTitle,
            retryLabel: s.paywallRetryLabel,
          ),
          source: 'flow_chore',
        ),
      ),
    );
    if (!context.mounted) return;
    if (result == true) {
      context.read<FlowChoreBloc>().add(const FlowChoreSubmitted());
    }
  }
}

class _FlowChoreFormView extends StatelessWidget {
  const _FlowChoreFormView({
    required this.titleController,
    required this.notesController,
    required this.howToController,
    required this.state,
    required this.spacing,
    required this.flowColors,
    required this.isUploadingPhoto,
    required this.expectationPhotoUrl,
    required this.onPhotoCapture,
    required this.onDeleteRequested,
  });

  final TextEditingController titleController;
  final TextEditingController notesController;
  final TextEditingController howToController;
  final FlowChoreState state;
  final Spacing? spacing;
  final SectionColors? flowColors;
  final bool isUploadingPhoto;
  final String? expectationPhotoUrl;
  final VoidCallback onPhotoCapture;
  final VoidCallback? onDeleteRequested;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final form = state.form;
    final showValidation = state.showValidationErrors;
    final requiresAssignee = state.requiresAssignee;
    final hasAssigneeError =
        showValidation && requiresAssignee && form.assigneeUserId == null;
    final hasDateError = showValidation && !state.isStartDateValid;
    final hasHowToError = showValidation && !form.isHowToUrlValid;
    final hasOptionalContent =
        form.notes.trim().isNotEmpty ||
        form.howToVideoUrl.trim().isNotEmpty ||
        form.expectationPhotoPath.trim().isNotEmpty;
    final expandOptional = hasOptionalContent || hasHowToError;
    final dateLabel = DateFormat.yMMMMd().format(form.startDate);
    final canSubmit = !state.isSubmitting;
    final showDeleteCta = state.isEditMode && !state.hasChanges;

    return ListView(
      children: [
        KinlyTextField(
          controller: titleController,
          labelText: s.flowChoreNameLabel,
          hintText: s.flowChoreNameHint,
          errorText:
              showValidation && !form.isTitleValid
                  ? s.flowChoreValidationName
                  : null,
          textInputAction: TextInputAction.next,
          onChanged:
              (value) => context.read<FlowChoreBloc>().add(
                FlowChoreTitleChanged(value),
              ),
        ),
        SizedBox(height: spacing?.lg ?? 16),
        Text(s.flowChoreAssigneeLabel, style: theme.textTheme.titleMedium),
        SizedBox(height: spacing?.sm ?? 8),
        _AssigneeChips(
          assignees: state.assignees,
          selectedUserId: form.assigneeUserId,
        ),
        if (hasAssigneeError)
          Padding(
            padding: EdgeInsets.only(top: spacing?.xs ?? 4),
            child: Text(
              s.flowChoreValidationAssignee,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
        SizedBox(height: spacing?.lg ?? 16),
        Text(s.flowChoreStartLabel, style: theme.textTheme.titleMedium),
        SizedBox(height: spacing?.xs ?? 4),
        KinlyOutlinedButton.text(
          onPressed: () => _pickStartDate(context, form.startDate),
          label: dateLabel,
        ),
        if (hasDateError)
          Padding(
            padding: EdgeInsets.only(top: spacing?.xs ?? 4),
            child: Text(
              s.flowChoreValidationDate,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
        SizedBox(height: spacing?.lg ?? 16),
        KinlyDropdownField<ChoreRecurrence>(
          value: form.recurrence,
          labelText: s.flowChoreRecurrenceLabel,
          items:
              ChoreRecurrence.values
                  .map(
                    (value) => DropdownMenuItem(
                      value: value,
                      child: Text(_recurrenceLabel(context, value)),
                    ),
                  )
                  .toList(),
          onChanged:
              (value) => context.read<FlowChoreBloc>().add(
                FlowChoreRecurrenceChanged(value!),
              ),
        ),
        SizedBox(height: spacing?.lg ?? 16),
        _OptionalDetailsExpansion(
          spacing: spacing,
          s: s,
          hasHowToError: hasHowToError,
          notesController: notesController,
          howToController: howToController,
          isUploadingPhoto: isUploadingPhoto,
          photoUrl: expectationPhotoUrl,
          onPhotoCapture: onPhotoCapture,
          initiallyExpanded: expandOptional,
        ),
        SizedBox(height: spacing?.xl ?? 24),
        SizedBox(
          width: double.infinity,
          child: _buildCtaButton(
            context: context,
            state: state,
            canSubmit: canSubmit,
            showDeleteCta: showDeleteCta,
            onDeleteRequested: onDeleteRequested,
          ),
        ),
      ],
    );
  }

  Future<void> _pickStartDate(BuildContext context, DateTime current) async {
    final now = DateTime.now();
    final earliestBase = DateTime(now.year - 10, now.month, now.day);
    final firstDate =
        current.isBefore(earliestBase)
            ? DateTime(current.year, current.month, current.day)
            : earliestBase;
    final lastDate = DateTime(now.year + 1, now.month, now.day);

    final picked = await showKinlyDatePicker(
      context: context,
      initialDate: current,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null && context.mounted) {
      context.read<FlowChoreBloc>().add(FlowChoreStartDateChanged(picked));
    }
  }

  Widget _buildCtaButton({
    required BuildContext context,
    required FlowChoreState state,
    required bool canSubmit,
    required bool showDeleteCta,
    required VoidCallback? onDeleteRequested,
  }) {
    final s = S.of(context);

    if (showDeleteCta) {
      Widget button = KinlyFilledButton.destructiveText(
        fullWidth: true,
        onPressed:
            state.isDeleting || onDeleteRequested == null
                ? null
                : onDeleteRequested,
        label: s.flowChoreDeleteButton,
      );
      if (state.isDeleting) {
        button = Stack(
          alignment: Alignment.center,
          children: [
            Opacity(opacity: 0.6, child: button),
            const SizedBox(height: 20, width: 20, child: KinlyLoader(size: 20)),
          ],
        );
      }
      return button;
    }

    final submitLabel =
        state.isEditMode ? s.flowChoreSubmitUpdate : s.flowChoreSubmitCreate;

    Widget button = KinlyFilledButton.text(
      fullWidth: true,
      onPressed:
          state.isSubmitting || !canSubmit
              ? null
              : () =>
                  context.read<FlowChoreBloc>().add(const FlowChoreSubmitted()),
      label: submitLabel,
    );
    if (state.isSubmitting) {
      button = Stack(
        alignment: Alignment.center,
        children: [
          Opacity(opacity: 0.6, child: button),
          const SizedBox(height: 20, width: 20, child: KinlyLoader(size: 20)),
        ],
      );
    }
    return button;
  }

  String _recurrenceLabel(BuildContext context, ChoreRecurrence recurrence) {
    final s = S.of(context);
    switch (recurrence) {
      case ChoreRecurrence.none:
        return s.flowChoreRecurrenceNone;
      case ChoreRecurrence.daily:
        return s.flowChoreRecurrenceDaily;
      case ChoreRecurrence.weekly:
        return s.flowChoreRecurrenceWeekly;
      case ChoreRecurrence.every2Weeks:
        return s.flowChoreRecurrenceEvery2Weeks;
      case ChoreRecurrence.monthly:
        return s.flowChoreRecurrenceMonthly;
      case ChoreRecurrence.every2Months:
        return s.flowChoreRecurrenceEvery2Months;
      case ChoreRecurrence.annual:
        return s.flowChoreRecurrenceAnnual;
    }
  }
}

class _AssigneeChips extends StatelessWidget {
  const _AssigneeChips({required this.assignees, required this.selectedUserId});

  final List<ChoreAssigneeSummary> assignees;
  final String? selectedUserId;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final spacing = Theme.of(context).extension<Spacing>();
    return Wrap(
      spacing: spacing?.sm ?? 8,
      runSpacing: spacing?.sm ?? 8,
      children: [
        KinlyChoiceChip(
          label: s.flowChoreAssigneeUnassigned,
          selected: selectedUserId == null,
          onSelected:
              (selected) =>
                  selected
                      ? context.read<FlowChoreBloc>().add(
                        const FlowChoreAssigneeChanged(null),
                      )
                      : null,
        ),
        for (final member in assignees)
          _AvatarChoice(
            avatarUrl: member.avatarStoragePath,
            isOwner: member.isOwner,
            selected: member.userId == selectedUserId,
            onTap:
                () => context.read<FlowChoreBloc>().add(
                  FlowChoreAssigneeChanged(member.userId),
                ),
          ),
      ],
    );
  }
}

class _AvatarChoice extends StatelessWidget {
  const _AvatarChoice({
    required this.avatarUrl,
    required this.isOwner,
    required this.selected,
    required this.onTap,
  });

  final String? avatarUrl;
  final bool isOwner;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = theme.extension<Spacing>();
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsetsDirectional.all(spacing?.xxs ?? 2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? colorScheme.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: KinlyCircleAvatar(
          avatarUrl: avatarUrl,
          radius: 22,
          isOwner: isOwner,
        ),
      ),
    );
  }
}

class _FlowChoreError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _FlowChoreError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          KinlyFilledButton.text(
            fullWidth: true,
            onPressed: onRetry,
            label: s.flowChoreRetry,
          ),
        ],
      ),
    );
  }
}

class _OptionalDetailsExpansion extends StatelessWidget {
  const _OptionalDetailsExpansion({
    required this.spacing,
    required this.s,
    required this.hasHowToError,
    required this.notesController,
    required this.howToController,
    required this.isUploadingPhoto,
    required this.photoUrl,
    required this.onPhotoCapture,
    this.initiallyExpanded = false,
  });

  final Spacing? spacing;
  final S s;
  final bool hasHowToError;
  final TextEditingController notesController;
  final TextEditingController howToController;
  final bool isUploadingPhoto;
  final String? photoUrl;
  final VoidCallback onPhotoCapture;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded || hasHowToError,
        title: Text(
          s.flowChoreDetailMoreInfoTitle,
          style: theme.textTheme.titleMedium,
        ),
        childrenPadding: EdgeInsetsDirectional.fromSTEB(
          16,
          0,
          16,
          spacing?.md ?? 16,
        ),
        children: [
          KinlyTextField(
            controller: notesController,
            minLines: 3,
            maxLines: 4,
            labelText: s.flowChoreNotesLabel,
            hintText: s.flowChoreNotesHint,
            onChanged:
                (value) => context.read<FlowChoreBloc>().add(
                  FlowChoreNotesChanged(value),
                ),
          ),
          SizedBox(height: spacing?.lg ?? 16),
          KinlyTextField(
            controller: howToController,
            labelText: s.flowChoreHowToLabel,
            hintText: s.flowChoreHowToHint,
            errorText: hasHowToError ? s.flowChoreValidationHowToUrl : null,
            keyboardType: TextInputType.url,
            onChanged:
                (value) => context.read<FlowChoreBloc>().add(
                  FlowChoreHowToChanged(value),
                ),
          ),
          SizedBox(height: spacing?.lg ?? 16),
          _ExpectationPhotoPicker(
            spacing: spacing,
            s: s,
            isUploading: isUploadingPhoto,
            photoUrl: photoUrl,
            onCapture: onPhotoCapture,
          ),
        ],
      ),
    );
  }
}

class _ExpectationPhotoPicker extends StatelessWidget {
  const _ExpectationPhotoPicker({
    required this.spacing,
    required this.s,
    required this.isUploading,
    required this.photoUrl,
    required this.onCapture,
  });

  final Spacing? spacing;
  final S s;
  final bool isUploading;
  final String? photoUrl;
  final VoidCallback onCapture;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasPhoto = photoUrl?.trim().isNotEmpty == true;

    final preview = Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child:
                hasPhoto && photoUrl != null
                    ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        photoUrl!,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) => Center(
                              child: Text(
                                s.flowChorePhotoLoadError,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.error,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                      ),
                    )
                    : Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.photo_camera_outlined,
                            size: 32,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            s.flowChorePhotoPlaceholder,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
          ),
          if (isUploading)
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(child: KinlyLoader(size: 32)),
            ),
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(s.flowChorePhotoLabel, style: theme.textTheme.titleMedium),
        SizedBox(height: spacing?.xs ?? 8),
        GestureDetector(
          onTap: isUploading ? null : onCapture,
          child: AspectRatio(aspectRatio: 4 / 3, child: preview),
        ),
      ],
    );
  }
}
