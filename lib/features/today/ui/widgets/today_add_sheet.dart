// lib/features/today/presentation/pages/widgets/today_add_sheet.dart
import 'package:flutter/material.dart';

import '../../../../../core/theme/spacing.dart';
import '../../../../../core/theme/kinly_sections.dart';
import '../../../../../generated/l10n.dart';

class TodayAddSheet extends StatelessWidget {
  final KinlySections sections;
  final Future<void> Function() onAddFlow;
  final Future<void> Function() onAddShare;

  const TodayAddSheet({
    super.key,
    required this.sections,
    required this.onAddFlow,
    required this.onAddShare,
  });

  static Future<void> show(
    BuildContext context,
    KinlySections sections, {
    required Future<void> Function() onAddFlow,
    required Future<void> Function() onAddShare,
  }) {
    return showModalBottomSheet(
      context: context,
      useSafeArea: true, // ensures the sheet itself respects system insets
      isScrollControlled: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder:
          (context) => TodayAddSheet(
            sections: sections,
            onAddFlow: onAddFlow,
            onAddShare: onAddShare,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;
    final s = S.of(context);

    return SafeArea(
      top: false, // keep the nice rounded top edge tight to the sheet
      child: Padding(
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
              s.todayAddSheetTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: spacing.md),
            ListTile(
              leading: Icon(Icons.checklist, color: sections.flow.icon),
              title: Text(s.todayAddSheetFlow),
              onTap: () async {
                Navigator.of(context).pop();
                await onAddFlow();
              },
            ),
            ListTile(
              leading: Icon(
                Icons.account_balance_wallet,
                color: sections.share.icon,
              ),
              title: Text(s.todayAddSheetShare),
              onTap: () async {
                Navigator.of(context).pop();
                await onAddShare();
              },
            ),
          ],
        ),
      ),
    );
  }
}
