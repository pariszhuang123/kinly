// lib/features/flow/ui/widgets/flow_chore_core_info_section.dart
import 'package:flutter/material.dart';

import '../../../../../core/theme/spacing.dart';

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
  });

  final String choreName;
  final String assigneeLabel;
  final String assigneeValue;
  final String startLabel;
  final String startValue;
  final String recurrenceLabel;
  final String recurrenceValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(choreName, style: theme.textTheme.headlineSmall),
        SizedBox(height: spacing?.md ?? 16),
        _FlowDetailRow(label: assigneeLabel, value: assigneeValue),
        SizedBox(height: spacing?.md ?? 16),
        _FlowDetailRow(label: startLabel, value: startValue),
        SizedBox(height: spacing?.md ?? 16),
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
