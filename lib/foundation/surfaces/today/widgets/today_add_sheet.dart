// lib/features/today/presentation/pages/widgets/today_add_sheet.dart
import 'package:flutter/widgets.dart';

import 'package:kinly/core/theme/kinly_sections.dart';
import 'package:kinly/core/theme/section_assets.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/kinly_bottom_sheet.dart';
import 'package:kinly/core/ui/kinly_list_tile.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/renderer/material/kinly_icons.dart';

class TodayAddSheet extends StatelessWidget {
  final KinlySections sections;
  final Future<void> Function() onAddFlow;
  final Future<void> Function() onAddShare;
  final Future<void> Function() onAddShopping;

  const TodayAddSheet({
    super.key,
    required this.sections,
    required this.onAddFlow,
    required this.onAddShare,
    required this.onAddShopping,
  });

  static Future<void> show(
    BuildContext context,
    KinlySections sections, {
    required Future<void> Function() onAddFlow,
    required Future<void> Function() onAddShare,
    required Future<void> Function() onAddShopping,
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
        onAddShopping: onAddShopping,
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
        SizedBox(height: spacing.md),
        KinlyListTile(
          leading: Icon(
            KinlyIcons.shoppingBasketOutlined,
            size: iconSize,
            color: flowColors.icon,
          ),
          title: s.todayAddSheetShopping,
          onTap: () async {
            Navigator.of(context).pop();
            await onAddShopping();
          },
        ),
      ],
    );
  }
}
