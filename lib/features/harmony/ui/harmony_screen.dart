import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/mood/enums/mood_scale.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/ui/buttons/kinly_filled_button.dart';
import '../../../core/ui/kinly_loader.dart';
import '../../../core/ui/kinly_toast.dart';
import '../../../core/ui/buttons/kinly_option_selector_row.dart';
import '../../../core/ui/kinly_comment_box.dart';
import '../../../core/ui/kinly_toggle.dart';
import '../../../generated/l10n.dart';
import '../bloc/harmony_cubit.dart';

class HarmonyScreen extends StatelessWidget {
  final String homeId;
  const HarmonyScreen({super.key, required this.homeId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;
    final s = S.of(context);

    return BlocListener<HarmonyCubit, HarmonyState>(
      listenWhen:
          (previous, current) =>
              previous.submitSuccessTick != current.submitSuccessTick ||
              previous.submitError != current.submitError,
      listener: (context, state) {
        if (state.submitSuccessTick > 0) {
          KinlyToast.showSuccess(context, s.harmonySubmitSuccess);
          Navigator.of(context, rootNavigator: true).pop(true);
        } else if (state.submitError != null) {
          final message = _mapError(context, state.submitError!);
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(SnackBar(content: Text(message)));
        }
      },
      child: BlocBuilder<HarmonyCubit, HarmonyState>(
        builder: (context, state) {
          final canPop = state.submitSuccessTick > 0;
          return PopScope(
            canPop: canPop,
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text(s.harmonyTitle),
              ),
              resizeToAvoidBottomInset: true,
              body: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(spacing.lg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s.harmonyQuestion,
                              style: theme.textTheme.headlineSmall,
                            ),
                            SizedBox(height: spacing.md),
                            Text(
                              s.harmonySubtext,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            SizedBox(height: spacing.lg),
                            _MoodSelector(),
                            SizedBox(height: spacing.lg),
                            _CommentBox(),
                            SizedBox(height: spacing.md),
                            _GratitudeToggle(),
                            SizedBox(height: spacing.lg),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        spacing.lg,
                        spacing.sm,
                        spacing.lg,
                        spacing.lg,
                      ),
                      child: _SubmitButton(),
                    ),
                  ],
                ),
              ),
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

class _MoodSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    final options = <KinlySelectorOption<MoodScale>>[
      KinlySelectorOption(
        value: MoodScale.sunny,
        label: s.harmonyMoodSunny,
        svgAsset: 'assets/icons/weather/Sunny.svg',
      ),
      KinlySelectorOption(
        value: MoodScale.partiallySunny,
        label: s.harmonyMoodPartiallySunny,
        svgAsset: 'assets/icons/weather/Partially Sunny.svg',
      ),
      KinlySelectorOption(
        value: MoodScale.cloudy,
        label: s.harmonyMoodCloudy,
        svgAsset: 'assets/icons/weather/Cloudy.svg',
      ),
      KinlySelectorOption(
        value: MoodScale.rainy,
        label: s.harmonyMoodRainy,
        svgAsset: 'assets/icons/weather/Raining.svg',
      ),
      KinlySelectorOption(
        value: MoodScale.thunderstorm,
        label: s.harmonyMoodThunderstorm,
        svgAsset: 'assets/icons/weather/Thunderstorm.svg',
      ),
    ];

    return BlocBuilder<HarmonyCubit, HarmonyState>(
      builder: (context, state) {
        return KinlyOptionSelectorRow<MoodScale>(
          options: options,
          selectedValue: state.selectedMood,
          onChanged: context.read<HarmonyCubit>().selectMood,
          iconSize: 40,
          optionWidth: 60,
          showLabel: false,
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
          // isDarkOverride: true/false if you ever want to force it
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
          subtitle: s.harmonyShareSubtitle,
          visible: canShare && hasComment,
          // isDarkOverride: true/false optional
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
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
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(SnackBar(content: Text(s.harmonyErrorSelectMood)));
            return;
          }
          context.read<HarmonyCubit>().submit();
        }
        return Stack(
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: canSubmit ? 1 : 0.5,
              child: KinlyFilledButton.text(
                label: s.harmonySubmitCta,
                onPressed: handler,
                fullWidth: true,
              ),
            ),
            if (state.isSubmitting)
              const Positioned(right: 24, child: KinlyLoader(size: 20)),
          ],
        );
      },
    );
  }
}
