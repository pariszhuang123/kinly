import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/locator.dart';
import '../../../core/homes/models.dart';
import '../../../core/purchases/revenuecat_service.dart';
import '../../../core/theme/kinly_sections.dart';
import '../../../core/theme/section_assets.dart';
import '../../../core/ui/buttons/kinly_filled_button.dart';
import '../../../core/ui/buttons/kinly_outlined_button.dart';
import '../../../core/logging/logger.dart';
import '../../../core/ui/kinly_loader.dart';
import '../../../core/ui/members/kinly_member_avatar_row.dart';
import '../../../core/ui/scroll/kinly_scroll_fade.dart';
import '../../../core/ui/snackbars/kinly_snackbar.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/home_repository.dart';
import '../../../data/repositories/paywall_repository.dart';
import '../bloc/paywall_bloc.dart';

class PaywallStrings {
  final String title;
  final String subtitle;
  final String bulletMembers;
  final String bulletFlows;
  final String bulletPhotos;
  final String bulletShares;
  final String unlimitedLabel;
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
    required this.unlimitedLabel,
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
    this.placementId,
  });

  final String homeId;
  final PaywallStrings strings;
  final String? source;
  final String? placementId;

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
          )..add(PaywallStarted(source: source)),
      child: Scaffold(
        body: SafeArea(
          child: BlocConsumer<PaywallBloc, PaywallState>(
            listenWhen:
                (prev, next) =>
                    prev.actionStatus != next.actionStatus ||
                    prev.error != next.error,
            listener: (context, state) {
              if (state.actionStatus == PaywallActionStatus.success) {
                KinlySnackBar.showSuccess(context, strings.purchaseSuccess);
                Navigator.of(context).pop(true);
              } else if (state.error != null) {
                KinlySnackBar.showError(context, strings.purchaseFailed);
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
                    context.read<PaywallBloc>().add(
                      PaywallStarted(source: source),
                    );
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
                  context.read<PaywallBloc>().add(
                    const PaywallRestorePressed(),
                  );
                },
                onDismiss: () {
                  context.read<PaywallBloc>().add(const PaywallDismissed());
                  Navigator.of(context).pop(false);
                },
                members: state.activeMembers,
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
    required this.members,
  });

  final PaywallStrings strings;
  final String? priceString;
  final VoidCallback onUpgrade;
  final VoidCallback onRestore;
  final VoidCallback onDismiss;
  final List<HomeMemberSummary> members;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sections = theme.extension<KinlySections>();
    final priceLine = priceString != null ? '$priceString / month' : '';
    final surface = theme.colorScheme.surface;
    final shareCard =
        sections?.share.card ?? theme.colorScheme.primaryContainer;
    final flowCard =
        sections?.flow.card ?? theme.colorScheme.secondaryContainer;
    final heroGradient = [
      Color.alphaBlend(shareCard.withValues(alpha: 0.18), surface),
      Color.alphaBlend(flowCard.withValues(alpha: 0.28), surface),
    ];

    final features = [
      _FeatureDetail(
        asset: const SectionAsset.icon(Icons.groups_rounded),
        accent: sections?.share.accent ?? theme.colorScheme.primary,
        tint: sections?.share.card ?? theme.colorScheme.primaryContainer,
        label: strings.bulletMembers,
      ),
      _FeatureDetail(
        asset: SectionAssets.flow,
        accent: sections?.flow.accent ?? theme.colorScheme.secondary,
        tint: sections?.flow.card ?? theme.colorScheme.secondaryContainer,
        label: strings.bulletFlows,
      ),
      _FeatureDetail(
        asset: const SectionAsset.icon(Icons.photo_library_outlined),
        accent: sections?.flow.icon ?? theme.colorScheme.secondary,
        tint: sections?.flow.card ?? theme.colorScheme.secondaryContainer,
        label: strings.bulletPhotos,
      ),
      _FeatureDetail(
        asset: SectionAssets.share,
        accent: sections?.share.icon ?? theme.colorScheme.primary,
        tint: sections?.share.card ?? theme.colorScheme.primaryContainer,
        label: strings.bulletShares,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(24, 24, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PaywallHero(
                title: strings.title,
                subtitle: strings.subtitle,
                priceLine: priceLine,
                unlimitedLabel: strings.unlimitedLabel,
                gradient: heroGradient,
                accent: sections?.share.accent ?? theme.colorScheme.primary,
                members: members,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: KinlyScrollFade(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: features.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1,
                          ),
                      itemBuilder: (context, index) {
                        final f = features[index];
                        return _FeatureCard(
                          asset: f.asset,
                          accent: f.accent,
                          tint: f.tint,
                          label: f.label,
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
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
        );
      },
    );
  }
}

class _FeatureDetail {
  final SectionAsset asset;
  final Color accent;
  final Color tint;
  final String label;

  _FeatureDetail({
    required this.asset,
    required this.accent,
    required this.tint,
    required this.label,
  });
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.asset,
    required this.accent,
    required this.tint,
    required this.label,
  });

  final SectionAsset asset;
  final Color accent;
  final Color tint;
  final String label;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final surface = colorScheme.surface;
    final cardColor = Color.alphaBlend(tint.withValues(alpha: 0.22), surface);
    final iconBg = Color.alphaBlend(accent.withValues(alpha: 0.22), surface);
    final iconColor =
        colorScheme.brightness == Brightness.dark
            ? Color.alphaBlend(
              accent,
              colorScheme.onSurface.withValues(alpha: 0.8),
            )
            : accent;
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Center(child: asset.build(color: iconColor, size: 20)),
          ),
          Text(
            label,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _PaywallHero extends StatelessWidget {
  const _PaywallHero({
    required this.title,
    required this.subtitle,
    required this.priceLine,
    required this.unlimitedLabel,
    required this.gradient,
    required this.accent,
    required this.members,
  });

  final String title;
  final String subtitle;
  final String priceLine;
  final String unlimitedLabel;
  final List<Color> gradient;
  final Color accent;
  final List<HomeMemberSummary> members;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 22, 20, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                if (members.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  KinlyMemberAvatarRow(
                    members: members,
                    avatarRadius: 20,
                  ),
                ],
                const SizedBox(height: 12),
                if (priceLine.isNotEmpty)
                  Text(
                    priceLine,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
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
