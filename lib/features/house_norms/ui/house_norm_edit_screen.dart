import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/core/theme/kinly_sections.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/kinly_app_bar.dart';
import 'package:kinly/core/ui/kinly_icons.dart';
import 'package:kinly/core/ui/kinly_loader.dart';
import 'package:kinly/core/ui/kinly_masonry_grid.dart';
import 'package:kinly/core/ui/kinly_scaffold.dart';
import 'package:kinly/core/ui/kinly_tap_target.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/core/ui/scroll/kinly_scroll_fade.dart';
import 'package:kinly/features/house_norms/bloc/house_norm_report_cubit.dart';
import 'package:kinly/features/house_norms/domain/house_norm_content_localization.dart';
import 'package:kinly/features/house_norms/domain/house_norm_document_view.dart';
import 'package:kinly/features/house_norms/ui/house_norm_section_route_args.dart';
import 'package:kinly/generated/l10n.dart';

class HouseNormEditScreen extends StatelessWidget {
  const HouseNormEditScreen({super.key, this.canEdit = true});

  final bool canEdit;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>();
    final palette = context.preferenceSection;
    final s = S.of(context);

    return KinlyScaffold(
      appBar: KinlyAppBar(
        title: Text(canEdit ? s.houseNormEditTitle : s.houseNormViewTitle),
        leading: _DirectionalBackButton(
          label: s.houseNormOnboardingBack,
          colors: palette,
          onTap: () => context.pop(),
        ),
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: BlocBuilder<HouseNormReportCubit, HouseNormReportState>(
          builder: (context, state) {
            if (state.status == HouseNormReportStatus.loading) {
              return const Center(child: KinlyLoader());
            }
            final document = state.document;
            final content =
                document == null ? null : resolveHouseNormDisplayContent(document);
            if (document == null || content == null) {
              return Center(child: Text(s.houseNormReportEmptyTitle));
            }
            final items = <_EditableNormSection>[
              _EditableNormSection(
                sectionKey: 'summary_framing',
                title: s.houseNormSummaryFramingLabel,
                text: content.summary.framing,
              ),
              ...content.sections.map(
                (section) => _EditableNormSection(
                  sectionKey: section.sectionKey,
                  title: localizeHouseNormSectionTitle(s, section),
                  text: section.text,
                ),
              ),
            ];

            return KinlyScrollFade(
              child: SingleChildScrollView(
                padding: EdgeInsetsDirectional.fromSTEB(
                  spacing?.lg ?? 16,
                  spacing?.lg ?? 16,
                  spacing?.lg ?? 16,
                  spacing?.xl ?? 24,
                ),
                child: KinlyMasonryGrid<_EditableNormSection>(
                  items: items,
                  palette: KinlySectionPalette([palette]),
                  builder: (context, item, _, itemPalette) {
                    return _HouseNormEditCard(
                      title: item.title,
                      text: item.text,
                      onTap:
                          canEdit
                              ? () => _handleSectionTap(
                                context,
                                HouseNormSectionRouteArgs(
                                  sectionKey: item.sectionKey,
                                  title: item.title,
                                  text: item.text,
                                  reportCubit:
                                      context.read<HouseNormReportCubit>(),
                                ),
                              )
                              : () {},
                      palette: itemPalette.colorForSeed(item.sectionKey),
                    );
                  },
                  estimateItemHeight: (item, textTheme, spacingTokens) {
                    final titleStyle = textTheme.titleMedium;
                    final bodyStyle = textTheme.bodyMedium;
                    final titleLines = _estimateLineCount(
                      item.title,
                      titleStyle?.fontSize ?? 16,
                    );
                    final bodyLines = _estimateLineCount(
                      item.text,
                      bodyStyle?.fontSize ?? 14,
                    );
                    final lineHeightTitle =
                        (titleStyle?.height ?? 1.2) *
                        (titleStyle?.fontSize ?? 16);
                    final lineHeightBody =
                        (bodyStyle?.height ?? 1.2) *
                        (bodyStyle?.fontSize ?? 14);
                    return (spacingTokens.lg + spacingTokens.m + spacingTokens.lg) +
                        lineHeightTitle * titleLines +
                        spacingTokens.s +
                        lineHeightBody * bodyLines +
                        spacingTokens.m;
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

Future<void> _handleSectionTap(
  BuildContext context,
  HouseNormSectionRouteArgs args,
) async {
  final updated = await context.pushNamed(
    AppRouteNames.houseNormsSectionEdit,
    pathParameters: {'sectionKey': args.sectionKey},
    extra: args,
  );
  if (context.mounted && updated == true) {
    await context.read<HouseNormReportCubit>().refresh();
  }
}

class _EditableNormSection {
  const _EditableNormSection({
    required this.sectionKey,
    required this.title,
    required this.text,
  });

  final String sectionKey;
  final String title;
  final String text;
}

class _HouseNormEditCard extends StatelessWidget {
  const _HouseNormEditCard({
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

int _estimateLineCount(String text, double fontSize) {
  if (text.isEmpty) return 1;
  final charsPerLine = (240 / (fontSize * 0.55)).floor().clamp(10, 60);
  return (text.length / charsPerLine).ceil().clamp(1, 8);
}
