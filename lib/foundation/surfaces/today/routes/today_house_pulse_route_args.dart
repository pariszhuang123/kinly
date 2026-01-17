import 'package:kinly/contracts/mood/house_pulse_models.dart';
import 'package:kinly/foundation/surfaces/today/bloc/today_bloc.dart';

class TodayHousePulseRouteArgs {
  TodayHousePulseRouteArgs({required this.pulse, required this.todayBloc});

  final HousePulsePayload pulse;
  final TodayBloc todayBloc;
}
