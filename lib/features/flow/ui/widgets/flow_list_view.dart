import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../../../contracts/chores/models.dart';
import '../../../../core/theme/kinly_sections.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/ui/badges/kinly_badge.dart';
import '../../../../core/ui/kinly_circle_avatar.dart';
import '../../../../core/ui/kinly_material.dart';
import '../../../../core/ui/kinly_refresh_indicator.dart';
import '../../../../core/ui/scroll/kinly_scroll_fade.dart';
import '../../../../core/ui/kinly_tap_target.dart';
import '../../../../generated/l10n.dart';
import '../../../../core/ui/kinly_theme_access.dart';
import '../../../../core/ui/kinly_icons.dart';

class FlowListView extends StatelessWidget {
  const FlowListView({
    super.key,
    required this.items,
    required this.ownerUserId,
    required this.onRefresh,
    required this.onItemTap,
  });

  final List<ChoreListEntry> items;
  final String? ownerUserId;
  final Future<void> Function() onRefresh;
  final void Function(ChoreListEntry entry) onItemTap;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final sections = theme.extension<KinlySections>()!;
    final flowColors = sections.flow;
    final spacing = theme.extension<Spacing>()!;
    final gap = spacing.md;
    final bottomSpacer = spacing.lg;

    return KinlyScrollFade(
      child: KinlyRefreshIndicator(
        onRefresh: onRefresh,
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsetsDirectional.only(bottom: bottomSpacer),
          itemCount: items.length,
          separatorBuilder: (_, __) => SizedBox(height: gap),
          itemBuilder: (context, index) {
            final entry = items[index];
            return _FlowListTile(
              entry: entry,
              flowColors: flowColors,
              ownerUserId: ownerUserId,
              onTap: () => onItemTap(entry),
            );
          },
        ),
      ),
    );
  }
}

class _FlowListTile extends StatelessWidget {
  const _FlowListTile({
    required this.entry,
    required this.flowColors,
    required this.ownerUserId,
    required this.onTap,
  });

  final ChoreListEntry entry;
  final SectionColors flowColors;
  final String? ownerUserId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final colorScheme = theme.colorScheme;
    final s = S.of(context);
    final spacing = theme.extension<Spacing>()!;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final entryDateLocal = DateTime(
      entry.startDate.toLocal().year,
      entry.startDate.toLocal().month,
      entry.startDate.toLocal().day,
    );
    final isOverdue = entryDateLocal.isBefore(today);
    final dateText = DateFormat.yMMMd().format(entryDateLocal);

    return KinlyMaterial(
      color: flowColors.card,
      borderRadius: BorderRadius.circular(16),
      child: KinlyTapTarget(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        alignment: AlignmentDirectional.centerStart,
        child: Padding(
          padding: EdgeInsetsDirectional.all(spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(entry.name, style: theme.textTheme.titleMedium),
                  ),
                  _AssigneeAvatar(
                    entry: entry,
                    ownerUserId: ownerUserId,
                  ),
                ],
              ),
              SizedBox(height: spacing.sm),
              Row(
                children: [
                  Icon(
                    KinlyIcons.calendarTodayRounded,
                    size: 16,
                    color: flowColors.accent,
                  ),
                  SizedBox(width: spacing.xs),
                  Text(
                    dateText,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color:
                          isOverdue
                              ? colorScheme.error
                              : colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (isOverdue) ...[
                    SizedBox(width: spacing.xs),
                    KinlyBadge(
                      label: s.flowListOverdueLabel,
                      destructive: true,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AssigneeAvatar extends StatelessWidget {
  const _AssigneeAvatar({
    required this.entry,
    this.ownerUserId,
  });

  final ChoreListEntry entry;
  final String? ownerUserId;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    if (entry.assigneeUserId == null) {
      return KinlyBadge(label: s.flowListDraftLabel, compact: false);
    }

    return KinlyCircleAvatar(
      avatarUrl: entry.assigneeAvatarStoragePath,
      radius: 20,
      isOwner: ownerUserId != null && entry.assigneeUserId == ownerUserId,
    );
  }
}




