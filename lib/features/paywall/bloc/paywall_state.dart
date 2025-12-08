part of 'paywall_bloc.dart';

enum PaywallLoadStatus { initial, loading, ready, error }
enum PaywallActionStatus { idle, purchasing, restoring, success }

class PaywallState extends Equatable {
  final PaywallLoadStatus status;
  final PaywallActionStatus actionStatus;
  final PaywallStatus? paywallStatus;
  final RevenueCatPackage? package;
  final String? error;

  const PaywallState({
    required this.status,
    required this.actionStatus,
    required this.paywallStatus,
    required this.package,
    required this.error,
  });

  const PaywallState.initial()
      : status = PaywallLoadStatus.initial,
        actionStatus = PaywallActionStatus.idle,
        paywallStatus = null,
        package = null,
        error = null;

  bool get isActionInFlight =>
      actionStatus == PaywallActionStatus.purchasing ||
      actionStatus == PaywallActionStatus.restoring;

  PaywallState copyWith({
    PaywallLoadStatus? status,
    PaywallActionStatus? actionStatus,
    PaywallStatus? paywallStatus,
    RevenueCatPackage? package,
    String? error,
  }) {
    return PaywallState(
      status: status ?? this.status,
      actionStatus: actionStatus ?? this.actionStatus,
      paywallStatus: paywallStatus ?? this.paywallStatus,
      package: package ?? this.package,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        status,
        actionStatus,
        paywallStatus,
        package,
        error,
      ];
}
