part of 'today_surface.dart';

void _openFlowListImpl(BuildContext context, FlowListFilter filter) {
  final filterParam = filter.toQueryParam();
  final todayBloc = context.read<TodayBloc>();
  final homeId = todayBloc.homeId;
  final userId = todayBloc.state.profile?.userId;
  final query = <String, String>{'filter': filterParam, 'scope': 'mine', 'homeId': homeId};
  if (userId != null && userId.isNotEmpty) {
    query['userId'] = userId;
  }
  context
      .pushNamed(
        AppRouteNames.flow,
        queryParameters: query,
      )
      .then((_) {
        if (context.mounted) {
          context.read<TodayBloc>().add(const TodayRefreshed());
        }
      });
}

Future<void> _openFlowChoreImpl(BuildContext context, {String? choreId}) async {
  final homeId = context.read<TodayBloc>().homeId;
  if (choreId == null) {
    final result = await context.pushNamed(
      AppRouteNames.flowChoreCreate,
      queryParameters: {'homeId': homeId},
    );
    if (!context.mounted) return;
    _handleFlowChoreOutcome(context, result);
    return;
  }

  final result = await context.pushNamed(
    AppRouteNames.flowChoreEdit,
    pathParameters: {'choreId': choreId},
    queryParameters: {'homeId': homeId},
  );
  if (!context.mounted) return;
  _handleFlowChoreOutcome(context, result);
}

Future<void> _openFlowChoreDetailImpl(
  BuildContext context, {
  required String choreId,
}) async {
  final homeId = context.read<TodayBloc>().homeId;
  final result = await context.pushNamed(
    AppRouteNames.flowChoreDetail,
    pathParameters: {'choreId': choreId},
    queryParameters: {'homeId': homeId},
  );
  if (!context.mounted) return;
  if (result is FlowChoreOutcome) {
    if (result.isCompleted) {
      final s = S.of(context);
      final accent =
          KinlyThemeAccess.of(context).extension<KinlySections>()?.flow.accent;
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
  final accent =
      KinlyThemeAccess.of(context).extension<KinlySections>()?.flow.accent;
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
