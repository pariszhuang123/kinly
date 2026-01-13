import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/core/theme/kinly_sections.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/kinly_app_bar.dart';
import 'package:kinly/core/ui/kinly_loader.dart';
import 'package:kinly/core/ui/kinly_masonry_grid.dart';
import 'package:kinly/core/ui/kinly_scaffold.dart';
import 'package:kinly/core/ui/kinly_tap_target.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/core/ui/kinly_icons.dart';
import 'package:kinly/core/ui/scroll/kinly_scroll_fade.dart';
import 'package:kinly/generated/l10n.dart';
import '../bloc/preference_report_cubit.dart';
import 'preference_report_section_route_args.dart';
import 'package:kinly/contracts/preferences/models.dart';

class PreferenceReportEditScreen extends StatelessWidget {
  const PreferenceReportEditScreen({
    super.key,
    this.subjectDisplayName,
    this.subjectAvatarUrl,
    this.canEdit = true,
  });

  final String? subjectDisplayName;
  final String? subjectAvatarUrl;
  final bool canEdit;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>();
    final preferenceColors = context.preferenceSection;
    final s = S.of(context);
    final headerName =
        subjectDisplayName?.isNotEmpty == true
            ? subjectDisplayName!
            : s.friendDefaultName;

    return KinlyScaffold(
      appBar: KinlyAppBar(
        title: Text(
          canEdit ? s.preferenceReportEditTitle : s.preferenceReportViewTitle,
        ),
        leading: _DirectionalBackButton(
          label: s.preferenceOnboardingBack,
          colors: preferenceColors,
          onTap: () => context.goNamed(AppRouteNames.hub),
        ),
        backgroundColor: preferenceColors.background,
        foregroundColor: preferenceColors.icon,
      ),
      backgroundColor: preferenceColors.background,
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) return;
          if (context.mounted) {
            context.goNamed(AppRouteNames.hub);
          }
        },
        child: SafeArea(
          child: BlocBuilder<PreferenceReportCubit, PreferenceReportState>(
            builder: (context, state) {
              if (state.status == PreferenceReportStatus.loading) {
                return const Center(child: KinlyLoader());
              }
              if (state.report == null) {
                return Center(child: Text(s.preferenceReportEmptyTitle));
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                      spacing?.lg ?? 16,
                      spacing?.lg ?? 16,
                      spacing?.lg ?? 16,
                      spacing?.m ?? 12,
                    ),
                    child: _SubjectHeader(
                      name: headerName,
                      avatarUrl: subjectAvatarUrl,
                    ),
                  ),
                  Expanded(
                    child: KinlyScrollFade(
                      child: SingleChildScrollView(
                        padding: EdgeInsetsDirectional.fromSTEB(
                          spacing?.lg ?? 16,
                          0,
                          spacing?.lg ?? 16,
                          spacing?.xl ?? 24,
                        ),
                        child: _PreferenceEditGrid(
                          sections: state.report!.content.sections,
                          spacing: spacing,
                          canEdit: canEdit,
                          palette: preferenceColors,
                          onSectionTap:
                              (section) => _handleSectionTap(context, section),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

Future<void> _handleSectionTap(
  BuildContext context,
  PreferenceReportSection section,
) async {
  final updated = await context.pushNamed(
    AppRouteNames.preferenceReportSectionEdit,
    pathParameters: {'sectionKey': section.sectionKey},
    extra: PreferenceReportSectionRouteArgs(
      sectionKey: section.sectionKey,
      title: section.title,
      text: section.text,
    ),
  );
  if (context.mounted && updated == true) {
    await context.read<PreferenceReportCubit>().refresh();
  }
}

class _PreferenceEditGrid extends StatelessWidget {
  const _PreferenceEditGrid({
    required this.sections,
    required this.spacing,
    required this.canEdit,
    required this.onSectionTap,
    required this.palette,
  });

  final List<PreferenceReportSection> sections;
  final Spacing? spacing;
  final bool canEdit;
  final void Function(PreferenceReportSection section) onSectionTap;
  final SectionColors palette;

  @override
  Widget build(BuildContext context) {
    return KinlyMasonryGrid(
      items: sections,
      palette: KinlySectionPalette([palette]),
      builder: (context, section, _, palette) {
        return _PreferenceEditCard(
          title: section.title,
          text: section.text,
          onTap: () {
            if (!canEdit) return;
            onSectionTap(section);
          },
          palette: palette.colorForSeed(section.sectionKey),
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
    );
  }
}

class _PreferenceEditCard extends StatelessWidget {
  const _PreferenceEditCard({
    required this.title,
    required this.text,
    required this.onTap,
    required this.palette,
  });

  final String title;
  final String text;
  final VoidCallback onTap;
  final SectionColors palette;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>();

    return KinlyTapTarget(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsetsDirectional.fromSTEB(
          spacing?.lg ?? 16,
          spacing?.m ?? 12,
          spacing?.lg ?? 16,
          spacing?.m ?? 12,
        ),
        decoration: BoxDecoration(
          color: palette.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: palette.accent.withValues(alpha: 0.35)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            SizedBox(height: spacing?.s ?? 8),
            Text(text, style: theme.textTheme.bodyMedium),
          ],
        ),
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

class _SubjectHeader extends StatelessWidget {
  const _SubjectHeader({required this.name, this.avatarUrl});

  final String name;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = theme.extension<Spacing>();
    final palette = context.preferenceSection;
    final hasAvatar = avatarUrl != null && avatarUrl!.isNotEmpty;

    return Row(
      children: [
        Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: palette.accent.withValues(alpha: 0.16),
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
                    color: palette.icon,
                  ),
        ),
        SizedBox(width: spacing?.sm ?? 8),
        Expanded(
          child: Text(
            name,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}

int _estimateLineCount(String text, double fontSize) {
  if (text.isEmpty) return 1;
  final charsPerLine = (240 / (fontSize * 0.55)).floor().clamp(10, 60);
  return (text.length / charsPerLine).ceil().clamp(1, 8);
}
