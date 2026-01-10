import 'package:confetti/confetti.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/core/theme/kinly_sections.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/buttons/kinly_filled_button.dart';
import 'package:kinly/core/ui/buttons/kinly_outlined_button.dart';
import 'package:kinly/core/ui/kinly_app_bar.dart';
import 'package:kinly/core/ui/kinly_confetti_overlay.dart';
import 'package:kinly/core/ui/kinly_loader.dart';
import 'package:kinly/core/ui/kinly_scaffold.dart';
import 'package:kinly/core/ui/kinly_tap_target.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/core/ui/kinly_icons.dart';
import 'package:kinly/core/ui/kinly_masonry_grid.dart';
import 'package:kinly/core/ui/scroll/kinly_scroll_fade.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/contracts/preferences/models.dart';
import '../bloc/preference_report_cubit.dart';

class PreferenceReportScreen extends StatefulWidget {
  const PreferenceReportScreen({
    super.key,
    this.showConfetti = false,
    this.canEdit = true,
    this.popOnDone = false,
    this.subjectDisplayName,
    this.subjectAvatarUrl,
  });

  final bool showConfetti;
  final bool canEdit;
  final bool popOnDone;
  final String? subjectDisplayName;
  final String? subjectAvatarUrl;

  @override
  State<PreferenceReportScreen> createState() => _PreferenceReportScreenState();
}

class _PreferenceReportScreenState extends State<PreferenceReportScreen> {
  late final ConfettiController _confettiController;
  bool _hasPlayedConfetti = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    _playConfettiIfNeeded();
  }

  @override
  void didUpdateWidget(covariant PreferenceReportScreen oldWidget) {
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
    final spacing = theme.extension<Spacing>();
    final sections = theme.extension<KinlySections>();
    final colors = theme.colorScheme;
    final s = S.of(context);
    final headerName =
        widget.subjectDisplayName?.isNotEmpty == true
            ? widget.subjectDisplayName!
            : s.friendDefaultName;

    return KinlyScaffold(
      appBar: KinlyAppBar(
        title: Text(s.preferenceReportTitle),
        leading: _DirectionalBackButton(
          label: s.preferenceOnboardingBack,
          onTap: () => context.pop(),
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: BlocBuilder<PreferenceReportCubit, PreferenceReportState>(
              builder: (context, state) {
                if (state.status == PreferenceReportStatus.loading) {
                  return const Center(child: KinlyLoader());
                }
                if (state.status == PreferenceReportStatus.empty) {
                  return _PreferenceReportEmpty(
                    title: s.preferenceReportEmptyTitle,
                    body: s.preferenceReportEmptyBody,
                  );
                }
                if (state.status == PreferenceReportStatus.failure) {
                  return _PreferenceReportEmpty(
                    title: s.preferenceReportErrorTitle,
                    body: s.preferenceReportErrorBody,
                  );
                }
                final report = state.report!;
                return KinlyScrollFade(
                  child: SingleChildScrollView(
                    padding: EdgeInsetsDirectional.fromSTEB(
                      spacing?.lg ?? 16,
                      spacing?.lg ?? 16,
                      spacing?.lg ?? 16,
                      spacing?.xl ?? 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (!widget.canEdit) ...[
                          Text(
                            s.preferenceReportReadOnlyNote,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          SizedBox(height: spacing?.m ?? 12),
                        ],
                        Text(
                          report.content.summary.title,
                          style: theme.textTheme.headlineSmall,
                        ),
                        SizedBox(height: spacing?.s ?? 8),
                        _SubjectHeader(
                          name: headerName,
                          avatarUrl: widget.subjectAvatarUrl,
                        ),
                        SizedBox(height: spacing?.s ?? 8),
                        Text(
                          report.content.summary.subtitle,
                          style: theme.textTheme.bodyMedium,
                        ),
                        SizedBox(height: spacing?.lg ?? 16),
                        KinlyMasonryGrid(
                          items: report.content.sections,
                          builder: (context, section, _, palette) {
                            return _PreferenceReportSectionCard(
                              section: section,
                              accent:
                                  palette
                                      .colorForSeed(section.sectionKey)
                                      .accent,
                            );
                          },
                          estimateItemHeight: (
                            section,
                            textTheme,
                            spacingTokens,
                          ) {
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
                                (titleStyle?.height ?? 1.2) *
                                (titleStyle?.fontSize ?? 16);
                            final lineHeightBody =
                                (bodyStyle?.height ?? 1.2) *
                                (bodyStyle?.fontSize ?? 14);
                            return (spacingTokens.lg +
                                    spacingTokens.m +
                                    spacingTokens.lg) +
                                lineHeightTitle * titleLines +
                                spacingTokens.s +
                                lineHeightBody * bodyLines +
                                spacingTokens.m;
                          },
                        ),
                        SizedBox(height: spacing?.lg ?? 16),
                        if (widget.canEdit) ...[
                          KinlyFilledButton.text(
                            fullWidth: true,
                            label: s.preferenceReportEditCta,
                            onPressed: () async {
                              await context.pushNamed(
                                AppRouteNames.preferenceReportEdit,
                              );
                              if (context.mounted) {
                                await context
                                    .read<PreferenceReportCubit>()
                                    .refresh();
                              }
                            },
                          ),
                          SizedBox(height: spacing?.m ?? 12),
                        ],
                        KinlyOutlinedButton.text(
                          fullWidth: true,
                          label: s.preferenceReportDoneCta,
                          onPressed: () {
                            if (widget.popOnDone && context.canPop()) {
                              context.pop();
                              return;
                            }
                            context.goNamed(AppRouteNames.today);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (sections != null)
            Positioned.fill(
              child: KinlyConfettiOverlay(
                confettiController: _confettiController,
                colors: [
                  sections.flow.accent,
                  sections.share.accent,
                  colors.primary,
                  colors.secondary,
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _PreferenceReportSectionCard extends StatelessWidget {
  const _PreferenceReportSectionCard({required this.section, this.accent});

  final PreferenceReportSection section;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>();
    final colors = theme.colorScheme;

    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(
        spacing?.lg ?? 16,
        spacing?.m ?? 12,
        spacing?.lg ?? 16,
        spacing?.m ?? 12,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (accent ?? colors.outlineVariant).withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(section.title, style: theme.textTheme.titleMedium),
          SizedBox(height: spacing?.s ?? 8),
          Text(section.text, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _PreferenceReportEmpty extends StatelessWidget {
  const _PreferenceReportEmpty({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>();
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
            label: S.of(context).preferenceReportDoneCta,
            onPressed: () => context.goNamed(AppRouteNames.today),
          ),
        ],
      ),
    );
  }
}

class _DirectionalBackButton extends StatelessWidget {
  const _DirectionalBackButton({required this.onTap, required this.label});

  final VoidCallback onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final colors = theme.colorScheme;
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
              child: Icon(
                KinlyIcons.chevronRightRounded,
                color: colors.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SubjectHeader extends StatelessWidget {
  const _SubjectHeader({required this.name, this.avatarUrl});

  final String name;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final colors = theme.colorScheme;
    final spacing = theme.extension<Spacing>();
    final hasAvatar = avatarUrl != null && avatarUrl!.isNotEmpty;

    return Row(
      children: [
        Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.primary.withValues(alpha: 0.16),
            image:
                hasAvatar
                    ? DecorationImage(
                      image: NetworkImage(avatarUrl!),
                      fit: BoxFit.cover,
                    )
                    : null,
          ),
          child:
              hasAvatar
                  ? null
                  : Icon(
                    KinlyIcons.selfImprovementRounded,
                    color: colors.primary,
                  ),
        ),
        SizedBox(width: spacing?.sm ?? 8),
        Expanded(child: Text(name, style: theme.textTheme.titleMedium)),
      ],
    );
  }
}

int _estimateLineCount(String text, double fontSize) {
  if (text.isEmpty) return 1;
  final charsPerLine = (240 / (fontSize * 0.55)).floor().clamp(10, 60);
  return (text.length / charsPerLine).ceil().clamp(1, 8);
}
