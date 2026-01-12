import 'package:kinly/contracts/homes/models.dart';
import 'package:kinly/contracts/preferences/models.dart';
import 'package:kinly/core/theme/kinly_sections.dart';
import '../bloc/hub_bloc.dart';

class HubPreferencesListArgs {
  const HubPreferencesListArgs({
    required this.members,
    required this.palette,
    required this.currentUserId,
    required this.houseVibe,
    required this.hubBloc,
  });

  final List<HomeMemberSummary> members;
  final SectionColors palette;
  final String currentUserId;
  final HouseVibePayload? houseVibe;
  final HubBloc hubBloc;
}
