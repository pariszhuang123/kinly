import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/supabase/supabase_error_mapper.dart';
import '../../../../core/theme/kinly_sections.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/ui/kinly_loader.dart';
import '../../../../core/ui/dialogs/kinly_dialogs.dart';
import '../../../../core/ui/snackbars/kinly_snackbar.dart';
import '../../../../generated/l10n.dart';
import '../../bloc/share_create_bloc/share_create_bloc.dart';
import '../../domain/share_create_form.dart';
import '../share_edit_outcome.dart';
import '../widgets/share_create_form_view.dart';
import '../widgets/share_create_error.dart';

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
          KinlySnackBar.showError(context, snackText);
        }

        if (state.deletionErrorTick > 0) {
          final message = state.deletionErrorMessage ?? s.shareEditDeleteError;
          KinlySnackBar.showError(context, message);
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
            // Delete now handled by primary button in the form.
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsetsDirectional.all(spacing.lg),
              child:
                  state.isLoading
                      ? const Center(child: KinlyLoader(size: 40))
                      : state.loadErrorMessage != null
                      ? ShareCreateError(
                        message: s.shareCreateLoadError,
                        onRetry:
                            () => context.read<ShareCreateBloc>().add(
                              const ShareCreateParticipantsRequested(),
                            ),
                      )
                      : ShareCreateFormView(
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
      cancelLabel: s.shareEditDeleteCancel,
      destructive: true,
    );

    if (shouldDelete == true && mounted) {
      bloc.add(const ShareCreateDeleted());
    }
  }
}
