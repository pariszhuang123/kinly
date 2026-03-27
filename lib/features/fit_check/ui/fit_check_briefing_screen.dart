import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:kinly/contracts/homes/fit_check_models.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/kinly_app_bar.dart';
import 'package:kinly/core/ui/kinly_loader.dart';
import 'package:kinly/core/ui/kinly_scaffold.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/features/fit_check/bloc/fit_check_briefing_cubit.dart';
import 'package:kinly/generated/l10n.dart';

class FitCheckBriefingScreen extends StatelessWidget {
  const FitCheckBriefingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return BlocBuilder<FitCheckBriefingCubit, FitCheckBriefingState>(
      builder: (context, state) {
        return KinlyScaffold(
          appBar: KinlyAppBar(title: Text(s.fitCheckBriefingTitle)),
          body: SafeArea(
            child: switch (state.status) {
              FitCheckBriefingStatus.loading => const Center(
                child: KinlyLoader(),
              ),
              FitCheckBriefingStatus.failure => _BriefingMessage(
                title: s.fitCheckInboxErrorTitle,
                body: state.errorMessage ?? s.fitCheckInboxErrorBody,
              ),
              FitCheckBriefingStatus.ready => _BriefingBody(),
            },
          ),
        );
      },
    );
  }
}

class _BriefingBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final briefing = context.select(
      (FitCheckBriefingCubit cubit) => cubit.state.briefing,
    );
    final spacing = KinlyThemeAccess.of(context).extension<Spacing>();
    final s = S.of(context);
    if (briefing == null) {
      return _BriefingMessage(
        title: s.fitCheckInboxErrorTitle,
        body: s.fitCheckInboxErrorBody,
      );
    }
    final submittedAt =
        briefing.submittedAt == null
            ? null
            : DateFormat.yMMMd().add_jm().format(briefing.submittedAt!.toLocal());
    final primaryWatchouts =
        briefing.watchouts.where((watchout) => watchout.isPrimaryFocus).toList(
          growable: false,
        );
    final secondaryWatchouts =
        briefing.watchouts.where((watchout) => !watchout.isPrimaryFocus).toList(
          growable: false,
        );
    return ListView(
      padding: EdgeInsetsDirectional.all(spacing?.lg ?? 16),
      children: [
        Text(
          briefing.displayName.isEmpty
              ? s.fitCheckSubmissionFallbackName
              : briefing.displayName,
        ),
        if (submittedAt != null) ...[
          SizedBox(height: spacing?.xs ?? 4),
          Text(submittedAt),
        ],
        if (briefing.contextText?.isNotEmpty == true) ...[
          SizedBox(height: spacing?.lg ?? 16),
          _Section(
            title: s.fitCheckBriefingContextTitle,
            children: [Text(briefing.contextText!)],
          ),
        ],
        if (briefing.alignments.isNotEmpty) ...[
          SizedBox(height: spacing?.lg ?? 16),
          _Section(
            title: s.fitCheckAlignmentsTitle,
            children:
                briefing.alignments
                    .map((alignment) => Text(_scenarioTitle(s, alignment)))
                    .toList(growable: false),
          ),
        ],
        if (briefing.alignmentPreviewText?.isNotEmpty == true) ...[
          SizedBox(height: spacing?.lg ?? 16),
          _Section(
            title: s.fitCheckAlignmentPreviewTitle,
            children: [Text(briefing.alignmentPreviewText!)],
          ),
        ],
        if (briefing.focusText?.isNotEmpty == true) ...[
          SizedBox(height: spacing?.lg ?? 16),
          _Section(
            title: s.fitCheckBriefingFocusTitle,
            children: [Text(briefing.focusText!)],
          ),
        ],
        if (primaryWatchouts.isNotEmpty) ...[
          SizedBox(height: spacing?.lg ?? 16),
          _Section(
            title: s.fitCheckPrimaryWatchoutsTitle,
            children: _buildWatchoutWidgets(
              spacing: spacing,
              strings: s,
              watchouts: primaryWatchouts,
            ),
          ),
        ],
        if (secondaryWatchouts.isNotEmpty) ...[
          SizedBox(height: spacing?.lg ?? 16),
          _Section(
            title:
                primaryWatchouts.isEmpty
                    ? s.fitCheckWatchoutsTitle
                    : s.fitCheckSecondaryWatchoutsTitle,
            children: _buildWatchoutWidgets(
              spacing: spacing,
              strings: s,
              watchouts: secondaryWatchouts,
            ),
          ),
        ],
        if (briefing.answers.isNotEmpty) ...[
          SizedBox(height: spacing?.lg ?? 16),
          _Section(
            title: s.fitCheckCandidateAnswersTitle,
            children:
                briefing.answers.entries
                    .map(
                      (entry) => Text(
                        '${_scenarioTitle(s, entry.key)}: ${entry.value}',
                      ),
                    )
                    .toList(growable: false),
          ),
        ],
        if (briefing.limitationText?.isNotEmpty == true) ...[
          SizedBox(height: spacing?.lg ?? 16),
          _Section(
            title: s.fitCheckLimitationTitle,
            children: [Text(briefing.limitationText!)],
          ),
        ],
      ],
    );
  }
}

List<Widget> _buildWatchoutWidgets({
  required Spacing? spacing,
  required S strings,
  required List<FitCheckWatchout> watchouts,
}) {
  return watchouts
      .map<Widget>(
        (watchout) => Padding(
          padding: EdgeInsetsDirectional.only(bottom: spacing?.m ?? 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_scenarioTitle(strings, watchout.scenarioId)),
              if (watchout.description?.isNotEmpty == true)
                Text(watchout.description!),
              if (watchout.questionTexts.isNotEmpty) ...[
                SizedBox(height: spacing?.xs ?? 4),
                Text(strings.fitCheckQuestionsTitle),
                ...watchout.questionTexts.map(Text.new),
              ],
            ],
          ),
        ),
      )
      .toList(growable: false);
}

String _scenarioTitle(S strings, String scenarioId) {
  return switch (scenarioId) {
    'fit_cleanliness' => strings.fitCheckScenarioCleanlinessTitle,
    'fit_rhythm' => strings.fitCheckScenarioRhythmTitle,
    'fit_chores' => strings.fitCheckScenarioChoresTitle,
    'fit_conflict' => strings.fitCheckScenarioConflictTitle,
    _ => scenarioId,
  };
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final spacing = KinlyThemeAccess.of(context).extension<Spacing>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        SizedBox(height: spacing?.s ?? 8),
        ...children,
      ],
    );
  }
}

class _BriefingMessage extends StatelessWidget {
  const _BriefingMessage({required this.title, required this.body});

  final String title;
  final String body;

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
          ],
        ),
      ),
    );
  }
}
