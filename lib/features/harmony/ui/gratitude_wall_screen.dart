import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/mood/enums/mood_scale.dart';
import '../../../core/mood/models.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/ui/kinly_circle_avatar.dart';
import '../../../core/ui/kinly_loader.dart';
import '../../../generated/l10n.dart';
import '../bloc/gratitude_wall_cubit.dart';

class GratitudeWallScreen extends StatelessWidget {
  const GratitudeWallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;
    final sizes = theme.extension<AppSizes>();
    final s = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(s.gratitudeWallTitle),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = sizes?.maxContentWidth ?? 640.0;
            final width = constraints.maxWidth < maxWidth
                ? constraints.maxWidth
                : maxWidth;
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: width),
                child: Padding(
                  padding: EdgeInsets.all(spacing.lg),
                  child: BlocBuilder<GratitudeWallCubit, GratitudeWallState>(
                    builder: (context, state) {
                      if (state.isLoading && !state.hasLoaded) {
                        return const Center(child: KinlyLoader());
                      }
                      if (state.error != null && state.posts.isEmpty) {
                        return _ErrorState(
                          message: state.error!,
                          onRetry: () =>
                              context.read<GratitudeWallCubit>().loadInitial(),
                        );
                      }
                      if (state.posts.isEmpty) {
                        return _EmptyState();
                      }
                      return NotificationListener<ScrollNotification>(
                        onNotification: (notification) {
                          if (notification.metrics.pixels >=
                                  notification.metrics.maxScrollExtent - 120 &&
                              state.hasMore &&
                              !state.isLoadingMore) {
                            context.read<GratitudeWallCubit>().loadMore();
                          }
                          return false;
                        },
                        child: ListView.separated(
                          itemCount: state.posts.length +
                              (state.isLoadingMore ? 1 : 0),
                          separatorBuilder: (_, __) =>
                              SizedBox(height: spacing.lg),
                          itemBuilder: (context, index) {
                            if (index >= state.posts.length) {
                              return const Center(child: KinlyLoader());
                            }
                            final post = state.posts[index];
                            final alignLeft = index.isEven;
                            return _WallRow(
                              post: post,
                              alignLeft: alignLeft,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _WallRow extends StatelessWidget {
  final GratitudeWallPost post;
  final bool alignLeft;
  const _WallRow({required this.post, required this.alignLeft});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;
    final s = S.of(context);
    final content = Expanded(
      child: Container(
        padding: EdgeInsets.all(spacing.md),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment:
              alignLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment:
                  alignLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
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
                      alignLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                  children: [
                    Text(
                      post.authorUsername ?? s.friendDefaultName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      s.gratitudeWallTimestamp(
                        TimeOfDay.fromDateTime(post.createdAt).format(context),
                      ),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: spacing.sm),
            Text(
              _moodLabel(context, post.mood),
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            if (post.message != null && post.message!.isNotEmpty) ...[
              SizedBox(height: spacing.sm),
              Text(
                post.message!,
                textAlign: alignLeft ? TextAlign.start : TextAlign.end,
                style: theme.textTheme.bodyLarge,
              ),
            ],
          ],
        ),
      ),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: alignLeft
          ? [
              content,
            ]
          : [
              content,
            ],
    );
  }

  String _moodLabel(BuildContext context, MoodScale mood) {
    final s = S.of(context);
    switch (mood) {
      case MoodScale.sunny:
        return s.harmonyMoodSunny;
      case MoodScale.partiallySunny:
        return s.harmonyMoodPartiallySunny;
      case MoodScale.cloudy:
        return s.harmonyMoodCloudy;
      case MoodScale.rainy:
        return s.harmonyMoodRainy;
      case MoodScale.thunderstorm:
        return s.harmonyMoodThunderstorm;
    }
  }

  String _initial(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return '?';
    return trimmed.substring(0, 1);
  }
}

class _EmptyState extends StatelessWidget {
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

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});

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
          OutlinedButton(
            onPressed: onRetry,
            child: Text(s.gratitudeWallRetry),
          ),
        ],
      ),
    );
  }
}
