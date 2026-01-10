// lib/features/flow/ui/widgets/flow_chore_core_info_section.dart
import 'package:flutter/widgets.dart';

import '../../../../../core/theme/spacing.dart';
import '../../../../../core/ui/kinly_theme_access.dart';

class FlowChoreCoreInfoSection extends StatelessWidget {
  const FlowChoreCoreInfoSection({
    super.key,
    required this.choreName,
    required this.assigneeLabel,
    required this.assigneeValue,
    required this.startLabel,
    required this.startValue,
    required this.recurrenceLabel,
    required this.recurrenceValue,
    this.showAssignee = true,
    this.showStart = true,
    this.showRecurrence = true,
  });

  final String choreName;
  final String assigneeLabel;
  final String assigneeValue;
  final String startLabel;
  final String startValue;
  final String recurrenceLabel;
  final String recurrenceValue;
  final bool showAssignee;
  final bool showStart;
  final bool showRecurrence;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: spacing.lg),
        Text(choreName, style: theme.textTheme.headlineSmall),
        SizedBox(height: spacing.md),
        if (showAssignee) ...[
          _FlowDetailRow(label: assigneeLabel, value: assigneeValue),
          SizedBox(height: spacing.md),
        ],
        if (showStart) ...[
          _FlowDetailRow(label: startLabel, value: startValue),
          SizedBox(height: spacing.md),
        ],
        if (showRecurrence)
          _FlowDetailRow(label: recurrenceLabel, value: recurrenceValue),
      ],
    );
  }
}

class _FlowDetailRow extends StatelessWidget {
  const _FlowDetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
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
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            // Strong, readable in dark mode
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
