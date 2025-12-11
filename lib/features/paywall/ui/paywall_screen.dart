import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/locator.dart';
import '../../../core/homes/models.dart';
import '../../../core/purchases/revenuecat_service.dart';
import '../../../core/theme/kinly_sections.dart';
import '../../../core/ui/buttons/kinly_filled_button.dart';
import '../../../core/logging/logger.dart';
import '../../../core/ui/kinly_circle_avatar.dart';
import '../../../core/ui/kinly_loader.dart';
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
  final String? priceCaption;
  final String? emotionalBody;
  final String? priceUnavailableLabel;
  final String Function(String price)? priceFormatter;
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
    this.priceCaption,
    this.emotionalBody,
    this.priceUnavailableLabel,
    this.priceFormatter,
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
    // Price is shown on the CTA only; keep hero copy price-free.
    const priceLine = '';
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
      strings.bulletMembers,
      strings.bulletFlows,
      strings.bulletPhotos,
      strings.bulletShares,
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
                priceCaption: strings.priceCaption ?? strings.unlimitedLabel,
                unlimitedLabel: strings.unlimitedLabel,
                gradient: heroGradient,
                accent: sections?.share.accent ?? theme.colorScheme.primary,
                members: members,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: KinlyScrollFade(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _BenefitChecklist(
                          features: features,
                          accent:
                              sections?.share.accent ??
                              theme.colorScheme.primary,
                        ),
                        const SizedBox(height: 18),
                        _EmotionalBlock(
                          text: strings.emotionalBody ?? strings.unlimitedLabel,
                          accent:
                              sections?.flow.accent ??
                              theme.colorScheme.secondary,
                        ),
                        const SizedBox(height: 18),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              KinlyFilledButton.text(
                label: strings.primaryCta,
                onPressed: onUpgrade,
                fullWidth: true,
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: onDismiss,
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.onSurface.withValues(
                    alpha: 0.9,
                  ),
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  textStyle: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                child: Text(strings.secondaryCta),
              ),
              const SizedBox(height: 12),
              TextButton(onPressed: onRestore, child: Text(strings.restoreCta)),
            ],
          ),
        );
      },
    );
  }
}

class _BenefitChecklist extends StatelessWidget {
  const _BenefitChecklist({required this.features, required this.accent});

  final List<String> features;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final surface = theme.colorScheme.surface;
    final checkBg = Color.alphaBlend(accent.withValues(alpha: 0.14), surface);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: features
          .map(
            (label) => Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: checkBg,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check_rounded, color: accent, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      label,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _EmotionalBlock extends StatelessWidget {
  const _EmotionalBlock({required this.text, required this.accent});

  final String text;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    if (text.trim().isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final surface = theme.colorScheme.surface;
    final bg = Color.alphaBlend(accent.withValues(alpha: 0.08), surface);
    return Container(
      width: double.infinity,
      padding: const EdgeInsetsDirectional.fromSTEB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _HouseholdAvatarRow extends StatelessWidget {
  const _HouseholdAvatarRow({required this.members, required this.accent});

  final List<HomeMemberSummary> members;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    if (members.isEmpty) return const SizedBox.shrink();
    const radius = 20.0;
    const step = radius * 1.3;
    final visible = members.take(5).toList();
    final overflow = members.length - visible.length;
    final stackWidth = radius * 2 + step * (visible.length - 1);
    final surface = Theme.of(context).colorScheme.surface;
    final overflowBg = Color.alphaBlend(
      accent.withValues(alpha: 0.12),
      surface,
    );

    return Row(
      children: [
        SizedBox(
          height: radius * 2,
          width: stackWidth + (overflow > 0 ? step : 0),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              for (var i = 0; i < visible.length; i++)
                PositionedDirectional(
                  start: i * step,
                  child: KinlyCircleAvatar(
                    avatarUrl: visible[i].avatarUrl,
                    isOwner: visible[i].isOwner,
                    radius: radius,
                    fallbackInitial:
                        visible[i].username.isNotEmpty
                            ? visible[i].username[0]
                            : null,
                  ),
                ),
              if (overflow > 0)
                PositionedDirectional(
                  start: visible.length * step,
                  child: Container(
                    width: radius * 2,
                    height: radius * 2,
                    decoration: BoxDecoration(
                      color: overflowBg,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.05),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '+$overflow',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PaywallHero extends StatelessWidget {
  const _PaywallHero({
    required this.title,
    required this.subtitle,
    required this.priceLine,
    required this.priceCaption,
    required this.unlimitedLabel,
    required this.gradient,
    required this.accent,
    required this.members,
  });

  final String title;
  final String subtitle;
  final String priceLine;
  final String? priceCaption;
  final String unlimitedLabel;
  final List<Color> gradient;
  final Color accent;
  final List<HomeMemberSummary> members;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final caption =
        priceCaption?.trim().isNotEmpty == true
            ? priceCaption!
            : unlimitedLabel;
    final priceChipColor = Color.alphaBlend(
      accent.withValues(alpha: 0.16),
      colorScheme.surface,
    );
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 22, 20, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.24),
            blurRadius: 28,
            spreadRadius: 2,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (caption.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              caption,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          if (members.isNotEmpty) ...[
            const SizedBox(height: 14),
            _HouseholdAvatarRow(members: members, accent: accent),
          ],
          if (priceLine.isNotEmpty) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
              decoration: BoxDecoration(
                color: priceChipColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                priceLine,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
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
