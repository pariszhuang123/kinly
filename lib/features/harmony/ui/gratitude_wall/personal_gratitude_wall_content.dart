import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/spacing.dart';
import '../../../../core/ui/kinly_loader.dart';
import '../../../../core/ui/kinly_theme_access.dart';
import '../../../../core/ui/kinly_empty_state.dart';
import '../../../../core/ui/kinly_icons.dart';
import '../../../../core/ui/kinly_circle_avatar.dart';
import '../../../../generated/l10n.dart';
import '../../bloc/personal_gratitude_cubit.dart';

class PersonalGratitudeWallContent extends StatelessWidget {
  const PersonalGratitudeWallContent({super.key, this.maxHeight});

  final double? maxHeight;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final s = S.of(context);

    return BlocBuilder<PersonalGratitudeCubit, PersonalGratitudeState>(
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

        return ListView.separated(
          shrinkWrap: true,
          itemCount: state.items.length + (state.hasMore ? 1 : 0),
          separatorBuilder: (_, __) => SizedBox(height: spacing.m),
          itemBuilder: (context, index) {
            if (index >= state.items.length) {
              context.read<PersonalGratitudeCubit>().loadMore();
              return const Center(child: KinlyLoader(size: 20));
            }
            final item = state.items[index];
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KinlyCircleAvatar(avatarUrl: item.authorAvatarPath, radius: 20),
                SizedBox(width: spacing.m),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.authorUsername,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (item.message?.isNotEmpty == true) ...[
                        SizedBox(height: spacing.xs),
                        Text(item.message!, style: theme.textTheme.bodyMedium),
                      ],
                      SizedBox(height: spacing.xs),
                      Text(
                        s.gratitudeWallPersonalMeta(item.homeId),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
