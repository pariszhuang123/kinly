// lib/features/gratitude_wall/ui/gratitude_wall_content.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/spacing.dart';
import '../../../../core/ui/kinly_loader.dart';
import '../../bloc/gratitude_wall_cubit.dart';
import 'gratitude_wall_widgets.dart';

class GratitudeWallContent extends StatelessWidget {
  const GratitudeWallContent({super.key, required this.maxHeight});

  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;

    return SizedBox(
      height: maxHeight,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surfaceContainerLowest,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        // 👇 Bigger “frame” padding to feel like an IG story
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: spacing.xl,
            vertical: spacing.lg,
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: BlocBuilder<GratitudeWallCubit, GratitudeWallState>(
                  builder: (context, state) {
                    if (state.isLoading && !state.hasLoaded) {
                      return const Center(child: KinlyLoader());
                    }

                    if (state.error != null && state.posts.isEmpty) {
                      return GratitudeWallErrorState(
                        message: state.error!,
                        onRetry:
                            () =>
                                context
                                    .read<GratitudeWallCubit>()
                                    .loadInitial(),
                      );
                    }

                    if (state.posts.isEmpty) {
                      return const GratitudeWallEmptyState();
                    }

                    return _buildLoadedList(context, state, spacing);
                  },
                ),
              ),
              PositionedDirectional(
                bottom: spacing.sm,
                start: spacing.sm,
                child: const PoweredByTagline(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadedList(
    BuildContext context,
    GratitudeWallState state,
    Spacing spacing,
  ) {
    final theme = Theme.of(context);
    final totalCount = state.totalPosts ?? state.posts.length;
    final hasMoreThanLoaded =
        state.totalPosts != null && state.posts.length < state.totalPosts!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GratitudeWallHeader(
          count: totalCount,
          hasMore: hasMoreThanLoaded,
        ),
        SizedBox(height: spacing.md),
        Expanded(
          child: NotificationListener<ScrollNotification>(
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
              // 👇 Extra bottom padding so last card isn’t hugging the edge
              padding: EdgeInsetsDirectional.only(bottom: spacing.xl * 2.5),
              itemCount: state.posts.length + 1 + (state.isLoadingMore ? 1 : 0),
              separatorBuilder: (_, __) => SizedBox(height: spacing.lg),
              itemBuilder: (context, index) {
                if (index < state.posts.length) {
                  final post = state.posts[index];
                  final alignLeft = index.isEven;
                  final accent = accentColorFor(
                    post.authorUsername ?? post.authorUserId,
                    theme.colorScheme,
                  );
                  return GratitudeWallRow(
                    post: post,
                    alignLeft: alignLeft,
                    accent: accent,
                  );
                }

                final loadingIndex = state.posts.length;
                if (state.isLoadingMore && index == loadingIndex) {
                  return const Center(child: KinlyLoader());
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ],
    );
  }
}
