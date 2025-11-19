import 'package:flutter/material.dart';

import '../../../../../generated/l10n.dart';
import '../../../../../core/theme/spacing.dart';
import '../../domain/models.dart';
import '../../../../core/ui/kinly_circle_avatar.dart';

class TodayHeader extends StatelessWidget {
  final String partOfDay; // “morning”, “afternoon”, “evening”
  final TodayUserProfile? profile;
  final VoidCallback? onAvatarTap;

  const TodayHeader({
    super.key,
    required this.partOfDay,
    this.profile,
    this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = theme.extension<Spacing>()!;
    final displayName = profile?.username ?? S.of(context).friendDefaultName;

    // Localize “Good morning / afternoon / evening”
    final greeting = S.of(context).greetingPartOfDay(partOfDay, displayName);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: spacing.xs),

              Text(
                S.of(context).todayFlowSubtitle, // NEW localized subtitle
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: spacing.md),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onAvatarTap,
            borderRadius: BorderRadius.circular(32),
            child: Padding(
              padding: EdgeInsets.all(spacing.xs / 2),
              child: KinlyCircleAvatar(
                avatarUrl: profile?.avatarUrl,
                radius: 30,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
