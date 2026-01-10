import 'package:kinly/contracts/homes/models.dart';
import 'package:kinly/core/theme/kinly_sections.dart';

class HubPreferencesListArgs {
  const HubPreferencesListArgs({
    required this.members,
    required this.palette,
  });

  final List<HomeMemberSummary> members;
  final SectionColors palette;
}
