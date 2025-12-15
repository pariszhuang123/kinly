import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/mood/enums/mood_scale.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/ui/snackbars/kinly_snackbar.dart';
import '../../../core/ui/buttons/kinly_filled_button.dart';
import '../../../core/ui/kinly_loader.dart';
import '../../../core/ui/kinly_toast.dart';
import '../../../core/ui/kinly_comment_box.dart';
import '../../../core/ui/toggles/kinly_toggle.dart';
import '../../../core/ui/harmony/kinly_weather_selector_row.dart';
import '../../../generated/l10n.dart';
import '../bloc/harmony_cubit.dart';
import 'package:go_router/go_router.dart';

/// Harmony content used by both the Harmony page and (legacy) bottom sheet.
/// Assumes [HarmonyCubit] is already provided above in the tree.
class HarmonyScreen extends StatelessWidget {
  final String homeId;
  final bool showHeader;

  const HarmonyScreen({
    super.key,
    required this.homeId,
    this.showHeader = true,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return BlocListener<HarmonyCubit, HarmonyState>(
      listenWhen:
          (previous, current) =>
              previous.submitSuccessTick != current.submitSuccessTick ||
              previous.submitError != current.submitError,
      listener: (context, state) {
        if (state.submitSuccessTick > 0) {
          KinlyToast.showSuccess(context, s.harmonySubmitSuccess);
          // Close the Harmony page and return success to caller.
          context.pop(true);
        } else if (state.submitError != null) {
          final message = _mapError(context, state.submitError!);
          KinlySnackBar.showError(context, message);
        }
      },
      child: BlocBuilder<HarmonyCubit, HarmonyState>(
        builder: (context, state) {
          final theme = Theme.of(context);
          final spacing = theme.extension<Spacing>()!;
          final canPop = state.submitSuccessTick > 0;

          return PopScope(
            canPop: canPop,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showHeader) ...[
                  _HarmonyHeader(spacing: spacing),
                  SizedBox(height: spacing.l),
                ],
                _MoodSelector(),
                SizedBox(height: spacing.l),
                _CommentBox(),
                SizedBox(height: spacing.m),
                _GratitudeToggle(),
              ],
            ),
          );
        },
      ),
    );
  }

  String _mapError(BuildContext context, String code) {
    final s = S.of(context);
    switch (code) {
      case 'moodAlreadySubmitted':
        return s.harmonyErrorAlreadySubmitted;
      case 'forbidden':
        return s.harmonyErrorForbidden;
      default:
        return s.harmonyErrorUnknown;
    }
  }
}

/// Separated submit button so it can be placed in the footer (page or sheet).
/// Must live under the same [HarmonyCubit] provider as [HarmonyScreen].
class HarmonySubmitButton extends StatelessWidget {
  const HarmonySubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return BlocBuilder<HarmonyCubit, HarmonyState>(
      builder: (context, state) {
        final hasMood = state.selectedMood != null;
        final canSubmit =
            hasMood && !state.isSubmitting && state.submitSuccessTick == 0;

        void handler() {
          if (!hasMood || state.submitSuccessTick > 0) {
            KinlySnackBar.showError(context, s.harmonyErrorSelectMood);
            return;
          }
          context.read<HarmonyCubit>().submit();
        }

        return Stack(
          alignment: Alignment.center,
          children: [
            KinlyFilledButton.text(
              label: s.harmonySubmitCta,
              onPressed: canSubmit ? handler : null,
              fullWidth: true,
            ),
            if (state.isSubmitting)
              const PositionedDirectional(
                end: 24,
                child: KinlyLoader(size: 20),
              ),
          ],
        );
      },
    );
  }
}

class _HarmonyHeader extends StatelessWidget {
  const _HarmonyHeader({required this.spacing});

  final Spacing spacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: spacing.xl),
        Text(
          s.harmonyQuestion,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _MoodSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    final options = <KinlyWeatherSelectorOption<MoodScale>>[
      KinlyWeatherSelectorOption(
        value: MoodScale.sunny,
        label: s.harmonyMoodSunny,
        svgAsset: 'assets/icons/weather/Sunny.svg',
      ),
      KinlyWeatherSelectorOption(
        value: MoodScale.partiallySunny,
        label: s.harmonyMoodPartiallySunny,
        svgAsset: 'assets/icons/weather/Partially Sunny.svg',
      ),
      KinlyWeatherSelectorOption(
        value: MoodScale.cloudy,
        label: s.harmonyMoodCloudy,
        svgAsset: 'assets/icons/weather/Cloudy.svg',
      ),
      KinlyWeatherSelectorOption(
        value: MoodScale.rainy,
        label: s.harmonyMoodRainy,
        svgAsset: 'assets/icons/weather/Raining.svg',
      ),
      KinlyWeatherSelectorOption(
        value: MoodScale.thunderstorm,
        label: s.harmonyMoodThunderstorm,
        svgAsset: 'assets/icons/weather/Thunderstorm.svg',
      ),
    ];

    return BlocBuilder<HarmonyCubit, HarmonyState>(
      builder: (context, state) {
        return KinlyWeatherSelectorRow<MoodScale>(
          options: options,
          selectedValue: state.selectedMood,
          onChanged: (mood) => context.read<HarmonyCubit>().selectMood(mood),
          showLabels: false,
        );
      },
    );
  }
}

class _CommentBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return BlocBuilder<HarmonyCubit, HarmonyState>(
      builder: (context, state) {
        return KinlyCommentBox(
          label: s.harmonyCommentLabel,
          hint: s.harmonyCommentHint,
          maxLines: 4,
          maxLength: 500,
          onChanged: context.read<HarmonyCubit>().commentChanged,
        );
      },
    );
  }
}

class _GratitudeToggle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return BlocBuilder<HarmonyCubit, HarmonyState>(
      builder: (context, state) {
        final canShare =
            state.selectedMood == MoodScale.sunny ||
            state.selectedMood == MoodScale.partiallySunny;
        final hasComment = state.comment.trim().isNotEmpty;

        return KinlyToggle(
          value: state.addToWall,
          onChanged:
              (value) => context.read<HarmonyCubit>().toggleAddToWall(value),
          title: s.harmonyShareLabel,
          visible: canShare && hasComment,
          // isDarkOverride: true/false optional
        );
      },
    );
  }
}
