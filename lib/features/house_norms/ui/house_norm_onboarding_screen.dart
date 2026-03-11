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
import 'package:kinly/core/ui/reflective_generation/reflective_generation_overlay.dart';
import 'package:kinly/core/ui/selector/kinly_onboarding_option_card.dart';
import 'package:kinly/core/ui/snackbars/kinly_snackbar.dart';
import 'package:kinly/features/house_norms/bloc/house_norm_capture_bloc.dart';
import 'package:kinly/features/house_norms/routes/house_norm_report_navigation_args.dart';
import 'package:kinly/generated/l10n.dart';

class HouseNormOnboardingScreen extends StatelessWidget {
  const HouseNormOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>();
    final palette = context.houseNormSection;
    final s = S.of(context);

    return BlocConsumer<HouseNormCaptureBloc, HouseNormCaptureState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == HouseNormCaptureStatus.success) {
          context.goNamed(
            AppRouteNames.houseNormsReport,
            extra: HouseNormReportNavigationArgs(
              showConfetti: true,
              initialDocument: state.generatedDocument,
              backRouteName: AppRouteNames.today,
            ),
          );
        } else if (state.status == HouseNormCaptureStatus.failure) {
          KinlySnackBar.showError(context, s.houseNormGenerationFailed);
          context.goNamed(AppRouteNames.today);
        }
      },
      builder: (context, state) {
        final scenario = state.scenarios[state.currentIndex];
        final selectedIndex = state.responses[scenario.id];
        final isLast = state.currentIndex == state.scenarios.length - 1;
        final isSubmitting = state.status == HouseNormCaptureStatus.submitting;
        final isReflecting = state.status == HouseNormCaptureStatus.reflecting;
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
            title: Text(s.houseNormOnboardingTitle),
            leading: _DirectionalBackButton(
              label: s.houseNormOnboardingBack,
              colors: palette,
              onTap:
                  state.currentIndex > 0
                      ? () => context.read<HouseNormCaptureBloc>().add(
                        const HouseNormCapturePreviousRequested(),
                      )
                      : () => context.pop(),
            ),
            backgroundColor: palette.background,
            foregroundColor: palette.icon,
          ),
          backgroundColor: palette.background,
          body: Stack(
            children: [
              SafeArea(
                child: Padding(
                  padding: contentPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        s.houseNormOnboardingProgress(
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
                            return KinlyOnboardingOptionCard(
                              label: optionText,
                              isSelected: isSelected,
                              colors: palette,
                              onTap:
                                  isBusy
                                      ? null
                                      : () {
                                        context
                                            .read<HouseNormCaptureBloc>()
                                            .add(
                                              HouseNormCaptureOptionSelected(
                                                scenarioId: scenario.id,
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
                          label: s.houseNormOnboardingSubmit,
                          backgroundColor: palette.accent,
                          disabledBackgroundColor: palette.background,
                          disabledForegroundColor: palette.icon.withValues(
                            alpha: 0.4,
                          ),
                          onPressed:
                              canSubmit
                                  ? () => context.read<HouseNormCaptureBloc>().add(
                                    const HouseNormCaptureSubmitted(),
                                  )
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
                    mode: state.reflectiveMode!,
                    onCompleted: () {
                      context.read<HouseNormCaptureBloc>().add(
                        const HouseNormCaptureReflectionCompleted(),
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
