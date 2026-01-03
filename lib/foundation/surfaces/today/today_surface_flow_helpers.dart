part of 'today_surface.dart';

void _openFlowListImpl(BuildContext context, FlowListFilter filter) {
  final filterParam = filter.toQueryParam();
  context
      .pushNamed(
        AppRouteNames.flow,
        queryParameters: {'filter': filterParam, 'scope': 'mine'},
      )
      .then((_) {
        if (context.mounted) {
          context.read<TodayBloc>().add(const TodayRefreshed());
        }
      });
}

Future<void> _openFlowChoreImpl(BuildContext context, {String? choreId}) async {
  if (choreId == null) {
    final result = await context.pushNamed(AppRouteNames.flowChoreCreate);
    if (!context.mounted) return;
    _handleFlowChoreOutcome(context, result);
    return;
  }

  final result = await context.pushNamed(
    AppRouteNames.flowChoreEdit,
    pathParameters: {'choreId': choreId},
  );
  if (!context.mounted) return;
  _handleFlowChoreOutcome(context, result);
}

Future<void> _openFlowChoreDetailImpl(
  BuildContext context, {
  required String choreId,
}) async {
  final result = await context.pushNamed(
    AppRouteNames.flowChoreDetail,
    pathParameters: {'choreId': choreId},
  );
  if (!context.mounted) return;
  if (result is FlowChoreOutcome) {
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

void _handleFlowChoreOutcome(BuildContext context, Object? result) {
  if (result is! FlowChoreOutcome) return;
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
