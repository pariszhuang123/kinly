// lib/features/harmony/ui/gratitude_wall/gratitude_wall_content.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/spacing.dart';
import '../../../../core/ui/kinly_loader.dart';
import '../../../../core/ui/scroll/kinly_scroll_fade.dart';
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
        // Removed outer padding so content can use more of the frame
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
                              context.read<GratitudeWallCubit>().loadInitial(),
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
              bottom: 0,
              start: 0,
              end: 0,
              child: IgnorePointer(
                child: Container(
                  height: spacing.xl * 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        theme.colorScheme.surface,
                        theme.colorScheme.surface.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
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
    );
  }

  Widget _buildLoadedList(
    BuildContext context,
    GratitudeWallState state,
    Spacing spacing,
  ) {
    final totalCount = state.totalPosts ?? state.posts.length;
    final hasMoreThanLoaded =
        state.totalPosts != null && state.posts.length < state.totalPosts!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GratitudeWallHeader(count: totalCount, hasMore: hasMoreThanLoaded),
        SizedBox(height: spacing.lg),
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
            child: KinlyScrollFade(
              fadeFraction: 0.08,
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsetsDirectional.only(start: 0, end: 0),
                    sliver: SliverToBoxAdapter(
                      child: GratitudeWallMasonryGrid(posts: state.posts),
                    ),
                  ),
                  if (state.isLoadingMore)
                    SliverPadding(
                      padding: EdgeInsetsDirectional.only(
                        top: spacing.lg,
                        bottom: spacing.xl * 2.5,
                      ),
                      sliver: const SliverToBoxAdapter(
                        child: Center(child: KinlyLoader()),
                      ),
                    )
                  else
                    SliverToBoxAdapter(
                      child: SizedBox(height: spacing.xl * 2.5),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
