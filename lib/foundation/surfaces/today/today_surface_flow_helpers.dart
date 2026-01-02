part of 'today_surface.dart';

void _openFlowListImpl(BuildContext context, FlowListFilter filter) {
  final filterParam = filter.toQueryParam();
  context.push('${AppRoutes.flow}?filter=$filterParam&scope=mine').then((_) {
    if (context.mounted) {
      context.read<TodayBloc>().add(const TodayRefreshed());
    }
  });
}

Future<void> _openFlowChoreImpl(BuildContext context, {String? choreId}) async {
  final path =
      choreId == null
          ? AppRoutes.flowChoreCreate
          : AppRoutes.flowChoreEditPath(choreId);
  final result = await context.push(path);
  if (result is FlowChoreOutcome) {
    if (!context.mounted) return;
    final s = S.of(context);
    final accent = Theme.of(context).extension<KinlySections>()?.flow.accent;
    if (result.isUpdate) {
      KinlySnackBar.showSuccess(
        context,
        s.flowChoreUpdateSuccess,
        accentColor: accent,
      );
    } else if (!result.isDeleted && !result.isCompleted) {
      KinlySnackBar.showSuccess(
        context,
        s.flowChoreCreateSuccess,
        accentColor: accent,
      );
    }
    context.read<TodayBloc>().add(const TodayRefreshed());
  }
}

Future<void> _openFlowChoreDetailImpl(
  BuildContext context, {
  required String choreId,
}) async {
  final result = await context.push(AppRoutes.flowChoreDetailPath(choreId));
  if (result is FlowChoreOutcome) {
    if (!context.mounted) return;
    if (result.isCompleted) {
      final s = S.of(context);
      final accent = Theme.of(context).extension<KinlySections>()?.flow.accent;
      KinlySnackBar.showSuccess(
        context,
        s.flowChoreDetailCompletionSuccess,
        accentColor: accent,
      );
    }
    context.read<TodayBloc>().add(const TodayRefreshed());
  }
}
