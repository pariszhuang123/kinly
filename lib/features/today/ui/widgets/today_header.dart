import 'package:flutter/material.dart';
import '../../../../../core/theme/spacing.dart';

class TodayHeader extends StatelessWidget {
  final String partOfDay;
  final String userName;

  const TodayHeader({
    super.key,
    required this.partOfDay,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = theme.extension<Spacing>()!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good $partOfDay, $userName',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: spacing.xs),
              Text(
                "Here's what's flowing in your home today.",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: spacing.md),
        CircleAvatar(
          radius: 20,
          backgroundColor: colorScheme.surfaceContainerHigh,
          child: const Text('🦊', style: TextStyle(fontSize: 20)),
        ),
      ],
    );
  }
}
