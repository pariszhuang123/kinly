// lib/features/flow/ui/widgets/flow_chore_detail_view.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/chores/models.dart';
import '../../../../../core/theme/spacing.dart';
import '../../../../../core/ui/kinly_loader.dart';
import '../../../../../core/utils/url_validator.dart';
import '../../../../../generated/l10n.dart';
import '../../../bloc/flow_chore_detail_bloc.dart';
import 'flow_chore_core_info_section.dart';
import 'flow_chore_extras_section.dart';

class FlowChoreDetailView extends StatelessWidget {
  const FlowChoreDetailView({
    super.key,
    required this.state,
    required this.onRetry,
    required this.onComplete,
  });

  final FlowChoreDetailState state;
  final VoidCallback onRetry;
  final VoidCallback? onComplete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>();

    if (state.isLoading) {
      return const Center(child: KinlyLoader(size: 40));
    }

    if (state.loadErrorMessage != null) {
      return _FlowDetailError(
        message: state.loadErrorMessage!,
        onRetry: onRetry,
      );
    }

    final details = state.details!;
    final chore = details.chore;
    final s = S.of(context);
    final normalizedHowToUrl =
        chore.howToVideoUrl != null
            ? normalizeHttpUrlOrNull(chore.howToVideoUrl!)
            : null;
    final howToBody =
        normalizedHowToUrl ??
            (chore.howToVideoUrl?.trim().isNotEmpty == true
                ? chore.howToVideoUrl!.trim()
                : s.flowChoreDetailNoHowTo);

    final assigneeName = _resolveAssignee(context, details);
    final formattedDate = DateFormat.yMMMMd().format(chore.startDate);
    final recurrenceLabel = _recurrenceLabel(context, chore.recurrence);

    return Padding(
      padding: EdgeInsets.all(spacing?.lg ?? 16),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FlowChoreCoreInfoSection(
                    choreName: chore.name,
                    assigneeLabel: s.flowChoreAssigneeLabel,
                    assigneeValue: assigneeName ?? s.flowChoreDetailUnassigned,
                    startLabel: s.flowChoreStartLabel,
                    startValue: formattedDate,
                    recurrenceLabel: s.flowChoreRecurrenceLabel,
                    recurrenceValue: recurrenceLabel,
                  ),
                  SizedBox(height: spacing?.lg ?? 24),
                  FlowChoreExtrasSection(
                    notesLabel: s.flowChoreNotesLabel,
                    notesBody:
                        chore.notes?.isNotEmpty == true
                            ? chore.notes!
                            : s.flowChoreDetailNoNotes,
                    howToLabel: s.flowChoreHowToLabel,
                    howToBody: howToBody,
                    onHowToTap:
                        normalizedHowToUrl != null
                            ? () => _launchHowToUrl(context, normalizedHowToUrl)
                            : null,
                    // expectationPhotoLabel: s.flowChoreExpectationPhotoLabel,
                    // expectationPhotoUrl: chore.expectationPhotoUrl,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: spacing?.md ?? 16),
          _CompletionButton(
            isBusy: state.isCompleting,
            enabled: state.canComplete,
            onPressed: onComplete,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Error + completion button
// ─────────────────────────────────────────────────────────────────────────────

class _FlowDetailError extends StatelessWidget {
  const _FlowDetailError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.error,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: Text(s.flowChoreRetry)),
        ],
      ),
    );
  }
}

class _CompletionButton extends StatelessWidget {
  const _CompletionButton({
    required this.onPressed,
    required this.enabled,
    required this.isBusy,
  });

  final VoidCallback? onPressed;
  final bool enabled;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        child:
            isBusy
                ? SizedBox(
                  width: 18,
                  height: 18,
                  child: KinlyLoader(
                    size: 18,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                )
                : Text(s.flowChoreDetailCompleteButton),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Top-level helpers
// ─────────────────────────────────────────────────────────────────────────────

Future<void> _launchHowToUrl(BuildContext context, String url) async {
  final messenger = ScaffoldMessenger.of(context);
  final s = S.of(context);
  final uri = Uri.parse(url);

  final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!launched) {
    messenger.showSnackBar(SnackBar(content: Text(s.flowChoreHowToLaunchError)));
  }
}

String _recurrenceLabel(BuildContext context, ChoreRecurrence recurrence) {
  final s = S.of(context);
  switch (recurrence) {
    case ChoreRecurrence.none:
      return s.flowChoreRecurrenceNone;
    case ChoreRecurrence.daily:
      return s.flowChoreRecurrenceDaily;
    case ChoreRecurrence.weekly:
      return s.flowChoreRecurrenceWeekly;
    case ChoreRecurrence.every2Weeks:
      return s.flowChoreRecurrenceEvery2Weeks;
    case ChoreRecurrence.monthly:
      return s.flowChoreRecurrenceMonthly;
    case ChoreRecurrence.every2Months:
      return s.flowChoreRecurrenceEvery2Months;
    case ChoreRecurrence.annual:
      return s.flowChoreRecurrenceAnnual;
  }
}

String? _resolveAssignee(BuildContext context, ChoreDetails details) {
  final userId = details.chore.assigneeUserId;
  if (userId == null) return null;

  final summary = details.assignees.firstWhere(
    (member) => member.userId == userId,
    orElse: () => ChoreAssigneeSummary(userId: userId),
  );

  return summary.fullName ?? S.of(context).friendDefaultName;
}
