import 'package:kinly/contracts/preferences/models.dart';

class PreferenceReportNavigationArgs {
  const PreferenceReportNavigationArgs({
    this.showConfetti = false,
    this.initialReport,
  });

  final bool showConfetti;
  final PreferenceReport? initialReport;
}
