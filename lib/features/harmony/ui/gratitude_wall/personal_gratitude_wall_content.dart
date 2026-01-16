import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/contracts/mood/personal_wall_models.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/ui/kinly_loader.dart';
import '../../../../core/ui/kinly_theme_access.dart';
import '../../../../core/ui/kinly_empty_state.dart';
import '../../../../core/ui/kinly_icons.dart';
import '../../../../core/ui/kinly_masonry_grid.dart';
import '../../../../core/ui/badges/kinly_badge.dart';
import '../../../../generated/l10n.dart';
import '../../bloc/personal_gratitude_cubit.dart';
import 'gratitude_wall_widgets.dart';

class PersonalGratitudeWallContent extends StatelessWidget {
  const PersonalGratitudeWallContent({super.key, this.maxHeight});

  final double? maxHeight;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final s = S.of(context);
    final spacing = theme.extension<Spacing>()!;

    final content = BlocBuilder<PersonalGratitudeCubit, PersonalGratitudeState>(
      builder: (context, state) {
        if (state.isLoading && state.items.isEmpty) {
          return const Center(child: KinlyLoader());
        }

        if (state.error != null && state.items.isEmpty) {
          return Center(
            child: Text(
              s.gratitudeWallErrorGeneric,
              style: theme.textTheme.bodyMedium,
            ),
          );
        }

        if (state.items.isEmpty) {
          return KinlyEmptyState(
            icon: Icon(KinlyIcons.favoriteRounded, size: 36),
            title: s.gratitudeWallEmptyTitle,
            body: s.gratitudeWallEmptySubtitle,
          );
        }

        final stats =
            state.stats ??
            const PersonalGratitudeStats(
              totalReceived: 0,
              uniqueIndividuals: 0,
              uniqueHomes: 0,
            );

        return NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification.metrics.pixels >=
                    notification.metrics.maxScrollExtent - 120 &&
                state.hasMore &&
                !state.isLoadingMore) {
              context.read<PersonalGratitudeCubit>().loadMore();
            }
            return false;
          },
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
            child: SingleChildScrollView(
              padding: EdgeInsetsDirectional.all(spacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.gratitudeWallPersonalTitle,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: spacing.xs),
                  Text(
                    s.gratitudeWallPersonalSummary,
                    style: theme.textTheme.bodyMedium,
                  ),
                  SizedBox(height: spacing.m),
                  _PersonalStatsRow(
                    mentions: stats.totalReceived,
                    people: stats.uniqueIndividuals,
                    homes: stats.uniqueHomes,
                  ),
                  SizedBox(height: spacing.lg),
                  KinlyMasonryGrid<PersonalGratitudeItem>(
                    items: state.items,
                    gap: spacing.md,
                    estimateItemHeight:
                        (item, textTheme, gridSpacing) => _estimateHeight(
                          item,
                          spacing: gridSpacing,
                          bodyStyle: textTheme.bodyMedium,
                        ),
                    builder: (context, item, index, palette) {
                      return GratitudeEntryCard(
                        username: item.authorUsername,
                        avatarUrl: item.authorAvatarPath,
                        createdAt: item.createdAt,
                        message: item.message,
                        palette: palette.colorForSeed(
                          '${item.id}-${item.authorUserId}',
                        ),
                        messageStyle: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                        initialBuilder: _initial,
                      );
                    },
                  ),
                  if (state.isLoadingMore)
                    Padding(
                      padding: EdgeInsets.only(top: spacing.m),
                      child: const Center(child: KinlyLoader(size: 20)),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (maxHeight != null) {
      return SizedBox(height: maxHeight, child: content);
    }

    return content;
  }

  double _estimateHeight(
    PersonalGratitudeItem item, {
    required Spacing spacing,
    required TextStyle? bodyStyle,
  }) {
    final base = 120.0;
    final msgLength = (item.message?.length ?? 0);
    final lineHeight = (bodyStyle?.height ?? 1.2) * 16;
    final extra = math.min(120, msgLength * 0.5);
    return base + lineHeight + extra;
  }
}

class _PersonalStatsRow extends StatelessWidget {
  const _PersonalStatsRow({
    required this.mentions,
    required this.people,
    required this.homes,
  });

  final int mentions;
  final int people;
  final int homes;

  @override
  Widget build(BuildContext context) {
    final spacing = KinlyThemeAccess.of(context).extension<Spacing>()!;
    final s = S.of(context);

    return Row(
      children: [
        Expanded(
          child: KinlyBadge(
            label: '${s.gratitudeWallStatsMentions}: $mentions',
            compact: false,
          ),
        ),
        SizedBox(width: spacing.sm),
        Expanded(
          child: KinlyBadge(
            label: '${s.gratitudeWallStatsPeople}: $people',
            compact: false,
          ),
        ),
        SizedBox(width: spacing.sm),
        Expanded(
          child: KinlyBadge(
            label: '${s.gratitudeWallStatsHomes}: $homes',
            compact: false,
          ),
        ),
      ],
    );
  }
}

String _initial(String value) {
  if (value.isEmpty) return '';
  return value.characters.first.toUpperCase();
}
