part of 'paywall_bloc.dart';

abstract class PaywallEvent extends Equatable {
  const PaywallEvent();
}

class PaywallStarted extends PaywallEvent {
  const PaywallStarted({this.source, this.triggers = const {}});
  final String? source;
  final Set<PaywallTrigger> triggers;

  @override
  List<Object?> get props => [source, triggers];
}

class PaywallCtaPressed extends PaywallEvent {
  const PaywallCtaPressed({this.locale, this.email, this.source});
  final String? locale;
  final String? email;
  final String? source;

  @override
  List<Object?> get props => [locale, email, source];
}

class PaywallRestorePressed extends PaywallEvent {
  const PaywallRestorePressed({this.source});
  final String? source;

  @override
  List<Object?> get props => [source];
}

class PaywallDismissed extends PaywallEvent {
  const PaywallDismissed({this.source});
  final String? source;

  @override
  List<Object?> get props => [source];
}
