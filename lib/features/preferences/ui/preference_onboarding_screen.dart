import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/core/theme/kinly_sections.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/buttons/kinly_filled_button.dart';
import 'package:kinly/core/ui/kinly_app_bar.dart';
import 'package:kinly/core/ui/kinly_icons.dart';
import 'package:kinly/core/ui/kinly_scaffold.dart';
import 'package:kinly/core/ui/kinly_tap_target.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/core/ui/enums/reflective_generation_mode.dart';
import 'package:kinly/core/ui/reflective_generation/reflective_generation_overlay.dart';
import 'package:kinly/core/ui/snackbars/kinly_snackbar.dart';
import 'package:kinly/generated/l10n.dart';
import '../bloc/preference_capture_bloc.dart';
import '../routes/preference_report_navigation_args.dart';

class PreferenceOnboardingScreen extends StatelessWidget {
  const PreferenceOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>();
    final preferenceColors = context.preferenceSection;
    final s = S.of(context);

    return BlocConsumer<PreferenceCaptureBloc, PreferenceCaptureState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == PreferenceCaptureStatus.success) {
          final args = PreferenceReportNavigationArgs(
            showConfetti: true,
            initialReport: state.generatedReport,
          );
          context.goNamed(AppRouteNames.preferenceReport, extra: args);
        } else if (state.status == PreferenceCaptureStatus.failure) {
          final message =
              state.errorMessage == PreferenceCaptureBloc.missingReportErrorCode
                  ? s.preferenceReportGenerationMissing
                  : s.preferenceReportGenerationFailed;
          KinlySnackBar.showError(context, message);
          context.goNamed(AppRouteNames.today);
        }
      },
      builder: (context, state) {
        final scenario = state.scenarios[state.currentIndex];
        final selectedIndex = state.responses[scenario.id];
        final isLast = state.currentIndex == state.scenarios.length - 1;
        final isSubmitting = state.status == PreferenceCaptureStatus.submitting;
        final isReflecting = state.status == PreferenceCaptureStatus.reflecting;
        final isBusy = isSubmitting || isReflecting;
        final canSubmit =
            isLast && selectedIndex != null && state.isComplete && !isBusy;
        final contentPadding = EdgeInsetsDirectional.fromSTEB(
          spacing?.lg ?? 16,
          spacing?.lg ?? 16,
          spacing?.lg ?? 16,
          spacing?.xl ?? 24,
        );

        return KinlyScaffold(
          appBar: KinlyAppBar(
            title: Text(s.preferenceOnboardingTitle),
            leading: _DirectionalBackButton(
              label: s.preferenceOnboardingBack,
              colors: preferenceColors,
              onTap:
                  state.currentIndex > 0
                      ? () => context.read<PreferenceCaptureBloc>().add(
                        const PreferenceCapturePreviousRequested(),
                      )
                      : () => context.pop(),
            ),
            backgroundColor: preferenceColors.background,
            foregroundColor: preferenceColors.icon,
          ),
          backgroundColor: preferenceColors.background,
          body: Stack(
            children: [
              SafeArea(
                child: Padding(
                  padding: contentPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        s.preferenceOnboardingProgress(
                          state.currentIndex + 1,
                          state.scenarios.length,
                        ),
                        style: theme.textTheme.labelLarge,
                      ),
                      SizedBox(height: spacing?.m ?? 12),
                      Text(
                        scenario.question(s),
                        style: theme.textTheme.headlineSmall,
                      ),
                      SizedBox(height: spacing?.lg ?? 16),
                      Expanded(
                        child: ListView.separated(
                          itemCount: scenario.options.length,
                          separatorBuilder:
                              (_, __) => SizedBox(height: spacing?.m ?? 12),
                          itemBuilder: (context, index) {
                            final optionText = scenario.options[index](s);
                            final isSelected = selectedIndex == index;
                            return _PreferenceOptionTile(
                              label: optionText,
                              isSelected: isSelected,
                              colors: preferenceColors,
                              onTap:
                                  isBusy
                                      ? null
                                      : () {
                                        context
                                            .read<PreferenceCaptureBloc>()
                                            .add(
                                              PreferenceCaptureOptionSelected(
                                                preferenceId: scenario.id,
                                                optionIndex: index,
                                              ),
                                            );
                                      },
                            );
                          },
                        ),
                      ),
                      if (isLast && selectedIndex != null) ...[
                        SizedBox(height: spacing?.lg ?? 16),
                        KinlyFilledButton.text(
                          fullWidth: true,
                          label: s.preferenceOnboardingSubmit,
                          backgroundColor: preferenceColors.accent,
                          foregroundColor: preferenceColors.onAccent(),
                          disabledBackgroundColor: preferenceColors.background,
                          disabledForegroundColor: preferenceColors.icon
                              .withValues(alpha: 0.4),
                          onPressed:
                              canSubmit
                                  ? () => context
                                      .read<PreferenceCaptureBloc>()
                                      .add(const PreferenceCaptureSubmitted())
                                  : null,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if (isReflecting)
                Positioned.fill(
                  child: ReflectiveGenerationOverlay(
                    mode:
                        state.reflectiveMode ??
                        ReflectiveGenerationMode.personalPreferences,
                    onCompleted: () {
                      context.read<PreferenceCaptureBloc>().add(
                        const PreferenceCaptureReflectionCompleted(),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _PreferenceOptionTile extends StatelessWidget {
  const _PreferenceOptionTile({
    required this.label,
    required this.isSelected,
    required this.colors,
    this.onTap,
  });

  final String label;
  final bool isSelected;
  final SectionColors colors;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>();
    final colorScheme = theme.colorScheme;

    return KinlyTapTarget(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      alignment: AlignmentDirectional.centerStart,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsetsDirectional.fromSTEB(
          spacing?.lg ?? 16,
          spacing?.m ?? 12,
          spacing?.lg ?? 16,
          spacing?.m ?? 12,
        ),
        decoration: BoxDecoration(
          color: isSelected ? colors.card : colors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? colors.accent : colorScheme.outlineVariant,
            width: isSelected ? 1.6 : 1,
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: isSelected ? colors.accent : colorScheme.onSurfaceVariant,
          ),
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
