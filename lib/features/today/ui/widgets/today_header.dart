import 'package:flutter/material.dart';

import '../../../../../core/theme/spacing.dart';
import '../../domain/models.dart';

class TodayHeader extends StatelessWidget {
  final String partOfDay;
  final TodayUserProfile? profile;

  const TodayHeader({
    super.key,
    required this.partOfDay,
    this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = theme.extension<Spacing>()!;
    final displayName = profile?.username ?? 'friend';
    final avatarUrl = profile?.avatarUrl;
    final initials = _initialFor(profile?.username);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good $partOfDay, $displayName',
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
          backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
          child:
              avatarUrl == null
                  ? Text(
                      initials,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    )
                  : null,
        ),
      ],
    );
  }

  String _initialFor(String? value) {
    if (value == null) return '?';
    final trimmed = value.trim();
    if (trimmed.isEmpty) return '?';
    return trimmed.substring(0, 1).toUpperCase();
  }
}
