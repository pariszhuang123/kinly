import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/features/paywall/paywall.dart';

class PaywallGateListener<B extends StateStreamable<S>, S>
    extends StatelessWidget {
  const PaywallGateListener({
    super.key,
    required this.strings,
    required this.requestSelector,
    required this.inFlightRequestIdSelector,
    required this.onOpened,
    required this.onOutcome,
    required this.child,
  });

  final PaywallStrings strings;
  final PaywallGateRequest? Function(S state) requestSelector;
  final String? Function(S state) inFlightRequestIdSelector;
  final void Function(String requestId) onOpened;
  final void Function(PaywallGateOutcome outcome) onOutcome;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<B, S>(
      listenWhen: (previous, current) {
        final prevReq = requestSelector(previous);
        final currReq = requestSelector(current);

        final prevId = prevReq?.requestId;
        final currId = currReq?.requestId;
        final prevTick = prevReq?.tick ?? 0;
        final currTick = currReq?.tick ?? 0;

        final changed =
            currReq != null && (prevId != currId || prevTick != currTick);

        return changed;
      },
      listener: (context, state) async {
        final request = requestSelector(state);
        if (request == null) return;

        final inFlight = inFlightRequestIdSelector(state);
        if (inFlight == request.requestId) return;

        onOpened(request.requestId);

        final outcome = await showPaywallAndAwait(
          context: context,
          request: request,
          strings: strings,
        );

        if (!context.mounted) return;
        onOutcome(outcome);
      },
      child: child,
    );
  }
}
