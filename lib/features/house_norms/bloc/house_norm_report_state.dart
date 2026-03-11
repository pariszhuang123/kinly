part of 'house_norm_report_cubit.dart';

enum HouseNormReportStatus { loading, ready, busy, empty, failure }

class HouseNormReportState extends Equatable {
  const HouseNormReportState._({
    required this.status,
    required this.isOwner,
    this.document,
    this.errorMessage,
    this.publishError,
  });

  const HouseNormReportState.loading({required bool isOwner})
    : this._(status: HouseNormReportStatus.loading, isOwner: isOwner);

  const HouseNormReportState.empty({required bool isOwner})
    : this._(status: HouseNormReportStatus.empty, isOwner: isOwner);

  const HouseNormReportState.ready(
    HouseNormDocument document, {
    required bool isOwner,
    String? publishError,
  }) : this._(
         status: HouseNormReportStatus.ready,
         document: document,
         isOwner: isOwner,
         publishError: publishError,
       );

  const HouseNormReportState.busy(
    HouseNormDocument document, {
    required bool isOwner,
  }) : this._(
         status: HouseNormReportStatus.busy,
         document: document,
         isOwner: isOwner,
       );

  const HouseNormReportState.failure(
    String message, {
    required bool isOwner,
  }) : this._(
         status: HouseNormReportStatus.failure,
         errorMessage: message,
         isOwner: isOwner,
       );

  final HouseNormReportStatus status;
  final bool isOwner;
  final HouseNormDocument? document;
  final String? errorMessage;

  /// Non-null when a publish attempt failed but the document is still valid.
  final String? publishError;

  bool get isLoading => status == HouseNormReportStatus.loading;
  bool get isBusy => status == HouseNormReportStatus.busy;

  @override
  List<Object?> get props => [status, isOwner, document, errorMessage, publishError];
}
