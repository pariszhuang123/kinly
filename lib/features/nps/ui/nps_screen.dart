import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/app_config.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/ui/buttons/kinly_outlined_button.dart';
import '../../../core/ui/kinly_loader.dart';
import '../../../core/ui/snackbars/kinly_snackbar.dart';
import '../../../core/utils/kinly_support.dart';
import '../../../core/utils/enums/kinly_support_intent.dart';
import '../../../generated/l10n.dart';
import '../bloc/nps_cubit.dart';

class NpsScreen extends StatelessWidget {
  const NpsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;
    final s = S.of(context);

    return BlocListener<NpsCubit, NpsState>(
      listenWhen:
          (previous, current) =>
              previous.submitSuccessTick != current.submitSuccessTick &&
              current.lastSubmittedScore != null,
      listener:
          (context, state) =>
              _handleSuccess(context, state.lastSubmittedScore!),
      child: BlocListener<NpsCubit, NpsState>(
        listenWhen:
            (prev, curr) =>
                prev.submitError != curr.submitError &&
                curr.submitError != null,
        listener: (context, state) {
          KinlySnackBar.showError(
            context,
            _errorMessage(context, state.submitError!),
          );
        },
        child: PopScope(
          canPop: false,
          child: Scaffold(
            body: SafeArea(
              child: Padding(
                padding: EdgeInsetsDirectional.all(spacing.lg),
                child: BlocBuilder<NpsCubit, NpsState>(
                  builder: (context, state) {
                    return Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: spacing.sm),
                            Text(
                              s.npsTitle,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: spacing.md),
                            Text(
                              s.npsDescription,
                              style: theme.textTheme.bodyLarge,
                            ),
                            SizedBox(height: spacing.lg),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  s.npsScaleLowLabel,
                                  style: theme.textTheme.bodySmall,
                                ),
                                Text(
                                  s.npsScaleHighLabel,
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                            SizedBox(height: spacing.sm),
                            AbsorbPointer(
                              absorbing: state.isSubmitting,
                              child: Wrap(
                                spacing: spacing.sm,
                                runSpacing: spacing.sm,
                                children: List.generate(
                                  11,
                                  (index) => KinlyOutlinedButton.text(
                                    onPressed:
                                        () => context
                                            .read<NpsCubit>()
                                            .submitScore(index),
                                    label: index.toString(),
                                    compact: true,
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              s.npsCannotSkip,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            SizedBox(height: spacing.sm),
                          ],
                        ),
                        if (state.isSubmitting)
                          Positioned.fill(
                            child: Container(
                              color: theme.colorScheme.surface.withValues(
                                alpha: 0.6,
                              ),
                              child: const Center(child: KinlyLoader()),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _errorMessage(BuildContext context, String code) {
    final s = S.of(context);
    switch (code) {
      case 'notEligible':
      case 'notRequired':
        return s.npsSubmitErrorNotRequired;
      case 'invalidScore':
        return s.npsSubmitErrorInvalidScore;
      case 'forbidden':
        return s.npsSubmitErrorForbidden;
      default:
        return s.npsSubmitErrorGeneric;
    }
  }

  Future<void> _handleSuccess(BuildContext context, int score) async {
    final s = S.of(context);
    final uri = _destinationUri(context, score);

    if (uri != null) {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        KinlySnackBar.showError(context, s.npsLaunchError);
      }
    }

    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  Uri? _destinationUri(BuildContext context, int score) {
    if (Platform.isIOS) {
      return KinlySupport.buildEmailUri(context, KinlySupportIntent.nps);
    }

    if (Platform.isAndroid && score >= 9) {
      if (AppConfig.androidStoreUrl.isEmpty) return null;
      return Uri.parse(AppConfig.androidStoreUrl);
    }

    return KinlySupport.buildEmailUri(context, KinlySupportIntent.nps);
  }
}
