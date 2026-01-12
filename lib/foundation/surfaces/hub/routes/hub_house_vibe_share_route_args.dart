import 'package:kinly/contracts/preferences/models.dart';
import 'package:kinly/core/theme/kinly_sections.dart';
import 'package:kinly/foundation/surfaces/hub/bloc/hub_bloc.dart';

class HubHouseVibeShareArgs {
  const HubHouseVibeShareArgs({
    required this.vibe,
    required this.palette,
    required this.hubBloc,
  });

  final HouseVibePayload vibe;
  final SectionColors palette;
  final HubBloc hubBloc;
}
