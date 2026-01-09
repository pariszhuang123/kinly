import 'package:flutter/widgets.dart';

import '../../bloc/share_create_bloc/share_create_bloc.dart';
import '../../../../core/ui/action_bar/kinly_action_bar.dart';
import '../../../../core/ui/enums/kinly_action_button_varient.dart';
import '../../../../generated/l10n.dart';

class ShareCreateActionBar extends StatelessWidget {
  const ShareCreateActionBar({
    super.key,
    required this.state,
    required this.allowDelete,
    required this.onDeleteRequested,
    required this.onSubmit,
    required this.showTerminatePlan,
    required this.isTerminatingPlan,
    required this.onTerminatePlan,
    required this.onPaywallOpened,
  });

  final ShareCreateState state;
  final bool allowDelete;
  final VoidCallback? onDeleteRequested;
  final VoidCallback onSubmit;
  final bool showTerminatePlan;
  final bool isTerminatingPlan;
  final VoidCallback onTerminatePlan;
  final VoidCallback? onPaywallOpened;

  @override
  Widget build(BuildContext context) {
    final vm = _ActionBarViewModel.from(state: state, allowDelete: allowDelete);
    final s = S.of(context);

    KinlyActionButton primary;
    KinlyActionButton? secondary;

    if (showTerminatePlan) {
      primary = KinlyActionButton(
        label:
            isTerminatingPlan
                ? s.shareEditTerminatePlanBusy
                : s.shareEditTerminatePlan,
        onPressed: isTerminatingPlan ? null : onTerminatePlan,
        destructive: true,
      );
    } else {
      primary = KinlyActionButton(
        label: vm.primaryLabel(s),
        destructive: vm.isDeleteAction,
        busy: vm.isBusy,
        disabled: vm.shouldDisable,
        onPressed: vm.isDeleteAction ? onDeleteRequested : onSubmit,
      );

      if (vm.shouldOpenPaywall && onPaywallOpened != null) {
        secondary = KinlyActionButton(
          label: s.paywallPrimaryCta,
          onPressed: onPaywallOpened,
          variant: KinlyActionButtonVariant.outlined,
        );
      }
    }

    return KinlyActionBar(primary: primary, secondary: secondary);
  }
}

class _ActionBarViewModel {
  _ActionBarViewModel({
    required this.isDeleteAction,
    required this.shouldDisable,
    required this.isBusy,
    required this.shouldOpenPaywall,
    required this.isEditing,
  });

  final bool isDeleteAction;
  final bool shouldDisable;
  final bool isBusy;
  final bool shouldOpenPaywall;
  final bool isEditing;

  factory _ActionBarViewModel.from({
    required ShareCreateState state,
    required bool allowDelete,
  }) {
    final editingDisabled = _isEditingDisabled(state);
    final locked = _isLocked(state, editingDisabled);
    final fullyPaid = state.allPaid;
    final canDelete = _canDelete(
      state,
      allowDelete: allowDelete,
      locked: locked,
      fullyPaid: fullyPaid,
      editingDisabled: editingDisabled,
    );
    final shouldDisable = _shouldDisable(
      state,
      editingDisabled: editingDisabled,
      canDelete: canDelete,
    );
    final shouldOpenPaywall = _shouldOpenPaywall(state);

    return _ActionBarViewModel(
      isDeleteAction: canDelete,
      shouldDisable: shouldDisable,
      isBusy: _isBusy(state),
      shouldOpenPaywall: shouldOpenPaywall,
      isEditing: state.isEditing,
    );
  }

  String primaryLabel(S s) {
    if (isDeleteAction) return s.shareEditDeleteButton;
    if (isEditing) return s.shareEditSubmit;
    return s.shareCreateSubmit;
  }
}

bool _isEditingDisabled(ShareCreateState state) =>
    state.isEditing && !state.canEdit;

bool _isLocked(ShareCreateState state, bool editingDisabled) =>
    state.isAmountLocked || editingDisabled;

bool _canDelete(
  ShareCreateState state, {
  required bool allowDelete,
  required bool locked,
  required bool fullyPaid,
  required bool editingDisabled,
}) {
  final deleteBlocked = state.paidByOther || locked || fullyPaid;
  final isPristineEdit = state.isEditing && !state.hasUserEdits;
  return allowDelete && isPristineEdit && !deleteBlocked && !editingDisabled;
}

bool _isBusy(ShareCreateState state) => state.isSubmitting || state.isDeleting;

bool _shouldDisable(
  ShareCreateState state, {
  required bool editingDisabled,
  required bool canDelete,
}) =>
    _isBusy(state) ||
    editingDisabled ||
    (!canDelete && state.isEditing && state.form.splitMode == null);

bool _shouldOpenPaywall(ShareCreateState state) =>
    state.paywallRequest != null && state.paywallInFlightRequestId == null;
