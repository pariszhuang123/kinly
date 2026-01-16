import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/contracts/preferences/ports/preference_reports_repository.dart';
import 'package:kinly/core/theme/kinly_sections.dart';
import 'package:kinly/features/preferences/bloc/preference_report_cubit.dart';
import 'preference_report_edit_screen.dart';

class PreferenceReportEditProvider extends StatelessWidget {
  const PreferenceReportEditProvider({
    super.key,
    this.homeId,
    required this.subjectUserId,
    required this.repository,
    this.subjectDisplayName,
    this.subjectAvatarUrl,
    this.canEdit = true,
  });

  final String? homeId;
  final String subjectUserId;
  final PreferenceReportsRepository repository;
  final String? subjectDisplayName;
  final String? subjectAvatarUrl;
  final bool canEdit;

  @override
  Widget build(BuildContext context) {
    // Ensure preference palette is available for the downstream screen.
    final _ = context.preferenceSection;
    return BlocProvider(
      create:
          (_) => PreferenceReportCubit(
            repository: repository,
            homeId: homeId,
            subjectUserId: subjectUserId,
          )..load(),
      child: PreferenceReportEditScreen(
        subjectDisplayName: subjectDisplayName,
        subjectAvatarUrl: subjectAvatarUrl,
        canEdit: canEdit,
      ),
    );
  }
}
