import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/contracts/preferences/ports/preference_reports_repository.dart';
import 'package:kinly/contracts/preferences/models.dart';
import 'package:kinly/core/theme/kinly_sections.dart';
import 'package:kinly/features/preferences/bloc/preference_report_cubit.dart';
import 'preference_report_screen.dart';

class PreferenceReportProvider extends StatelessWidget {
  const PreferenceReportProvider({
    super.key,
    required this.homeId,
    required this.subjectUserId,
    required this.repository,
    this.showConfetti = false,
    this.canEdit = true,
    this.popOnDone = false,
    this.initialReport,
    this.subjectDisplayName,
    this.subjectAvatarUrl,
  });

  final String homeId;
  final String subjectUserId;
  final PreferenceReportsRepository repository;
  final bool showConfetti;
  final bool canEdit;
  final bool popOnDone;
  final PreferenceReport? initialReport;
  final String? subjectDisplayName;
  final String? subjectAvatarUrl;

  @override
  Widget build(BuildContext context) {
    // Resolve preference palette early to align with the preference UI contract.
    final _ = context.preferenceSection;
    return BlocProvider(
      create: (_) {
        final cubit = PreferenceReportCubit(
          repository: repository,
          homeId: homeId,
          subjectUserId: subjectUserId,
          acknowledgeOnLoad: !canEdit,
          initialReport: initialReport,
        );
        if (initialReport == null) {
          cubit.load();
        }
        return cubit;
      },
      child: PreferenceReportScreen(
        showConfetti: showConfetti,
        canEdit: canEdit,
        popOnDone: popOnDone,
        subjectDisplayName: subjectDisplayName,
        subjectAvatarUrl: subjectAvatarUrl,
      ),
    );
  }
}
