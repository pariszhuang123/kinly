// lib/features/harmony/ui/gratitude_wall/gratitude_wall_widgets.dart
import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'package:kinly/contracts/mood/models.dart';
import '../../../../core/ui/buttons/kinly_outlined_button.dart';
import '../../../../core/ui/kinly_circle_avatar.dart';
import '../../../../core/ui/kinly_masonry_grid.dart';
import '../../../../core/theme/kinly_sections.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/ui/badges/kinly_badge.dart';
import '../../../../generated/l10n.dart';
import '../../../../core/ui/kinly_theme_access.dart';

class GratitudeCardHeader extends StatelessWidget {
  const GratitudeCardHeader({
    super.key,
    required this.username,
    required this.avatarUrl,
    required this.weeksLabel,
    required this.palette,
    required this.initialBuilder,
  });

  final String username;
  final String? avatarUrl;
  final String weeksLabel;
  final SectionColors palette;
  final String Function(String value) initialBuilder;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: palette.background.withValues(alpha: 0.25),
                shape: BoxShape.circle,
              ),
              padding: EdgeInsetsDirectional.all(spacing.xs),
              child: KinlyCircleAvatar(
                avatarUrl: avatarUrl,
                radius: 20,
                fallbackInitial: initialBuilder(username),
              ),
            ),
            SizedBox(width: spacing.sm),
            Flexible(
              child: KinlyBadge(
                label: weeksLabel,
                backgroundColor: palette.accent.withValues(alpha: 0.16),
                foregroundColor: colorScheme.onSurfaceVariant,
                borderColor: palette.accent.withValues(alpha: 0.35),
                textStyle: theme.textTheme.labelSmall?.copyWith(
                  letterSpacing: 0.1,
                ),
                maxLines: 2,
              ),
            ),
          ],
        ),
        SizedBox(height: spacing.xs),
        Center(
          child: Text(
            username,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class GratitudeCard extends StatelessWidget {
  const GratitudeCard({
    super.key,
    required this.username,
    required this.avatarUrl,
    required this.weeksLabel,
    required this.palette,
    this.message,
    this.messageStyle,
    this.initialBuilder = _initial,
  });

  final String username;
  final String? avatarUrl;
  final String weeksLabel;
  final SectionColors palette;
  final String? message;
  final TextStyle? messageStyle;
  final String Function(String value) initialBuilder;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final colorScheme = theme.colorScheme;

    final cardFill = Color.alphaBlend(
      palette.card.withValues(alpha: 0.6),
      colorScheme.surface,
    );

    return Container(
      decoration: BoxDecoration(
        color: cardFill,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: EdgeInsetsDirectional.fromSTEB(
        spacing.lg,
        spacing.lg,
        spacing.lg,
        spacing.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GratitudeCardHeader(
            username: username,
            avatarUrl: avatarUrl,
            weeksLabel: weeksLabel,
            palette: palette,
            initialBuilder: initialBuilder,
          ),
          SizedBox(height: spacing.sm),
          if (message != null && message!.isNotEmpty) ...[
            SizedBox(height: spacing.md),
            Text(
              message!,
              textAlign: TextAlign.start,
              style: (messageStyle ?? theme.textTheme.bodyMedium)?.copyWith(
                color: (messageStyle?.color) ?? colorScheme.onSurface,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class GratitudeEntryCard extends StatelessWidget {
  const GratitudeEntryCard({
    super.key,
    required this.username,
    required this.avatarUrl,
    required this.createdAt,
    required this.palette,
    this.message,
    this.messageStyle,
    this.fallbackUsername,
    this.initialBuilder = _initial,
  });

  final String username;
  final String? avatarUrl;
  final DateTime createdAt;
  final SectionColors palette;
  final String? message;
  final TextStyle? messageStyle;
  final String? fallbackUsername;
  final String Function(String value) initialBuilder;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final displayName =
        username.isNotEmpty ? username : (fallbackUsername ?? s.friendDefaultName);
    final weeksLabel = _weeksLabelForDate(createdAt, s);

    return GratitudeCard(
      username: displayName,
      avatarUrl: avatarUrl,
      weeksLabel: weeksLabel,
      palette: palette,
      message: message,
      messageStyle: messageStyle,
      initialBuilder: initialBuilder,
    );
  }
}

class GratitudeWallMasonryGrid extends StatelessWidget {
  const GratitudeWallMasonryGrid({super.key, required this.posts});

  final List<GratitudeWallPost> posts;

  @override
  Widget build(BuildContext context) {
    final spacing = KinlyThemeAccess.of(context).extension<Spacing>()!;

    return KinlyMasonryGrid<GratitudeWallPost>(
      items: posts,
      gap: spacing.md,
      estimateItemHeight:
          (post, textTheme, gridSpacing) =>
              _estimateHeight(post, spacing: gridSpacing, textTheme: textTheme),
      builder: (context, post, index, palette) {
        return GratitudeWallCard(
          post: post,
          palette: palette.colorForSeed('${post.id}-${post.authorUserId}'),
        );
      },
    );
  }
}

class GratitudeWallCard extends StatelessWidget {
  const GratitudeWallCard({
    super.key,
    required this.post,
    required this.palette,
  });

  final GratitudeWallPost post;
  final SectionColors palette;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final colorScheme = theme.colorScheme;

    return GratitudeEntryCard(
      username: post.authorUsername ?? S.of(context).friendDefaultName,
      fallbackUsername: S.of(context).friendDefaultName,
      avatarUrl: post.authorAvatarUrl,
      createdAt: post.createdAt,
      palette: palette,
      message: post.message,
      messageStyle: theme.textTheme.bodyMedium?.copyWith(
        letterSpacing: 0.1,
        height: 1.35,
        color: colorScheme.onSurface,
      ),
      initialBuilder: _initial,
    );
  }
}

class GratitudeWallEmptyState extends StatelessWidget {
  const GratitudeWallEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
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
  const GratitudeWallErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final spacing = KinlyThemeAccess.of(context).extension<Spacing>()!;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center),
          SizedBox(height: spacing.md),
          KinlyOutlinedButton.text(
            label: s.gratitudeWallRetry,
            onPressed: onRetry,
          ),
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
    required this.memberCount,
  });

  final int count;
  final bool hasMore;
  final int memberCount;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final s = S.of(context);
    final spacing = theme.extension<Spacing>()!;

    final countLabel = hasMore ? '$count+' : '$count';
    final baseTitle = s.gratitudeWallTitleCount(count);
    final title = _replaceCountPlaceholder(baseTitle, countLabel);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: spacing.xs),
        GratitudeWallStatsRow(
          mentionsLabel: '${s.gratitudeWallStatsMentions}: $countLabel',
          peopleLabel: '${s.gratitudeWallStatsPeople}: $memberCount',
        ),
      ],
    );
  }
}

class GratitudeWallStatsRow extends StatelessWidget {
  const GratitudeWallStatsRow({
    super.key,
    required this.mentionsLabel,
    required this.peopleLabel,
  });

  final String mentionsLabel;
  final String peopleLabel;

  @override
  Widget build(BuildContext context) {
    final spacing = KinlyThemeAccess.of(context).extension<Spacing>()!;

    return Row(
      children: [
        Expanded(
          child: KinlyBadge(
            label: mentionsLabel,
            compact: false,
          ),
        ),
        SizedBox(width: spacing.sm),
        Expanded(
          child: KinlyBadge(
            label: peopleLabel,
            compact: false,
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
    final theme = KinlyThemeAccess.of(context);
    final colorScheme = theme.colorScheme;
    final s = S.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: theme.extension<Spacing>()!.sm,
          vertical: theme.extension<Spacing>()!.xs,
        ),
        child: Text(
          s.gratitudeWallFooter(s.app_title),
          textAlign: TextAlign.start,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

String _initial(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return '?';
  return trimmed.substring(0, 1);
}

double _estimateHeight(
  GratitudeWallPost post, {
  required Spacing spacing,
  required dynamic textTheme,
}) {
  final messageLength = post.message?.trim().length ?? 0;
  final lineHeight =
      (textTheme.bodyLarge?.height ?? 1.35) *
      (textTheme.bodyLarge?.fontSize ?? 16);
  final estimatedLines = (messageLength / 26).ceil().clamp(1, 10).toDouble();
  return spacing.xl * 2.5 + estimatedLines * lineHeight;
}

String _replaceCountPlaceholder(
  String text,
  String replacement, {
  bool appendIfNoMatch = true,
}) {
  final pattern = RegExp(r'#|\\d+', unicode: true);
  if (pattern.hasMatch(text)) {
    return text.replaceFirst(pattern, replacement);
  }
  if (appendIfNoMatch) {
    return '$text ($replacement)';
  }
  // No placeholder and we don't want to append anything.
  return text;
}

String _weeksLabelForDate(DateTime createdAt, S s) {
  final createdLocal = createdAt.toLocal();
  final now = DateTime.now();
  final weeksAgo = math.max(0, now.difference(createdLocal).inDays ~/ 7);
  return _replaceCountPlaceholder(
    s.gratitudeWallWeeksAgo(weeksAgo),
    weeksAgo.toString(),
    appendIfNoMatch: false,
  );
}
