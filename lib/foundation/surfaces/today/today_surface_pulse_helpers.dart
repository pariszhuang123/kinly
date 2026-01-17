part of 'today_surface.dart';

Future<void> _openHousePulseDetail(BuildContext context) async {
  final bloc = context.read<TodayBloc>();
  final pulse = bloc.state.housePulse;
  if (pulse == null) return;
  bloc.add(const TodayHousePulseViewed());
  await context.pushNamed(
    AppRouteNames.todayHousePulse,
    extra: TodayHousePulseRouteArgs(
      pulse: pulse,
      todayBloc: bloc,
    ),
  );
}
