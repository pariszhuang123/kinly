part of '../flow_chore_screen.dart';

class _ChoreActionBar extends StatelessWidget {
  const _ChoreActionBar({
    required this.state,
    required this.onSubmit,
    required this.onDeleteRequested,
  });

  final FlowChoreState state;
  final VoidCallback onSubmit;
  final VoidCallback? onDeleteRequested;

  @override
  Widget build(BuildContext context) {
    if (!state.canEditOrDelete) {
      return const SizedBox.shrink();
    }

    final vm = _ChoreActionBarViewModel.from(state);
    final s = S.of(context);

    final primary = KinlyActionButton(
      label: vm.primaryLabel(s),
      destructive: vm.isDeleteAction,
      busy: vm.isBusy,
      disabled: vm.shouldDisable,
      onPressed: vm.isDeleteAction ? onDeleteRequested : onSubmit,
    );

    return KinlyActionBar(primary: primary);
  }
}

class _ChoreActionBarViewModel {
  _ChoreActionBarViewModel({
    required this.isDeleteAction,
    required this.isBusy,
    required this.shouldDisable,
    required this.isEditing,
  });

  final bool isDeleteAction;
  final bool isBusy;
  final bool shouldDisable;
  final bool isEditing;

  factory _ChoreActionBarViewModel.from(FlowChoreState state) {
    final isDeleteAction = state.isEditMode && !state.hasChanges;
    final isBusy = state.isSubmitting || state.isDeleting;
    final shouldDisable = isBusy;

    return _ChoreActionBarViewModel(
      isDeleteAction: isDeleteAction,
      isBusy: isBusy,
      shouldDisable: shouldDisable,
      isEditing: state.isEditMode,
    );
  }

  String primaryLabel(S s) {
    if (isDeleteAction) return s.flowChoreDeleteButton;
    if (isEditing) return s.flowChoreSubmitUpdate;
    return s.flowChoreSubmitCreate;
  }
}
