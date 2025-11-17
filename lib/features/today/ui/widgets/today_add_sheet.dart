// lib/features/today/presentation/pages/widgets/today_add_sheet.dart
import 'package:flutter/material.dart';
import '../../../../../core/theme/spacing.dart';
import '../../../../../core/theme/kinly_sections.dart';

class TodayAddSheet extends StatelessWidget {
  final KinlySections sections;

  const TodayAddSheet({super.key, required this.sections});

  static Future<void> show(BuildContext context, KinlySections sections) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;

    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => TodayAddSheet(sections: sections),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        spacing.lg,
        spacing.md,
        spacing.lg,
        spacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add to your home',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: spacing.md),
          ListTile(
            leading: Icon(Icons.checklist, color: sections.flow.icon),
            title: const Text('Add task (Flow)'),
            onTap: () {
              Navigator.of(context).pop();
              // TODO: navigate to add-task flow
            },
          ),
          ListTile(
            leading: Icon(
              Icons.account_balance_wallet,
              color: sections.share.icon,
            ),
            title: const Text('Add expense (Share)'),
            onTap: () {
              Navigator.of(context).pop();
              // TODO: navigate to add-expense flow
            },
          ),
        ],
      ),
    );
  }
}
