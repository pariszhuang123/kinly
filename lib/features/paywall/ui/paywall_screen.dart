import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/core/di/locator.dart';
import 'package:kinly/contracts/homes/ports/home_repository.dart';
import 'package:kinly/core/logging/logger.dart';
import 'package:kinly/contracts/paywall/enums/paywall_trigger.dart';
import 'package:kinly/core/purchases/revenuecat_service.dart';
import 'package:kinly/core/theme/typography_tokens.dart';
import 'package:kinly/core/ui/snackbars/kinly_snackbar.dart';
import 'package:kinly/contracts/auth/ports/auth_repository.dart';
import 'package:kinly/features/paywall/paywall.dart';
import '../bloc/paywall_bloc.dart';
import '../../../core/ui/kinly_scaffold.dart';
import '../../../core/ui/kinly_app_bar.dart';
import '../../../core/ui/kinly_theme_access.dart';
import '../../../core/ui/kinly_icon_button.dart';
import '../../../core/ui/kinly_icons.dart';

class KinlyPaywallScreen extends StatelessWidget {
  const KinlyPaywallScreen({
    super.key,
    required this.homeId,
    required this.strings,
    this.source,
    this.placementId,
    this.triggers = const {},
  });

  final String homeId;
  final PaywallStrings strings;
  final String? source;
  final String? placementId;
  final Set<PaywallTrigger> triggers;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => PaywallBloc(
            paywallRepository: sl<PaywallRepository>(),
            revenueCatService: sl<RevenueCatService>(),
            authRepository: sl<AuthRepository>(),
            homeRepository: sl<HomeRepository>(),
            homeId: homeId,
            logger: sl<Logger>(),
            placementId: placementId,
          )..add(PaywallStarted(source: source, triggers: triggers)),
      child: Builder(
        builder: (context) {
          final theme = KinlyThemeAccess.of(context);
          final typography = theme.extension<KinlyTypography>()!;
          PaywallRegistry.bootstrap();
          final orderedBenefits = orderPaywallBenefits(
            strings: strings,
            triggers: triggers,
          );

          void handleDismiss() {
            context.read<PaywallBloc>().add(const PaywallDismissed());
            Navigator.of(context).pop(false);
          }

          return KinlyScaffold(
            appBar: KinlyAppBar(
              title: Text(
                strings.title,
                style: typography.titleSmall.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              automaticallyImplyLeading: false,
              actions: [
                KinlyIconButton(
                  tooltip: strings.secondaryCta,
                  icon: KinlyIcons.closeRounded,
                  onPressed: handleDismiss,
                ),
              ],
            ),
            body: SafeArea(
              child: BlocConsumer<PaywallBloc, PaywallState>(
                listenWhen:
                    (prev, next) =>
                        prev.actionStatus != next.actionStatus ||
                        prev.error != next.error,
                listener: _onPaywallStateChanged,
                builder:
                    (context, state) => _buildPaywallSections(
                      context: context,
                      state: state,
                      orderedBenefits: orderedBenefits,
                      handleDismiss: handleDismiss,
                    ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _onPaywallStateChanged(BuildContext context, PaywallState state) {
    if (state.actionStatus == PaywallActionStatus.success) {
      KinlySnackBar.showSuccess(context, strings.purchaseSuccess);
      Navigator.of(context).pop(true);
    } else if (state.error != null) {
      KinlySnackBar.showError(context, strings.purchaseFailed);
    }
  }

  Widget _buildPaywallSections({
    required BuildContext context,
    required PaywallState state,
    required List<String> orderedBenefits,
    required VoidCallback handleDismiss,
  }) {
    final actions = PaywallSurfaceActions(
      onUpgrade: () {
        context.read<PaywallBloc>().add(const PaywallCtaPressed());
      },
      onRestore: () {
        context.read<PaywallBloc>().add(const PaywallRestorePressed());
      },
      onDismiss: handleDismiss,
      onRetry: () {
        context.read<PaywallBloc>().add(PaywallStarted(source: source));
      },
    );
    final scope = PaywallSurfaceScope(
      context: context,
      state: state,
      strings: strings,
      orderedBenefits: orderedBenefits,
      actions: actions,
    );
    final slots = PaywallSurfaceSlots(body: _buildPaywallBodySections(scope));
    return slots.body;
  }

  Widget _buildPaywallBodySections(PaywallSurfaceScope scope) {
    final entries = PaywallRegistry.bodySections;
    if (entries.length == 1) {
      return entries.first.builder(scope);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: entries
          .map((entry) => entry.builder(scope))
          .toList(growable: false),
    );
  }
}

enum _PaywallBenefitGroup { flow, flowPhotos, expenses, members }

const _groupPriority = [
  _PaywallBenefitGroup.flow,
  _PaywallBenefitGroup.flowPhotos,
  _PaywallBenefitGroup.expenses,
  _PaywallBenefitGroup.members,
];

class _Benefit {
  const _Benefit(this.group, this.label);

  final _PaywallBenefitGroup group;
  final String label;
}

List<_PaywallBenefitGroup> _resolvePrimaryGroups(Set<PaywallTrigger> triggers) {
  final groups = <_PaywallBenefitGroup>{};
  for (final trigger in triggers) {
    switch (trigger) {
      case PaywallTrigger.flowActiveCap:
        groups.add(_PaywallBenefitGroup.flow);
        break;
      case PaywallTrigger.flowPhotosCap:
        groups.add(_PaywallBenefitGroup.flowPhotos);
        break;
      case PaywallTrigger.expenseActiveCap:
        groups.add(_PaywallBenefitGroup.expenses);
        break;
      case PaywallTrigger.membersCap:
        groups.add(_PaywallBenefitGroup.members);
        break;
    }
  }
  return _groupPriority.where(groups.contains).toList(growable: false);
}

List<String> _orderedBenefitsForGroups(
  Iterable<_PaywallBenefitGroup> groups,
  List<_Benefit> benefits,
) {
  return groups
      .expand(
        (group) => benefits
            .where((benefit) => benefit.group == group)
            .map((benefit) => benefit.label),
      )
      .toList(growable: false);
}

@visibleForTesting
List<String> orderPaywallBenefits({
  required PaywallStrings strings,
  required Set<PaywallTrigger> triggers,
}) {
  final benefits = <_Benefit>[
    _Benefit(_PaywallBenefitGroup.flow, strings.bulletFlows),
    _Benefit(_PaywallBenefitGroup.flowPhotos, strings.bulletPhotos),
    _Benefit(_PaywallBenefitGroup.expenses, strings.bulletShares),
    _Benefit(_PaywallBenefitGroup.members, strings.bulletMembers),
  ];

  final primaryGroups = _resolvePrimaryGroups(triggers);
  final primaryBenefits = _orderedBenefitsForGroups(primaryGroups, benefits);

  final secondaryGroups = _groupPriority.where(
    (group) => !primaryGroups.contains(group),
  );
  final secondaryBenefits = _orderedBenefitsForGroups(
    secondaryGroups,
    benefits,
  );

  return [...primaryBenefits, ...secondaryBenefits];
}
