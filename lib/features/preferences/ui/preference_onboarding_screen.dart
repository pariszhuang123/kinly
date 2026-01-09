import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/buttons/kinly_filled_button.dart';
import 'package:kinly/core/ui/kinly_app_bar.dart';
import 'package:kinly/core/ui/kinly_icons.dart';
import 'package:kinly/core/ui/kinly_scaffold.dart';
import 'package:kinly/core/ui/kinly_tap_target.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/generated/l10n.dart';
import '../bloc/preference_capture_bloc.dart';

class PreferenceOnboardingScreen extends StatelessWidget {
  const PreferenceOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>();
    final s = S.of(context);

    return BlocConsumer<PreferenceCaptureBloc, PreferenceCaptureState>(
      listenWhen:
          (previous, current) =>
              previous.status != current.status &&
              current.status == PreferenceCaptureStatus.success,
      listener: (context, state) {
        context.goNamed(AppRouteNames.preferenceReport);
      },
      builder: (context, state) {
        final scenario = state.scenarios[state.currentIndex];
        final selectedIndex = state.responses[scenario.id];
        final isLast = state.currentIndex == state.scenarios.length - 1;
        final isSubmitting = state.status == PreferenceCaptureStatus.submitting;
        final canSubmit = isLast && selectedIndex != null && state.isComplete;
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
              onTap:
                  state.currentIndex > 0
                      ? () => context.read<PreferenceCaptureBloc>().add(
                        const PreferenceCapturePreviousRequested(),
                      )
                      : () => context.pop(),
            ),
          ),
          body: SafeArea(
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
                      separatorBuilder: (_, __) =>
                          SizedBox(height: spacing?.m ?? 12),
                      itemBuilder: (context, index) {
                        final optionText = scenario.options[index](s);
                        final isSelected = selectedIndex == index;
                        return _PreferenceOptionTile(
                          label: optionText,
                          isSelected: isSelected,
                          onTap:
                              isSubmitting
                                  ? null
                                  : () {
                                    context.read<PreferenceCaptureBloc>().add(
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
                      onPressed:
                          canSubmit && !isSubmitting
                              ? () => context.read<PreferenceCaptureBloc>().add(
                                const PreferenceCaptureSubmitted(),
                              )
                              : null,
                    ),
                  ],
                ],
              ),
            ),
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
    this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>();
    final colors = theme.colorScheme;

    return KinlyTapTarget(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsetsDirectional.fromSTEB(
          spacing?.lg ?? 16,
          spacing?.m ?? 12,
          spacing?.lg ?? 16,
          spacing?.m ?? 12,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.primary.withValues(alpha: 0.08)
              : colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? colors.primary : colors.outlineVariant,
            width: isSelected ? 1.6 : 1,
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: isSelected ? colors.primary : colors.onSurfaceVariant,
          ),
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
