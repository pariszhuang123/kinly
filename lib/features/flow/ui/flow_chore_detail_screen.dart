import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/chores/models.dart';
import '../../../core/theme/spacing.dart';
import '../../../generated/l10n.dart';
import '../../../core/ui/kinly_loader.dart';
import '../bloc/flow_chore_detail_bloc.dart';
import '../domain/flow_chore_outcome.dart';

class FlowChoreDetailScreen extends StatelessWidget {
  const FlowChoreDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>();

    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).flowChoreDetailTitle)),
      body: SafeArea(
        child: BlocConsumer<FlowChoreDetailBloc, FlowChoreDetailState>(
          listenWhen:
              (previous, current) =>
                  previous.completionResult != current.completionResult ||
                  previous.completionErrorTick != current.completionErrorTick,
          listener: (context, state) {
            if (state.completionResult != null) {
              Navigator.of(context).pop(
                FlowChoreOutcome(
                  choreId: state.completionResult!.choreId,
                  isUpdate: false,
                  isCompleted: true,
                ),
              );
              return;
            }

            if (state.completionErrorTick > 0) {
              final message =
                  state.completionErrorMessage ??
                  S.of(context).flowChoreDetailCompletionError;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(message)));
            }
          },
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: KinlyLoader(size: 40));
            }

            if (state.loadErrorMessage != null) {
              return _FlowDetailError(
                message: state.loadErrorMessage!,
                onRetry:
                    () => context.read<FlowChoreDetailBloc>().add(
                      const FlowChoreDetailStarted(),
                    ),
              );
            }

            final details = state.details!;
            final chore = details.chore;
            final s = S.of(context);
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
                          Text(
                            chore.name,
                            style: theme.textTheme.headlineSmall,
                          ),
                          SizedBox(height: spacing?.md ?? 16),
                          _FlowDetailRow(
                            label: s.flowChoreAssigneeLabel,
                            value: assigneeName ?? s.flowChoreDetailUnassigned,
                          ),
                          SizedBox(height: spacing?.md ?? 16),
                          _FlowDetailRow(
                            label: s.flowChoreStartLabel,
                            value: formattedDate,
                          ),
                          SizedBox(height: spacing?.md ?? 16),
                          _FlowDetailRow(
                            label: s.flowChoreRecurrenceLabel,
                            value: recurrenceLabel,
                          ),
                          SizedBox(height: spacing?.lg ?? 24),
                          _FlowDetailSection(
                            title: s.flowChoreNotesLabel,
                            body:
                                chore.notes?.isNotEmpty == true
                                    ? chore.notes!
                                    : s.flowChoreDetailNoNotes,
                          ),
                          SizedBox(height: spacing?.md ?? 16),
                          _FlowDetailSection(
                            title: s.flowChoreHowToLabel,
                            body:
                                chore.howToVideoUrl?.isNotEmpty == true
                                    ? chore.howToVideoUrl!
                                    : s.flowChoreDetailNoHowTo,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: spacing?.md ?? 16),
                  _CompletionButton(
                    isBusy: state.isCompleting,
                    enabled: state.canComplete,
                    onPressed:
                        state.canComplete
                            ? () => context.read<FlowChoreDetailBloc>().add(
                              const FlowChoreDetailCompletionRequested(),
                            )
                            : null,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
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
}

class _FlowDetailRow extends StatelessWidget {
  const _FlowDetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(value, style: theme.textTheme.titleMedium),
      ],
    );
  }
}

class _FlowDetailSection extends StatelessWidget {
  const _FlowDetailSection({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: colorScheme.surfaceContainerHigh,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(body, style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }
}

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
