import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/contracts/preferences/ports/preference_reports_repository.dart';
import 'package:kinly/features/preferences/bloc/preference_report_cubit.dart';
import 'preference_report_edit_screen.dart';

class PreferenceReportEditProvider extends StatelessWidget {
  const PreferenceReportEditProvider({
    super.key,
    required this.homeId,
    required this.subjectUserId,
    required this.repository,
  });

  final String homeId;
  final String subjectUserId;
  final PreferenceReportsRepository repository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              PreferenceReportCubit(
                  repository: repository,
                  homeId: homeId,
                  subjectUserId: subjectUserId,
                )
                ..load(),
      child: const PreferenceReportEditScreen(),
    );
  }
}
