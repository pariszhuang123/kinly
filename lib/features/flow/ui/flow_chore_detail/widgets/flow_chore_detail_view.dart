// lib/features/flow/ui/widgets/flow_chore_detail_view.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/ui/buttons/kinly_filled_button.dart';
import '../../../../../core/chores/models.dart';
import '../../../../../core/supabase/storage_path_resolver.dart';
import '../../../../../core/theme/spacing.dart';
import '../../../../../core/ui/kinly_loader.dart';
import '../../../../../core/utils/url_validator.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../core/ui/snackbars/kinly_snackbar.dart';
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
    final expectationPhotoUrl = storagePathToPublicUrl(
      Supabase.instance.client,
      chore.expectationPhotoPath,
    );

    final assigneeName = _resolveAssignee(context, details);
    final formattedDate = DateFormat.yMMMMd().format(chore.startDate);
    final recurrenceLabel = _recurrenceLabel(context, chore.recurrence);

    return Padding(
      padding: EdgeInsetsDirectional.all(spacing?.lg ?? 16),
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
                    expectationPhotoLabel: s.flowChoreExpectationPhotoLabel,
                    expectationPhotoUrl: expectationPhotoUrl,
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
          KinlyFilledButton.text(onPressed: onRetry, label: s.flowChoreRetry),
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

    // KinlyFilledButton requires a non-null onPressed, so we no-op when disabled/busy.
    final effectiveOnPressed =
        (enabled && !isBusy && onPressed != null) ? onPressed! : () {};

    return SizedBox(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          KinlyFilledButton.text(
            onPressed: effectiveOnPressed,
            label: s.flowChoreDetailCompleteButton,
            fullWidth: true,
          ),
          if (isBusy)
            IgnorePointer(
              child: SizedBox(
                width: 18,
                height: 18,
                child: KinlyLoader(
                  size: 18,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Top-level helpers
// ─────────────────────────────────────────────────────────────────────────────

Future<void> _launchHowToUrl(BuildContext context, String url) async {
  final s = S.of(context);
  final uri = Uri.parse(url);

  final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!launched) {
    KinlySnackBar.showError(context, s.flowChoreHowToLaunchError);
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
