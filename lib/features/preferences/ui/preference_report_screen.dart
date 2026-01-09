import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/buttons/kinly_filled_button.dart';
import 'package:kinly/core/ui/buttons/kinly_outlined_button.dart';
import 'package:kinly/core/ui/kinly_app_bar.dart';
import 'package:kinly/core/ui/kinly_loader.dart';
import 'package:kinly/core/ui/kinly_scaffold.dart';
import 'package:kinly/core/ui/kinly_tap_target.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/core/ui/kinly_icons.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/contracts/preferences/models.dart';
import '../bloc/preference_report_cubit.dart';

class PreferenceReportScreen extends StatelessWidget {
  const PreferenceReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>();
    final s = S.of(context);

    return KinlyScaffold(
      appBar: KinlyAppBar(
        title: Text(s.preferenceReportTitle),
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
            return Padding(
              padding: EdgeInsetsDirectional.fromSTEB(
                spacing?.lg ?? 16,
                spacing?.lg ?? 16,
                spacing?.lg ?? 16,
                spacing?.xl ?? 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    report.content.summary.title,
                    style: theme.textTheme.headlineSmall,
                  ),
                  SizedBox(height: spacing?.s ?? 8),
                  Text(
                    report.content.summary.subtitle,
                    style: theme.textTheme.bodyMedium,
                  ),
                  SizedBox(height: spacing?.lg ?? 16),
                  Expanded(
                    child: ListView.separated(
                      itemCount: report.content.sections.length,
                      separatorBuilder: (_, __) =>
                          SizedBox(height: spacing?.m ?? 12),
                      itemBuilder: (context, index) {
                        final section = report.content.sections[index];
                        return _PreferenceReportSectionCard(section: section);
                      },
                    ),
                  ),
                  SizedBox(height: spacing?.lg ?? 16),
                  KinlyFilledButton.text(
                    fullWidth: true,
                    label: s.preferenceReportEditCta,
                    onPressed: () async {
                      await context.pushNamed(
                        AppRouteNames.preferenceReportEdit,
                      );
                      if (context.mounted) {
                        await context.read<PreferenceReportCubit>().refresh();
                      }
                    },
                  ),
                  SizedBox(height: spacing?.m ?? 12),
                  KinlyOutlinedButton.text(
                    fullWidth: true,
                    label: s.preferenceReportDoneCta,
                    onPressed: () => context.goNamed(AppRouteNames.today),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PreferenceReportSectionCard extends StatelessWidget {
  const _PreferenceReportSectionCard({required this.section});

  final PreferenceReportSection section;

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
