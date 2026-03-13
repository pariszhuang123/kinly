import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:kinly/contracts/house_directory/models.dart';
import 'package:kinly/core/ui/buttons/kinly_filled_button.dart';
import 'package:kinly/core/ui/buttons/kinly_outlined_button.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/generated/l10n.dart';

class TodayHouseDirectoryRemindersCard extends StatelessWidget {
  const TodayHouseDirectoryRemindersCard({
    super.key,
    required this.reminders,
    required this.isOwner,
    required this.onOpen,
    required this.onAcknowledge,
    required this.onDismiss,
  });

  final List<HouseDirectoryReminder> reminders;
  final bool isOwner;
  final VoidCallback onOpen;
  final void Function(HouseDirectoryReminder reminder) onAcknowledge;
  final void Function(HouseDirectoryReminder reminder) onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final s = S.of(context);
    final format = DateFormat.yMMMd();
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            s.todayHouseDirectoryRemindersTitle,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ...reminders.map(
            (reminder) => Padding(
              padding: const EdgeInsetsDirectional.only(top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reminder.providerName,
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    s.todayHouseDirectoryReminderDue(
                      format.format(reminder.dueAt),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      KinlyOutlinedButton.text(
                        onPressed: onOpen,
                        label: s.todayHouseDirectoryOpenCta,
                        compact: true,
                      ),
                      if (isOwner)
                        KinlyFilledButton.text(
                          onPressed: () => onDismiss(reminder),
                          label: s.todayHouseDirectoryDismissCta,
                          compact: true,
                        )
                      else
                        KinlyFilledButton.text(
                          onPressed: () => onAcknowledge(reminder),
                          label: s.todayHouseDirectoryAcknowledgeCta,
                          compact: true,
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
