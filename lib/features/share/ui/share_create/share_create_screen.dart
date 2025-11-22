import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/supabase/supabase_error_mapper.dart';
import '../../../../core/theme/kinly_sections.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/ui/kinly_circle_avatar.dart';
import '../../../../core/ui/kinly_loader.dart';
import '../../../../generated/l10n.dart';
import '../../bloc/share_create_bloc/share_create_bloc.dart';
import '../../domain/share_create_form.dart';
import '../../domain/share_participant.dart';
import '../../domain/share_split_mode.dart';
import '../share_edit_outcome.dart';

class ShareCreateScreen extends StatefulWidget {
  const ShareCreateScreen({super.key, this.allowDelete = false});

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

    return BlocConsumer<ShareCreateBloc, ShareCreateState>(
      listenWhen:
          (previous, current) =>
              previous.successExpenseId != current.successExpenseId ||
              previous.submissionErrorTick != current.submissionErrorTick ||
              previous.deletionErrorTick != current.deletionErrorTick ||
              previous.deletionSuccessTick != current.deletionSuccessTick,
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
          final snackText = _mapSubmissionError(context, state);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(snackText)));
        }
        if (state.deletionErrorTick > 0) {
          final message = state.deletionErrorMessage ?? s.shareEditDeleteError;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
        }
      },
      builder: (context, state) {
        _hydrateBaseControllers(state.form);
        _syncCustomControllers(state);
        final s = S.of(context);

        return Scaffold(
          appBar: AppBar(
            title: Text(
              state.isEditing ? s.shareEditTitle : s.shareCreateTitle,
            ),
            // 👇 AppBar delete button removed – primary button handles delete now
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(spacing.lg),
              child:
                  state.isLoading
                      ? const Center(child: KinlyLoader(size: 40))
                      : state.loadErrorMessage != null
                      ? _ShareCreateError(
                        message: s.shareCreateLoadError,
                        onRetry:
                            () => context.read<ShareCreateBloc>().add(
                              const ShareCreateParticipantsRequested(),
                            ),
                      )
                      : _ShareCreateForm(
                        state: state,
                        shareColors: shareColors,
                        descriptionController: _descriptionController,
                        amountController: _amountController,
                        notesController: _notesController,
                        customControllers: _customControllers,
                        allowDelete: widget.allowDelete,
                        onDeleteRequested:
                            widget.allowDelete
                                ? () => _confirmDelete(context)
                                : null,
                      ),
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
    final theme = Theme.of(context);
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(s.shareEditDeleteConfirmTitle),
          content: Text(s.shareEditDeleteConfirmMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(s.shareEditDeleteCancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                foregroundColor: theme.colorScheme.onError,
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(s.shareEditDeleteConfirm),
            ),
          ],
        );
      },
    );
    if (shouldDelete == true && mounted) {
      bloc.add(const ShareCreateDeleted());
    }
  }
}

class _ShareCreateForm extends StatelessWidget {
  const _ShareCreateForm({
    required this.state,
    required this.shareColors,
    required this.descriptionController,
    required this.amountController,
    required this.notesController,
    required this.customControllers,
    required this.allowDelete,
    required this.onDeleteRequested,
  });

  final ShareCreateState state;
  final SectionColors? shareColors;
  final TextEditingController descriptionController;
  final TextEditingController amountController;
  final TextEditingController notesController;
  final Map<String, TextEditingController> customControllers;

  /// Whether delete is allowed at all for this screen
  final bool allowDelete;

  /// Callback to trigger delete (shows confirm dialog + dispatches event)
  final VoidCallback? onDeleteRequested;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;
    final showValidation = state.showValidationErrors;
    final customSummary = state.evaluateCustomSplit();
    final locked = state.isAmountLocked;

    // ------------------------------------------------------------------
    // Primary button behaviour:
    // - Create mode: always "Create"
    // - Edit, pristine, allowDelete: "Delete" (no edits made yet)
    // - Edit, dirty: "Update"
    // ------------------------------------------------------------------
    final isEditing = state.isEditing;
    final isPristineEdit = isEditing && !state.hasUserEdits;
    final canDelete = allowDelete && isPristineEdit;

    final String primaryLabel;
    if (!isEditing) {
      primaryLabel = s.shareCreateSubmit;
    } else if (canDelete) {
      primaryLabel = s.shareEditDeleteButton; // e.g. "Delete"
    } else {
      primaryLabel = s.shareEditSubmit; // e.g. "Update"
    }

    final bool shouldDisable =
        state.isSubmitting ||
        state.isDeleting ||
        // Only require splitMode when doing create/update.
        (!canDelete && isEditing && state.form.splitMode == null);

    void handlePrimaryPressed() {
      if (shouldDisable) return;
      if (canDelete) {
        onDeleteRequested?.call();
      } else {
        context.read<ShareCreateBloc>().add(const ShareCreateSubmitted());
      }
    }

    return ListView(
      children: [
        TextField(
          controller: descriptionController,
          decoration: InputDecoration(
            labelText: s.shareCreateDescriptionLabel,
            hintText: s.shareCreateDescriptionHint,
            errorText:
                showValidation && !state.form.hasValidDescription
                    ? s.shareCreateValidationDescription
                    : null,
          ),
          onChanged:
              (value) => context.read<ShareCreateBloc>().add(
                ShareCreateDescriptionChanged(value),
              ),
        ),
        SizedBox(height: spacing.lg),
        TextField(
          controller: amountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          enabled: !locked,
          decoration: InputDecoration(
            labelText: s.shareCreateAmountLabel,
            hintText: s.shareCreateAmountHint,
            errorText:
                showValidation &&
                        (state.form.amountCents == null ||
                            state.form.amountCents! <= 0)
                    ? s.shareCreateValidationAmount
                    : null,
          ),
          onChanged:
              (value) => context.read<ShareCreateBloc>().add(
                ShareCreateAmountChanged(value),
              ),
        ),
        SizedBox(height: spacing.lg),
        Text(s.shareCreateSplitLabel, style: theme.textTheme.titleMedium),
        SizedBox(height: spacing.sm),
        SegmentedButton<ShareSplitMode>(
          showSelectedIcon: false,
          emptySelectionAllowed: true,
          segments: [
            ButtonSegment(
              value: ShareSplitMode.equal,
              label: Text(s.shareCreateSplitEqual),
            ),
            ButtonSegment(
              value: ShareSplitMode.custom,
              label: Text(s.shareCreateSplitCustom),
            ),
          ],
          selected:
              state.form.splitMode != null
                  ? {state.form.splitMode!}
                  : <ShareSplitMode>{},
          onSelectionChanged:
              locked
                  ? null
                  : (selection) {
                    if (selection.isEmpty) return;
                    context.read<ShareCreateBloc>().add(
                      ShareCreateSplitModeChanged(selection.first),
                    );
                  },
        ),
        SizedBox(height: spacing.lg),
        Text(
          s.shareCreateParticipantsLabel,
          style: theme.textTheme.titleMedium,
        ),
        SizedBox(height: spacing.sm),
        if (state.participants.isEmpty)
          Text(
            s.shareCreateParticipantsEmpty,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          )
        else
          _buildParticipantsSection(
            context,
            shareColors,
            spacing,
            customSummary,
            showValidation,
            locked,
          ),
        SizedBox(height: spacing.lg),
        TextField(
          controller: notesController,
          minLines: 3,
          maxLines: 4,
          decoration: InputDecoration(
            labelText: s.shareCreateNotesLabel,
            hintText: s.shareCreateNotesHint,
          ),
          onChanged:
              (value) => context.read<ShareCreateBloc>().add(
                ShareCreateNotesChanged(value),
              ),
        ),
        SizedBox(height: spacing.xl),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style:
                shareColors != null
                    ? ElevatedButton.styleFrom(
                      backgroundColor: shareColors!.accent,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    )
                    : null,
            onPressed: shouldDisable ? null : handlePrimaryPressed,
            child:
                state.isSubmitting || state.isDeleting
                    ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: KinlyLoader(size: 20),
                    )
                    : Text(primaryLabel),
          ),
        ),
      ],
    );
  }

  Widget _buildParticipantsSection(
    BuildContext context,
    SectionColors? shareColors,
    Spacing spacing,
    ShareCustomSplitSummary customSummary,
    bool showValidation,
    bool locked,
  ) {
    final theme = Theme.of(context);
    final s = S.of(context);
    final splitMode = state.form.splitMode;

    if (splitMode == null) {
      return const SizedBox.shrink();
    }

    if (splitMode == ShareSplitMode.custom) {
      final errorText = _customErrorText(s, customSummary, showValidation);
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
              enabled: !locked && isSelected,
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
        Wrap(
          spacing: spacing.sm,
          runSpacing: spacing.sm,
          children:
              state.participants.map((participant) {
                final isSelected = state.form.selectedParticipantIds.contains(
                  participant.userId,
                );
                return FilterChip(
                  label: Text(participant.displayName),
                  selected: isSelected,
                  onSelected:
                      locked
                          ? null
                          : (selected) => context.read<ShareCreateBloc>().add(
                            ShareCreateParticipantToggled(
                              participant.userId,
                              selected,
                            ),
                          ),
                  avatar: KinlyCircleAvatar(
                    avatarUrl: participant.avatarUrl,
                    radius: 16,
                  ),
                  selectedColor: shareColors?.accent.withValues(alpha: .18),
                  checkmarkColor: shareColors?.icon,
                );
              }).toList(),
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
  ) {
    if (!showValidation) return null;
    if (summary.missingTotal) return s.shareCreateValidationAmount;
    if (summary.hasInvalidAmounts) return s.shareCreateValidationCustomAmounts;
    if (summary.hasInsufficientParticipants) {
      return s.shareCreateValidationCustomParticipants;
    }
    if (!summary.sumMatchesTotal) return s.shareCreateValidationCustomSum;
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
    required this.enabled,
    required this.onToggled,
    required this.onAmountChanged,
  });

  final ShareParticipant participant;
  final TextEditingController controller;
  final bool selected;
  final bool enabled;
  final ValueChanged<bool>? onToggled;
  final ValueChanged<String>? onAmountChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;
    final s = S.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: spacing.sm),
      padding: EdgeInsets.all(spacing.sm),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: theme.colorScheme.surfaceContainerHighest,
      ),
      child: Row(
        children: [
          Checkbox(
            value: selected,
            onChanged:
                enabled ? (value) => onToggled?.call(value ?? false) : null,
          ),
          KinlyCircleAvatar(avatarUrl: participant.avatarUrl, radius: 20),
          SizedBox(width: spacing.sm),
          Expanded(
            child: Text(
              participant.displayName,
              style: theme.textTheme.bodyLarge,
            ),
          ),
          SizedBox(
            width: 110,
            child: TextField(
              controller: controller,
              enabled: enabled,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: s.shareCreateCustomAmountLabel,
              ),
              onChanged: onAmountChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _ShareCreateError extends StatelessWidget {
  const _ShareCreateError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;
    final s = S.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing.md),
          ElevatedButton(onPressed: onRetry, child: Text(s.shareCreateRetry)),
        ],
      ),
    );
  }
}

Color _validationColor(ThemeData theme) {
  final scheme = theme.colorScheme;
  if (theme.brightness == Brightness.dark) {
    return scheme.onErrorContainer;
  }
  return scheme.error;
}
