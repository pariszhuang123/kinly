import 'package:flutter/widgets.dart';

import 'package:kinly/contracts/homes/models.dart';
import 'package:kinly/core/theme/app_sizes.dart';
import 'package:kinly/core/theme/kinly_sections.dart';
import 'package:kinly/core/theme/opacity.dart';
import 'package:kinly/core/theme/radius.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/theme/typography_tokens.dart';
import 'package:kinly/core/ui/action_bar/kinly_action_bar.dart';
import 'package:kinly/core/ui/buttons/kinly_filled_button.dart';
import 'package:kinly/core/ui/enums/kinly_action_button_varient.dart';
import 'package:kinly/core/ui/kinly_action_card.dart';
import 'package:kinly/core/ui/kinly_loader.dart';
import 'package:kinly/core/ui/members/kinly_member_avatar_stack.dart';
import 'package:kinly/core/ui/scroll/kinly_scroll_fade.dart';
import 'package:kinly/core/ui/kinly_icons.dart';
import 'package:kinly/core/ui/kinly_scrollbar.dart';

import '../paywall_strings.dart';
import '../paywall_surface_contract.dart';
import '../../bloc/paywall_bloc.dart';
import '../../../../core/ui/kinly_theme_access.dart';

class PaywallContent extends StatelessWidget {
  const PaywallContent({super.key, required this.scope});

  final PaywallSurfaceScope scope;

  @override
  Widget build(BuildContext context) {
    final state = scope.state;
    if (state.status == PaywallLoadStatus.loading ||
        state.status == PaywallLoadStatus.initial) {
      return const Center(child: KinlyLoader());
    }
    if (state.status == PaywallLoadStatus.error) {
      return _ErrorView(strings: scope.strings, onRetry: scope.actions.onRetry);
    }
    final pkg = state.package;
    return _PaywallBody(
      strings: scope.strings,
      priceString: pkg?.priceString,
      isActionBusy: state.isActionInFlight,
      onUpgrade: scope.actions.onUpgrade,
      onRestore: scope.actions.onRestore,
      onDismiss: scope.actions.onDismiss,
      members: state.activeMembers,
      orderedFeatures: scope.orderedBenefits,
    );
  }
}

class _PaywallBody extends StatelessWidget {
  const _PaywallBody({
    required this.strings,
    required this.priceString,
    required this.isActionBusy,
    required this.onUpgrade,
    required this.onRestore,
    required this.onDismiss,
    required this.members,
    required this.orderedFeatures,
  });

  final PaywallStrings strings;
  final String? priceString;
  final bool isActionBusy;
  final VoidCallback onUpgrade;
  final VoidCallback onRestore;
  final VoidCallback onDismiss;
  final List<HomeMemberSummary> members;
  final List<String> orderedFeatures;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final sections = theme.extension<KinlySections>();
    final spacing = theme.extension<Spacing>()!;
    final opacities = theme.extension<KinlyOpacity>()!;
    final appSizes = theme.extension<AppSizes>();
    final typography = theme.extension<KinlyTypography>()!;
    final formattedPrice =
        priceString == null
            ? null
            : strings.priceFormatter?.call(priceString!) ?? priceString;
    final unavailableLabel = strings.priceUnavailableLabel?.trim();
    final primaryLabel =
        formattedPrice != null && formattedPrice.trim().isNotEmpty
            ? formattedPrice
            : unavailableLabel != null && unavailableLabel.isNotEmpty
            ? unavailableLabel
            : strings.primaryCta;
    const priceLine = '';
    final surface = theme.colorScheme.surface;
    final shareCard =
        sections?.share.card ?? theme.colorScheme.primaryContainer;
    final flowCard =
        sections?.flow.card ?? theme.colorScheme.secondaryContainer;
    final heroGradient = [
      Color.alphaBlend(shareCard.withValues(alpha: opacities.alphaMD), surface),
      Color.alphaBlend(flowCard.withValues(alpha: opacities.alphaXXL), surface),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) onDismiss();
          },
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(
              spacing.xl,
              spacing.xl,
              spacing.xl,
              spacing.xxl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _PaywallHero(
                  subtitle: strings.subtitle,
                  priceLine: priceLine,
                  priceCaption: strings.priceCaption ?? strings.unlimitedLabel,
                  unlimitedLabel: strings.unlimitedLabel,
                  gradient: heroGradient,
                  accent: sections?.share.accent ?? theme.colorScheme.primary,
                  members: members,
                ),
                SizedBox(height: spacing.xl),
                Expanded(
                  child: KinlyActionCard(
                    padding: EdgeInsets.zero,
                    background:
                        sections?.share.card ??
                        theme.colorScheme.surfaceContainerHighest.withValues(
                          alpha: opacities.alphaOpaque,
                        ),
                    child: KinlyScrollbar(
                      thumbVisibility: false,
                      child: KinlyScrollFade(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsetsDirectional.fromSTEB(
                            spacing.xl,
                            spacing.xl,
                            spacing.xl,
                            spacing.m,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _BenefitChecklist(
                                features: orderedFeatures,
                                accent:
                                    sections?.share.accent ??
                                    theme.colorScheme.primary,
                                bulletSize: spacing.xxl,
                                iconSize: appSizes?.iconMd ?? spacing.xl,
                                titleStyle: typography.titleSmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: spacing.l),
                KinlyActionBar(
                  primary: KinlyActionButton(
                    label: primaryLabel,
                    onPressed: isActionBusy ? null : onUpgrade,
                    busy: isActionBusy,
                  ),
                  secondary: KinlyActionButton(
                    label: strings.restoreCta,
                    onPressed: isActionBusy ? null : onRestore,
                    variant: KinlyActionButtonVariant.outlined,
                  ),
                  includeSafeArea: false,
                  padding: EdgeInsetsDirectional.zero,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BenefitChecklist extends StatelessWidget {
  const _BenefitChecklist({
    required this.features,
    required this.accent,
    this.bulletSize,
    this.iconSize,
    this.titleStyle,
  });

  final List<String> features;
  final Color accent;
  final double? bulletSize;
  final double? iconSize;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final textTheme = theme.textTheme;
    final surface = theme.colorScheme.surface;
    final opacities = theme.extension<KinlyOpacity>()!;
    final spacing = theme.extension<Spacing>()!;
    final checkBg = Color.alphaBlend(
      accent.withValues(alpha: opacities.alphaXL),
      surface,
    );
    final checkColor = theme.colorScheme.onSurface;
    final size = bulletSize ?? spacing.xxl;
    final iconDimension = iconSize ?? spacing.xl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: features
          .map(
            (label) => Padding(
              padding: EdgeInsetsDirectional.only(bottom: spacing.m),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      color: checkBg,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      KinlyIcons.checkRounded,
                      color: checkColor,
                      size: iconDimension,
                    ),
                  ),
                  SizedBox(width: spacing.m),
                  Expanded(
                    child: Text(
                      label,
                      style: titleStyle ?? textTheme.titleMedium,
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

class _PaywallHero extends StatelessWidget {
  const _PaywallHero({
    required this.subtitle,
    required this.priceLine,
    required this.priceCaption,
    required this.unlimitedLabel,
    required this.gradient,
    required this.accent,
    required this.members,
  });

  final String subtitle;
  final String priceLine;
  final String? priceCaption;
  final String unlimitedLabel;
  final List<Color> gradient;
  final Color accent;
  final List<HomeMemberSummary> members;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = theme.extension<Spacing>()!;
    final corners = theme.extension<Corners>()!;
    final opacities = theme.extension<KinlyOpacity>()!;
    final typography = theme.extension<KinlyTypography>()!;
    final caption =
        priceCaption?.trim().isNotEmpty == true
            ? priceCaption!
            : unlimitedLabel;
    final priceChipColor = Color.alphaBlend(
      accent.withValues(alpha: opacities.alphaMD),
      colorScheme.surface,
    );
    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(
        spacing.xl - spacing.s,
        spacing.xl - spacing.xs,
        spacing.xl - spacing.s,
        spacing.xl - spacing.s,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
        ),
        borderRadius: BorderRadius.circular(corners.xl),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: opacities.alphaXL),
            blurRadius: spacing.xxl,
            spreadRadius: spacing.xs,
            offset: Offset(0, spacing.m),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtitle,
            style: typography.bodyLarge.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          if (caption.isNotEmpty) ...[
            SizedBox(height: spacing.m),
            Text(caption, style: typography.bodyMedium),
          ],
          if (members.isNotEmpty) ...[
            SizedBox(height: spacing.l),
            KinlyMemberAvatarStack(
              members: members,
              accent: accent,
              maxVisible: 5,
              radius: spacing.xl,
            ),
          ],
          if (priceLine.isNotEmpty) ...[
            SizedBox(height: spacing.l),
            Container(
              padding: EdgeInsetsDirectional.fromSTEB(
                spacing.m,
                spacing.s,
                spacing.m,
                spacing.s,
              ),
              decoration: BoxDecoration(
                color: priceChipColor,
                borderRadius: BorderRadius.circular(corners.md),
              ),
              child: Text(priceLine, style: typography.titleMedium),
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
