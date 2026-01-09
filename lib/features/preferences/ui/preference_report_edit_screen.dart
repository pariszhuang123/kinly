import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/kinly_app_bar.dart';
import 'package:kinly/core/ui/kinly_loader.dart';
import 'package:kinly/core/ui/kinly_masonry_grid.dart';
import 'package:kinly/core/ui/kinly_scaffold.dart';
import 'package:kinly/core/ui/kinly_tap_target.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/core/ui/kinly_icons.dart';
import 'package:kinly/generated/l10n.dart';
import '../bloc/preference_report_cubit.dart';
import 'preference_report_section_route_args.dart';
import 'package:kinly/contracts/preferences/models.dart';

class PreferenceReportEditScreen extends StatelessWidget {
  const PreferenceReportEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>();
    final s = S.of(context);

    return KinlyScaffold(
      appBar: KinlyAppBar(
        title: Text(s.preferenceReportEditTitle),
        leading: _DirectionalBackButton(
          label: s.preferenceOnboardingBack,
          onTap: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<PreferenceReportCubit, PreferenceReportState>(
          builder: (context, state) {
            if (state.status == PreferenceReportStatus.loading) {
              return const Center(child: KinlyLoader());
            }
            if (state.report == null) {
              return Center(child: Text(s.preferenceReportEmptyTitle));
            }
            return _PreferenceEditGrid(
              sections: state.report!.content.sections,
              spacing: spacing,
              onSectionTap: (section) => _handleSectionTap(context, section),
            );
          },
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
    required this.onSectionTap,
  });

  final List<PreferenceReportSection> sections;
  final Spacing? spacing;
  final void Function(PreferenceReportSection section) onSectionTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(
        spacing?.lg ?? 16,
        spacing?.lg ?? 16,
        spacing?.lg ?? 16,
        spacing?.xl ?? 24,
      ),
      child: KinlyMasonryGrid(
        items: sections,
        builder: (context, section, _, palette) {
          return _PreferenceEditCard(
            title: section.title,
            text: section.text,
            onTap: () => onSectionTap(section),
            accent: palette.colorForSeed(section.sectionKey).accent,
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
    );
  }
}

class _PreferenceEditCard extends StatelessWidget {
  const _PreferenceEditCard({
    required this.title,
    required this.text,
    required this.onTap,
    required this.accent,
  });

  final String title;
  final String text;
  final VoidCallback onTap;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>();
    final colors = theme.colorScheme;

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
          color: colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: accent.withValues(alpha: 0.35)),
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

int _estimateLineCount(String text, double fontSize) {
  if (text.isEmpty) return 1;
  final charsPerLine = (240 / (fontSize * 0.55)).floor().clamp(10, 60);
  return (text.length / charsPerLine).ceil().clamp(1, 8);
}
