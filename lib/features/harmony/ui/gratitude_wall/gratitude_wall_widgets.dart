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
    required this.palette,
    this.title,
    this.subtitle,
    this.username,
    this.avatarUrl,
    this.weeksLabel,
  });

  final SectionColors palette;
  final String? title;
  final String? subtitle;
  final String? username;
  final String? avatarUrl;
  final String? weeksLabel;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final colorScheme = theme.colorScheme;

    final showIdentity = username != null && username!.isNotEmpty;
    final identityWeeks = weeksLabel ?? subtitle ?? '';

    if (showIdentity) {
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
                  fallbackInitial: _initial(username!),
                ),
              ),
              SizedBox(width: spacing.sm),
              Flexible(
                child: KinlyBadge(
                  label: identityWeeks,
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
              username!,
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        KinlyBadge(
          label: subtitle ?? '',
          backgroundColor: palette.accent.withValues(alpha: 0.16),
          foregroundColor: colorScheme.onSurfaceVariant,
          borderColor: palette.accent.withValues(alpha: 0.35),
          textStyle: theme.textTheme.labelSmall?.copyWith(letterSpacing: 0.1),
          maxLines: 2,
        ),
        SizedBox(height: spacing.xs),
        Text(
          title ?? '',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class GratitudeCard extends StatelessWidget {
  const GratitudeCard({
    super.key,
    required this.palette,
    this.showHeader = true,
    this.title,
    this.subtitle,
    this.username,
    this.avatarUrl,
    this.weeksLabel,
    this.message,
    this.messageStyle,
  });

  final SectionColors palette;
  final String? title;
  final String? subtitle;
  final String? username;
  final String? avatarUrl;
  final String? weeksLabel;
  final String? message;
  final TextStyle? messageStyle;
  final bool showHeader;

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
          if (showHeader) ...[
            GratitudeCardHeader(
              palette: palette,
              title: title,
              subtitle: subtitle,
              username: username,
              avatarUrl: avatarUrl,
              weeksLabel: weeksLabel,
            ),
            SizedBox(height: spacing.sm),
          ],
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
    required this.createdAt,
    required this.palette,
    this.message,
    this.messageStyle,
    this.title,
    this.subtitle,
    this.username,
    this.avatarUrl,
    this.showIdentity = false,
    this.showHeader = true,
  });

  final DateTime createdAt;
  final SectionColors palette;
  final String? message;
  final TextStyle? messageStyle;
  final String? title;
  final String? subtitle;
  final String? username;
  final String? avatarUrl;
  final bool showIdentity;
  final bool showHeader;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final weeksLabel = _weeksLabelForDate(createdAt, s);

    return GratitudeCard(
      title: title ?? s.gratitudeWallShareTitle,
      subtitle: subtitle ?? '${s.gratitudeWallHouseTab} - $weeksLabel',
      username: showIdentity ? (username ?? s.friendDefaultName) : null,
      avatarUrl: showIdentity ? avatarUrl : null,
      weeksLabel: showIdentity ? weeksLabel : null,
      palette: palette,
      message: message,
      messageStyle: messageStyle,
      showHeader: showHeader,
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
          palette: palette.colorForSeed(post.id),
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
      createdAt: post.createdAt,
      palette: palette,
      message: post.message,
      messageStyle: theme.textTheme.bodyMedium?.copyWith(
        letterSpacing: 0.1,
        height: 1.35,
        color: colorScheme.onSurface,
      ),
      showHeader: false,
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
  const GratitudeWallHeader({super.key, required this.timeLabel});

  final String timeLabel;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final s = S.of(context);
    final spacing = theme.extension<Spacing>()!;
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${s.gratitudeWallShareTitle} - ${s.gratitudeWallHouseTab}',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: spacing.sm),
        KinlyBadge(
          label: timeLabel,
          backgroundColor: colorScheme.surfaceContainerHighest,
          foregroundColor: colorScheme.onSurfaceVariant,
          compact: false,
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

String _initial(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return '?';
  return trimmed.substring(0, 1).toUpperCase();
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
