// lib/features/today/presentation/pages/widgets/today_add_sheet.dart
import 'package:flutter/widgets.dart';

import '../../../../../core/theme/spacing.dart';
import '../../../../../core/theme/kinly_sections.dart';
import '../../../../../core/theme/section_assets.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../core/ui/kinly_bottom_sheet.dart';
import '../../../../../core/ui/kinly_list_tile.dart';
import '../../../../core/ui/kinly_theme_access.dart';

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
    return KinlyBottomSheet.show(
      context: context,
      isScrollControlled: false,
      isDismissible: true,
      title: S.of(context).todayAddSheetTitle,
      body: TodayAddSheet(
        sections: sections,
        onAddFlow: onAddFlow,
        onAddShare: onAddShare,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final s = S.of(context);

    final flowColors = sections.flow;
    final shareColors = sections.share;

    const iconSize = 28.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KinlyListTile(
          leading: SectionAssets.flow.build(
            color: flowColors.icon,
            size: iconSize,
          ),
          title: s.todayAddSheetFlow,
          onTap: () async {
            Navigator.of(context).pop();
            await onAddFlow();
          },
        ),
        SizedBox(height: spacing.md),
        KinlyListTile(
          leading: SectionAssets.share.build(
            color: shareColors.icon,
            size: iconSize,
          ),
          title: s.todayAddSheetShare,
          onTap: () async {
            Navigator.of(context).pop();
            await onAddShare();
          },
        ),
      ],
    );
  }
}




