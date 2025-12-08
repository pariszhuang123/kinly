import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/locator.dart';
import '../../../core/purchases/revenuecat_service.dart';
import '../../../core/ui/buttons/kinly_filled_button.dart';
import '../../../core/ui/buttons/kinly_outlined_button.dart';
import '../../../core/ui/kinly_loader.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/paywall_repository.dart';
import '../bloc/paywall_bloc.dart';

class PaywallStrings {
  final String title;
  final String subtitle;
  final String bulletMembers;
  final String bulletFlows;
  final String bulletPhotos;
  final String bulletShares;
  final String primaryCta;
  final String secondaryCta;
  final String purchaseFailed;
  final String purchaseSuccess;
  final String restoreCta;
  final String errorTitle;
  final String retryLabel;

  const PaywallStrings({
    required this.title,
    required this.subtitle,
    required this.bulletMembers,
    required this.bulletFlows,
    required this.bulletPhotos,
    required this.bulletShares,
    required this.primaryCta,
    required this.secondaryCta,
    required this.purchaseFailed,
    required this.purchaseSuccess,
    required this.restoreCta,
    required this.errorTitle,
    required this.retryLabel,
  });
}

class KinlyPaywallScreen extends StatelessWidget {
  const KinlyPaywallScreen({
    super.key,
    required this.homeId,
    required this.strings,
    this.source,
  });

  final String homeId;
  final PaywallStrings strings;
  final String? source;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaywallBloc(
        paywallRepository: sl<PaywallRepository>(),
        revenueCatService: sl<RevenueCatService>(),
        authRepository: sl<AuthRepository>(),
        homeId: homeId,
      )..add(PaywallStarted(source: source)),
      child: Scaffold(
        body: SafeArea(
          child: BlocConsumer<PaywallBloc, PaywallState>(
            listenWhen: (prev, next) =>
                prev.actionStatus != next.actionStatus || prev.error != next.error,
            listener: (context, state) {
              if (state.actionStatus == PaywallActionStatus.success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(strings.purchaseSuccess)),
                );
                Navigator.of(context).pop(true);
              } else if (state.error != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(strings.purchaseFailed)),
                );
              }
            },
            builder: (context, state) {
              if (state.status == PaywallLoadStatus.loading ||
                  state.status == PaywallLoadStatus.initial) {
                return const Center(child: KinlyLoader());
              }
              if (state.status == PaywallLoadStatus.error) {
                return _ErrorView(
                  strings: strings,
                  onRetry: () {
                    context.read<PaywallBloc>().add(PaywallStarted(source: source));
                  },
                );
              }
              final pkg = state.package;
              return _PaywallBody(
                strings: strings,
                priceString: pkg?.priceString,
                onUpgrade: () {
                  context.read<PaywallBloc>().add(const PaywallCtaPressed());
                },
                onRestore: () {
                  context.read<PaywallBloc>().add(const PaywallRestorePressed());
                },
                onDismiss: () {
                  context.read<PaywallBloc>().add(const PaywallDismissed());
                  Navigator.of(context).pop(false);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _PaywallBody extends StatelessWidget {
  const _PaywallBody({
    required this.strings,
    required this.priceString,
    required this.onUpgrade,
    required this.onRestore,
    required this.onDismiss,
  });

  final PaywallStrings strings;
  final String? priceString;
  final VoidCallback onUpgrade;
  final VoidCallback onRestore;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final priceLine = priceString != null ? '$priceString / month' : '';
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsetsDirectional.fromSTEB(24, 24, 24, 32),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 56),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(strings.title, style: textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(strings.subtitle, style: textTheme.bodyMedium),
                const SizedBox(height: 16),
                if (priceLine.isNotEmpty)
                  Text(
                    priceLine,
                    style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                const SizedBox(height: 24),
                _FeatureRow(label: strings.bulletMembers),
                _FeatureRow(label: strings.bulletFlows),
                _FeatureRow(label: strings.bulletPhotos),
                _FeatureRow(label: strings.bulletShares),
                const SizedBox(height: 24),
                KinlyFilledButton.text(
                  label: strings.primaryCta,
                  onPressed: onUpgrade,
                  fullWidth: true,
                ),
                const SizedBox(height: 12),
                KinlyOutlinedButton.text(
                  label: strings.secondaryCta,
                  onPressed: onDismiss,
                  fullWidth: true,
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: onRestore,
                  child: Text(strings.restoreCta),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 12),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry, required this.strings});
  final VoidCallback onRetry;
  final PaywallStrings strings;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(strings.errorTitle),
          const SizedBox(height: 12),
          KinlyFilledButton.text(label: strings.retryLabel, onPressed: onRetry),
        ],
      ),
    );
  }
}
