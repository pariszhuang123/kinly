import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/color_tokens.dart';
import '../../../../core/theme/kinly_sections.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography_tokens.dart';
import '../../../../core/ui/kinly_circle_avatar.dart';
import '../../../../core/ui/kinly_list_tile.dart';
import '../../../../core/ui/kinly_loader.dart';
import '../../../../core/ui/scroll/kinly_scroll_fade.dart';
import '../../../../core/ui/kinly_material.dart';
import '../../../../generated/l10n.dart';
import '../../../../contracts/share/models.dart';
import '../share_paid_to_me_detail_models.dart';
import '../share_period_label.dart';
import '../../../../core/ui/kinly_theme_access.dart';

class SharePaidToMeDetailBody extends StatelessWidget {
  const SharePaidToMeDetailBody({
    super.key,
    required this.entry,
    required this.items,
    required this.spacing,
    required this.strings,
    required this.isLoading,
    required this.error,
  });

  final TodaySharePaidToMe entry;
  final List<TodaySharePaidItem> items;
  final Spacing spacing;
  final S strings;
  final bool isLoading;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        KinlyThemeAccess.of(context).scaffoldBackgroundColor;
    final bottomScrollPad = spacing.lg + spacing.xl + spacing.lg;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        KinlyMaterial(color: backgroundColor, child: _Header(entry: entry)),
        SizedBox(height: spacing.lg),
        Expanded(
          child: ClipRect(
            child: KinlyScrollFade(
              fadeTop: true,
              maskColor: backgroundColor,
              child: CustomScrollView(
                physics: const ClampingScrollPhysics(),
                slivers: [
                  if (isLoading)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: KinlyLoader()),
                    )
                  else if (error != null)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          error!,
                          style: KinlyThemeAccess.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color:
                                KinlyThemeAccess.of(context).colorScheme.error,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  else if (items.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: Text(strings.shareOwedDetailEmpty)),
                    )
                  else
                    SliverList.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, __) => SizedBox(height: spacing.sm),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final typography =
                            KinlyThemeAccess.of(
                              context,
                            ).extension<KinlyTypography>();
                        final colors =
                            KinlyThemeAccess.of(
                              context,
                            ).extension<KinlyColorTokens>();
                        final periodLabel = sharePeriodLabel(
                          recurrenceEvery: item.recurrenceEvery,
                          recurrenceUnit: item.recurrenceUnit,
                          startDate: item.startDate,
                          strings: strings,
                        );

                        return KinlyListTile(
                          title: item.description,
                          subtitle: periodLabel,
                          trailing: Text(
                            item.formattedAmount,
                            style: (typography?.titleSmall ??
                                    KinlyThemeAccess.of(
                                      context,
                                    ).textTheme.titleSmall)
                                ?.copyWith(color: colors?.onSurface),
                          ),
                        );
                      },
                    ),
                  SliverToBoxAdapter(child: SizedBox(height: bottomScrollPad)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.entry});

  final TodaySharePaidToMe entry;

  @override
  Widget build(BuildContext context) {
    final spacing = KinlyThemeAccess.of(context).extension<Spacing>()!;
    final colors =
        KinlyThemeAccess.of(context).extension<KinlySections>()?.share;
    final hasUnseen = entry.unseenCount > 0;
    final totalPaidFormatted = NumberFormat.simpleCurrency(
      decimalDigits: 2,
    ).format(entry.totalPaidCents / 100.0);

    return Row(
      children: [
        KinlyCircleAvatar(
          avatarUrl: entry.debtorAvatarUrl,
          isOwner: entry.isOwner,
          radius: 28,
        ),
        SizedBox(width: spacing.md),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.debtorUsername,
              style: KinlyThemeAccess.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: colors?.icon),
            ),
            Text(
              hasUnseen
                  ? S.of(context).todaySharePaidUnseen(entry.unseenCount)
                  : S.of(context).todaySharePaidSubtitle,
              style: KinlyThemeAccess.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        const Spacer(),
        Text(
          totalPaidFormatted,
          style: KinlyThemeAccess.of(context).textTheme.titleMedium?.copyWith(
            color: colors?.icon,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
