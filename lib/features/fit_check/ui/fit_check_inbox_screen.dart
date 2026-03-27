import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/contracts/homes/fit_check_models.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/buttons/kinly_filled_button.dart';
import 'package:kinly/core/ui/kinly_app_bar.dart';
import 'package:kinly/core/ui/kinly_loader.dart';
import 'package:kinly/core/ui/kinly_scaffold.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/core/ui/snackbars/kinly_snackbar.dart';
import 'package:kinly/features/fit_check/bloc/fit_check_inbox_cubit.dart';
import 'package:kinly/generated/l10n.dart';

class FitCheckInboxScreen extends StatelessWidget {
  const FitCheckInboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>();
    final s = S.of(context);

    return BlocBuilder<FitCheckInboxCubit, FitCheckInboxState>(
      builder: (context, state) {
        return KinlyScaffold(
          appBar: KinlyAppBar(title: Text(s.fitCheckInboxTitle)),
          body: SafeArea(
            child: switch (state.status) {
              FitCheckInboxStatus.loading => const Center(child: KinlyLoader()),
              FitCheckInboxStatus.failure => _FitCheckMessageBody(
                title: s.fitCheckInboxErrorTitle,
                body: state.errorMessage ?? s.fitCheckInboxErrorBody,
              ),
              FitCheckInboxStatus.ready => _FitCheckInboxBody(
                spacing: spacing,
                onStartHouseNorms:
                    state.review?.homeId == null
                        ? null
                        : () => _startHouseNorms(context, state.review!.homeId!),
              ),
            },
          ),
        );
      },
    );
  }

  Future<void> _startHouseNorms(BuildContext context, String homeId) async {
    final cubit = context.read<FitCheckInboxCubit>();
    final s = S.of(context);
    try {
      final payload = await cubit.getPrefillPayload();
      if (!context.mounted) return;
      if (!fitCheckHasHouseNormSeed(payload)) {
        KinlySnackBar.showError(context, s.fitCheckLoadPrefillFailed);
        return;
      }
      context.pushNamed(
        AppRouteNames.houseNormsOnboarding,
        extra: {
          'homeIdOverride': homeId,
          'initialResponses': payload.houseNormInitialResponses,
          'entrySource': 'fit_check',
        },
      );
    } catch (_) {
      if (!context.mounted) return;
      KinlySnackBar.showError(context, s.fitCheckLoadPrefillFailed);
    }
  }
}

class _FitCheckInboxBody extends StatelessWidget {
  const _FitCheckInboxBody({
    required this.spacing,
    required this.onStartHouseNorms,
  });

  final Spacing? spacing;
  final VoidCallback? onStartHouseNorms;

  @override
  Widget build(BuildContext context) {
    final review = context.select((FitCheckInboxCubit cubit) => cubit.state.review);
    final s = S.of(context);
    if (review == null) {
      return _FitCheckMessageBody(
        title: s.fitCheckInboxErrorTitle,
        body: s.fitCheckInboxErrorBody,
      );
    }
    final submissions = fitCheckReviewSubmissions(review);
    if (submissions.isEmpty) {
      return _FitCheckMessageBody(
        title: s.fitCheckInboxEmptyTitle,
        body: s.fitCheckInboxEmptyBody,
        ctaLabel:
            onStartHouseNorms == null ? null : s.fitCheckStartHouseNormsCta,
        onPressed: onStartHouseNorms,
      );
    }
    final currentGeneration = fitCheckCurrentShareGeneration(review);
    final historicalGenerations =
        review.shareGenerations
            .where((generation) => !generation.isCurrent)
            .toList(growable: false);
    return ListView(
      padding: EdgeInsetsDirectional.all(spacing?.lg ?? 16),
      children: [
        if (review.ownerSummaryLabels.isNotEmpty) ...[
          Text(s.fitCheckInboxSummaryTitle),
          SizedBox(height: spacing?.s ?? 8),
          Wrap(
            spacing: spacing?.s ?? 8,
            runSpacing: spacing?.s ?? 8,
            children:
                review.ownerSummaryLabels
                    .map((label) => Text(label))
                    .toList(growable: false),
          ),
          SizedBox(height: spacing?.lg ?? 16),
        ],
        if (currentGeneration != null) ...[
          _ShareGenerationSection(
            draftId: review.draftId,
            generation: currentGeneration,
            spacing: spacing,
            isCurrent: true,
          ),
          SizedBox(height: spacing?.lg ?? 16),
        ],
        ...historicalGenerations.map(
          (generation) => Padding(
            padding: EdgeInsetsDirectional.only(bottom: spacing?.lg ?? 16),
            child: _ShareGenerationSection(
              draftId: review.draftId,
              generation: generation,
              spacing: spacing,
              isCurrent: false,
            ),
          ),
        ),
        if (onStartHouseNorms != null) ...[
          SizedBox(height: spacing?.m ?? 12),
          KinlyFilledButton.text(
            onPressed: onStartHouseNorms,
            label: s.fitCheckStartHouseNormsCta,
            fullWidth: true,
          ),
        ],
      ],
    );
  }
}

class _ShareGenerationSection extends StatelessWidget {
  const _ShareGenerationSection({
    required this.draftId,
    required this.generation,
    required this.spacing,
    required this.isCurrent,
  });

  final String draftId;
  final FitCheckShareGeneration generation;
  final Spacing? spacing;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final date = generation.createdAt;
    final dateLabel =
        date == null ? null : DateFormat.yMMMd().format(date.toLocal());
    final title =
        isCurrent
            ? s.fitCheckShareCurrentTitle
            : dateLabel == null
            ? s.fitCheckSharePreviousTitle
            : '${s.fitCheckSharePreviousTitle} - $dateLabel';
    final statusLabel =
        generation.shareTokenStatus.toLowerCase() == 'active'
            ? s.fitCheckShareActiveStatus
            : s.fitCheckShareRevokedStatus;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title),
        SizedBox(height: spacing?.xs ?? 4),
        Text(statusLabel),
        if (isCurrent) ...[
          SizedBox(height: spacing?.s ?? 8),
          const _CurrentShareActions(),
        ],
        SizedBox(height: spacing?.m ?? 12),
        ...generation.submissions.map(
          (submission) => Padding(
            padding: EdgeInsetsDirectional.only(bottom: spacing?.m ?? 12),
            child: _SubmissionCard(
              draftId: draftId,
              submission: submission,
            ),
          ),
        ),
      ],
    );
  }
}

class _CurrentShareActions extends StatelessWidget {
  const _CurrentShareActions();

  @override
  Widget build(BuildContext context) {
    final spacing = KinlyThemeAccess.of(context).extension<Spacing>();
    final s = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KinlyFilledButton.text(
          onPressed: () => _rotateShareToken(context),
          label: s.fitCheckRotateShareCta,
          fullWidth: true,
        ),
        SizedBox(height: spacing?.s ?? 8),
        KinlyFilledButton.destructiveText(
          onPressed: () => _revokeShareToken(context),
          label: s.fitCheckRevokeShareCta,
          fullWidth: true,
        ),
      ],
    );
  }

  Future<void> _rotateShareToken(BuildContext context) async {
    final cubit = context.read<FitCheckInboxCubit>();
    final s = S.of(context);
    try {
      await cubit.rotateShareToken();
      if (!context.mounted) return;
      KinlySnackBar.showSuccess(context, s.fitCheckRotateShareSuccess);
    } catch (_) {
      if (!context.mounted) return;
      KinlySnackBar.showError(context, s.fitCheckInboxErrorBody);
    }
  }

  Future<void> _revokeShareToken(BuildContext context) async {
    final cubit = context.read<FitCheckInboxCubit>();
    final s = S.of(context);
    try {
      await cubit.revokeShareToken();
      if (!context.mounted) return;
      KinlySnackBar.showSuccess(context, s.fitCheckRevokeShareSuccess);
    } catch (_) {
      if (!context.mounted) return;
      KinlySnackBar.showError(context, s.fitCheckInboxErrorBody);
    }
  }
}

class _SubmissionCard extends StatelessWidget {
  const _SubmissionCard({required this.draftId, required this.submission});

  final String draftId;
  final FitCheckSubmissionPreview submission;

  @override
  Widget build(BuildContext context) {
    final spacing = KinlyThemeAccess.of(context).extension<Spacing>();
    final s = S.of(context);
    final submittedAt = submission.submittedAt;
    final submittedLabel =
        submittedAt == null
            ? null
            : DateFormat.yMMMd().add_jm().format(submittedAt.toLocal());
    return DecoratedBox(
      decoration: const BoxDecoration(),
      child: Padding(
        padding: EdgeInsetsDirectional.all(spacing?.m ?? 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              submission.displayName.isEmpty
                  ? s.fitCheckSubmissionFallbackName
                  : submission.displayName,
            ),
            if (submission.reviewLabel.isNotEmpty) ...[
              SizedBox(height: spacing?.xs ?? 4),
              Text(submission.reviewLabel),
            ],
            if (submittedLabel != null) ...[
              SizedBox(height: spacing?.xs ?? 4),
              Text(submittedLabel),
            ],
            if (submission.summaryLabel.isNotEmpty) ...[
              SizedBox(height: spacing?.s ?? 8),
              Text(submission.summaryLabel),
            ],
            SizedBox(height: spacing?.m ?? 12),
            KinlyFilledButton.text(
              onPressed:
                  () => context.pushNamed(
                    AppRouteNames.fitCheckBriefing,
                    pathParameters: {
                      'draftId': draftId,
                      'submissionId': submission.submissionId,
                    },
                  ),
              label: s.fitCheckOpenBriefingCta,
              fullWidth: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _FitCheckMessageBody extends StatelessWidget {
  const _FitCheckMessageBody({
    required this.title,
    required this.body,
    this.ctaLabel,
    this.onPressed,
  });

  final String title;
  final String body;
  final String? ctaLabel;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final spacing = KinlyThemeAccess.of(context).extension<Spacing>();
    return Center(
      child: Padding(
        padding: EdgeInsetsDirectional.all(spacing?.lg ?? 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, textAlign: TextAlign.center),
            SizedBox(height: spacing?.s ?? 8),
            Text(body, textAlign: TextAlign.center),
            if (ctaLabel != null && onPressed != null) ...[
              SizedBox(height: spacing?.lg ?? 16),
              KinlyFilledButton.text(
                onPressed: onPressed,
                label: ctaLabel!,
                fullWidth: true,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
