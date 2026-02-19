import 'package:confetti/confetti.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/app/share/share_position_origin.dart';
import 'package:kinly/core/theme/kinly_sections.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/buttons/kinly_filled_button.dart';
import 'package:kinly/core/ui/buttons/kinly_outlined_button.dart';
import 'package:kinly/core/ui/kinly_app_bar.dart';
import 'package:kinly/core/ui/kinly_confetti_overlay.dart';
import 'package:kinly/core/ui/kinly_loader.dart';
import 'package:kinly/core/ui/kinly_masonry_grid.dart';
import 'package:kinly/core/ui/kinly_scaffold.dart';
import 'package:kinly/core/ui/kinly_tap_target.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/core/ui/kinly_icons.dart';
import 'package:kinly/core/ui/scroll/kinly_scroll_fade.dart';
import 'package:kinly/contracts/house_norms/models.dart';
import 'package:kinly/core/ui/snackbars/kinly_snackbar.dart';
import 'package:kinly/features/house_norms/bloc/house_norm_report_cubit.dart';
import 'package:kinly/features/house_norms/domain/house_norm_content_localization.dart';
import 'package:kinly/features/house_norms/domain/house_norm_document_view.dart';
import 'package:kinly/features/house_norms/ui/house_norm_section_route_args.dart';
import 'package:kinly/generated/l10n.dart';

class HouseNormReportScreen extends StatefulWidget {
  const HouseNormReportScreen({
    super.key,
    required this.isOwner,
    this.showConfetti = false,
    this.showDoneCta = true,
    this.popOnDone = false,
  });

  final bool isOwner;
  final bool showConfetti;
  final bool showDoneCta;
  final bool popOnDone;

  @override
  State<HouseNormReportScreen> createState() => _HouseNormReportScreenState();
}

class _HouseNormReportScreenState extends State<HouseNormReportScreen> {
  late final ConfettiController _confettiController;
  bool _hasPlayedConfetti = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _playConfettiIfNeeded();
  }

  @override
  void didUpdateWidget(covariant HouseNormReportScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showConfetti && !oldWidget.showConfetti) {
      _playConfettiIfNeeded();
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _playConfettiIfNeeded() {
    if (_hasPlayedConfetti || !widget.showConfetti) return;
    _hasPlayedConfetti = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _confettiController.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final sections = theme.extension<KinlySections>();
    final colors = theme.colorScheme;
    final palette = context.preferenceSection;
    final s = S.of(context);

    return KinlyScaffold(
      appBar: KinlyAppBar(
        title: Text(widget.isOwner ? s.houseNormEditTitle : s.houseNormReportTitle),
        leading: _DirectionalBackButton(
          label: s.houseNormOnboardingBack,
          colors: palette,
          onTap: () {
            if (context.canPop()) {
              context.pop();
              return;
            }
            context.goNamed(AppRouteNames.today);
          },
        ),
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
      ),
      backgroundColor: colors.surface,
      body: Stack(
        children: [
          SafeArea(
            child: BlocBuilder<HouseNormReportCubit, HouseNormReportState>(
              builder: (context, state) => _buildStateBody(
                context: context,
                state: state,
                strings: s,
                palette: palette,
              ),
            ),
          ),
          if (sections != null)
            Positioned.fill(
              child: KinlyConfettiOverlay(
                confettiController: _confettiController,
                colors: [
                  sections.flow.accent,
                  sections.share.accent,
                  palette.accent,
                  colors.primary,
                  colors.secondary,
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStateBody({
    required BuildContext context,
    required HouseNormReportState state,
    required S strings,
    required SectionColors palette,
  }) {
    if (state.status == HouseNormReportStatus.loading) {
      return const Center(child: KinlyLoader());
    }
    if (state.status == HouseNormReportStatus.failure) {
      return _HouseNormEmpty(
        title: strings.houseNormReportErrorTitle,
        body: strings.houseNormReportErrorBody,
      );
    }

    final document = state.document;
    if (state.status == HouseNormReportStatus.empty || document == null) {
      return _HouseNormEmpty(
        title: strings.houseNormReportEmptyTitle,
        body: strings.houseNormReportEmptyBody,
      );
    }

    final content = resolveHouseNormDisplayContent(document);
    if (content == null) {
      return _HouseNormEmpty(
        title: strings.houseNormReportEmptyTitle,
        body: strings.houseNormReportEmptyBody,
      );
    }

    return _HouseNormReadyBody(
      state: state,
      document: document,
      content: content,
      palette: palette,
      showDoneCta: widget.showDoneCta,
      popOnDone: widget.popOnDone,
    );
  }
}

class _HouseNormReadyBody extends StatelessWidget {
  const _HouseNormReadyBody({
    required this.state,
    required this.document,
    required this.content,
    required this.palette,
    required this.showDoneCta,
    required this.popOnDone,
  });

  final HouseNormReportState state;
  final HouseNormDocument document;
  final HouseNormContent content;
  final SectionColors palette;
  final bool showDoneCta;
  final bool popOnDone;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>();
    final strings = S.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: KinlyScrollFade(
            child: SingleChildScrollView(
              padding: EdgeInsetsDirectional.fromSTEB(
                spacing?.lg ?? 16,
                spacing?.lg ?? 16,
                spacing?.lg ?? 16,
                spacing?.lg ?? 16,
              ),
              child: _HouseNormContentView(
                content: content,
                palette: palette,
                canEdit: state.isOwner,
              ),
            ),
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(
              spacing?.lg ?? 16,
              spacing?.m ?? 12,
              spacing?.lg ?? 16,
              spacing?.xl ?? 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (state.isOwner)
                  _HouseNormOwnerActions(state: state, document: document, palette: palette),
                if (!state.isOwner && showDoneCta)
                  KinlyOutlinedButton.text(
                    fullWidth: true,
                    label: strings.houseNormDoneCta,
                    foregroundColor: palette.accent,
                    borderColor: palette.accent,
                    onPressed: () {
                      if (popOnDone && context.canPop()) {
                        context.pop();
                        return;
                      }
                      context.goNamed(AppRouteNames.today);
                    },
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HouseNormContentView extends StatelessWidget {
  const _HouseNormContentView({
    required this.content,
    required this.palette,
    required this.canEdit,
  });

  final HouseNormContent content;
  final SectionColors palette;
  final bool canEdit;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>();
    final colors = theme.colorScheme;
    final s = S.of(context);
    final summaryTitle = localizeHouseNormSummaryTitle(s, content.summary);
    final summarySubtitle = localizeHouseNormSummarySubtitle(s, content.summary);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (summaryTitle.isNotEmpty)
          Text(summaryTitle, style: theme.textTheme.headlineSmall),
        if (summarySubtitle.isNotEmpty) ...[
          SizedBox(height: spacing?.s ?? 8),
          Text(
            summarySubtitle,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
        if (content.summary.framing.isNotEmpty)
          Padding(
            padding: EdgeInsetsDirectional.only(
              top:
                  summaryTitle.isNotEmpty || summarySubtitle.isNotEmpty
                      ? spacing?.m ?? 12
                      : 0,
            ),
            child:
                canEdit
                    ? _HouseNormSectionCard(
                      title: s.houseNormSummaryFramingLabel,
                      text: content.summary.framing,
                      palette: palette,
                      onTap:
                          () => _openSectionEditor(
                            context,
                            sectionKey: 'summary_framing',
                            title: s.houseNormSummaryFramingLabel,
                            text: content.summary.framing,
                          ),
                    )
                    : Text(
                      content.summary.framing,
                      style: theme.textTheme.bodyMedium,
                    ),
          ),
        SizedBox(height: spacing?.lg ?? 16),
        KinlyMasonryGrid(
          items: content.sections,
          palette: KinlySectionPalette([palette]),
          builder: (context, section, _, itemPalette) {
            final sectionTitle = localizeHouseNormSectionTitle(s, section);
            return _HouseNormSectionCard(
              title: sectionTitle,
              text: section.text,
              palette: itemPalette.colorForSeed(section.sectionKey),
              onTap:
                  canEdit
                      ? () => _openSectionEditor(
                        context,
                        sectionKey: section.sectionKey,
                        title: sectionTitle,
                        text: section.text,
                      )
                      : null,
            );
          },
          estimateItemHeight: (section, textTheme, spacingTokens) {
            final titleStyle = textTheme.titleMedium;
            final bodyStyle = textTheme.bodyMedium;
            final titleLines = _estimateLineCount(
              section.title,
              titleStyle?.fontSize ?? 16,
            );
            final bodyLines = _estimateLineCount(
              section.text,
              bodyStyle?.fontSize ?? 14,
            );
            final lineHeightTitle =
                (titleStyle?.height ?? 1.2) * (titleStyle?.fontSize ?? 16);
            final lineHeightBody =
                (bodyStyle?.height ?? 1.2) * (bodyStyle?.fontSize ?? 14);
            return (spacingTokens.lg + spacingTokens.m + spacingTokens.lg) +
                lineHeightTitle * titleLines +
                spacingTokens.s +
                lineHeightBody * bodyLines +
                spacingTokens.m;
          },
        ),
      ],
    );
  }
}

class _HouseNormOwnerActions extends StatelessWidget {
  const _HouseNormOwnerActions({
    required this.state,
    required this.document,
    required this.palette,
  });

  final HouseNormReportState state;
  final HouseNormDocument document;
  final SectionColors palette;

  @override
  Widget build(BuildContext context) {
    final spacing = KinlyThemeAccess.of(context).extension<Spacing>();
    final strings = S.of(context);
    final hasPublicUrl =
        document.showPublicUrl && (document.publicUrl?.isNotEmpty ?? false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (hasPublicUrl) _PublicUrlRow(url: document.publicUrl!),
        if (hasPublicUrl) SizedBox(height: spacing?.m ?? 12),
        if (document.showRepublishButton)
          KinlyFilledButton.text(
            fullWidth: true,
            label: strings.houseNormRepublishCta,
            backgroundColor: palette.accent,
            foregroundColor: palette.onAccent(),
            onPressed: state.isBusy ? null : () => _publish(context, strings),
          ),
        if (document.showPublishButton)
          KinlyFilledButton.text(
            fullWidth: true,
            label: strings.houseNormPublishCta,
            backgroundColor: palette.accent,
            foregroundColor: palette.onAccent(),
            onPressed: state.isBusy ? null : () => _publish(context, strings),
          ),
      ],
    );
  }

  Future<void> _publish(BuildContext context, S strings) async {
    final ok = await context.read<HouseNormReportCubit>().publish();
    if (!context.mounted) return;
    if (ok) {
      KinlySnackBar.showSuccess(context, strings.houseNormPublishSuccess);
      return;
    }
    KinlySnackBar.showError(context, strings.houseNormPublishFailed);
  }
}

class _PublicUrlRow extends StatelessWidget {
  const _PublicUrlRow({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>();
    final palette = context.preferenceSection;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(url, style: theme.textTheme.bodyMedium),
        SizedBox(height: spacing?.s ?? 8),
        Row(
          children: [
            Expanded(
              child: KinlyOutlinedButton.text(
                label: s.houseNormCopyUrlCta,
                foregroundColor: palette.accent,
                borderColor: palette.accent,
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: url));
                  if (!context.mounted) return;
                  KinlySnackBar.showSuccess(context, s.houseNormUrlCopied);
                },
              ),
            ),
            SizedBox(width: spacing?.sm ?? 8),
            Expanded(
              child: KinlyOutlinedButton.text(
                label: s.houseNormShareUrlCta,
                foregroundColor: palette.accent,
                borderColor: palette.accent,
                onPressed: () async {
                  await Share.share(
                    url,
                    subject: s.houseNormShareSubject,
                    sharePositionOrigin: sharePositionOriginForContext(context),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _HouseNormSectionCard extends StatelessWidget {
  const _HouseNormSectionCard({
    required this.title,
    required this.text,
    required this.palette,
    this.onTap,
  });

  final String title;
  final String text;
  final SectionColors palette;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>();

    final card = Container(
      padding: EdgeInsetsDirectional.fromSTEB(
        spacing?.lg ?? 16,
        spacing?.m ?? 12,
        spacing?.lg ?? 16,
        spacing?.m ?? 12,
      ),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.accent.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleMedium),
          SizedBox(height: spacing?.s ?? 8),
          Text(text, style: theme.textTheme.bodyMedium),
        ],
      ),
    );

    if (onTap == null) {
      return card;
    }

    return KinlyTapTarget(
      onTap: onTap!,
      borderRadius: BorderRadius.circular(16),
      child: card,
    );
  }
}

class _HouseNormEmpty extends StatelessWidget {
  const _HouseNormEmpty({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>();
    final palette = context.preferenceSection;

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(
        spacing?.lg ?? 16,
        spacing?.lg ?? 16,
        spacing?.lg ?? 16,
        spacing?.xl ?? 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.headlineSmall),
          SizedBox(height: spacing?.m ?? 12),
          Text(body, style: theme.textTheme.bodyMedium),
          SizedBox(height: spacing?.xl ?? 24),
          KinlyFilledButton.text(
            fullWidth: true,
            label: S.of(context).houseNormDoneCta,
            backgroundColor: palette.accent,
            foregroundColor: palette.onAccent(),
            onPressed: () => context.goNamed(AppRouteNames.today),
          ),
        ],
      ),
    );
  }
}

class _DirectionalBackButton extends StatelessWidget {
  const _DirectionalBackButton({
    required this.onTap,
    required this.label,
    required this.colors,
  });

  final VoidCallback onTap;
  final String label;
  final SectionColors colors;

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Semantics(
      button: true,
      label: label,
      child: KinlyTapTarget(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: SizedBox(
          height: 48,
          width: 48,
          child: Center(
            child: Transform.scale(
              scaleX: isRtl ? 1.0 : -1.0,
              scaleY: 1.0,
              child: Icon(KinlyIcons.chevronRightRounded, color: colors.icon),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _openSectionEditor(
  BuildContext context, {
  required String sectionKey,
  required String title,
  required String text,
}) async {
  final reportCubit = context.read<HouseNormReportCubit>();
  final updated = await context.pushNamed(
    AppRouteNames.houseNormsSectionEdit,
    pathParameters: {'sectionKey': sectionKey},
    extra: HouseNormSectionRouteArgs(
      sectionKey: sectionKey,
      title: title,
      text: text,
      reportCubit: reportCubit,
    ),
  );
  if (context.mounted && updated == true) {
    await reportCubit.refresh();
  }
}

int _estimateLineCount(String text, double fontSize) {
  if (text.isEmpty) return 1;
  final charsPerLine = (240 / (fontSize * 0.55)).floor().clamp(10, 60);
  return (text.length / charsPerLine).ceil().clamp(1, 8);
}
