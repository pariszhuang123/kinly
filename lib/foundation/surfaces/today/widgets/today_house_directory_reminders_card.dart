import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:kinly/contracts/house_directory/models.dart';
import 'package:kinly/core/theme/kinly_sections.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/buttons/kinly_filled_button.dart';
import 'package:kinly/core/ui/section_container.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/generated/l10n.dart';

class TodayHouseDirectoryRemindersCard extends StatelessWidget {
  const TodayHouseDirectoryRemindersCard({
    super.key,
    required this.reminders,
    required this.palette,
    required this.onOpenReminder,
  });

  final List<HouseDirectoryReminder> reminders;
  final SectionColors palette;
  final Future<void> Function(HouseDirectoryReminder reminder) onOpenReminder;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final s = S.of(context);
    final format = DateFormat.yMMMd();
    return SectionContainer(
      title: s.todayHouseDirectoryRemindersTitle,
      colors: palette,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: spacing.xs),
          ...reminders.map(
            (reminder) => Padding(
              padding: EdgeInsetsDirectional.only(top: spacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reminder.providerName,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: palette.accent,
                    ),
                  ),
                  SizedBox(height: spacing.xs),
                  Text(
                    s.todayHouseDirectoryReminderDue(
                      format.format(reminder.dueAt),
                    ),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: spacing.sm),
                  Wrap(
                    spacing: spacing.sm,
                    runSpacing: spacing.sm,
                    children: [
                      KinlyFilledButton.text(
                        onPressed: () => onOpenReminder(reminder),
                        label: s.todayHouseDirectoryOpenCta,
                        compact: true,
                        backgroundColor: palette.accent,
                        foregroundColor: palette.onAccent(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
