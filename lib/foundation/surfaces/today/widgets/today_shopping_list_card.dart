import 'package:flutter/widgets.dart';

import 'package:kinly/core/theme/kinly_sections.dart';
import 'package:kinly/core/theme/section_assets.dart';
import 'package:kinly/core/ui/kinly_list_tile.dart';
import 'package:kinly/core/ui/section_container.dart';
import 'package:kinly/generated/l10n.dart';

class TodayShoppingListCard extends StatelessWidget {
  const TodayShoppingListCard({
    super.key,
    required this.onTap,
    required this.count,
    required this.colors,
  });

  final VoidCallback onTap;
  final int count;
  final SectionColors colors;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    if (count <= 0) {
      return const SizedBox.shrink();
    }

    const iconSize = 28.0;

    return SectionContainer(
      title: s.shoppingCardTitle,
      colors: colors,
      leading: SectionAssets.shopping.build(
        color: colors.icon,
        size: iconSize,
      ),
      child: KinlyListTile(
        title: s.shoppingCardSubtitle(count),
        onTap: onTap,
      ),
    );
  }
}
