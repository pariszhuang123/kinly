// lib/features/gratitude_wall/ui/gratitude_wall_widgets.dart
import 'package:flutter/material.dart';

import '../../../../core/mood/models.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/ui/kinly_circle_avatar.dart';
import '../../../../generated/l10n.dart';

class GratitudeWallRow extends StatelessWidget {
  final GratitudeWallPost post;
  final bool alignLeft;
  final Color accent;

  const GratitudeWallRow({
    super.key,
    required this.post,
    required this.alignLeft,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;
    final s = S.of(context);
    final materialLocalizations = MaterialLocalizations.of(context);

    final accentBg = accent.withValues(alpha: 0.08);
    final accentStripe = accent.withValues(alpha: 0.22);

    final createdLocal = post.createdAt.toLocal();
    final now = DateTime.now();
    final isToday =
        now.year == createdLocal.year &&
        now.month == createdLocal.month &&
        now.day == createdLocal.day;
    final dateLabel = materialLocalizations.formatMediumDate(createdLocal);
    final timeLabel = TimeOfDay.fromDateTime(createdLocal).format(context);
    final timestampLabel =
        isToday ? s.gratitudeWallTimestamp(timeLabel) : '$dateLabel • $timeLabel';

    final content = Expanded(
      child: Container(
        padding: EdgeInsetsDirectional.all(spacing.sm),
        decoration: BoxDecoration(
          color: Color.alphaBlend(
            accentBg,
            theme.colorScheme.surfaceContainerHighest,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.7),
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            PositionedDirectional(
              start: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 5,
                decoration: BoxDecoration(
                  color: accentStripe,
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(start: spacing.sm),
              child: Column(
                crossAxisAlignment:
                    alignLeft
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment:
                        alignLeft
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.end,
                    children: [
                      KinlyCircleAvatar(
                        avatarUrl: post.authorAvatarUrl,
                        radius: 18,
                        fallbackInitial: _initial(
                          post.authorUsername ?? s.friendDefaultName,
                        ),
                      ),
                      SizedBox(width: spacing.sm),
                      Column(
                        crossAxisAlignment:
                            alignLeft
                                ? CrossAxisAlignment.start
                                : CrossAxisAlignment.end,
                        children: [
                          Text(
                            post.authorUsername ?? s.friendDefaultName,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            timestampLabel,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (post.message != null && post.message!.isNotEmpty) ...[
                    SizedBox(height: spacing.sm),
                    Text(
                      post.message!,
                      textAlign: alignLeft ? TextAlign.start : TextAlign.end,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        letterSpacing: 0.1,
                        height: 1.35,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [content],
    );
  }

  String _initial(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return '?';
    return trimmed.substring(0, 1);
  }
}

class GratitudeWallEmptyState extends StatelessWidget {
  const GratitudeWallEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;
    final s = S.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          s.gratitudeWallEmptyTitle,
          style: theme.textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: spacing.sm),
        Text(
          s.gratitudeWallEmptySubtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class GratitudeWallErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const GratitudeWallErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final spacing = Theme.of(context).extension<Spacing>()!;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center),
          SizedBox(height: spacing.md),
          OutlinedButton(onPressed: onRetry, child: Text(s.gratitudeWallRetry)),
        ],
      ),
    );
  }
}

class GratitudeWallHeader extends StatelessWidget {
  const GratitudeWallHeader({
    super.key,
    required this.count,
    required this.hasMore,
  });

  final int count;
  final bool hasMore;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);
    final colorScheme = theme.colorScheme;

    final countLabel = hasMore ? '$count+' : '$count';
    final title = s.gratitudeWallTitleCount(countLabel);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          s.gratitudeWallSubtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class PoweredByTagline extends StatelessWidget {
  const PoweredByTagline({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final s = S.of(context);

    return Text.rich(
      TextSpan(
        text: s.gratitudeWallPoweredBy,
        children: [
          const TextSpan(text: ' '),
          TextSpan(
            // ideally localize this too, e.g. s.appName
            text: s.app_title,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.start,
      style: theme.textTheme.bodySmall?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }
}

Color accentColorFor(String seed, ColorScheme colorScheme) {
  final palette = <Color>[
    colorScheme.primary,
    colorScheme.secondary,
    colorScheme.tertiary,
    colorScheme.error,
    colorScheme.outline,
  ];
  var hash = 0;
  for (final codeUnit in seed.codeUnits) {
    hash = (hash * 31 + codeUnit) & 0x7fffffff;
  }
  final index = hash % palette.length;
  return palette[index];
}
