part of 'preference_report_cubit.dart';

enum PreferenceReportStatus { loading, ready, empty, failure }

class PreferenceReportState extends Equatable {
  const PreferenceReportState._({
    required this.status,
    this.report,
    this.errorMessage,
  });

  const PreferenceReportState.loading()
    : this._(status: PreferenceReportStatus.loading);

  const PreferenceReportState.empty()
    : this._(status: PreferenceReportStatus.empty);

  const PreferenceReportState.ready(PreferenceReport report)
    : this._(status: PreferenceReportStatus.ready, report: report);

  const PreferenceReportState.failure(String message)
    : this._(status: PreferenceReportStatus.failure, errorMessage: message);

  final PreferenceReportStatus status;
  final PreferenceReport? report;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, report, errorMessage];
}
